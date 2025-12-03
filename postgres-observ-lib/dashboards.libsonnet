local g = import './g.libsonnet';

{
  new(this):
    {
      // Main overview dashboard - Single pane of glass
      'postgres-overview.json':
        g.dashboard.new(this.config.dashboardNamePrefix + 'PostgreSQL Overview')
        + g.dashboard.withVariables(this.signals.health.getVariablesMultiChoice())
        + g.dashboard.withTags(this.config.dashboardTags)
        + g.dashboard.withUid(this.config.uid + '-overview')
        + g.dashboard.withLinks(this.grafana.links.otherDashboards)
        + g.dashboard.withDescription(
          |||
            PostgreSQL monitoring dashboard for DBAs.
            
            Tiers:
            - Health: At-a-glance status (always visible)
            - Problems: Issues needing attention
            - Performance: Throughput and resource trends
            - Maintenance: Vacuum, bloat, and capacity planning
          |||
        )
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels([
              this.grafana.rows.health,
              this.grafana.rows.problems,
              this.grafana.rows.performance,
              this.grafana.rows.maintenance,
            ])
          ), setPanelIDs=false
        ),

      // Query performance dashboard - Requires pg_stat_statements
      'postgres-queries.json':
        g.dashboard.new(this.config.dashboardNamePrefix + 'PostgreSQL Query Performance')
        + g.dashboard.withVariables(this.signals.queries.getVariablesMultiChoice())
        + g.dashboard.withTags(this.config.dashboardTags + ['pg_stat_statements'])
        + g.dashboard.withUid(this.config.uid + '-queries')
        + g.dashboard.withLinks(this.grafana.links.otherDashboards)
        + g.dashboard.withDescription(
          |||
            PostgreSQL query performance analysis.
            
            Requires pg_stat_statements extension:
            
            1. Add to postgresql.conf:
               shared_preload_libraries = 'pg_stat_statements'
            
            2. Restart PostgreSQL
            
            3. Create extension:
               CREATE EXTENSION pg_stat_statements;
          |||
        )
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels([
              this.grafana.rows.queries,
            ])
          ), setPanelIDs=false
        ),
    },
}
