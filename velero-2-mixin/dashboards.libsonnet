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
    local annotations = this.grafana.annotations;
    local refresh = this.config.dashboardRefresh;
    local period = this.config.dashboardPeriod;
    local timezone = this.config.dashboardTimezone;
    local panels = this.grafana.panels;
    local stat = g.panel.stat;
    {
      clusterOverview:
        g.dashboard.new(prefix + ' cluster view')
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            [
              panels.successfulBackupsCount { gridPos+: { w: 4, h: 4 } },
              panels.failedBackupsCount { gridPos+: { w: 4, h: 4 } },
              panels.successfulRestores { gridPos+: { w: 4, h: 4 } },
              panels.failedRestores { gridPos+: { w: 4, h: 4 } },
              panels.alertsPanel { gridPos+: { w: 8, h: 4 } },
              panels.topClustersByBackup,
              panels.topClustersByRestore,
              panels.topClustersByBackupSize { gridPos+: { w: 24 } },
              panels.topClustersByVolumeSnapshots,
              panels.topClustersByCSISnapshots,
            ], 12, 6
          )
        )
        // hide link to self
        + root.applyCommon(vars.clusterVariableSelectors, uid + '-cluster-view', tags, links { veleroClusterOverview+:: {} }, annotations, timezone, refresh, period),
      overview:
        g.dashboard.new(prefix + ' overview')
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            [
              panels.lastBackupStatus { gridPos+: { w: 4, h: 4 } },
              panels.backupSuccessRate { gridPos+: { w: 4, h: 4 } },
              panels.restoreSuccessRate { gridPos+: { w: 4, h: 4 } },
              panels.successfulBackups { gridPos+: { w: 4, h: 4 } },
              panels.failedBackups { gridPos+: { w: 4, h: 4 } },
              panels.restoreValidationFailure { gridPos+: { w: 4, h: 4 } },
              g.panel.row.new('Backup'),
              panels.backupCount,
              panels.backupSuccessRateTimeseries,
              panels.backupSize { gridPos+: { w: 24 } },
              panels.backupTime { gridPos+: { w: 24 } },
              g.panel.row.new('Restore'),
              panels.restoreCount,
              panels.restoreSuccessRateTimeseries,
              g.panel.row.new('CSI snapshots'),
              panels.csiSnapshotCount,
              panels.csiSnapshotSuccessRateTimeseries,
              g.panel.row.new('Volume snapshots'),
              panels.volumeSnapshotCount,
              panels.volumeSnapshotSuccessRateTimeseries,
            ], 12, 6
          )
        )
        // hide link to self
<<<<<<< HEAD
        + root.applyCommon(vars.singleInstance, uid + '-overview', tags, links { veleroOverview+:: {} }, annotations, timezone, refresh, period),
    }
    //Apply common options(uids, tags, annotations etc..) to all dashboards above
    +
    if this.config.enableLokiLogs then
      {
        logs:
          logslib.new(
            prefix + ' logs',
            datasourceName=this.grafana.variables.datasources.loki.name,
            datasourceRegex=this.grafana.variables.datasources.loki.regex,
            filterSelector=this.config.filteringSelector,
            labels=this.config.logLabels + this.config.extraLogLabels,
            formatParser=null,
            showLogsVolume=this.config.showLogsVolume,
            logsVolumeGroupBy=this.config.logsVolumeGroupBy,
          )
          {
            dashboards+:
              {
                logs+:
                  // reference to self, already generated variables, to keep them, but apply other common data in applyCommon
                  root.applyCommon(super.logs.templating.list, uid=uid + '-logs', tags=tags, links=links { logs+:: {} }, annotations=annotations, timezone=timezone, refresh=refresh, period=period),
              },
            panels+:
              {
                // modify log panel
                logs+:
                  g.panel.logs.options.withEnableLogDetails(true)
                  + g.panel.logs.options.withShowTime(false)
                  + g.panel.logs.options.withWrapLogMessage(false),
              },
            variables+: {
              // add prometheus datasource for annotations processing
              toArray+: [
                this.grafana.variables.datasources.prometheus { hide: 2 },
              ],
            },
          }.dashboards.logs,
      }
    else {},
=======
        + root.applyCommon(vars.overviewVariables, uid + '-overview', tags, links { veleroOverview+:: {} }, annotations, timezone, refresh, period),

    },
>>>>>>> 14d5873 (added attempt into timeseries, refactored)
  //Apply common options(uids, tags, annotations etc..) to all dashboards above
  applyCommon(vars, uid, tags, links, annotations, timezone, refresh, period):
    g.dashboard.withTags(tags)
    + g.dashboard.withUid(uid)
    + g.dashboard.withLinks(std.objectValues(links))
    + g.dashboard.withTimezone(timezone)
    + g.dashboard.withRefresh(refresh)
    + g.dashboard.time.withFrom(period)
    + g.dashboard.withVariables(vars),
}
