local g = import '../g.libsonnet';
local alertsOverviewlib = import 'alerts-observ-lib/main.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(this): {
    local overviewUid = this.grafana.dashboards['nodes.json'].uid,
    local datasourceVariable = this.grafana.variables.datasources.prometheus.name,
    local fleetTopK = 25,
    local common = {
      overviewUid: overviewUid,
      datasourceVariable: datasourceVariable,
      drillDown: commonlib.panels.generic.timeSeries.base.withDataLink(this.config.instanceLabels, overviewUid),
      fleetTopK: fleetTopK,
      topNote: { description: 'Top %d. ' % fleetTopK + super.description },
      fleetLegend:
        g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.options.legend.withCalcs(['mean', 'max', 'lastNotNull']),
      hostTextSize: g.panel.stat.options.text.withValueSize(24),
      capacityTextSize: g.panel.stat.options.text.withValueSize(40),
      // Only the shared settings: our whole config would replace alerts-observ-lib's own signals.
      alertsOverview:
        alertsOverviewlib.new()
        + alertsOverviewlib.withConfigMixin({
          filteringSelector: this.config.filteringSelector,
          groupLabels: this.config.groupLabels,
          instanceLabels: this.config.instanceLabels,
          uid: this.config.uid,
          dashboardNamePrefix: this.config.dashboardNamePrefix,
          dashboardTags: this.config.dashboardTags,
          signals+: { alerts+: { datasource: datasourceVariable } },
        }),
    },

    fleet: (import './fleet.libsonnet').new(this, common),
    host: (import './host.libsonnet').new(this, common),
    cpu: (import './cpu.libsonnet').new(this, common),
    memory: (import './memory.libsonnet').new(this, common),
    disk: (import './disk.libsonnet').new(this, common),
    filesystem: (import './filesystem.libsonnet').new(this, common),
    network: (import './network.libsonnet').new(this, common),
  },
}
