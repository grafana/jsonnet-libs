local alerts = import './alerts.libsonnet';
local config = import './config.libsonnet';
local dashboards = import './dashboards.libsonnet';
local links = import './links.libsonnet';
local panels = import './panels.libsonnet';
local rows = import './rows.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  withConfigMixin(config): {
    config+: config,
  },

  new(): {
    local this = self,
    config: config,

    signals:
      {
        [sig]: commonlib.signals.unmarshallJsonMulti(
          this.config.signals[sig],
          type=this.config.metricsSource
        )
        for sig in std.objectFields(this.config.signals)
      },

    // Cluster-overview has no base_url variable, so its signals are scoped to
    // solr_cluster only (queriesSelector is frozen at unmarshall time).
    signalsCluster:
      {
        [sig]: commonlib.signals.unmarshallJsonMulti(
          this.config.signals[sig] { instanceLabels: ['solr_cluster'] },
          type=this.config.metricsSource
        )
        for sig in std.objectFields(this.config.signals)
      },

    grafana: {
      variables: commonlib.variables.new(
        filteringSelector=this.config.filteringSelector,
        groupLabels=this.config.groupLabels,
        instanceLabels=this.config.instanceLabels,
        // node-level metric: every Solr node exports JVM metrics, so job /
        // solr_cluster / base_url discovery works on all dashboards, including
        // resource monitoring where a node may host no cores.
        varMetric='solr_metrics_jvm_os_cpu_load',
        customAllValue=this.config.customAllValue,
        enableLokiLogs=this.config.enableLokiLogs,
      ),
      annotations: {},
      links: links.new(this),
      panels: panels.new(this),
      rows: rows.new(this),
      dashboards: dashboards.new(this),
    },

    prometheus: {
      alerts: alerts.new(this),
      recordingRules: {},
    },
  },
}
