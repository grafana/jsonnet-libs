local g = import './g.libsonnet';

{
  local root = self,
  new(this):
    local prefix = this.config.dashboardNamePrefix;
    local links = this.grafana.links;
    local tags = this.config.dashboardTags;
    local uid = this.config.uid;
    local vars = this.grafana.variables;
    local annotations = this.grafana.annotations;
    local refresh = this.config.dashboardRefresh;
    local period = this.config.dashboardPeriod;
    local timezone = this.config.dashboardTimezone;

    {
      'mongodb-atlas-cluster-overview.json':
        g.dashboard.new(prefix + ' cluster overview')
        + g.dashboard.withDescription('Overview of MongoDB Atlas cluster metrics.')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.clusterOverviewHardwareRow,
                this.grafana.rows.clusterOverviewDiskRow,
                this.grafana.rows.clusterOverviewNetworkRow,
                this.grafana.rows.clusterOverviewConnectionsRow,
                this.grafana.rows.clusterOverviewOperationsRow,
                this.grafana.rows.clusterOverviewLocksRow,
              ]
            )
          )
        )
        + root.applyCommon(
          vars.multiInstance,
          uid + '-cluster-overview',
          tags,
          links { clusterOverview+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),

      'mongodb-atlas-elections-overview.json':
        g.dashboard.new(prefix + ' elections overview')
        + g.dashboard.withDescription('Overview of MongoDB Atlas election metrics.')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.electionsStepUpRow,
                this.grafana.rows.electionsPriorityTakeoverRow,
                this.grafana.rows.electionsCatchUpTakeoverRow,
                this.grafana.rows.electionsTimeoutRow,
                this.grafana.rows.electionsCatchUpsRow,
              ]
            )
          )
        )
        + root.applyCommon(
          vars.multiInstance,
          uid + '-elections-overview',
          tags,
          links { electionsOverview+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),

      'mongodb-atlas-operations-overview.json':
        g.dashboard.new(prefix + ' operations overview')
        + g.dashboard.withDescription('Overview of MongoDB Atlas operation metrics.')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.operationsCountersClusterRow,
                this.grafana.rows.operationsCountersInstanceRow,
                this.grafana.rows.operationsLatenciesClusterRow,
                this.grafana.rows.operationsLatenciesInstanceRow,
                this.grafana.rows.operationsAvgLatenciesRow,
              ]
            )
          )
        )
        + root.applyCommon(
          vars.multiInstance,
          uid + '-operations-overview',
          tags,
          links { operationsOverview+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),

      'mongodb-atlas-performance-overview.json':
        g.dashboard.new(prefix + ' performance overview')
        + g.dashboard.withDescription('Overview of MongoDB Atlas performance metrics.')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.performanceConnectionsRow,
                this.grafana.rows.performanceDbLocksClusterRow,
                this.grafana.rows.performanceDbLocksInstanceRow,
                this.grafana.rows.performanceDbWaitCountsClusterRow,
                this.grafana.rows.performanceDbWaitCountsInstanceRow,
                this.grafana.rows.performanceDbAcqTimeRow,
                this.grafana.rows.performanceCollLocksRow,
                this.grafana.rows.performanceCollWaitCountsRow,
                this.grafana.rows.performanceCollAcqTimeRow,
              ]
            )
          )
        )
        + root.applyCommon(
          vars.multiInstance,
          uid + '-performance-overview',
          tags,
          links { performanceOverview+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),
    }
    +
    if this.config.enableShardingOverview then
      {
        'mongodb-atlas-sharding-overview.json':
          g.dashboard.new(prefix + ' sharding overview')
          + g.dashboard.withDescription('Overview of MongoDB Atlas sharding metrics.')
          + g.dashboard.withPanels(
            g.util.panel.resolveCollapsedFlagOnRows(
              g.util.grid.wrapPanels(
                [
                  this.grafana.rows.overview,
                ]
              )
            )
          )
          + root.applyCommon(
            vars.multiInstance,
            uid + '-sharding-overview',
            tags,
            links { shardingOverview+:: {} },
            annotations,
            timezone,
            refresh,
            period
          ),
      } else {},

  applyCommon(vars, uid, tags, links, annotations, timezone, refresh, period):
    g.dashboard.withTags(tags)
    + g.dashboard.withUid(uid)
    + g.dashboard.withLinks(std.objectValues(links))
    + g.dashboard.withTimezone(timezone)
    + g.dashboard.withRefresh(refresh)
    + g.dashboard.time.withFrom(period)
    + g.dashboard.withVariables(vars)
    + g.dashboard.withAnnotations(std.objectValues(annotations)),
}
