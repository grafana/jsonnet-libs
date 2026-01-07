local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';


{
  new(this)::
    {
      local signals = this.signals,

      // ==========================
      // DataNode Overview Panels
      // ==========================

      unreadBlocksEvictedPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Unread blocks evicted',
          targets=[signals.datanode.unreadBlocksEvicted.asTarget() { interval: '2m' }],
          description='Total number of blocks evicted without being read by the Hadoop DataNode.'
        ),


      blocksRemovedPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Blocks removed',
          targets=[signals.datanode.blocksRemoved.asTarget() { interval: '2m' }],
          description='Total number of blocks removed by the Hadoop DataNode.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      volumeFailuresPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Volume failures',
          targets=[signals.datanode.volumeFailures.asTarget() { interval: '2m' }],
          description='Displays the total number of volume failures encountered by the Hadoop DataNode.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),


      // ==========================
      // NameNode Overview Panels
      // ==========================

      namenodeDatanodeStatePanel:
        g.panel.pieChart.new(
          'DataNode state',
        ) + g.panel.pieChart.queryOptions.withTargets([
          signals.namenode.datanodeStateLive.asTarget(),
          signals.namenode.datanodeStateDead.asTarget(),
          signals.namenode.datanodeStateStale.asTarget(),
          signals.namenode.datanodeStateDecommissioning.asTarget(),
        ])
        + g.panel.pieChart.options.legend.withAsTable(true)
        + g.panel.pieChart.options.legend.withPlacement('right')
        + g.panel.pieChart.panelOptions.withDescription('The DataNodes current state.'),


      namenodeCapacityUtilizationPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Capacity utilization',
          targets=[signals.namenode.capacityUtilization.asTarget()],
          description='The storage utilization of the NameNode.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      namenodeTotalBlocksPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Total blocks',
          targets=[signals.namenode.totalBlocks.asTarget()],
          description='Total number of blocks managed by the NameNode.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      namenodeMissingBlocksPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Missing blocks',
          targets=[signals.namenode.missingBlocks.asTarget()],
          description='Number of blocks reported by DataNodes as missing.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      namenodeUnderreplicatedBlocksPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Under-replicated blocks',
          targets=[signals.namenode.underreplicatedBlocks.asTarget()],
          description='Number of blocks that are under-replicated.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      namenodeTransactionsSinceLastCheckpointPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Transactions since last checkpoint',
          targets=[signals.namenode.transactionsSinceLastCheckpoint.asTarget()],
          description='Number of transactions processed by the NameNode since the last checkpoint.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      namenodeVolumeFailuresPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Volume failures',
          targets=[signals.namenode.volumeFailures.asTarget() { interval: '2m' }],
          description='The recent increase in number of volume failures on all DataNodes.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('ops')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      namenodeTotalFilesPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Total files',
          targets=[signals.namenode.totalFiles.asTarget()],
          description='Total number of files managed by the NameNode.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      namenodeTotalLoadPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Total load',
          targets=[signals.namenode.totalLoad.asTarget()],
          description='Total load on the NameNode.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      // ==========================
      // NodeManager Overview Panels
      // ==========================


      nodeManagerApplicationsRunningPanel:
        g.panel.stat.new(
          'Applications running',
        )
        + g.panel.stat.queryOptions.withTargets([signals.nodemanager.applicationsRunning.asTarget()])
        + g.panel.stat.panelOptions.withDescription('Number of applications currently running for the NodeManager.'),

      nodeManagerAllocatedContainersPanel:
        g.panel.stat.new(
          'Allocated containers',
        )
        + g.panel.stat.queryOptions.withTargets([signals.nodemanager.allocatedContainers.asTarget()])
        + g.panel.stat.panelOptions.withDescription('Number of containers currently allocated for the NodeManager.'),

      nodeManagerContainersLocalizationDurationPanel:
        g.panel.stat.new(
          'Containers localization duration',
        )
        + g.panel.stat.standardOptions.withUnit('ms')
        + g.panel.stat.queryOptions.withTargets([signals.nodemanager.localizationDuration.asTarget()])
        + g.panel.stat.panelOptions.withDescription('Average time taken for the NodeManager to localize necessary resources for a container.'),

      nodeManagerContainersLaunchDurationPanel:
        g.panel.stat.new(
          'Containers launch duration',
        )
        + g.panel.stat.standardOptions.withUnit('ms')
        + g.panel.stat.queryOptions.withTargets([signals.nodemanager.containersLaunchDuration.asTarget()])
        + g.panel.stat.panelOptions.withDescription('Average time taken to launch a container on the NodeManager after the necessary resources have been localized.'),

      // ==========================
      // NodeManager JVM Panels
      // ==========================

      nodeManagerMemoryUsagePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Memory used',
          targets=[
            signals.nodemanager.heapMemoryUsage.asTarget(),
            signals.nodemanager.nonHeapMemoryUsage.asTarget(),
          ],
          description='The Heap and non-heap memory used for the NodeManager.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      nodeManagerMemoryCommittedPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Memory committed',
          targets=[
            signals.nodemanager.heapMemoryCommitted.asTarget(),
            signals.nodemanager.nonHeapMemoryCommitted.asTarget(),
          ],
          description='The Heap and non-heap memory committed for the NodeManager.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('decmbytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      nodeManagerGarbageCollectionCountPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Garbage collection count',
          targets=[signals.nodemanager.gcCount.asTarget() { interval: '2m' }],
          description='The number of garbage collection events for the NodeManager.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      nodeManagerGarbageCollectionTimePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Average garbage collection time',
          targets=[signals.nodemanager.gcTime.asTarget() { interval: '2m' }],
          description='The average duration for each garbage collection operation in the NodeManager JVM.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      // ==========================
      // NodeManager Node Panels
      // ==========================

      nodeManagerNodeMemoryUsedPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Node memory used',
          targets=[
            signals.nodemanager.nodeHeapMemoryUsage.asTarget(),
            signals.nodemanager.nodeNonHeapMemoryUsage.asTarget(),
          ],
          description='The Heap and non-heap memory used for the NodeManager.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('decmbytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),


      nodeManagerNodeMemoryCommittedPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Node memory committed',
          targets=[
            signals.nodemanager.nodeHeapMemoryCommitted.asTarget(),
            signals.nodemanager.nodeNonHeapMemoryCommitted.asTarget(),
          ],
          description='The Heap and non-heap memory committed for the NodeManager.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('decmbytes'),

      nodeManagerNodeCPUUtilizationPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Node CPU utilization',
          targets=[signals.nodemanager.nodeCPUUtilization.asTarget()],
          description='CPU utilization of the Node.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      nodeManagerNodeGPUUtilizationPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Node GPU utilization',
          targets=[signals.nodemanager.nodeGPUUtilization.asTarget()],
          description='GPU utilization of the Node.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      // ==========================
      // NodeManager Container Panels
      // ==========================

      nodeManagerContainerStatePausedPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Container state',
          targets=[
            signals.nodemanager.containerStatePaused.asTarget(),
            signals.nodemanager.containerStateLaunched.asTarget(),
            signals.nodemanager.containerStateCompleted.asTarget(),
            signals.nodemanager.containerStateFailed.asTarget(),
            signals.nodemanager.containerStateKilled.asTarget(),
            signals.nodemanager.containerStateIniting.asTarget(),
            signals.nodemanager.containerStateReiniting.asTarget(),
          ],
          description='Number of containers with a given state for the NodeManager.',
        )
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      nodeManagerContainerUsedMemoryPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Containers used memory',
          targets=[signals.nodemanager.containerUsedMemory.asTarget()],
          description='Total memory used by containers for the NodeManager.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('decmbytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0),


      nodeManagerContainerUsedVirtualMemoryPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Containers used virtual memory',
          targets=[signals.nodemanager.containerUsedVirtualMemory.asTarget()],
          description='Total virtual memory used by containers for the NodeManager.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('decmbytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0),

      nodeManagerContainerAvailableMemoryPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Containers available memory',
          targets=[
            signals.nodemanager.containersAvailableMemory.asTarget(),
            signals.nodemanager.containersAllocatedMemory.asTarget(),
          ],
          description='The memory available and currently allocated for containers by the NodeManager.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('decmbytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0),


      nodeManagerContainersAvailableVirtualCoresPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Containers available virtual cores',
          targets=[
            signals.nodemanager.containersAvailableVCores.asTarget(),
            signals.nodemanager.containersAllocatedVCores.asTarget(),
          ],
          description='The virtual cores available and currently allocated for containers by the NodeManager.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0),


      // ==========================
      // ResourceManager Overview Panels
      // ==========================

      resourceNodeManagerActiveNodeManagersPanel:
        g.panel.barGauge.new(
          'Node Managers state',
        )
        + g.panel.barGauge.queryOptions.withTargets([
          signals.resourcemanager.activeNodeManagers.asTarget(),
          signals.resourcemanager.decommissionedNodeManagers.asTarget(),
          signals.resourcemanager.lostNodeManagers.asTarget(),
          signals.resourcemanager.unhealthyNodeManagers.asTarget(),
          signals.resourcemanager.rebootedNodeManagers.asTarget(),
          signals.resourcemanager.shutdownNodeManagers.asTarget(),
        ])
        + g.panel.barGauge.options.withOrientation('horizontal')
        + g.panel.barGauge.panelOptions.withDescription('The number of Node Managers by state in the Hadoop ResourceManager.'),


      resourceNodeManagerApplicationsStatePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Applications state',
          targets=[
            signals.resourcemanager.applicationsRunning.asTarget(),
            signals.resourcemanager.applicationsPending.asTarget(),
            signals.resourcemanager.applicationsKilled.asTarget(),
            signals.resourcemanager.applicationsSubmitted.asTarget(),
            signals.resourcemanager.applicationsCompleted.asTarget(),
            signals.resourcemanager.applicationsFailed.asTarget(),
          ],
        )
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.panelOptions.withDescription('Number of applications by state for the Hadoop ResourceManager.'),

      resourceManagerAvailableMemoryPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Available memory',
          targets=[
            signals.resourcemanager.availableMemory.asTarget(),
            signals.resourcemanager.allocatedMemory.asTarget(),
          ],
        )
        + g.panel.timeSeries.standardOptions.withUnit('decmbytes')
        + g.panel.timeSeries.panelOptions.withDescription('The available memory in the Hadoop ResourceManager.'),


      resourceManagerAvailableVCoresPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Available virtual cores',
          targets=[
            signals.resourcemanager.availableVCores.asTarget(),
            signals.resourcemanager.allocatedVCores.asTarget(),
          ],
        )
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.panelOptions.withDescription('The available virtual cores in the Hadoop ResourceManager.'),


      resourceManagerJVMMemoryUsedPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Memory used',
          targets=[
            signals.resourcemanager.heapMemoryUsed.asTarget(),
            signals.resourcemanager.nonHeapMemoryUsed.asTarget(),
          ],
        )
        + g.panel.timeSeries.standardOptions.withUnit('decmbytes')
        + g.panel.timeSeries.panelOptions.withDescription('The Heap and non-heap memory used for the ResourceManager.'),


      resourceManagerJVMMemoryCommittedPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Memory committed',
          targets=[
            signals.resourcemanager.heapMemoryCommitted.asTarget(),
            signals.resourcemanager.nonHeapMemoryCommitted.asTarget(),
          ],
        )
        + g.panel.timeSeries.standardOptions.withUnit('decmbytes')
        + g.panel.timeSeries.panelOptions.withDescription('The Heap and non-heap memory committed for the ResourceManager.'),


      resourceManagerJVMGarbageCollectionCountPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Garbage collection count',
          targets=[signals.resourcemanager.gcCount.asTarget() { interval: '2m' }],
        )
        + g.panel.timeSeries.panelOptions.withDescription('The recent increase in the number of garbage collection events for the ResourceManager JVM.'),

      resourceManagerJVMAverageGarbageCollectionTimePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Average garbage collection time',
          targets=[signals.resourcemanager.averageGCCTime.asTarget() { interval: '2m' }],
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.panelOptions.withDescription('The average duration for each garbage collection operation in the ResourceManager JVM.'),

    },
}
