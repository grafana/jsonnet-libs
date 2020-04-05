{
  local configMap = $.core.v1.configMap,

  // Extension point for you to add your own dashboards.
  dashboards+:: {},
  grafana_dashboards+:: {},
  grafanaDashboards+:: $.dashboards + $.grafana_dashboards,
  dashboardsByFolder+:: {},

  local materialise_config_map(config_map_name, dashboards) =
    configMap.new(config_map_name) +
      configMap.withDataMixin({
        [name]: std.toString(dashboards[name])
        for name in std.objectFields(dashboards)
      }) +
      configMap.mixin.metadata.withLabels($._config.grafana_dashboard_labels),

  // This config map contains all "root" dashboards, when sharding is disabled.
  dashboards_config_map:
    if $._config.dashboard_config_maps == 0
    then materialise_config_map('dashboards', $.grafanaDashboards)
    else {},

  // When sharding is enabled, this is a map of config maps, each map named
  // "dashboard-0" ... "dashboard-N" and containing dashboards whose name
  // hashes to that shard.
  dashboards_config_maps: {
    ['dashboard-%d' % shard]:
      materialise_config_map('dashboards-%d' % shard, {
        [name]: $.grafanaDashboards[name]
        for name in std.objectFields($.grafanaDashboards)
        if std.codepoint(std.md5(name)[1]) % $._config.dashboard_config_maps == shard
      })
    for shard in std.range(0, $._config.dashboard_config_maps - 1)
  },

  // A map of config maps, one per folder, for dashboards in folders.
  dashboard_folders_config_maps: {
    ['dashboard-%s' % std.asciiLower(folder)]:
      materialise_config_map('dashboards-%s' % std.asciiLower(folder),
        $.dashboardsByFolder[folder])
    for folder in std.objectFields($.dashboardsByFolder)
  },

  // Config map containing the dashboard provisioning YAML, telling
  // Grafana where to find the dashboard JSONs.
  grafana_dashboard_provisioning_config_map:
    configMap.new('grafana-dashboard-provisioning') +
    configMap.withData({
      'dashboards.yml': $.util.manifestYaml({
        apiVersion: 1,
        providers: [
          {
            name: 'dashboards',
            orgId: 1,
            folder: '',
            type: 'file',
            disableDeletion: true,
            editable: false,
            options: {
              path: '/grafana/dashboards',
            },
          },
        ] + [
          {
            name: 'dashboards-%s' % std.asciiLower(folder),
            orgId: 1,
            folder: folder,
            type: 'file',
            disableDeletion: true,
            editable: false,
            options: {
              path: '/grafana/dashboard-folders/%s' % std.asciiLower(folder),
            },
          }
          for folder in std.objectFields($.dashboardsByFolder)
        ],
      }),
    }),
}
