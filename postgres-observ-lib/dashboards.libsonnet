local g = import './g.libsonnet';

{
  new(this):
    local settingsFilterVar =
      g.dashboard.variable.textbox.new('settingsFilter', default='')
      + g.dashboard.variable.textbox.generalOptions.withLabel('Settings Filter (regex)')
      + g.dashboard.variable.textbox.generalOptions.withDescription('Regex pattern to filter pg_settings_* metrics. Leave empty to show all settings.');

    // Helper to make a variable single-select (no "All", no multi)
    local makeSingleSelect(v) = v {
      includeAll: false,
      multi: false,
      allValue: null,
    };

    // Helper to make specific variables single-select by name
    local makeSingleSelectByName(vars, names) = [
      if std.member(names, v.name) then makeSingleSelect(v) else v
      for v in vars
    ];

    // Cluster dashboard variables: exclude instance, make cluster single-select
    local clusterVariables = makeSingleSelectByName(
      std.filter(function(v) v.name != 'instance', this.signals.cluster.getVariablesMultiChoice()),
      ['cluster']
    );

    // Instance dashboard variables: make instance single-select
    local instanceVariables = makeSingleSelectByName(
      this.signals.health.getVariablesMultiChoice(),
      ['instance']
    );

    // Queries dashboard variables: make instance single-select
    local queriesVariables = makeSingleSelectByName(
      this.signals.queries.getVariablesMultiChoice(),
      ['instance']
    );

    {
      // Cluster overview dashboard - Top-level view of the entire cluster
      'postgres-cluster.json':
        g.dashboard.new(this.config.dashboardNamePrefix + 'PostgreSQL Cluster Overview')
        + g.dashboard.withVariables(clusterVariables)
        + g.dashboard.withTags(this.config.dashboardTags + ['cluster'])
        + g.dashboard.withUid(this.config.uid + '-cluster')
        + g.dashboard.withLinks(this.grafana.links.otherDashboards)
        + g.dashboard.withDescription(
          |||
            PostgreSQL Cluster monitoring dashboard.

            Provides a top-level view of the entire cluster:
            - Cluster health at-a-glance
            - Instance list with drill-down
            - Master history / failover tracking
            - Replication topology and lag
            - Read/Write split visibility
            - Cluster-wide problems and resources

            Click on an instance row to drill down to the instance-level dashboard.
          |||
        )
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels([
              this.grafana.rows.clusterHealth,
              this.grafana.rows.clusterInstances,  // Includes role history and failover events
              this.grafana.rows.clusterProblems,
              this.grafana.rows.clusterReplication,
              this.grafana.rows.clusterReadWrite,
              this.grafana.rows.clusterResources,
            ])
          ), setPanelIDs=false
        ),

      // Main overview dashboard - Single pane of glass
      'postgres-overview.json':
        g.dashboard.new(this.config.dashboardNamePrefix + 'PostgreSQL Overview')
        + g.dashboard.withVariables(
          instanceVariables
          + [settingsFilterVar]
        )
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
            - Settings: PostgreSQL configuration parameters
          |||
        )
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels([
              this.grafana.rows.health,
              this.grafana.rows.problems,
              this.grafana.rows.performance,
              this.grafana.rows.maintenance,
              this.grafana.rows.settings,
            ])
          ), setPanelIDs=false
        ),

      // Query performance dashboard - Requires pg_stat_statements
      'postgres-queries.json':
        g.dashboard.new(this.config.dashboardNamePrefix + 'PostgreSQL Query Performance')
        + g.dashboard.withVariables(queriesVariables)
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
