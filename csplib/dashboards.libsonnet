local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(this):
    {
      _common::
        g.dashboard.withTags(this.config.dashboardTags)
        + g.dashboard.withTimezone(this.config.dashboardTimezone)
        + g.dashboard.withRefresh(this.config.dashboardRefresh)
        + g.dashboard.timepicker.withTimeOptions(this.config.dashboardPeriod),
    }
    +
    {
      [this.config.uid + '-blobstorage.json']:
        local variables = this.signals.blobstore.getVariablesMultiChoice();
        g.dashboard.new(this.config.dashboardNamePrefix + 'Blob Storage')
        + g.dashboard.withUid(this.config.uid + '-blobstorage')
        + self._common
        + g.dashboard.withVariables([
          if v.label == 'Bucket_name'
          then v { label: 'Bucket Name' }
          else v
          for v in variables
        ])
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            this.grafana.rows.overview
            + this.grafana.rows.api
            + this.grafana.rows.network
          )
        ),
    },
}
