{
  local configMap = $.core.v1.configMap,

  _config+:: {
    // Shard dashboards across multiple config maps to overcome annotation
    // length limits.
    dashboard_config_maps: 8,
  },

  mixins+:: {},

  // convert to format expected by `grafana/grafana.libsonnet`:
  grafanaDashboardFolders+:: std.foldr(
    function(name, acc)
      acc
      + (if !std.objectHasAll($.mixins[name], 'grafanaDashboards')
         then {}
         else {
           [if std.objectHasAll($.mixins[name], 'grafanaDashboardFolder') then $.folderID($.mixins[name].grafanaDashboardFolder) else 'general']+: {
             dashboards+: ($.mixins[name] + mixinProto).grafanaDashboards,
             shards: if std.objectHasAll($.mixins[name], 'grafanaDashboardShards') then $.mixins[name].grafanaDashboardShards else 1,
             name: if std.objectHasAll($.mixins[name], 'grafanaDashboardFolder') then $.mixins[name].grafanaDashboardFolder else 'General',
             id: $.folderID(self.name),
           },
         }),
    std.objectFields($.mixins),
    {}
  ) + {
    general+: {
      shards: $._config.dashboard_config_maps,  // legacy dashboard configmap setting
    },
  },

  // mixinProto allows us to reliably do `mixin.grafanaDashboards` without
  // having to check the field exists first. Some mixins don't declare all
  // the fields, and that's fine.
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
}
