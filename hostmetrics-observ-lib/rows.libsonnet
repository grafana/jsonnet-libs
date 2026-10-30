local g = import './g.libsonnet';

{
  new(this): {
    local panels = this.grafana.panels,
    local row(title, rowPanels) =
      g.panel.row.new(title)
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels(rowPanels),

    // Fleet overview
    fleetCompute: row('Compute', [
      panels.cpu.cpuUsageTopk { gridPos+: { w: 8 } },
      panels.memory.memoryUsageTopk { gridPos+: { w: 8 } },
      panels.cpu.loadAverageTopk { gridPos+: { w: 8 } },
    ]),
    fleetStorageAndNetwork: row(
      'Storage and network',
      [
        panels.disk.diskIOTopk { gridPos+: { w: 8 } },
        panels.filesystem.filesystemUsageTopk { gridPos+: { w: 8 } },
      ]
      + (if this.config.enableNetworkScraper then [
           panels.network.networkIOTopk { gridPos+: { w: 8 } },
           panels.network.networkErrorsAndDroppedTopk { gridPos+: { w: 12 } },
         ] else [])
      + [
        panels.host.uptimeTs { gridPos+: { w: 12 } },
      ]
    ),

    // Host overview
    nodesHost: row('Host', [
      panels.host.hostname { gridPos+: { w: 8, h: 3 } },
      panels.host.osName { gridPos+: { w: 8, h: 3 } },
      panels.host.arch { gridPos+: { w: 4, h: 3 } },
      panels.host.uptime { gridPos+: { w: 4, h: 3 } },
    ]),
    nodesCapacity: row('Capacity', [
      panels.host.cpuCount { gridPos+: { h: 3 } },
      panels.host.cpuPhysicalCount { gridPos+: { h: 3 } },
      panels.memory.memoryTotal { gridPos+: { h: 3 } },
      panels.filesystem.rootFilesystemSize { gridPos+: { h: 3 } },
    ]),
    nodesAlerts: row('Alerts', [
      panels.host.alerts { gridPos+: { w: 24, h: 6 } },
    ]),
    nodesCpu: row('CPU', [
      panels.cpu.cpuUsageTs { gridPos+: { w: 12, h: 8 } },
      panels.cpu.loadAverage { gridPos+: { w: 12, h: 8 } },
    ]),
    nodesMemory: row('Memory', [
      panels.memory.memoryUsageTs { gridPos+: { w: 12, h: 8 } },
      panels.memory.memoryAvailable { gridPos+: { w: 12, h: 8 } },
    ]),
    nodesDisk: row('Disk', [
      panels.filesystem.filesystemUsagePercent { gridPos+: { w: 12, h: 8 } },
      panels.disk.diskIO { gridPos+: { w: 12, h: 8 } },
    ]),
    nodesNetworkAndProcesses: row(
      if this.config.enableNetworkScraper then 'Network and processes' else 'Processes',
      (if this.config.enableNetworkScraper then [panels.network.networkIO { gridPos+: { w: 12, h: 8 } }] else [])
      + [
        panels.host.processes { gridPos+: { w: if this.config.enableNetworkScraper then 12 else 24, h: 8 } },
      ]
    ),

    // CPU and system
    systemUtilization: row('Utilization', [
      panels.cpu.cpuUsageTs,
      panels.cpu.cpuUsageByMode,
      panels.cpu.cpuUsagePerCore,
      panels.cpu.cpuTimeByMode,
    ]),
    systemSystem: row('System', [
      panels.cpu.loadAverage,
      panels.cpu.cpuFrequency,
      panels.host.processes { gridPos+: { w: 24 } },
    ]),

    // Memory
    memoryUtilization: row(
      'Utilization',
      [
        panels.memory.memoryUsageTs,
        panels.memory.memoryUsageByState,
        panels.memory.memoryAvailable,
        panels.memory.memoryTotalTs,
      ]
      + (if this.config.enablePagingScraper then [] else [
           panels.memory.memoryDirtyAndShared { gridPos+: { w: 24 } },
         ])
    ),
    memoryPaging: row('Paging', [
      panels.memory.pagingOperations,
      panels.memory.pageFaults,
      panels.memory.swapUsage,
      panels.memory.memoryDirtyAndShared,
    ]),

    // Filesystem and disks
    disksFilesystems: row('Filesystems', [
      panels.filesystem.filesystemUsagePercent,
      panels.filesystem.filesystemAvailable,
      panels.filesystem.filesystemUsageByState,
      panels.filesystem.inodesFree { gridPos+: { w: 6 } },
      panels.filesystem.inodesTotal { gridPos+: { w: 6 } },
    ]),
    disksIO: row('Disk I/O', [
      panels.disk.diskIO,
      panels.disk.diskOperations,
      panels.disk.diskIOTime,
      panels.disk.diskWaitTime,
      panels.disk.diskQueue { gridPos+: { w: 8 } },
      panels.disk.diskPendingOperations { gridPos+: { w: 8 } },
      panels.disk.diskMerged { gridPos+: { w: 8 } },
    ]),

    // Network
    networkThroughput: row('Throughput', [
      panels.network.networkIO,
      panels.network.networkPackets,
    ]),
    networkErrors: row('Errors', [
      panels.network.networkErrors,
      panels.network.networkDropped,
    ]),
    networkConnections: row('Connections', [
      panels.network.networkConnections,
      panels.network.conntrack,
    ]),
  },
}
