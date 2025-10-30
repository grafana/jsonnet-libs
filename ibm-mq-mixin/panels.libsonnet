local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this): {
    local signals = this.signals,

    // Cluster overview panels
    clusterCount:
      g.panel.stat.new('Clusters')
      + g.panel.stat.queryOptions.withTargets([
        g.query.prometheus.new('${prometheus_datasource}', 'count(count(ibmmq_qmgr_commit_count{%(filteringSelector)s}) by (mq_cluster))' % this.config)
        + g.query.prometheus.withIntervalFactor(2)
        + g.query.prometheus.withLegendFormat('{{job}} - {{mq_cluster}}'),
      ])
      + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
      + g.panel.stat.standardOptions.withDecimals(0)
      + g.panel.stat.standardOptions.thresholds.withSteps([
        g.panel.stat.thresholdStep.withColor('green'),
        g.panel.stat.thresholdStep.withColor('red') + g.panel.stat.thresholdStep.withValue(0),
      ])
      + g.panel.stat.options.withColorMode('value')
      + g.panel.stat.options.withGraphMode('none')
      + g.panel.stat.options.withTextMode('auto')
      + g.panel.stat.panelOptions.withDescription('The unique number of clusters being reported.'),

    queueManagerCount:
      g.panel.stat.new('Queue managers')
      + g.panel.stat.queryOptions.withTargets([
        g.query.prometheus.new('${prometheus_datasource}', 'count(count(ibmmq_qmgr_commit_count{%(filteringSelector)s}) by (qmgr, mq_cluster))' % this.config)
        + g.query.prometheus.withIntervalFactor(2)
        + g.query.prometheus.withLegendFormat(''),
      ])
      + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
      + g.panel.stat.standardOptions.withDecimals(0)
      + g.panel.stat.standardOptions.thresholds.withSteps([
        g.panel.stat.thresholdStep.withColor('green'),
        g.panel.stat.thresholdStep.withColor('red') + g.panel.stat.thresholdStep.withValue(0),
      ])
      + g.panel.stat.options.withColorMode('value')
      + g.panel.stat.options.withGraphMode('none')
      + g.panel.stat.options.withTextMode('auto')
      + g.panel.stat.panelOptions.withDescription('The unique number of queue managers in the cluster being reported.'),

    topicCount:
      g.panel.stat.new('Topics')
      + g.panel.stat.queryOptions.withTargets([
        g.query.prometheus.new('${prometheus_datasource}', 'count(count(ibmmq_topic_messages_received{%(filteringSelector)s}) by (topic, qmgr))' % this.config)
        + g.query.prometheus.withIntervalFactor(2)
        + g.query.prometheus.withLegendFormat(''),
      ])
      + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
      + g.panel.stat.standardOptions.withDecimals(0)
      + g.panel.stat.standardOptions.thresholds.withSteps([
        g.panel.stat.thresholdStep.withColor('green'),
        g.panel.stat.thresholdStep.withColor('red') + g.panel.stat.thresholdStep.withValue(0),
      ])
      + g.panel.stat.options.withColorMode('value')
      + g.panel.stat.options.withGraphMode('none')
      + g.panel.stat.options.withTextMode('auto')
      + g.panel.stat.panelOptions.withDescription('The unique number of topics in the cluster.'),

    queueCount:
      g.panel.stat.new('Queues')
      + g.panel.stat.queryOptions.withTargets([
        g.query.prometheus.new('${prometheus_datasource}', 'count(count(ibmmq_queue_depth{%(filteringSelector)s}) by (queue, mq_cluster, qmgr))' % this.config)
        + g.query.prometheus.withIntervalFactor(2)
        + g.query.prometheus.withLegendFormat(''),
      ])
      + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
      + g.panel.stat.standardOptions.withDecimals(0)
      + g.panel.stat.standardOptions.thresholds.withSteps([
        g.panel.stat.thresholdStep.withColor('green'),
        g.panel.stat.thresholdStep.withColor('red') + g.panel.stat.thresholdStep.withValue(0),
      ])
      + g.panel.stat.options.withColorMode('value')
      + g.panel.stat.options.withGraphMode('none')
      + g.panel.stat.options.withTextMode('auto')
      + g.panel.stat.panelOptions.withDescription('The unique number of queues in the cluster.'),

    clusterQueueOperations:
      g.panel.pieChart.new('Queue operations')
      + g.panel.pieChart.queryOptions.withTargets([
        signals.queue.mqinqCount.asTarget() + g.query.prometheus.withIntervalFactor(2),
        signals.queue.mqgetCount.asTarget() + g.query.prometheus.withIntervalFactor(2),
        signals.queue.mqopenCount.asTarget() + g.query.prometheus.withIntervalFactor(2),
        signals.queue.mqputMqput1Count.asTarget() + g.query.prometheus.withIntervalFactor(2),
      ])
      + g.panel.pieChart.standardOptions.withUnit('operations')
      + g.panel.pieChart.standardOptions.withOverrides([
        g.panel.pieChart.fieldOverride.byName.new('MQINQ')
        + g.panel.pieChart.fieldOverride.byName.withProperty('custom.hideFrom', { legend: false, tooltip: false, viz: false }),
        g.panel.pieChart.fieldOverride.byName.new('MQGET')
        + g.panel.pieChart.fieldOverride.byName.withProperty('custom.hideFrom', { legend: false, tooltip: false, viz: false }),
        g.panel.pieChart.fieldOverride.byName.new('MQOPEN')
        + g.panel.pieChart.fieldOverride.byName.withProperty('custom.hideFrom', { legend: false, tooltip: false, viz: false }),
        g.panel.pieChart.fieldOverride.byName.new('MQPUT/MQPUT1')
        + g.panel.pieChart.fieldOverride.byName.withProperty('custom.hideFrom', { legend: false, tooltip: false, viz: false }),
      ])
      + g.panel.pieChart.options.legend.withDisplayMode('list')
      + g.panel.pieChart.options.legend.withPlacement('bottom')
      + g.panel.pieChart.panelOptions.withDescription('The number of queue operations of the cluster. '),

    clusterStatus:
      g.panel.table.new('Cluster status')
      + g.panel.table.queryOptions.withTargets([
        signals.cluster.suspend.asTarget() + g.query.prometheus.withIntervalFactor(2),
      ])
      + g.panel.table.queryOptions.withTransformations([
        g.panel.table.transformation.withId('joinByLabels')
        + g.panel.table.transformation.withOptions({ join: ['cluster', 'mq_cluster', 'qmgr'], value: '__name__' }),
        g.panel.table.transformation.withId('organize')
        + g.panel.table.transformation.withOptions({
          renameByName: {
            job: 'Job',
            mq_cluster: 'Cluster',
            'ibmmq_cluster_suspend{job="integrations/ibmmq", mq_cluster="cluster0"}': 'Status',
          },
        }),
      ])
      + g.panel.table.standardOptions.withMappings([
        g.panel.table.standardOptions.mapping.ValueMap.withType()
        + g.panel.table.standardOptions.mapping.ValueMap.withOptions({
          '0': { color: 'green', index: 0, text: 'Not suspended' },
          '1': { color: 'red', index: 1, text: 'Suspended' },
        }),
      ])
      + g.panel.table.standardOptions.color.withMode('fixed')
      + g.panel.table.options.withShowHeader(true)
      + g.panel.table.options.footer.withEnablePagination(false)
      + g.panel.table.standardOptions.withOverrides([
        g.panel.table.fieldOverride.byName.new('Status')
        + g.panel.table.fieldOverride.byName.withProperty('unit', 'short')
        + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'center')
        + g.panel.table.fieldOverride.byName.withProperty('custom.cellOptions', { type: 'color-text' }),
      ])
      + g.panel.table.panelOptions.withDescription('The status of the cluster.'),

    queueManagerStatus:
      g.panel.table.new('Queue manager status')
      + g.panel.table.queryOptions.withTargets([
        signals.qmgr.status.asTarget() + g.query.prometheus.withIntervalFactor(2),
      ])
      + g.panel.table.queryOptions.withTransformations([
        g.panel.table.transformation.withId('joinByLabels')
        + g.panel.table.transformation.withOptions({ join: ['cluster', 'mq_cluster', 'qmgr'], value: '__name__' }),
        g.panel.table.transformation.withId('organize')
        + g.panel.table.transformation.withOptions({
          renameByName: {
            job: 'Job',
            mq_cluster: 'Cluster',
            qmgr: 'Queue manager',
            'ibmmq_qmgr_status{job="integrations/ibmmq", mq_cluster="cluster0", qmgr="qm0"}': 'Status',
          },
        }),
      ])
      + g.panel.table.standardOptions.withMappings([
        g.panel.table.standardOptions.mapping.ValueMap.withType()
        + g.panel.table.standardOptions.mapping.ValueMap.withOptions({
          '-1': { color: 'text', index: 0, text: 'N/A' },
          '0': { color: 'red', index: 1, text: 'Stopped' },
          '1': { color: 'yellow', index: 2, text: 'Starting' },
          '2': { color: 'green', index: 3, text: 'Running' },
          '3': { color: 'yellow', index: 4, text: 'Quiescing' },
          '4': { color: 'yellow', index: 5, text: 'Stopping' },
          '5': { color: 'blue', index: 6, text: 'Standby' },
        }),
      ])
      + g.panel.table.standardOptions.color.withMode('fixed')
      + g.panel.table.options.withShowHeader(true)
      + g.panel.table.options.footer.withEnablePagination(false)
      + g.panel.table.standardOptions.withOverrides([
        g.panel.table.fieldOverride.byName.new('Status')
        + g.panel.table.fieldOverride.byName.withProperty('unit', 'short')
        + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'center')
        + g.panel.table.fieldOverride.byName.withProperty('custom.cellOptions', { type: 'color-text' }),
      ])
      + g.panel.table.panelOptions.withDescription('The status of the queue manager (-1=N/A, 0=Stopped, 1=Starting, 2=Running, 3=Quiescing, 4=Stopping, 5=Standby).'),

    transmissionQueueTime:
      g.panel.timeSeries.new('Transmission queue time')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.channel.xmitqTimeShort.asTarget() + g.query.prometheus.withIntervalFactor(2),
        signals.channel.xmitqTimeLong.asTarget() + g.query.prometheus.withIntervalFactor(2),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('µs')
      + g.panel.timeSeries.standardOptions.withDecimals(2)
      + g.panel.timeSeries.options.legend.withDisplayMode('table')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withShowLegend(true)
      + g.panel.timeSeries.options.legend.withCalcs(['last', 'mean', 'max'])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.panelOptions.withDescription('The time taken for messages to be transmitted over sender channels.'),

    // Queue manager overview panels
    activeListeners:
      g.panel.stat.new('Active listeners')
      + g.panel.stat.queryOptions.withTargets([
        signals.qmgr.activeListeners.asTarget() + g.query.prometheus.withIntervalFactor(2),
      ])
      + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
      + g.panel.stat.standardOptions.thresholds.withSteps([
        g.panel.stat.thresholdStep.withColor('red'),
        g.panel.stat.thresholdStep.withColor('green') + g.panel.stat.thresholdStep.withValue(1),
      ])
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.options.withColorMode('value')
      + g.panel.stat.options.withGraphMode('none')
      + g.panel.stat.options.withTextMode('auto')
      + g.panel.stat.panelOptions.withDescription('The number of active listeners for the queue manager.'),

    activeConnections:
      g.panel.stat.new('Active connections')
      + g.panel.stat.queryOptions.withTargets([
        signals.qmgr.connectionCount.asTarget() + g.query.prometheus.withIntervalFactor(2),
      ])
      + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
      + g.panel.stat.standardOptions.thresholds.withSteps([
        g.panel.stat.thresholdStep.withColor('red'),
        g.panel.stat.thresholdStep.withColor('green') + g.panel.stat.thresholdStep.withValue(1),
      ])
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.options.withColorMode('value')
      + g.panel.stat.options.withGraphMode('none')
      + g.panel.stat.options.withTextMode('auto')
      + g.panel.stat.panelOptions.withDescription('The number of active connections for the queue manager.'),

    queuesManaged:
      g.panel.stat.new('Queues')
      + g.panel.stat.queryOptions.withTargets([
        g.query.prometheus.new('${prometheus_datasource}', 'count(count(ibmmq_queue_depth{%(filteringSelector)s}) by (queue, mq_cluster, qmgr))' % this.config)
        + g.query.prometheus.withIntervalFactor(2)
        + g.query.prometheus.withLegendFormat(''),
      ])
      + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
      + g.panel.stat.standardOptions.thresholds.withSteps([
        g.panel.stat.thresholdStep.withColor('red'),
        g.panel.stat.thresholdStep.withColor('green') + g.panel.stat.thresholdStep.withValue(1),
      ])
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.options.withColorMode('value')
      + g.panel.stat.options.withGraphMode('none')
      + g.panel.stat.options.withTextMode('auto')
      + g.panel.stat.panelOptions.withDescription('The unique number of queues being managed by the queue manager.'),

    memoryUtilization:
      g.panel.timeSeries.new('Estimated memory utilization')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.qmgr.memoryUtilization.asTarget() + g.query.prometheus.withIntervalFactor(2),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('percentunit')
      + g.panel.timeSeries.standardOptions.withMin(0)
      + g.panel.timeSeries.standardOptions.withMax(1)
      + g.panel.timeSeries.options.legend.withDisplayMode('table')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withShowLegend(true)
      + g.panel.timeSeries.options.legend.withCalcs(['last', 'mean', 'max'])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.panelOptions.withDescription('The estimated memory usage of the queue managers.'),

    cpuUsage:
      g.panel.timeSeries.new('CPU usage')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.qmgr.userCpuTimePercentage.asTarget() + g.query.prometheus.withIntervalFactor(2),
        signals.qmgr.systemCpuTimePercentage.asTarget() + g.query.prometheus.withIntervalFactor(2),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('percent')
      + g.panel.timeSeries.standardOptions.withMin(0)
      + g.panel.timeSeries.standardOptions.withMax(100)
      + g.panel.timeSeries.options.legend.withDisplayMode('table')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withShowLegend(true)
      + g.panel.timeSeries.options.legend.withCalcs(['last', 'mean', 'max'])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.panelOptions.withDescription('The CPU usage of the queue managers.'),

    diskUsage:
      g.panel.timeSeries.new('Disk usage')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.qmgr.queueManagerFileSystemInUseBytes.asTarget() + g.query.prometheus.withIntervalFactor(2),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('decbytes')
      + g.panel.timeSeries.options.legend.withDisplayMode('table')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withShowLegend(true)
      + g.panel.timeSeries.options.legend.withCalcs(['last', 'mean', 'max'])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.panelOptions.withDescription('The disk allocated to the queue manager that is being used.'),

    freeDiskSpace:
      g.panel.timeSeries.new('Free disk space')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.qmgr.queueManagerFileSystemFreeSpacePercentage.asTarget() + g.query.prometheus.withIntervalFactor(2),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('percent')
      + g.panel.timeSeries.standardOptions.withMin(0)
      + g.panel.timeSeries.standardOptions.withMax(100)
      + g.panel.timeSeries.options.legend.withDisplayMode('table')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withShowLegend(true)
      + g.panel.timeSeries.options.legend.withCalcs(['last', 'mean', 'max'])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.panelOptions.withDescription('The percentage of free disk space available for the queue manager.'),

    commitRate:
      g.panel.timeSeries.new('Commit rate')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.qmgr.commitCount.asTarget() + g.query.prometheus.withIntervalFactor(2),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('short')
      + g.panel.timeSeries.options.legend.withDisplayMode('table')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withShowLegend(true)
      + g.panel.timeSeries.options.legend.withCalcs(['last', 'mean', 'max'])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.panelOptions.withDescription('The rate of commits by the queue manager.'),

    publishedBytes:
      g.panel.timeSeries.new('Published bytes')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.qmgr.publishedToSubscribersBytes.asTarget() + g.query.prometheus.withIntervalFactor(2),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('decbytes')
      + g.panel.timeSeries.options.legend.withDisplayMode('table')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withShowLegend(true)
      + g.panel.timeSeries.options.legend.withCalcs(['last', 'mean', 'max'])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.panelOptions.withDescription('The rate of data being pushed from the queue manager to subscribers.'),

    publishedMessages:
      g.panel.timeSeries.new('Published messages')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.qmgr.publishedToSubscribersMessageCount.asTarget() + g.query.prometheus.withIntervalFactor(2),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('short')
      + g.panel.timeSeries.options.legend.withDisplayMode('table')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withShowLegend(true)
      + g.panel.timeSeries.options.legend.withCalcs(['last', 'mean', 'max'])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.panelOptions.withDescription('The rate of messages being published by the queue manager.'),

    expiredMessages:
      g.panel.timeSeries.new('Expired messages')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.qmgr.expiredMessageCount.asTarget() + g.query.prometheus.withIntervalFactor(2),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('short')
      + g.panel.timeSeries.options.legend.withDisplayMode('table')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withShowLegend(true)
      + g.panel.timeSeries.options.legend.withCalcs(['last', 'mean', 'max'])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.panelOptions.withDescription('The rate of expired messages for the queue manager.'),

    logWriteLatency:
      g.panel.timeSeries.new('Log write latency')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.qmgr.logWriteLatencySeconds.asTarget() + g.query.prometheus.withIntervalFactor(2),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('s')
      + g.panel.timeSeries.options.legend.withDisplayMode('table')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withShowLegend(true)
      + g.panel.timeSeries.options.legend.withCalcs(['last', 'mean', 'max'])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.panelOptions.withDescription('The recent latency of log writes.'),

    logUsage:
      g.panel.timeSeries.new('Log usage')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.qmgr.logInUseBytes.asTarget() + g.query.prometheus.withIntervalFactor(2),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('decbytes')
      + g.panel.timeSeries.options.legend.withDisplayMode('table')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withShowLegend(true)
      + g.panel.timeSeries.options.legend.withCalcs(['last', 'mean', 'max'])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.panelOptions.withDescription('The amount of data on the filesystem occupied by queue manager logs.'),

    // Queue overview panels
    queueAverageTime:
      g.panel.timeSeries.new('Average queue time')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.queue.averageQueueTimeSeconds.asTarget() + g.query.prometheus.withIntervalFactor(2),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('s')
      + g.panel.timeSeries.options.legend.withDisplayMode('table')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withShowLegend(true)
      + g.panel.timeSeries.options.legend.withCalcs(['last', 'mean', 'max'])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.panelOptions.withDescription('The average amount of time a message spends in the queue.'),

    queueExpiredMessages:
      g.panel.timeSeries.new('Expired messages')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.queue.expiredMessages.asTarget() + g.query.prometheus.withIntervalFactor(2),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('short')
      + g.panel.timeSeries.options.legend.withDisplayMode('table')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withShowLegend(true)
      + g.panel.timeSeries.options.legend.withCalcs(['last', 'mean', 'max'])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.panelOptions.withDescription('The rate of expired messages in the queue.'),

    queueDepth:
      g.panel.timeSeries.new('Depth')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.queue.depth.asTarget() + g.query.prometheus.withIntervalFactor(2),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('short')
      + g.panel.timeSeries.options.legend.withDisplayMode('table')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withShowLegend(true)
      + g.panel.timeSeries.options.legend.withCalcs(['last', 'mean', 'max'])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.panelOptions.withDescription('The number of active messages in the queue.'),

    queueOperationThroughput:
      g.panel.timeSeries.new('Operation throughput')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.queue.mqgetBytes.asTarget() + g.query.prometheus.withIntervalFactor(2),
        signals.queue.mqputBytes.asTarget() + g.query.prometheus.withIntervalFactor(2),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('decbytes')
      + g.panel.timeSeries.options.legend.withDisplayMode('table')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withShowLegend(true)
      + g.panel.timeSeries.options.legend.withCalcs(['last', 'mean', 'max'])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.panelOptions.withDescription('The throughput of operations on the queue.'),

    queueOperations:
      g.panel.timeSeries.new('Operations')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.queue.mqsetCount.asTarget() + g.query.prometheus.withIntervalFactor(2),
        signals.queue.mqinqCount.asTarget() + g.query.prometheus.withIntervalFactor(2),
        signals.queue.mqgetCount.asTarget() + g.query.prometheus.withIntervalFactor(2),
        signals.queue.mqopenCount.asTarget() + g.query.prometheus.withIntervalFactor(2),
        signals.queue.mqcloseCount.asTarget() + g.query.prometheus.withIntervalFactor(2),
        signals.queue.mqputMqput1Count.asTarget() + g.query.prometheus.withIntervalFactor(2),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('operations')
      + g.panel.timeSeries.options.legend.withDisplayMode('table')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withShowLegend(true)
      + g.panel.timeSeries.options.legend.withCalcs(['last', 'mean', 'max'])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.panelOptions.withDescription('The rate of operations on the queue.'),

    // Topics overview panels
    topicMessagesReceived:
      g.panel.timeSeries.new('Topic messages received')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.topic.messagesReceived.asTarget() + g.query.prometheus.withIntervalFactor(2),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('short')
      + g.panel.timeSeries.options.legend.withDisplayMode('table')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withShowLegend(true)
      + g.panel.timeSeries.options.legend.withCalcs(['last', 'mean', 'max'])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.panelOptions.withDescription('Received messages per topic.'),

    timeSinceLastMessage:
      g.panel.barGauge.new('Time since last message')
      + g.panel.barGauge.queryOptions.withTargets([
        signals.topic.timeSinceMsgReceived.asTarget() + g.query.prometheus.withIntervalFactor(2),
      ])
      + g.panel.barGauge.standardOptions.withUnit('s')
      + g.panel.barGauge.standardOptions.color.withMode('thresholds')
      + g.panel.barGauge.options.reduceOptions.withCalcs(['lastNotNull'])
      + g.panel.barGauge.options.withDisplayMode('basic')
      + g.panel.barGauge.options.withOrientation('horizontal')
      + g.panel.barGauge.options.withShowUnfilled(true)
      + g.panel.barGauge.options.withValueMode('color')
      + g.panel.barGauge.panelOptions.withDescription('The time since the topic last received a message.'),

    topicSubscribers:
      g.panel.timeSeries.new('Topic subscribers')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.topic.subscriberCount.asTarget() + g.query.prometheus.withIntervalFactor(2),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('short')
      + g.panel.timeSeries.options.legend.withDisplayMode('table')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withShowLegend(true)
      + g.panel.timeSeries.options.legend.withCalcs(['last', 'mean', 'max'])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.panelOptions.withDescription('The number of subscribers per topic.'),

    topicPublishers:
      g.panel.timeSeries.new('Topic publishers')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.topic.publisherCount.asTarget() + g.query.prometheus.withIntervalFactor(2),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('short')
      + g.panel.timeSeries.options.legend.withDisplayMode('table')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withShowLegend(true)
      + g.panel.timeSeries.options.legend.withCalcs(['last', 'mean', 'max'])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.panelOptions.withDescription('The number of publishers per topic.'),

    subscriptionMessagesReceived:
      g.panel.timeSeries.new('Subscription messages received')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.subscription.messagesReceived.asTarget() + g.query.prometheus.withIntervalFactor(2),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('short')
      + g.panel.timeSeries.options.legend.withDisplayMode('table')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withShowLegend(true)
      + g.panel.timeSeries.options.legend.withCalcs(['last', 'mean', 'max'])
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.panelOptions.withDescription('The rate of messages a subscription receives.'),

    subscriptionStatus:
      g.panel.table.new('Subscription status')
      + g.panel.table.queryOptions.withTargets([
        signals.subscription.timeSinceMessagePublished.asTarget() + g.query.prometheus.withIntervalFactor(2),
      ])
      + g.panel.table.queryOptions.withTransformations([
        g.panel.table.transformation.withId('joinByLabels')
        + g.panel.table.transformation.withOptions({ value: '__name__' }),
        g.panel.table.transformation.withId('organize')
        + g.panel.table.transformation.withOptions({
          renameByName: {
            job: 'Job',
            mq_cluster: 'Cluster',
            qmgr: 'Queue manager',
            subscription: 'Subscription',
            'ibmmq_subscription_time_since_message_published{job="integrations/ibmmq", mq_cluster="cluster0", qmgr="qm0", subscription="sub0"}': 'Time since message published',
          },
        }),
      ])
      + g.panel.table.standardOptions.withUnit('s')
      + g.panel.table.options.withShowHeader(true)
      + g.panel.table.options.footer.withEnablePagination(false)
      + g.panel.table.standardOptions.withOverrides([
        g.panel.table.fieldOverride.byName.new('Time since message published')
        + g.panel.table.fieldOverride.byName.withProperty('unit', 's')
        + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'center'),
      ])
      + g.panel.table.panelOptions.withDescription('The time since a message was published to the subscription.'),
  },
}
