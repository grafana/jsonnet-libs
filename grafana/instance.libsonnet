local k = import 'ksonnet-util/kausal.libsonnet';
local deployment = k.apps.v1.deployment;
local statefulset = k.apps.v1.statefulSet;
local service = k.core.v1.service;
local servicePort = service.mixin.spec.portsType;
local container = k.core.v1.container;
{
  grafana_container::
    container.new('grafana', $._images.grafana) +
    container.withPorts($.core.v1.containerPort.new('grafana-metrics', 3000)) +
    container.withEnvMap({
      GF_PATHS_CONFIG: '/etc/grafana-config/grafana.ini',
      GF_INSTALL_PLUGINS: std.join(',', $.grafana_plugins),
    }) +
    k.util.resourcesRequests('10m', '40Mi'),

  // Helper to mount a variable number of shareded config maps.
  local sharded_config_map_mounts(prefix, shards) =
    std.foldr(
      function(shard, acc)
        $.util.configVolumeMount(
          '%s-%d' % [prefix, shard],
          '/grafana/%s/%d' % [prefix, shard]
        ) + acc,
      std.range(0, shards - 1),
      {}
    ),

  local folder_mounts =
    // Dedupe folder names through a map fold first,
    // just incase two mixins go into the same folder.
    local folderShards = std.foldr(
      function(mixinName, acc)
        local mixin = $.mixins[mixinName];
        if !$.isFolderedMixin(mixin)
        then acc
        else acc {
          [$.folderID(mixin.grafanaDashboardFolder)]:
            if std.objectHas(mixin, 'grafanaDashboardShards')
            then mixin.grafanaDashboardShards
            else 1,
        },
      std.objectFields($.mixins),
      {},
    );
    std.foldr(
      function(folderName, acc)
        local config_map_name = 'dashboards-%s' % folderName;
        local shards = folderShards[folderName];
        sharded_config_map_mounts(config_map_name, shards) + acc,
      std.objectFields(folderShards),
      {},
    ),

  // Use configMapVolumeMount to automatically include the hash of the config
  // as an annotation.  No need to use for others, Grafana will pick up
  // changes there.
  grafana_mounts()::
    k.util.configMapVolumeMount($.grafana_config_map, '/etc/grafana-config') +
    k.util.configVolumeMount('grafana-dashboard-provisioning', '%(grafana_provisioning_dir)s/dashboards' % $._config) +
    k.util.configVolumeMount('grafana-datasources', '%(grafana_provisioning_dir)s/datasources' % $._config) +
    k.util.configVolumeMount('grafana-notification-channels', '%(grafana_provisioning_dir)s/notifiers' % $._config) +
    (
      // Mount _all_ the dashboard config map shards.
      sharded_config_map_mounts('dashboards', $._config.dashboard_config_maps)
    ) + (
      // Add config map mounts for each folder for dashboards.
      folder_mounts
    ),
  local grafana_mounts = self.grafana_mounts,

  // this object may be either a k8s deployment resource or a statefulset depending on user selection
  grafana_deployment:
    deployment.new('grafana', 1, [$.grafana_container])
    + grafana_mounts()
    + k.util.podPriority('critical'),

  grafana_service:
    k.util.serviceFor($.grafana_deployment) +
    service.mixin.spec.withPortsMixin([
      servicePort.newNamed(
        name='http',
        port=80,
        targetPort=3000,
      ),
    ]),

  withStatelessness():: {
    kind: 'Deployment',
    spec+: {
      minReadySeconds: 10,
      revisionHistoryLimit: 10,
    },
    updateStrategy:: {},
  },

  local configMap = k.core.v1.configMap,

  grafana_config_map:
    configMap.new('grafana-config') +
    configMap.withData({ 'grafana.ini': std.manifestIni($.grafana_config) }),
}
