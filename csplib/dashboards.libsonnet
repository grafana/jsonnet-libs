local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(csplib):
    local this = self;
    {
      [csplib.config.uid + '-blobstorage.json']:
        local variables = csplib.signals.blobstore.getVariablesMultiChoice();
        g.dashboard.new(csplib.config.dashboardNamePrefix + 'Blob Storage')
        + g.dashboard.withUid(csplib.config.uid + '-blobstorage')
        + g.dashboard.withTags(csplib.config.dashboardTags)
        + g.dashboard.withTimezone(csplib.config.dashboardTimezone)
        + g.dashboard.withRefresh(csplib.config.dashboardRefresh)
        + g.dashboard.timepicker.withTimeOptions(csplib.config.dashboardPeriod)
        + g.dashboard.withVariables([
          if std.asciiLower(v.label) == std.asciiLower(csplib.config.bucketLabel) #v.label == 'Bucket_name'
          then v { label: 'Bucket Name' }
          else v
          for v in variables
        ])
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            csplib.grafana.rows.overview
            + csplib.grafana.rows.api
            + csplib.grafana.rows.network,
          )
        ),
    },
}
