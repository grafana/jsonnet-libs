{
  _config+:: {
    // Grafana config options.
    grafana_root_url: '',
    grafana_provisioning_dir: '/etc/grafana/provisioning',

    // Optionally shard dashboards into multiple config maps.
    // Set to the number of desired config maps.  0 to disable.
    dashboard_config_maps: 0,

    // Optionally add labels to grafana config maps.
    grafana_dashboard_labels: {},
    grafana_datasource_labels: {},
    grafana_notification_channel_labels: {},
  },

  grafana_plugins+:: [
    "grafana-polystat-panel",
  ],

  local container = $.core.v1.container,

  grafana_container::
    container.new('grafana', $._images.grafana) +
    container.withPorts($.core.v1.containerPort.new('grafana-metrics', 3000)) +
    container.withEnvMap({
      GF_PATHS_CONFIG: '/etc/grafana-config/grafana.ini',
      GF_INSTALL_PLUGINS: std.join(',', $.grafana_plugins),
    }) +
    $.util.resourcesRequests('10m', '40Mi'),

  local deployment = $.apps.v1.deployment,

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

  grafana_deployment:
    deployment.new('grafana', 1, [$.grafana_container]) +
    // Use configMapVolumeMount to automatically include the hash of the config
    // as an annotation.  No need to use for others, Grafana will pick up
    // changes there.
    $.util.configMapVolumeMount($.grafana_config_map, '/etc/grafana-config') +
    $.util.configVolumeMount('grafana-dashboard-provisioning', '%(grafana_provisioning_dir)s/dashboards' % $._config) +
    $.util.configVolumeMount('grafana-datasources', '%(grafana_provisioning_dir)s/datasources' % $._config) +
    $.util.configVolumeMount('grafana-notification-channels', '%(grafana_provisioning_dir)s/notifiers' % $._config) +
    (
      // Mount _all_ the dashboard config map shards.
      sharded_config_map_mounts('dashboards', $._config.dashboard_config_maps)
    ) + (
      // Add config map mounts for each folder for dashboards.
      folder_mounts
    ) +
    $.util.podPriority('critical'),

  local service = $.core.v1.service,
  local servicePort = service.mixin.spec.portsType,

  grafana_service:
    $.util.serviceFor($.grafana_deployment) +
    service.mixin.spec.withPortsMixin([
      servicePort.newNamed(
        name='http',
        port=80,
        targetPort=3000,
      ),
    ]),
}
