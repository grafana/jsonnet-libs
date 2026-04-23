local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local logslib = import 'logs-lib/logs/main.libsonnet';
{
  local root = self,
  new(this)::

    local links = this.grafana.links;
    local tags = this.config.dashboardTags;
    local uid = g.util.string.slugify(this.config.uid);
    local vars = this.grafana.variables;
    local annotations = this.grafana.annotations;
    local refresh = this.config.dashboardRefresh;
    local period = this.config.dashboardPeriod;
    local timezone = this.config.dashboardTimezone;
    {
      'mongodb-overview.json':
        g.dashboard.new(this.config.dashboardNamePrefix + ' overview')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels([
              this.grafana.rows.overviewHealth,
              this.grafana.rows.overviewPerformance,
            ])
          )
        ) + root.applyCommon(
          vars.multiInstance,
          uid + '-overview',
          tags,
          links { mongodbOverview+:: {} },
          annotations,
          timezone,
          refresh,
          period,
        ),

      'mongodb-instance.json':
        g.dashboard.new(this.config.dashboardNamePrefix + ' instance')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels([
              this.grafana.rows.instanceOverview,
              this.grafana.rows.instanceServiceSummary,
            ])
          )
        ) + root.applyCommon(
          vars.multiInstance,
          uid + '-instance',
          tags,
          links { mongodbInstance+:: {} },
          annotations,
          timezone,
          refresh,
          period,
        ),

      'mongodb-replicaset.json':
        g.dashboard.new(this.config.dashboardNamePrefix + ' replica set')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels([
              this.grafana.rows.replicasetOverview,
              this.grafana.rows.replicasetPerformance,
              this.grafana.rows.replicasetOplogDetails,
            ])
          )
        ) + root.applyCommon(
          vars.multiInstance + [
            g.dashboard.variable.query.new('replset')
            + g.dashboard.variable.query.queryTypes.withLabelValues(label='set', metric='mongodb_mongod_replset_my_state{%(queriesSelector)s}' % vars)
            + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.prometheus)
            + g.dashboard.variable.query.selectionOptions.withMulti(true)
            + g.dashboard.variable.query.selectionOptions.withIncludeAll(true)
            + g.dashboard.variable.query.generalOptions.withLabel('Replica set'),

            g.dashboard.variable.query.new('secondary')
            + g.dashboard.variable.query.queryTypes.withLabelValues(label='service_name', metric='mongodb_mongod_replset_member_replication_lag{%(queriesSelector)s}' % vars)
            + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.prometheus)
            + g.dashboard.variable.query.selectionOptions.withMulti(true)
            + g.dashboard.variable.query.selectionOptions.withIncludeAll(true)
            + g.dashboard.variable.query.generalOptions.withLabel('Secondary'),
          ],
          uid + '-replicaset',
          tags,
          links { mongodbReplicaset+:: {} },
          annotations,
          timezone,
          refresh,
          period,
        ),

      'mongodb-cluster.json':
        g.dashboard.new(this.config.dashboardNamePrefix + ' cluster')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels([
              this.grafana.rows.clusterOverview,
              this.grafana.rows.clusterChunks,
              this.grafana.rows.clusterIndexes,
              this.grafana.rows.clusterConnections,
              this.grafana.rows.clusterOperations,
              this.grafana.rows.clusterCursors,
              this.grafana.rows.clusterAdditionalInfo,
            ])
          )
        ) + root.applyCommon(
          vars.multiInstance + [
            g.dashboard.variable.query.new('shard')
            + g.dashboard.variable.query.queryTypes.withLabelValues(label='set', metric='mongodb_mongod_replset_my_state{%(queriesSelector)s}' % vars)
            + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.prometheus)
            + g.dashboard.variable.query.selectionOptions.withMulti(true)
            + g.dashboard.variable.query.selectionOptions.withIncludeAll(true)
            + g.dashboard.variable.query.generalOptions.withLabel('Shard'),
          ],
          uid + '-cluster',
          tags,
          links { mongodbCluster+:: {} },
          annotations,
          timezone,
          refresh,
          period,
        ),

    } + if this.config.enableLokiLogs then {
      'mongodb-logs.json':
        logslib.new(
          this.config.dashboardNamePrefix + ' logs',
          datasourceName=this.grafana.variables.datasources.loki.name,
          datasourceRegex=this.grafana.variables.datasources.loki.regex,
          filterSelector=this.config.filteringSelector,
          labels=this.config.groupLabels + this.config.extraLogLabels,
          formatParser=null,
          showLogsVolume=this.config.showLogsVolume,
          customAllValue=this.config.customAllValue,
        )
        {
          dashboards+:
            {
              logs+:
                root.applyCommon(super.logs.templating.list, uid=uid + '-logs', tags=tags, links=links { logs+:: {} }, annotations=annotations, timezone=timezone, refresh=refresh, period=period),
            },
          panels+:
            {
              logs+:
                g.panel.logs.options.withEnableLogDetails(true)
                + g.panel.logs.options.withShowTime(false)
                + g.panel.logs.options.withWrapLogMessage(false),
            },
          variables+: {
            toArray+: [
              this.grafana.variables.datasources.prometheus { hide: 2 },
            ],
          },
        }.dashboards.logs,
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
