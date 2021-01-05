local util = import 'util.libsonnet';

{
  getFolder(main):: util.get(main, 'grafanaDashboardFolder', 'General'),

  fromMap(dashboards, folder):: {
    [k]: util.makeResource('Dashboard', k, dashboards[k], { folder: folder })
    for k in std.objectFields(dashboards)
  },

  fromMixins(mixins):: {
    [key]:
      local mixin = mixins[key];
      {
        local folder = util.get(mixin, 'grafanaDashboardFolder', 'General'),
        [k]: util.makeResource('Dashboard', k, mixin.grafanaDashboards[k], { folder: folder })
        for k in std.objectFieldsAll(util.get(mixin, 'grafanaDashboards', {}))
      }
    for key in std.objectFields(mixins)
  },
}
