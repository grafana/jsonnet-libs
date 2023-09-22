local g = import './g.libsonnet';
local logslib = import 'github.com/grafana/jsonnet-libs/logs-lib/logs/main.libsonnet';
{
  local root = self,
  new(
    this
  ):
    local prefix = this.config.dashboardNamePrefix;
    local links = this.links;
    local tags = this.config.dashboardTags;
    local uid = this.config.uid;
    local vars = this.variables;
    local annotations = this.annotations;
    local panels = this.panels;
    local stat = g.panel.stat;
    {
      fleet:
        local title = prefix + 'Windows fleet overview';
        g.dashboard.new(title)
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            [
              // g.panel.row.new("Overview"),
              panels.fleetOverviewTable { gridPos+: { w: 24, h: 16 } },
              panels.cpuUsageTopk { gridPos+: { w: 24 } },
              panels.memotyUsageTopKPercent { gridPos+: { w: 24 } },
              panels.diskIOutilPercentTopK { gridPos+: { w: 12 } },
              panels.diskUsagePercentTopK { gridPos+: { w: 12 } },
              panels.networkErrorsAndDroppedPerSec { gridPos+: { w: 24 } },
            ], 12, 7
          )
        )
        // hide link to self
        + root.applyCommon(vars.multiInstance, uid + '-fleet', tags, links { backToFleet+:: {}, backToOverview+:: {} }, annotations),
      overview: g.dashboard.new(prefix + 'Windows overview')
                + g.dashboard.withUid('overview')
                + g.dashboard.withPanels(
                  g.util.grid.wrapPanels(
                    [
                      g.panel.row.new('Overview'),
                      panels.uptime,
                      panels.hostname,
                      panels.osVersion,
                      panels.osInfo,
                      panels.cpuCount,
                      panels.memoryTotalBytes,
                      panels.memoryPageTotalBytes,
                      panels.diskTotalC,
                      g.panel.row.new('CPU'),
                      panels.cpuUsageStat { gridPos+: { w: 6, h: 6 } },
                      panels.cpuUsageTs { gridPos+: { w: 18, h: 6 } },
                      g.panel.row.new('Memory'),
                      panels.memoryUsageStatPercent { gridPos+: { w: 6, h: 6 } },
                      panels.memoryUsageTsBytes { gridPos+: { w: 18, h: 6 } },
                      g.panel.row.new('Disk'),
                      panels.diskIOBytesPerSec { gridPos+: { w: 12, h: 8 } },
                      panels.diskUsage { gridPos+: { w: 12, h: 8 } },
                      g.panel.row.new('Network'),
                      panels.networkUsagePerSec { gridPos+: { w: 12, h: 8 } },
                      panels.networkErrorsPerSec { gridPos+: { w: 12, h: 8 } },
                    ], 6, 2
                  )
                )
                + root.applyCommon(vars.singleInstance, uid + '-overview', tags, links { backToOverview+:: {} }, annotations),
      network: g.dashboard.new(prefix + 'Windows network')
               + g.dashboard.withPanels(
                 g.util.grid.wrapPanels(
                   [
                     g.panel.row.new('Network'),
                     panels.networkInterfacesOverview { gridPos+: { w: 24 } },
                     panels.networkUsagePerSec,
                     panels.networkInterfaceCarrierStatus,
                     panels.networkErrorsPerSec,
                     panels.networkDroppedPerSec,
                     panels.networkPacketsPerSec,
                     panels.networkMulticast,
                   ], 12, 7
                 )
               )
               + root.applyCommon(vars.singleInstance, uid + '-network', tags, links, annotations),
      // TODO advanced memory dashboard (must enable memory collector)
      // memory:
      system: g.dashboard.new(prefix + 'Windows CPU and system')
              + g.dashboard.withPanels(
                g.util.grid.wrapPanels(
                  [
                    g.panel.row.new('System'),
                    panels.cpuUsageStat { gridPos+: { w: 6, h: 6 } },
                    panels.cpuUsageTs { gridPos+: { w: 9, h: 6 } },
                    panels.cpuUsageByMode { gridPos+: { w: 9, h: 6 } },
                    panels.cpuQueue,
                    panels.systemContextSwitchesAndInterrupts,
                    // panels.systemThreads,
                    // panels.systemExceptions,
                    g.panel.row.new('Time'),
                    panels.osTimezone { gridPos+: { w: 3, h: 4 } },
                    panels.timeNtpStatus { gridPos+: { x: 0, y: 0, w: 21, h: 4 } },
                    panels.timeNtpDelay { gridPos+: { w: 24, h: 7 } },
                  ], 12, 7
                )
              )
              + root.applyCommon(vars.singleInstance, uid + '-system', tags, links, annotations),

      disks: g.dashboard.new(prefix + 'Windows disks and filesystems')
             + g.dashboard.withPanels(
               g.util.grid.wrapPanels(
                 [
                   g.panel.row.new('Filesystem'),
                   g.panel.timeSeries.new('Disk space available'),
                   g.panel.row.new('Disk'),
                   g.panel.timeSeries.new('Disk I/O'),
                   g.panel.timeSeries.new('Disk I/Ops completed'),
                   g.panel.timeSeries.new('Disk average wait time'),
                   g.panel.timeSeries.new('Average queue size'),
                 ], 12, 7
               )
             )
             + root.applyCommon(vars.singleInstance, uid + '-disks', tags, links, annotations),
    }
    +
    if this.config.enableLokiLogs
    then
      {
        logs:

          logslib.new(prefix + 'Windows logs',
                      datasourceName='loki_datasource',
                      datasourceRegex='',
                      filterSelector=this.config.filteringSelector,
                      labels=this.config.groupLabels + this.config.instanceLabels + ['channel', 'source', 'keywords', 'level'],
                      formatParser='json',
                      showLogsVolume=true,
                      logsVolumeGroupBy='level',
                      extraFilters=|||
                        | label_format timestamp="{{__timestamp__}}"
                        | drop channel_extracted,source_extracted,computer_extracted,level_extracted,keywords_extracted
                        | line_format `{{ if eq "[[instance]]" ".*" }}{{ alignLeft 15 .instance}}|{{end}}{{alignLeft 12 .channel }}| {{ alignLeft 15 .source}}| {{ .message }}`
                      |||)
          {
            dashboards+:
              {
                logs+:
                  // reference self, already generated variables to keep them, but apply other common data in applyCommon
                  root.applyCommon(super.logs.templating.list, uid=uid + '-logs', tags=tags, links=links, annotations=annotations),
              },
            panels+:
              {
                logs+:
                  g.panel.logs.options.withEnableLogDetails(true)
                  + g.panel.logs.options.withShowTime(false)
                  + g.panel.logs.options.withWrapLogMessage(false),
              },
            variables+: {
              // add prometheus datasource for annotations processing
              toArray+: [
                this.variables.datasources.prometheus { hide: 2 },
              ],
            },
          }.dashboards.logs,
      }
    else {},

  applyCommon(vars, uid, tags, links, annotations):
    g.dashboard.withTags(tags)
    + g.dashboard.withUid(g.util.string.slugify(uid))
    + g.dashboard.withLinks(std.objectValues(links))
    + g.dashboard.withVariables(vars)
    + g.dashboard.withAnnotations(std.objectValues(annotations)),
}
