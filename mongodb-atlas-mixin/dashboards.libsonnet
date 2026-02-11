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

    local rsNmVariable = g.dashboard.variable.query.new('rs_nm')
                         + g.dashboard.variable.custom.selectionOptions.withMulti(true)
                         + g.dashboard.variable.custom.selectionOptions.withIncludeAll(true)
                         + g.dashboard.variable.query.queryTypes.withLabelValues(label='rs_nm', metric='mongodb_network_bytesIn')
                         + g.dashboard.variable.query.withDatasourceFromVariable(variable=vars.datasources.prometheus)
                         + g.dashboard.variable.query.refresh.onTime();

    {
      'mongodb-atlas-cluster-overview.json':
        g.dashboard.new(prefix + ' cluster overview')
        + g.dashboard.withDescription('Overview of MongoDB Atlas cluster metrics.')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.clusterOverviewShardRow,
                this.grafana.rows.clusterOverviewConfigRow,
                this.grafana.rows.clusterOverviewMongosRow,
                this.grafana.rows.clusterOverviewPerformanceRow,
                this.grafana.rows.clusterOverviewOperationsRow,
                this.grafana.rows.clusterOverviewLocksRow,
              ]
            )
          )
        )
        + root.applyCommon(
          vars.multiInstance + [
            rsNmVariable,
          ],
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
                this.grafana.rows.electionsRow,
                this.grafana.rows.electionsCatchUpsRow,
              ]
            )
          )
        )
        + root.applyCommon(
          vars.multiInstance + [
            rsNmVariable,
          ],
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
                this.grafana.rows.operationsRow,
                this.grafana.rows.operationsConnectionsRow,
                this.grafana.rows.operationsReadWriteRow,
                this.grafana.rows.operationsLocksRow,
              ]
            )
          )
        )
        + root.applyCommon(
          vars.multiInstance + [
            rsNmVariable,
          ],
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
                this.grafana.rows.performanceMemoryHardwareRow,
                this.grafana.rows.performanceDiskRow,
                this.grafana.rows.performanceNetworkRow,
                this.grafana.rows.performanceHardwareIORow,
              ]
            )
          )
        )
        + root.applyCommon(
          vars.multiInstance + [
            rsNmVariable,
          ],
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
                  this.grafana.rows.shardingGeneralStatsRow,
                  this.grafana.rows.shardingCatalogCacheRow,
                  this.grafana.rows.shardingOperationsRow,
                ]
              )
            )
          )
          + root.applyCommon(
            vars.multiInstance + [
              rsNmVariable,
            ],
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
