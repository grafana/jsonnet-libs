{
  local configMap = $.core.v1.configMap,

  _config+:: {
    // Shard dashboards across multiple config maps to overcome annotation
    // lenght limits.
    dashboard_config_maps: 8,
  },

  // New API: Mixins go in the mixins map.
  mixins+:: {},

  // emptyMixin allows us to reliably do `mixin.grafanaDashboards` without
  // having to check the field exists first. Some mixins don't declare all
  // the fields, and thats fine.
  local emptyMixin = {
    grafanaDashboards+: {},
  },

  // Legacy extension points for you to add your own dashboards.
  grafanaDashboards+:: std.foldr(
    function(mixinName, acc)
      local mixin = $.mixins[mixinName] + emptyMixin;
      if !std.objectHas(mixin, 'grafanaDashboardFolder')
      then acc + mixin.grafanaDashboards
      else acc,
    std.objectFields($.mixins),
    {}
  ),

  dashboardsByFolder+:: std.foldr(
    function(mixinName, acc)
      local mixin = $.mixins[mixinName] + emptyMixin;
      if std.objectHas(mixin, 'grafanaDashboardFolder')
      then acc {
        [mixin.grafanaDashboardFolder]: mixin.grafanaDashboards,
      }
      else acc,
    std.objectFields($.mixins),
    {}
  ),

  local materialise_config_map(config_map_name, dashboards) =
    configMap.new(config_map_name) +
    configMap.withDataMixin({
      [name]: std.toString(dashboards[name])
      for name in std.objectFields(dashboards)
    }) +
    configMap.mixin.metadata.withLabels($._config.grafana_dashboard_labels),

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
      materialise_config_map(
        'dashboards-%s' % std.asciiLower(folder),
        $.dashboardsByFolder[folder]
      )
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
