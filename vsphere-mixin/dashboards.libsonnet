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
      overview:
        g.dashboard.new(prefix + ' overview')
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            [
              panels.clustersCountStatus { gridPos+: { w: 6, h: 4 } },
              panels.hostsCountStatus { gridPos+: { w: 6, h: 4 } },
              panels.resourcePoolsCountStatus { gridPos+: { w: 6, h: 4 } },
              panels.vmsCountStatus { gridPos+: { w: 6, h: 4 } },
              panels.clusteredVMsOnStatus { gridPos+: { w: 4, h: 4 } },
              panels.clusteredVMsOffStatus { gridPos+: { w: 4, h: 4 } },
              panels.clusteredVMsSuspendedStatus { gridPos+: { w: 4, h: 4 } },
              panels.clusteredVMTemplatesCountStatus { gridPos+: { w: 4, h: 4 } },
              panels.clusteredHostsActiveStatus { gridPos+: { w: 4, h: 4 } },
              panels.clusteredHostsInactiveStatus { gridPos+: { w: 4, h: 4 } },
              g.panel.row.new('Clusters'),
              panels.topCPUUtilizationClusters,
              panels.topMemoryUtilizationClusters,
              panels.clustersTable { gridPos+: { w: 24 } },
              g.panel.row.new('Resource pools'),
              panels.topCPUUsageResourcePools,
              panels.topMemoryUsageResourcePools,
              panels.topCPUShareResourcePools,
              panels.topMemoryShareResourcePools,
              g.panel.row.new('ESXi hosts'),
              panels.topCPUUtilizationHosts,
              panels.topMemoryUtilizationHosts,
              panels.topDiskAvgLatencyHosts,
              panels.topPacketErrorRateHosts,
              g.panel.row.new('Datastores'),
              panels.datastoreTable { gridPos+: { w: 24 } },
            ], 12, 6
          )
        )
        // hide link to self
        + root.applyCommon(vars.overviewVariables, uid + '-overview', tags, links { vSphereOverview+:: {} }, annotations, timezone, refresh, period),
      clusters:
        g.dashboard.new(prefix + ' clusters')
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            [
              panels.clusterVMsOnStatus { gridPos+: { w: 4, h: 4 } },
              panels.clusterVMsOffStatus { gridPos+: { w: 4, h: 4 } },
              panels.clusterVMsSuspendedStatus { gridPos+: { w: 4, h: 4 } },
              panels.clusterHostsActiveStatus { gridPos+: { w: 4, h: 4 } },
              panels.clusterHostsInactiveStatus { gridPos+: { w: 4, h: 4 } },
              panels.clusterResourcePoolsStatus { gridPos+: { w: 4, h: 4 } },
              panels.clusterCPULimit { gridPos+: { w: 8 } },
              panels.clusterCPUEffective { gridPos+: { w: 8 } },
              panels.clusterCPUUtilization { gridPos+: { w: 8 } },
              panels.clusterMemoryLimit { gridPos+: { w: 8 } },
              panels.clusterMemoryEffective { gridPos+: { w: 8 } },
              panels.clusterMemoryUtilization { gridPos+: { w: 8 } },
              g.panel.row.new('ESXi hosts'),
              panels.clusterHostsTable { gridPos+: { w: 24 } },
              g.panel.row.new('VMs'),
              panels.clusterVMsTable { gridPos+: { w: 24 } },
            ], 12, 6
          )
        )
        // hide link to self
        + root.applyCommon(vars.clusterVariables, uid + '-clusters', tags, links { vSphereClusters+:: {} }, annotations, timezone, refresh, period),
      hosts:
        g.dashboard.new(prefix + ' hosts')
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            [
              panels.hostCPUUsage,
              panels.hostCPUUtilization,
              panels.hostMemoryUsage,
              panels.hostMemoryUtilization,
              panels.hostModifiedMemory { gridPos+: { w: 24 } },
              panels.hostNetworkThroughputRate,
              panels.hostPacketErrorRate,
              g.panel.row.new('VMs'),
              panels.hostVMsTable { gridPos+: { w: 24 } },
              g.panel.row.new('Disks'),
              panels.hostDisksTable { gridPos+: { w: 24 } },
            ], 12, 6
          )
        )
        // hide link to self
        + root.applyCommon(vars.hostsVariable, uid + '-hosts', tags, links { vSphereHosts+:: {} }, annotations, timezone, refresh, period),
      virtualMachines:
        g.dashboard.new(prefix + ' virtual machines')
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            [
              panels.vmCPUUsage,
              panels.vmCPUUtilization,
              panels.vmMemoryUsage,
              panels.vmMemoryUtilization,
              panels.vmModifiedMemory { gridPos+: { w: 24 } },
              panels.vmNetworkThroughputRate,
              panels.vmPacketDropRate,
              g.panel.row.new('Disks'),
              panels.vmDiskUsage,
              panels.vmDiskUtilization,
              panels.vmDisksTable { gridPos+: { w: 24 } },
            ], 12, 6
          )
        )
        // hide link to self
        + root.applyCommon(vars.virtualMachinesVariables, uid + '-virtual-machines', tags, links { vSphereVirtualMachines+:: {} }, annotations, timezone, refresh, period),
    }
    +
    if this.config.enableLokiLogs then
      {
        logs:
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
