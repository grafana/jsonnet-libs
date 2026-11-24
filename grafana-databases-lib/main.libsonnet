// grafana-databases-lib: shared dashboard panels and rows for the Mimir, Loki,
// Tempo and Pyroscope mixins, built on grafonnet-latest. It builds dashboard v2
// (dashboard.grafana.app/v2) panels and rows; see dashboard.libsonnet.
//
//   local dblib = import 'grafana-databases-lib/main.libsonnet';
//   local databases =
//     dblib.new()
//     + dblib.withConfigMixin({ clusterLabel: 'cluster' })
//     + dblib.autoscaling.withConfigMixin({ components: { ... } });
//
//   databases.autoscaling.panels.querier.replicas
//   databases.autoscaling.rows.querier
//
// Everything reads `config` through `self`, so a config mixin added at any
// point re-derives every panel and row. Each area keeps its own portion of the
// config under config.<area>.
local autoscaling = import './autoscaling.libsonnet';
local dashboard = import './dashboard.libsonnet';

{
  new():: {
    local this = self,

    config: {
      local shared = self,
      // Dashboard datasource variable, or a datasource uid.
      datasource: '$datasource',
      // Labels identifying a cluster and a namespace.
      clusterLabel: 'cluster',
      namespaceLabel: 'namespace',
      // Matcher applied to kube-state-metrics series.
      selector: '%s=~"$cluster", %s=~"$namespace"' % [shared.clusterLabel, shared.namespaceLabel],
      // Labels used to join series.
      groupBy: [shared.clusterLabel, shared.namespaceLabel],

      autoscaling: autoscaling.defaults(shared),
    },

    autoscaling: autoscaling.new(this.config),
  },

  // withConfigMixin merges into the library-wide config.
  withConfigMixin(config):: { config+: config },

  autoscaling:: {
    // withConfigMixin merges into config.autoscaling.
    withConfigMixin(config):: { config+: { autoscaling+: config } },
  },

  // Assembling rows into a dashboard: `spec.elements` and `spec.layout` from a
  // list of rows, and custom rows from named panels.
  elements:: dashboard.elements,
  layout:: dashboard.layout,
  row:: dashboard.row,

  // Building custom panels.
  panel:: dashboard.panel,
  query:: dashboard.query,
  withViz:: dashboard.withViz,

  // legacy converts the library's panels and rows for dashboards still built
  // with grafana-builder, while they are migrated.
  legacy:: import './legacy.libsonnet',
}
