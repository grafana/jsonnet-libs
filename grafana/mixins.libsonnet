  {
    mixins+:: {},

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