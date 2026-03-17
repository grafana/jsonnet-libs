# Alerts observability library

Single `ALERTS` signal with one alerts-overview dashboard (alertlist panel grouped by configurable labels).  
Note that this library doesn't provide prometheus alerts themselves, only alerts presenation as annotations and dashboard panel that can be easily imported into other libraries or mixins.

## Example

### Simple init
```jsonnet
local alertslib = import 'alerts-observ-lib/main.libsonnet';

alertslib.new()
+ alertslib.withConfigMixin({
  filteringSelector: 'job="integrations/myapp"',
  groupLabels: ['cluster', 'container'],
  instanceLabels: ['instance'],
  uid: 'myapp',
})
| asMonitoringMixin()
```

### Import into another observ-lib

```
# dashboards.libsonnet
local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local alertsOverviewlib = import 'alerts-observ-lib/main.libsonnet';


{
  new(this):
    {
      local alertsOverview = 
        alertsOverviewlib.new()
        + alertsOverviewlib.withConfigMixin(this.config),

      'some-dashboard-overview.json':
        g.dashboard.new(this.config.dashboardNamePrefix + 'overview')
        + g.dashboard.withUid(this.config.uid + '-overview')
        + g.dashboard.withTags(this.config.dashboardTags)
        //insert here annotations:
        + g.dashboard.withAnnotations(std.objectValues(alertsOverview.grafana.annotations))
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            g.util.panel.resolveCollapsedFlagOnRows(
              [
                g.panel.row.new('Overview')
                + g.panel.row.withCollapsed(false)
                + g.panel.row.withPanels(
                  [
                    //insert here resized alerts panel annotations
                    alertsOverview.grafana.panels.alertsOverview { gridPos: { w: 12, h: 12 } },
                    // some other panel
                    panels.serviceMap { gridPos: { w: 12, h: 12 } },
                  ],
                ),
              ],
            ),
          ), setPanelIDs=false  // required to reuse queries
        ),
    },
}


```