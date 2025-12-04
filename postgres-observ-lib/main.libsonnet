local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(): {
    local this = self,
    config: import './config.libsonnet',

    // Signal definitions organized by DBA priority tier
    local signalDefs = {
      // Tier 1: Critical Health - "Is there a problem RIGHT NOW?"
      health: (import './signals/health.libsonnet')(this.config),
      
      // Tier 2: Active Problems - Alert-worthy issues
      problems: (import './signals/problems.libsonnet')(this.config),
      
      // Tier 3: Performance Trends - Time series analysis
      performance: (import './signals/performance.libsonnet')(this.config),
      
      // Tier 4: Maintenance - Actionable tasks
      maintenance: (import './signals/maintenance.libsonnet')(this.config),
      
      // Tier 5: Query Analysis - Root cause (requires pg_stat_statements)
      queries: (import './signals/queries.libsonnet')(this.config),

      // Cluster-level signals - aggregate view across instances
      cluster: (import './signals/cluster.libsonnet')(this.config),
    },

    // Process signals from all tiers
    signals: {
      [sig]: commonlib.signals.unmarshallJsonMulti(signalDefs[sig], type=this.config.metricsSource)
      for sig in std.objectFields(signalDefs)
      },

    grafana: {
      panels: (import './panels/main.libsonnet').new(this.signals, this.config),
      rows: (import './rows.libsonnet').new(this.grafana.panels, type=this.config.metricsSource),

      links: {
        local link = g.dashboard.link,
        otherDashboards:
          link.dashboards.new('All PostgreSQL dashboards', this.config.dashboardTags)
          + link.dashboards.options.withIncludeVars(true)
          + link.dashboards.options.withKeepTime(true)
          + link.dashboards.options.withAsDropdown(false),
      },

      dashboards: (import './dashboards.libsonnet').new(this),
    },

    prometheus: {
      alerts: (import './alerts.libsonnet').new(this),
      recordingRules: {},
    },

    asMonitoringMixin(): {
      grafanaDashboards: this.grafana.dashboards,
      prometheusAlerts: this.prometheus.alerts,
      prometheusRules: this.prometheus.recordingRules,
    },
  },

  withConfigMixin(config): {
    config+: config,
  },
}
