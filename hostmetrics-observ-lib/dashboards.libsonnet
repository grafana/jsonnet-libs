local g = import './g.libsonnet';
local logslib = import 'logs-lib/logs/main.libsonnet';
{
  local root = self,
  new(this):
    local prefix = this.config.dashboardNamePrefix;
    local links = this.grafana.links;
    local tags = this.config.dashboardTags;
    local uid = g.util.string.slugify(this.config.uid);
    local vars = this.grafana.variables;
    local refresh = this.config.dashboardRefresh;
    local period = this.config.dashboardPeriod;
    local timezone = this.config.dashboardTimezone;
    local annotations = this.grafana.annotations;
    local panels = this.grafana.panels;
    local rows = this.grafana.rows;
    local layout(items, w, h) =
      g.dashboard.withPanels(g.util.panel.resolveCollapsedFlagOnRows(g.util.grid.wrapPanels(items, w, h)));
    local common(vars, name, links) =
      root.applyCommon(vars, uid + '-' + name, tags, links, annotations, timezone, refresh, period);
    local logsLabels = this.config.logsGroupLabels + this.config.logsInstanceLabels + this.config.extraLogLabels;
    // Logs sent over OTLP are labeled service_instance_id where metrics have instance. The logs dashboard names
    // its variable after the metrics label, so links between the dashboards keep the host.
    local logsVarNames = {
      [this.config.logsInstanceLabels[i]]: this.config.instanceLabels[i]
      for i in std.range(0, std.min(std.length(this.config.logsInstanceLabels), std.length(this.config.instanceLabels)) - 1)
    };
    local metricsVarLabels = { [v.name]: v.label for v in vars.multiInstance };
    local withMetricsVarNames(dashboard) =
      local rename(expr) =
        std.foldl(function(e, old) std.strReplace(e, '$' + old, '$' + logsVarNames[old]), std.objectFields(logsVarNames), expr);
      dashboard {
        templating+: {
          list: [
            if std.objectHas(logsVarNames, v.name) then v { name: logsVarNames[v.name], label: metricsVarLabels[logsVarNames[v.name]] }
            else v
                 + (if std.objectHas(v, 'label') then { label: std.strReplace(v.label, '_', ' ') } else {})
                 + (if std.isString(std.get(v, 'query')) then { query: rename(v.query) } else {})
            for v in super.list
          ],
        },
        panels: [
          p { [if std.objectHas(p, 'targets') then 'targets']: [t { expr: rename(t.expr) } for t in p.targets] }
          for p in super.panels
        ],
      };
    // Hidden, so links keep them and the annotations, which filter on them, work.
    local metricsGroupVars = [
      v { hide: 2 }
      for v in vars.multiInstance
      if std.member(this.config.groupLabels, v.name) && !std.member(logsLabels, v.name)
    ];
    {
      'fleet.json':
        g.dashboard.new(prefix + 'fleet overview')
        + layout([
          panels.fleet.fleetOverviewTable { gridPos+: { w: 24, h: 10 } },
          rows.fleetCompute,
          rows.fleetStorageAndNetwork,
        ], 12, 8)
        // hide link to self
        + common(vars.multiInstance, 'fleet', links { backToFleet+:: {}, backToOverview+:: {} }),

      'nodes.json':
        g.dashboard.new(prefix + 'overview')
        + layout([
          rows.nodesHost,
          rows.nodesCapacity,
          rows.nodesAlerts,
          rows.nodesCpu,
          rows.nodesMemory,
          rows.nodesDisk,
          rows.nodesNetworkAndProcesses,
        ], 6, 4)
        + common(vars.singleInstance, 'nodes', links { backToOverview+:: {} }),

      'system.json':
        g.dashboard.new(prefix + 'CPU and system')
        + layout([
          rows.systemUtilization,
          rows.systemSystem,
        ], 12, 8)
        + common(vars.singleInstance, 'system', links),

      'memory.json':
        g.dashboard.new(prefix + 'memory')
        + layout(
          [rows.memoryUtilization]
          + (if this.config.enablePagingScraper then [rows.memoryPaging] else []),
          12,
          8
        )
        + common(vars.singleInstance, 'memory', links),

      'disks.json':
        g.dashboard.new(prefix + 'filesystem and disks')
        + layout([
          rows.disksFilesystems,
          rows.disksIO,
        ], 12, 8)
        + common(vars.singleInstance, 'disks', links),
    }
    + (if this.config.enableNetworkScraper then {
         'network.json':
           g.dashboard.new(prefix + 'network')
           + layout([
             rows.networkThroughput,
             rows.networkErrors,
             rows.networkConnections,
           ], 12, 8)
           + common(vars.singleInstance, 'network', links),
       } else {})
    + (if this.config.enableLokiLogs then {
         'logs.json': withMetricsVarNames(
           logslib.new(
             prefix + 'logs',
             datasourceName=vars.datasources.loki.name,
             datasourceRegex=vars.datasources.loki.regex,
             filterSelector=this.config.logsFilteringSelector,
             labels=logsLabels,
             formatParser=null,
             showLogsVolume=this.config.showLogsVolume,
             logsVolumeGroupBy=this.config.logsVolumeGroupBy,
             extraFilters=this.config.logsExtraFilters
           )
           {
             dashboards+: {
               // Keep logs-lib's variables; apply the rest of the common settings.
               logs+: root.applyCommon(super.logs.templating.list, uid=uid + '-logs', tags=tags, links=links, annotations=annotations, timezone=timezone, refresh=refresh, period=period),
             },
             panels+: {
               logs+:
                 g.panel.logs.options.withEnableLogDetails(true)
                 + g.panel.logs.options.withShowTime(false)
                 + g.panel.logs.options.withWrapLogMessage(false),
             },
             variables+: {
               // Keep the Prometheus data source for the status panels.
               toArray+: [vars.datasources.prometheus { hide: 2 }] + metricsGroupVars,
             },
           }.dashboards.logs
         ),
       } else {}),

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
