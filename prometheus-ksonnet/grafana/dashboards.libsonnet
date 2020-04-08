{
  local configMap = $.core.v1.configMap,

  _config+:: {
    // Shard dashboards across multiple config maps to overcome annotation
    // lenght limits.
    dashboard_config_maps: 8,
  },

  // New API: Mixins go in the mixins map.
  mixins+:: {},

  // mixinProto allows us to reliably do `mixin.grafanaDashboards` without
  // having to check the field exists first. Some mixins don't declare all
  // the fields, and thats fine.
  //
  // We also use this to add a little "opinion":
  // - Dashboard UIDs should be the md5 hash of their filename.
  // - Timezone should be "default" (ie local).
  // - Tooltip should only show a single value.
  local mixinProto = {
    grafanaDashboards+:: {},
  } + {
    local grafanaDashboards = super.grafanaDashboards,

    grafanaDashboards+:: {
      [filename]:
        local dashboard = grafanaDashboards[filename];
        dashboard {
          uid: std.md5(filename),
          timezone: '',

          [if std.objectHas(dashboard, 'rows') then 'rows']: [
            row {
              panels: [
                panel {
                  tooltip+: {
                    shared: false,
                  },
                }
                for panel in super.panels
              ],
            }
            for row in super.rows
          ],
        }
      for filename in std.objectFields(grafanaDashboards)
    },
  },

  // Legacy extension points for you to add your own dashboards.
  grafanaDashboards+:: std.foldr(
    function(mixinName, acc)
      local mixin = $.mixins[mixinName] + mixinProto;
      if !std.objectHas(mixin, 'grafanaDashboardFolder')
      then acc + mixin.grafanaDashboards
      else acc,
    std.objectFields($.mixins),
    {}
  ),

  dashboardsByFolder+:: std.foldr(
    function(mixinName, acc)
      local mixin = $.mixins[mixinName] + mixinProto;
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
