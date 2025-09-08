local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local logslib = import 'logs-lib/logs/main.libsonnet';

{
  local root = self,
  new(this)::
    local prefix = this.config.dashboardNamePrefix;
    local links = this.grafana.links;
    local tags = this.config.dashboardTags;
    local uid = g.util.string.slugify(this.config.uid);
    local vars = this.grafana.variables;
    local annotations = this.grafana.annotations;
    local refresh = this.config.dashboardRefresh;
    local period = this.config.dashboardPeriod;
    local timezone = this.config.dashboardTimezone;
    {

      // NameNode dashboard
      'apache-hadoop-namenode-overview.json':
        g.dashboard.new(prefix + ' NameNode overview')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.namenodeOverview,
              ]
            )
          )
        ) + root.applyCommon(
          vars.multiInstance,
          uid + '_namenode_overview',
          tags,
          links { hadoopNameNodeOverview:: {} },
          annotations,
          timezone,
          refresh,
          period,
        ),

      // DataNode dashboard
      'apache-hadoop-datanode-overview.json':
        g.dashboard.new(prefix + ' DataNode overview')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.datanodeOverview,
              ]
            )
          )
        ) + root.applyCommon(
          vars.multiInstance,
          uid + '_datanode_overview',
          tags,
          links { hadoopDataNodeOverview:: {} },
          annotations,
          timezone,
          refresh,
          period,
        ),

      // NodeManager dashboard
      'apache-hadoop-nodemanager-overview.json':
        g.dashboard.new(prefix + ' NodeManager overview')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.nodemanagerOverview,
                this.grafana.rows.nodeManagerJVM,
                this.grafana.rows.nodeManagerNode,
                this.grafana.rows.nodeManagerContainers,
              ]
            )
          )
        ) + root.applyCommon(
          vars.multiInstance,
          uid + '_nodemanager_overview',
          tags,
          links { hadoopNodeManagerOverview:: {} },
          annotations,
          timezone,
          refresh,
          period,
        ),

      // ResourceManager dashboard
      'apache-hadoop-resourcemanager-overview.json':
        g.dashboard.new(prefix + ' ResourceManager overview')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.resourcemanagerOverview,
                this.grafana.rows.resourcemanagerApplications,
                this.grafana.rows.resourcemanagerJVM,
              ]
            )
          )
        ) + root.applyCommon(
          vars.multiInstance,
          uid + '_resourcemanager_overview',
          tags,
          links { hadoopResourceManagerOverview:: {} },
          annotations,
          timezone,
          refresh,
          period,
        ),
    }
    +
    if this.config.enableLokiLogs then
      {
        'apache-hadoop-logs-overview.json':
          logslib.new(
            prefix + ' logs',
            datasourceName=this.grafana.variables.datasources.loki.name,
            datasourceRegex=this.grafana.variables.datasources.loki.regex,
            filterSelector=this.config.filteringSelector,
            labels=this.config.groupLabels + this.config.extraLogLabels,
            formatParser=null,
            showLogsVolume=this.config.showLogsVolume,
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
      }
    else {},

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
