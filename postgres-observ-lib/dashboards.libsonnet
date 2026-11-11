local g = import './g.libsonnet';

{
  local root = self,
  new(this):
    local tags = this.config.dashboardTags;
    local uid = this.config.uid;
    local links = this.grafana.links.otherDashboards;
    local timezone = this.config.dashboardTimezone;
    local refresh = this.config.dashboardRefresh;
    local period = this.config.dashboardPeriod;

    local settingsFilterVar =
      g.dashboard.variable.textbox.new('settingsFilter', default='')
      + g.dashboard.variable.textbox.generalOptions.withLabel('Settings filter (regex)')
      + g.dashboard.variable.textbox.generalOptions.withDescription('Regex pattern to filter pg_settings_* metrics. Leave empty to show all settings.');

    // Variable for topk query limit (10 is first = default)
    local topkVar =
      g.dashboard.variable.custom.new('topk', values=['10', '5', '15', '20', '25', '50'])
      + g.dashboard.variable.custom.generalOptions.withLabel('Top K queries')
      + g.dashboard.variable.custom.generalOptions.withDescription('Number of top queries to show in each panel.');

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

    // Matches servers without a cluster label: .* also matches an empty label.
    // The framework's default label would be "Postgres_cluster".
    local makeClusterOptional(vars) = [
      (if v.name == 'postgres_cluster' then v { label: 'PostgreSQL cluster' } else v)
      + (if std.member(['postgres_cluster', 'cluster'], v.name) && std.get(v, 'includeAll', false) then { allValue: '.*' } else {})
      for v in vars
    ];

    // The cluster overview shows one PostgreSQL cluster and all of its instances.
    local clusterVariables = makeClusterOptional(makeSingleSelectByName(
      std.filter(function(v) !std.member(this.config.instanceLabels, v.name), this.signals.cluster.getVariablesMultiChoice()),
      ['postgres_cluster']
    ));

    local instanceVariables = makeClusterOptional(this.signals.health.getVariablesSingleChoice());

    local queriesVariables = makeClusterOptional(this.signals.queries.getVariablesSingleChoice()) + [topkVar];

    {
      'postgres-cluster.json':
        g.dashboard.new(this.config.dashboardNamePrefix + 'PostgreSQL cluster overview')
        + root.applyCommon(clusterVariables, uid + '-cluster', tags + ['cluster'], links, timezone, refresh, period)
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
              this.grafana.rows.clusterInstances,
              this.grafana.rows.clusterProblems,
              this.grafana.rows.clusterReplication,
              this.grafana.rows.clusterReadWrite,
              this.grafana.rows.clusterResources,
            ])
          ), setPanelIDs=false
        ),

      'postgres-overview.json':
        g.dashboard.new(this.config.dashboardNamePrefix + 'PostgreSQL instance overview')
        + root.applyCommon(instanceVariables + [settingsFilterVar], uid + '-overview', tags + ['instance'], links, timezone, refresh, period)
        + g.dashboard.withDescription(
          |||
            PostgreSQL instance monitoring dashboard.

            Drill down from the Cluster Overview to investigate a specific instance.

            Sections:
            - Health: At-a-glance status
            - Problems: Issues needing attention
            - Settings: PostgreSQL configuration parameters
          |||
        )
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels([
              this.grafana.rows.health,
              this.grafana.rows.problems,
              this.grafana.rows.settings,
            ])
          ), setPanelIDs=false
        ),

      'postgres-performance-maintenance.json':
        g.dashboard.new(this.config.dashboardNamePrefix + 'PostgreSQL instance performance and maintenance')
        + root.applyCommon(instanceVariables, uid + '-performance-maintenance', tags + ['instance'], links, timezone, refresh, period)
        + g.dashboard.withDescription(
          |||
            PostgreSQL instance trends and maintenance work.

            Sections:
            - Performance: Throughput and resource trends
            - Maintenance: Vacuum, bloat, and capacity planning
          |||
        )
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels([
              this.grafana.rows.performance,
              this.grafana.rows.maintenance,
            ])
          ), setPanelIDs=false
        ),

      'postgres-queries.json':
        g.dashboard.new(this.config.dashboardNamePrefix + 'PostgreSQL query performance')
        + root.applyCommon(queriesVariables, uid + '-queries', tags + ['pg_stat_statements'], links, timezone, refresh, period)
        + g.dashboard.withDescription(
          |||
            PostgreSQL query performance analysis.            
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

  applyCommon(vars, uid, tags, links, timezone, refresh, period):
    g.dashboard.withVariables(vars)
    + g.dashboard.withTags(tags)
    + g.dashboard.withUid(uid)
    + g.dashboard.withLinks(links)
    + g.dashboard.withTimezone(timezone)
    + g.dashboard.withRefresh(refresh)
    + g.dashboard.time.withFrom(period),
}
