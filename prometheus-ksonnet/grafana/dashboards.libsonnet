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
  // - Dashboard UIDs are set to the md5 hash of their filename.
  // - Timezone are set to be "default" (ie local).
  // - Tooltip only show a single value.
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
      if !$.isFolderedMixin(mixin)
      then acc + mixin.grafanaDashboards
      else acc,
    std.objectFields($.mixins),
    {}
  ),

  // Config map names can't contain special chars, this is a hack but will
  // do for now.
  folderID(folder)::
    local lower = std.asciiLower(folder);
    local underscore = std.strReplace(lower, '_', '-');
    local space = std.strReplace(underscore, ' ', '-');
    space,

  // Helper to decide is a mixin should go in a folder or not.
  isFolderedMixin(m)::
    local mixin = m + mixinProto;
    std.objectHas(mixin, 'grafanaDashboardFolder') &&
    std.length(mixin.grafanaDashboards) > 0,

  // Its super common for a single mixin's worth of dashboards to not even fit
  // in a single config map.  So we split each mixin's dashboards up over
  // multiple config maps, depending on the hash of dashboards name.
  local sharded_config_maps(name_prefix, shards, dashboards) = {
    ['%s-%d' % [name_prefix, shard]]+:
      configMap.new('%s-%d' % [name_prefix, shard]) +
      configMap.withDataMixin({
        [name]: std.toString(dashboards[name])
        for name in std.objectFields(dashboards)
        if std.codepoint(std.md5(name)[1]) % shards == shard
      }) +
      configMap.mixin.metadata.withLabels($._config.grafana_dashboard_labels)
    for shard in std.range(0, shards - 1)
  },

  // Map containing all the sharded config maps for dashboards in no folder.
  // ie dashboards_config_maps[dashboard name] -> dashboard
  dashboards_config_maps:
    sharded_config_maps(
      'dashboards',
      $._config.dashboard_config_maps,
      $.grafanaDashboards,
    ),

  // Map containing maps of all the sharded config maps for each folder.
  // ie dashboard_folders_config_maps[dashboard folder][dashboard name] -> dashboard
  dashboard_folders_config_maps: std.foldr(
    function(mixinName, acc)
      local mixin = $.mixins[mixinName] + mixinProto;
      if !$.isFolderedMixin(mixin)
      then acc
      else
        local config_map_name = 'dashboards-%s' % $.folderID(mixin.grafanaDashboardFolder);
        acc {
          [config_map_name]+:
            sharded_config_maps(
              config_map_name,
              if std.objectHas(mixin, 'grafanaDashboardShards')
              then mixin.grafanaDashboardShards
              else 1,
              mixin.grafanaDashboards
            ),
        },
    std.objectFields($.mixins),
    {},
  ),

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
            name: 'dashboards-%s' % $.folderID($.mixins[mixinName].grafanaDashboardFolder),
            orgId: 1,
            folder: $.mixins[mixinName].grafanaDashboardFolder,
            type: 'file',
            disableDeletion: true,
            editable: false,
            options: {
              path: '/grafana/dashboards-%s' % $.folderID($.mixins[mixinName].grafanaDashboardFolder),
            },
          }
          for mixinName in std.objectFields($.mixins)
          if $.isFolderedMixin($.mixins[mixinName])
        ],
      }),
    }),
}
