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
      'blobstorage.json':
        g.dashboard.new(this.config.dashboardNamePrefix + 'Blob Storage')
        + g.dashboard.withUid(this.config.uid + '-blobstorage')
        + self._common
        + g.dashboard.withVariables(
          this.signals.blobstore.getVariablesMultiChoice(),
        )
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            this.grafana.rows.overview
          )
        ),
    },
}
