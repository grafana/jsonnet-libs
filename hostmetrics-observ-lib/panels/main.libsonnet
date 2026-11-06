local g = import '../g.libsonnet';
local alertsOverviewlib = import 'alerts-observ-lib/main.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(this): {
    local overviewUid = this.grafana.dashboards['hostmetrics-nodes.json'].uid,
    local datasourceVariable = this.grafana.variables.datasources.prometheus.name,
    local fleetTopK = 25,
    // Link to the host summary for the host in ref, i.e. '__field.labels' on series or '__data.fields' in tables.
    // common-lib's withDataLink always passes ${datasource}, but the variable is prometheus_datasource when Loki logs are enabled.
    local drillDownUrl(ref) = '/d/%s?%s&${__url_time_range}&${%s:queryparam}' % [
      overviewUid,
      std.join('&', ['var-%s=${%s.%s}' % [label, ref, label] for label in this.config.instanceLabels]),
      datasourceVariable,
    ],
    local common = {
      drillDownUrl:: drillDownUrl,
      drillDown: g.panel.timeSeries.standardOptions.withLinks({
        url: drillDownUrl('__field.labels'),
        title: 'Drill down to this instance',
      }),
      fleetTopK: fleetTopK,
      topNote: { description: 'Top %d. ' % fleetTopK + super.description },
      tableLegend:
        g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.options.legend.withCalcs(['mean', 'max', 'lastNotNull']),
      hideZeros: { options+: { tooltip+: { hideZeros: true } } },
      // Keeps series that are above 0 at some point in the dashboard's time range.
      activeInRange(signal)::
        local expr = signal.withInterval('$__range').asPanelExpression();
        local inRange =
          // Counters. common-lib rewrites increase into a subquery, so build rate and swap it.
          if std.length(std.findSubstr('rate(', expr)) > 0 then std.strReplace(expr, 'rate(', 'increase(')
          else 'max_over_time((%s)[$__range:])' % expr;
        signal.withExprWrappersMixin(['(', ') and ((%s) > 0)' % inRange]),
      hostTextSize: g.panel.stat.options.text.withValueSize(24),
      capacityTextSize: g.panel.stat.options.text.withValueSize(40),
      // Shared settings only: the full config would replace alerts-observ-lib's signals.
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
