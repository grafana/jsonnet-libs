local k = import 'ksonnet-util/kausal.libsonnet';
local configMap = k.core.v1.configMap;
{
  // grafana_ini configmap
  grafana_ini_config_map:
    configMap.new('grafana-config') +
    configMap.withData({ 'grafana.ini': std.manifestIni($._config.grafana_ini) }),

  // datasource provisioning configmap
  grafana_datasource_config_map:
    configMap.new('grafana-datasources') +
    configMap.withDataMixin({
      ['%s.yml' % name]: k.util.manifestYaml({
        apiVersion: 1,
        datasources: [$.grafanaDatasources[name]],
      })
      for name in std.objectFields($.grafanaDatasources)
    })
    + configMap.mixin.metadata.withLabels($._config.labels.datasources),

  // notification channel provisioning configmap
  notification_channel_config_map:
    configMap.new('grafana-notification-channels') +
    configMap.withDataMixin({
      [name]: $.util.manifestYaml({
        notifiers: [
          $.grafanaNotificationChannels[name],
        ],
      })
      for name in std.objectFields($.grafanaNotificationChannels)
    }) +
    configMap.mixin.metadata.withLabels($._config.labels.notificationChannels),

  // dashboard provisioning configmaps
  dashboard_provisioning_config_map:
    configMap.new('grafana-dashboard-provisioning') +
    configMap.withData({
      'dashboards.yml': $.util.manifestYaml({
        apiVersion: 1,
        providers: [
          {
            name: 'dashboards-%s' % $.grafanaDashboardFolders[name].id,
            orgId: 1,
            folder: $.grafanaDashboardFolders[name].name,
            type: 'file',
            disableDeletion: true,
            editable: false,
            options: {
              path: '/grafana/dashboards-%s' % $.grafanaDashboardFolders[name].id,
            },
          }
          for name in std.objectFields($.grafanaDashboardFolders)
        ],
      }),
    }),

  // dashboard JSON configmaps:
  local shardedConfigMaps(folder) = {
    ['dashboards-%s-%d' % [folder.id, shard]]+:
      configMap.new('dashboards-%s-%d' % [folder.id, shard]) +
      configMap.withDataMixin({
        [name]: std.toString(folder.dashboards[name])
        for name in std.objectFields(folder.dashboards)
        if std.codepoint(std.md5(name)[1]) % folder.shards == shard
      })
      + configMap.mixin.metadata.withLabels($._config.labels.dashboards)
    for shard in std.range(0, folder.shards - 1)
  },

  dashboard_folders_config_maps: std.foldl(
    function(acc, name)
      acc + shardedConfigMaps($.grafanaDashboardFolders[name]),
    std.objectFields($.grafanaDashboardFolders),
    {},
  ),

  // Helper to mount a variable number of sharded config maps.
  local shardedMounts(folder) =
    std.foldl(
      function(acc, shard)
        acc + k.util.configVolumeMount(
          'dashboards-%s-%d' % [folder.id, shard],
          '/grafana/dashboards-%s/%d' % [folder.id, shard]
        ),
      std.range(0, folder.shards - 1),
      {}
    ),

  // configmap mounts for use within statefulset/deployment
  configmap_mounts::
    k.util.configMapVolumeMount($.grafana_ini_config_map, '/etc/grafana-config')
    + k.util.configVolumeMount('grafana-dashboard-provisioning', '%(grafana_provisioning_dir)s/dashboards' % $._config)
    + k.util.configVolumeMount('grafana-datasources', '%(grafana_provisioning_dir)s/datasources' % $._config)
    + k.util.configVolumeMount('grafana-notification-channels', '%(grafana_provisioning_dir)s/notifiers' % $._config)
    + std.foldr(
      function(folder, acc) shardedMounts($.grafanaDashboardFolders[folder]) + acc,
      std.objectFields($.grafanaDashboardFolders),
      {},
    ),
}
