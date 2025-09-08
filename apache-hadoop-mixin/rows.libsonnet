local g = import './g.libsonnet';

{
  new(this):
    {
      local panels = this.grafana.panels,

      // NameNode Overview
      namenodeOverview:
        g.panel.row.new('NameNode overview')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.namenodeDatanodeStatePanel + g.panel.pieChart.gridPos.withW(12),
          panels.namenodeCapacityUtilizationPanel + g.panel.timeSeries.gridPos.withW(12),
          panels.namenodeTotalBlocksPanel + g.panel.timeSeries.gridPos.withW(8),
          panels.namenodeMissingBlocksPanel + g.panel.timeSeries.gridPos.withW(8),
          panels.namenodeUnderreplicatedBlocksPanel + g.panel.timeSeries.gridPos.withW(8),
          panels.namenodeTransactionsSinceLastCheckpointPanel + g.panel.timeSeries.gridPos.withW(12),
          panels.namenodeVolumeFailuresPanel + g.panel.timeSeries.gridPos.withW(12),
          panels.namenodeTotalFilesPanel + g.panel.timeSeries.gridPos.withW(12),
          panels.namenodeTotalLoadPanel + g.panel.timeSeries.gridPos.withW(12),
        ]),

      // DataNode Overview
      datanodeOverview:
        g.panel.row.new('DataNode overview')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.unreadBlocksEvictedPanel + g.panel.timeSeries.gridPos.withW(8),
          panels.blocksRemovedPanel + g.panel.timeSeries.gridPos.withW(8),
          panels.volumeFailuresPanel + g.panel.timeSeries.gridPos.withW(8),
        ]),

      // NodeManager Overview
      nodemanagerOverview:
        g.panel.row.new('NodeManager overview')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.nodeManagerApplicationsRunningPanel + g.panel.stat.gridPos.withW(6),
          panels.nodeManagerAllocatedContainersPanel + g.panel.stat.gridPos.withW(6),
          panels.nodeManagerContainersLocalizationDurationPanel + g.panel.stat.gridPos.withW(6),
          panels.nodeManagerContainersLaunchDurationPanel + g.panel.stat.gridPos.withW(6),

        ]),

      nodeManagerJVM:
        g.panel.row.new('JVM')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.nodeManagerMemoryUsagePanel + g.panel.timeSeries.gridPos.withW(12),
          panels.nodeManagerMemoryCommittedPanel + g.panel.timeSeries.gridPos.withW(12),
          panels.nodeManagerGarbageCollectionCountPanel + g.panel.timeSeries.gridPos.withW(12),
          panels.nodeManagerGarbageCollectionTimePanel + g.panel.timeSeries.gridPos.withW(12),
        ]),

      nodeManagerNode:
        g.panel.row.new('Node')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.nodeManagerNodeMemoryUsedPanel + g.panel.timeSeries.gridPos.withW(12),
          panels.nodeManagerNodeMemoryCommittedPanel + g.panel.timeSeries.gridPos.withW(12),
          panels.nodeManagerNodeCPUUtilizationPanel + g.panel.timeSeries.gridPos.withW(12),
          panels.nodeManagerNodeGPUUtilizationPanel + g.panel.timeSeries.gridPos.withW(12),
        ]),

      nodeManagerContainers:
        g.panel.row.new('Containers')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.nodeManagerContainerStatePausedPanel + g.panel.timeSeries.gridPos.withW(8),
          panels.nodeManagerContainerUsedMemoryPanel + g.panel.timeSeries.gridPos.withW(8),
          panels.nodeManagerContainerUsedVirtualMemoryPanel + g.panel.timeSeries.gridPos.withW(8),
          panels.nodeManagerContainerAvailableMemoryPanel + g.panel.timeSeries.gridPos.withW(12),
          panels.nodeManagerContainersAvailableVirtualCoresPanel + g.panel.timeSeries.gridPos.withW(12),
        ]),


      // ResourceManager Overview
      resourcemanagerOverview:
        g.panel.row.new('ResourceManager overview')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.resourceNodeManagerActiveNodeManagersPanel + g.panel.barGauge.gridPos.withW(24),
        ]),

      resourcemanagerApplications:
        g.panel.row.new('Applications')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.resourceNodeManagerApplicationsStatePanel + g.panel.timeSeries.gridPos.withW(24),
          panels.resourceManagerAvailableMemoryPanel + g.panel.timeSeries.gridPos.withW(12),
          panels.resourceManagerAvailableVCoresPanel + g.panel.timeSeries.gridPos.withW(12),
        ]),

      resourcemanagerJVM:
        g.panel.row.new('JVM')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.resourceManagerJVMMemoryUsedPanel + g.panel.timeSeries.gridPos.withW(12),
          panels.resourceManagerJVMMemoryCommittedPanel + g.panel.timeSeries.gridPos.withW(12),
          panels.resourceManagerJVMGarbageCollectionCountPanel + g.panel.timeSeries.gridPos.withW(12),
          panels.resourceManagerJVMAverageGarbageCollectionTimePanel + g.panel.timeSeries.gridPos.withW(12),
        ]),
    },
}
