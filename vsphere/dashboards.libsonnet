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
              panels.vmOnStatus { gridPos+: { w: 3, h: 4 } },
              panels.vmOffStatus { gridPos+: { w: 3, h: 4 } },
              panels.vmSuspendedStatus { gridPos+: { w: 3, h: 4 } },
              panels.vmTemplateStatus { gridPos+: { w: 3, h: 4 } },
              panels.clusterCountStatus { gridPos+: { w: 3, h: 4 } },
              panels.resourcePoolCountStatus { gridPos+: { w: 3, h: 4 } },
              panels.esxiHostsActiveStatus { gridPos+: { w: 3, h: 4 } },
              panels.esxiHostsInactiveStatus { gridPos+: { w: 3, h: 4 } },
              g.panel.row.new('Cluster row'),
              panels.topCPUUtilizationClusters,
              panels.topMemoryUtilizationClusters,
              panels.clustersTable { gridPos+: { w: 24 } },
              g.panel.row.new('Resource pool row'),
              panels.topCPUUsageResourcePools,
              panels.topMemoryUsageResourcePools,
              panels.topCPUShareResourcePools,
              panels.topMemoryShareResourcePools,
              g.panel.row.new('ESXi host row'),
              panels.topCPUUtilizationEsxiHosts,
              panels.topMemoryUsageEsxiHosts,
              panels.topNetworksActiveEsxiHosts,
              panels.topPacketErrorEsxiHosts,
              g.panel.row.new('Datastore row'),
              panels.datastoresTable { gridPos+: { w: 24 } },
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
              panels.vmOnStatusCluster { gridPos+: { w: 4, h: 4 } },
              panels.vmOffStatusCluster { gridPos+: { w: 4, h: 4 } },
              panels.vmSuspendedStatusCluster { gridPos+: { w: 4, h: 4 } },
              panels.vmTemplateStatusCluster { gridPos+: { w: 4, h: 4 } },
              panels.esxiHostsActiveStatusCluster { gridPos+: { w: 4, h: 4 } },
              panels.esxiHostsInactiveStatusCluster { gridPos+: { w: 4, h: 4 } },
              panels.clusterCPUEffective { gridPos+: { w: 8, h: 4 } },
              panels.clusterCPULimit { gridPos+: { w: 8, h: 4 } },
              panels.clusterCPUUtilization { gridPos+: { w: 8, h: 4 } },
              panels.clusterMemoryEffective { gridPos+: { w: 8, h: 4 } },
              panels.clusterMemoryLimit { gridPos+: { w: 8, h: 4 } },
              panels.clusterMemoryUtilization { gridPos+: { w: 8, h: 4 } },
              g.panel.row.new('ESXi host row'),
              panels.esxiHostsTable { gridPos+: { w: 24 } },
              g.panel.row.new('VMs row'),
              panels.VMTable { gridPos+: { w: 24 } },
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
              panels.modifiedMemory { gridPos+: { w: 24 } },
              panels.networkThroughputRate,
              panels.packetRate,
              g.panel.row.new('VMs row'),
              panels.VMTable { gridPos+: { w: 24 } },
              g.panel.row.new('Disks row'),
              panels.disksTable { gridPos+: { w: 24 } },
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
              panels.hostCPUUsage,
              panels.hostCPUUtilization,
              panels.hostMemoryUsage,
              panels.hostMemoryUtilization,
              panels.modifiedMemory { gridPos+: { w: 24 } },
              panels.networkThroughputRate,
              panels.packetRate,
              g.panel.row.new('Disks row'),
              panels.disksTable,
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
