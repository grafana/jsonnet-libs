local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this)::
    {
      local signals = this.signals,

      /*
      -------------------------
      Cluster Overview
      -------------------------
      */

      clusterClusters:
        commonlib.panels.generic.stat.info.new('Clusters', targets=[signals.cluster.clusters.asTarget()])
        + g.panel.stat.panelOptions.withDescription('The unique number of clusters being reported.')
        + g.panel.stat.standardOptions.withUnit('none'),

      clusterQueueManagers:
        commonlib.panels.generic.stat.info.new('Queue managers', targets=[signals.cluster.queueManagers.asTarget()])
        + g.panel.stat.panelOptions.withDescription('The unique number of queue managers in the cluster being reported.')
        + g.panel.stat.standardOptions.withUnit('none'),

      clusterTopics:
        commonlib.panels.generic.stat.info.new('Topics', targets=[signals.cluster.topics.asTarget()])
        + g.panel.stat.panelOptions.withDescription('The unique number of topics in the cluster.')
        + g.panel.stat.standardOptions.withUnit('none'),

      clusterQueues:
        commonlib.panels.generic.stat.info.new('Queues', targets=[signals.cluster.queues.asTarget()])
        + g.panel.stat.panelOptions.withDescription('The unique number of queues in the cluster.')
        + g.panel.stat.standardOptions.withUnit('none'),

      clusterQueueOperations:
        g.panel.pieChart.new('Queue operations')
        + g.panel.pieChart.queryOptions.withTargets([
          signals.cluster.queueOperationsMqset.asTarget(),
          signals.cluster.queueOperationsMqinq.asTarget(),
          signals.cluster.queueOperationsMqget.asTarget(),
          signals.cluster.queueOperationsMqopen.asTarget(),
          signals.cluster.queueOperationsMqclose.asTarget(),
          signals.cluster.queueOperationsMqput.asTarget(),
        ])
        + g.panel.pieChart.panelOptions.withDescription('The number of queue operations of the cluster.')
        + g.panel.pieChart.standardOptions.withUnit('operations')
        + g.panel.pieChart.options.withLegend({ displayMode: 'list', placement: 'bottom', showLegend: true })
        + g.panel.pieChart.options.withPieType('pie')
        + g.panel.pieChart.options.reduceOptions.withCalcs(['lastNotNull']),

      clusterStatusTable:
        commonlib.panels.generic.table.base.new('Cluster status', targets=[signals.cluster.clusterStatus.asTarget()])
        + g.panel.table.panelOptions.withDescription('The status of the cluster.')
        + g.panel.table.standardOptions.color.withMode('fixed')
        + g.panel.table.fieldConfig.defaults.custom.withAlign('center')
        + g.panel.table.fieldConfig.defaults.custom.withCellOptions({ type: 'color-text' })
        + g.panel.table.fieldConfig.defaults.custom.withInspect(false)
        + {
          options+: {
            enablePagination: true,
          },
        }
        + g.panel.table.standardOptions.withMappings([
          {
            type: 'value',
            options: {
              '0': {
                text: 'Not suspended',
                color: 'green',
                index: 0,
              },
              '1': {
                text: 'Suspended',
                color: 'red',
                index: 1,
              },
            },
          },
        ])
        + g.panel.table.queryOptions.withTransformations([
          g.panel.table.transformation.withId('joinByLabels')
          + g.panel.table.transformation.withOptions({
            join: ['cluster', 'mq_cluster', 'qmgr'],
            value: '__name__',
          }),
          g.panel.table.transformation.withId('organize')
          + g.panel.table.transformation.withOptions({
            excludeByName: {},
            indexByName: {},
            renameByName: {
              cluster: 'Cluster',
              ibmmq_cluster_suspend: 'Status',
              mq_cluster: 'MQ cluster',
              qmgr: 'Queue manager',
            },
          }),
          g.panel.table.transformation.withId('reduce')
          + g.panel.table.transformation.withOptions({
            includeTimeField: false,
            mode: 'reduceFields',
            reducers: ['last'],
          }),
        ]),

      clusterQueueManagerStatusTable:
        commonlib.panels.generic.table.base.new('Queue manager status', targets=[signals.cluster.queueManagerStatus.asTarget()])
        + g.panel.table.panelOptions.withDescription('The queue managers of the cluster displayed in a table.')
        + g.panel.table.standardOptions.color.withMode('fixed')
        + g.panel.table.fieldConfig.defaults.custom.withAlign('center')
        + g.panel.table.fieldConfig.defaults.custom.withCellOptions({ type: 'color-text' })
        + g.panel.table.fieldConfig.defaults.custom.withInspect(false)
        + { options+: { enablePagination: true } }
        + g.panel.table.standardOptions.withMappings([
          {
            type: 'value',
            options: {
              '-1': {
                text: 'N/A',
                color: 'dark-red',
                index: 0,
              },
              '0': {
                text: 'Stopped',
                color: 'red',
                index: 1,
              },
              '1': {
                text: 'Starting',
                color: 'light-green',
                index: 2,
              },
              '2': {
                text: 'Running',
                color: 'green',
                index: 3,
              },
              '3': {
                text: 'Quiescing',
                index: 4,
              },
              '4': {
                text: 'Stopping',
                color: 'light-red',
                index: 5,
              },
              '5': {
                text: 'Standby',
                index: 6,
              },
            },
          },
        ])
        + g.panel.table.queryOptions.withTransformations([
          g.panel.table.transformation.withId('joinByLabels')
          + g.panel.table.transformation.withOptions({
            join: ['mq_cluster', 'qmgr', 'instance'],
            value: '__name__',
          }),
          g.panel.table.transformation.withId('organize')
          + g.panel.table.transformation.withOptions({
            excludeByName: {},
            indexByName: {},
            renameByName: {
              ibmmq_qmgr_status: 'Status',
              instance: 'Instance',
              mq_cluster: 'MQ cluster',
              qmgr: 'Queue manager',
            },
          }),
          g.panel.table.transformation.withId('reduce')
          + g.panel.table.transformation.withOptions({
            includeTimeField: false,
            mode: 'reduceFields',
            reducers: ['last'],
          }),
        ]),

      clusterTransmissionQueueTime:
        commonlib.panels.generic.timeSeries.base.new('Transmission queue time', targets=[
          signals.cluster.transmissionQueueTimeShort.asTarget(),
          signals.cluster.transmissionQueueTimeLong.asTarget(),
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The time it takes for the messages to get through the transmission queue. (Long) - total time taken for messages to be transmitted over the channel, (Short) - an average, minimum, or maximum time taken to transmit messages over the channel in recent intervals.')
        + g.panel.timeSeries.standardOptions.withUnit('µs'),

      /*
      -------------------------
      Queue Manager Overview
      -------------------------
      */

      qmgrActiveListeners:
        commonlib.panels.generic.stat.info.new('Active listeners', targets=[signals.queueManager.activeListeners.asTarget()])
        + g.panel.stat.panelOptions.withDescription('The number of active listeners for the queue manager.')
        + g.panel.stat.standardOptions.withUnit('none')
        + g.panel.stat.standardOptions.thresholds.withSteps([
          g.panel.stat.standardOptions.threshold.step.withColor('red')
          + g.panel.stat.standardOptions.threshold.step.withValue(null),
          g.panel.stat.standardOptions.threshold.step.withColor('green')
          + g.panel.stat.standardOptions.threshold.step.withValue(1),
        ])
        + g.panel.stat.options.withColorMode('value'),

      qmgrActiveConnections:
        commonlib.panels.generic.stat.info.new('Active connections', targets=[signals.queueManager.activeConnections.asTarget()])
        + g.panel.stat.panelOptions.withDescription('The number of active connections for the queue manager.')
        + g.panel.stat.standardOptions.withUnit('none')
        + g.panel.stat.standardOptions.thresholds.withSteps([
          g.panel.stat.standardOptions.threshold.step.withColor('red')
          + g.panel.stat.standardOptions.threshold.step.withValue(null),
          g.panel.stat.standardOptions.threshold.step.withColor('green')
          + g.panel.stat.standardOptions.threshold.step.withValue(1),
        ])
        + g.panel.stat.options.withColorMode('value'),

      qmgrQueues:
        commonlib.panels.generic.stat.info.new('Queues', targets=[signals.queueManager.queues.asTarget()])
        + g.panel.stat.panelOptions.withDescription('The unique number of queues being managed by the queue manager.')
        + g.panel.stat.standardOptions.withUnit('none')
        + g.panel.stat.standardOptions.thresholds.withSteps([
          g.panel.stat.standardOptions.threshold.step.withColor('red')
          + g.panel.stat.standardOptions.threshold.step.withValue(null),
          g.panel.stat.standardOptions.threshold.step.withColor('green')
          + g.panel.stat.standardOptions.threshold.step.withValue(1),
        ])
        + g.panel.stat.options.withColorMode('value'),

      qmgrEstimatedMemoryUtilization:
        commonlib.panels.generic.timeSeries.base.new('Estimated memory utilization', targets=[
          signals.queueManager.estimatedMemoryUtilization.asTarget(),
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The estimated memory usage of the queue managers.')
        + g.panel.timeSeries.standardOptions.withUnit('percentunit'),

      qmgrStatusTable:
        commonlib.panels.generic.table.base.new('Queue manager status', targets=[signals.queueManager.queueManagerStatusUptime.asTarget(), signals.queueManager.queueManagerStatus.asTarget()])
        + g.panel.table.panelOptions.withDescription('A table showing the status and uptime of the queue manager.')
        + { options+: { enablePagination: true } }
        + g.panel.table.queryOptions.withTransformations([
          g.panel.table.transformation.withId('joinByField')
          + g.panel.table.transformation.withOptions({
            byField: 'Time',
            mode: 'inner',
          }),
          g.panel.table.transformation.withId('organize')
          + g.panel.table.transformation.withOptions({
            excludeByName: {
              Time: true,
              __name__: true,
              description: true,
              hostname: true,
              instance: true,
              job: true,
              platform: true,
            },
            renameByName: {
              Value: 'Uptime',
              'ibmmq_qmgr_status{job="$job", mq_cluster=~"$mq_cluster", qmgr="$qmgr"}': 'Status',
              mq_cluster: 'MQ cluster',
              qmgr: 'Queue manager',
            },
          }),
          g.panel.table.transformation.withId('reduce')
          + g.panel.table.transformation.withOptions({
            includeTimeField: false,
            mode: 'reduceFields',
            reducers: ['lastNotNull'],
          }),
        ])
        + g.panel.table.standardOptions.withOverrides([
          g.panel.table.fieldOverride.byName.new('Uptime')
          + g.panel.table.fieldOverride.byName.withProperty('unit', 's'),
          g.panel.table.fieldOverride.byName.new('Status')
          + g.panel.table.fieldOverride.byName.withProperty('custom.cellOptions', { type: 'color-text' }),
        ]),

      qmgrCpuUsage:
        commonlib.panels.generic.timeSeries.base.new('CPU usage', targets=[
          signals.queueManager.cpuUsageUser.asTarget(),
          signals.queueManager.cpuUsageSystem.asTarget(),
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The system/user CPU usage of the queue manager.')
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

      qmgrDiskUsage:
        commonlib.panels.generic.timeSeries.base.new('Disk usage', targets=[
          signals.queueManager.diskUsage.asTarget(),
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The disk allocated to the queue manager that is being used.')
        + g.panel.timeSeries.standardOptions.withUnit('decbytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

      qmgrCommits:
        commonlib.panels.generic.timeSeries.base.new('Commits', targets=[
          signals.queueManager.commits.asTarget(),
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The commits of the queue manager.')
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

      qmgrPublishThroughput:
        commonlib.panels.generic.timeSeries.base.new('Publish throughput', targets=[
          signals.queueManager.publishThroughput.asTarget(),
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The amount of data being pushed from the queue manager to subscribers.')
        + g.panel.timeSeries.standardOptions.withUnit('decbytes'),

      qmgrPublishedMessages:
        commonlib.panels.generic.timeSeries.base.new('Published messages', targets=[
          signals.queueManager.publishedMessages.asTarget(),
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The number of messages being published by the queue manager.')
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

      qmgrExpiredMessages:
        commonlib.panels.generic.timeSeries.base.new('Expired messages', targets=[
          signals.queueManager.expiredMessages.asTarget(),
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The expired messages of the queue manager.')
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

      qmgrQueueOperations:
        commonlib.panels.generic.timeSeries.base.new('Queue operations', targets=[
          signals.queueManager.queueOperationsMqset.asTarget(),
          signals.queueManager.queueOperationsMqinq.asTarget(),
          signals.queueManager.queueOperationsMqget.asTarget(),
          signals.queueManager.queueOperationsMqopen.asTarget(),
          signals.queueManager.queueOperationsMqclose.asTarget(),
          signals.queueManager.queueOperationsMqput.asTarget(),
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The number of queue operations of the queue manager.')
        + g.panel.timeSeries.standardOptions.withUnit('operations')
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      qmgrLogLatency:
        commonlib.panels.generic.timeSeries.base.new('Log latency', targets=[
          signals.queueManager.logLatency.asTarget(),
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The recent latency of log writes.')
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

      qmgrLogUsage:
        commonlib.panels.generic.timeSeries.base.new('Log usage', targets=[
          signals.queueManager.logUsage.asTarget(),
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The amount of data on the filesystem occupied by queue manager logs.')
        + g.panel.timeSeries.standardOptions.withUnit('decbytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

      qmgrErrorLogs:
        g.panel.logs.new('Error logs')
        + g.panel.logs.panelOptions.withDescription('Recent error logs from the queue manager.')
        + g.panel.logs.options.withEnableLogDetails(true)
        + g.panel.logs.options.withShowTime(false)
        + g.panel.logs.options.withWrapLogMessage(false)
        + g.panel.logs.options.withDedupStrategy('none')
        + g.panel.logs.options.withPrettifyLogMessage(false)
        + g.panel.logs.options.withShowCommonLabels(false)
        + g.panel.logs.options.withShowLabels(false)
        + g.panel.logs.options.withSortOrder('Descending')
        + g.panel.logs.queryOptions.withDatasource('loki', '${loki_datasource}')
        + g.panel.logs.queryOptions.withTargets([
          g.query.loki.new(
            '${loki_datasource}',
            '{job=~"$job", qmgr=~"$qmgr"} |= `` | (filename=~"/var/mqm/qmgrs/.*/errors/.*LOG" or log_type="mq-qmgr-error")'
          )
          + g.query.loki.withRefId('A'),
        ]),

      /*
      -------------------------
      Queue Overview
      -------------------------
      */

      queueAverageQueueTime:
        commonlib.panels.generic.timeSeries.base.new('Average queue time', targets=[
          signals.queue.averageQueueTime.asTarget(),
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The average amount of time a message spends in the queue.')
        + g.panel.timeSeries.standardOptions.withUnit('s'),

      queueExpiredMessages:
        commonlib.panels.generic.timeSeries.base.new('Expired messages', targets=[
          signals.queue.expiredMessages.asTarget(),
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The expired messages of the queue.')
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      queueDepth:
        commonlib.panels.generic.timeSeries.base.new('Queue depth', targets=[
          signals.queue.queueDepth.asTarget(),
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The depth of the queue.')
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      queueOldestMessageAge:
        commonlib.panels.generic.timeSeries.base.new('Oldest message age', targets=[
          signals.queue.oldestMessageAge.asTarget(),
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The oldest message age of the queue.')
        + g.panel.timeSeries.standardOptions.withUnit('s'),

      queueInputOutputRate:
        commonlib.panels.generic.timeSeries.base.new('Input/output rate', targets=[
          signals.queue.inputOutputRate.asTarget(),
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The input/output rate of the queue.')
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      queueTimeOnQueue:
        commonlib.panels.generic.timeSeries.base.new('Time on queue', targets=[
          signals.queue.timeOnQueue.asTarget(),
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The average time messages spent on the queue.')
        + g.panel.timeSeries.standardOptions.withUnit('µs'),

      queuePurgedMessages:
        commonlib.panels.generic.timeSeries.base.new('Purged messages', targets=[
          signals.queue.purgedMessages.asTarget(),
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The purged messages from the queue.')
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      queueInputOutputBytes:
        commonlib.panels.generic.timeSeries.base.new('Input/output bytes', targets=[
          signals.queue.inputMessagesBytes.asTarget(),
          signals.queue.outputMessagesBytes.asTarget(),
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The input/output messages of the queue in bytes.')
        + g.panel.timeSeries.standardOptions.withUnit('decbytes'),

      queueOperationThroughput:
        commonlib.panels.generic.timeSeries.base.new('Operation throughput', targets=[
          signals.queue.mqgetBytes.asTarget(),
          signals.queue.mqputBytes.asTarget(),
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The amount of throughput going through the queue via MQGETs and MQPUTs.')
        + g.panel.timeSeries.standardOptions.withUnit('decbytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
        + g.panel.timeSeries.options.legend.withDisplayMode('list')
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      queueOperations:
        commonlib.panels.generic.timeSeries.base.new('Operations', targets=[
          signals.queue.mqsetCount.asTarget(),
          signals.queue.mqinqCount.asTarget(),
          signals.queue.mqgetCount.asTarget(),
          signals.queue.mqopenCount.asTarget(),
          signals.queue.mqcloseCount.asTarget(),
          signals.queue.mqputMqput1Count.asTarget(),
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The number of queue operations of the queue manager.')
        + g.panel.timeSeries.standardOptions.withUnit('operations')
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
        + g.panel.timeSeries.options.legend.withCalcs(['min', 'max', 'mean'])
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      /*
      -------------------------
      Topics Overview
      -------------------------
      */

      topicMessagesReceived:
        commonlib.panels.generic.timeSeries.base.new('Topic messages received', targets=[
          signals.topic.topicMessagesReceived.asTarget(),
        ])
        + g.panel.timeSeries.panelOptions.withDescription('Received messages per topic.')
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
        + g.panel.timeSeries.options.legend.withDisplayMode('list')
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      topicTimeSinceLastMessage:
        g.panel.barGauge.new('Time since last message')
        + g.panel.barGauge.queryOptions.withTargets([
          signals.topic.timeSinceLastMessage.asTarget(),
        ])
        + g.panel.barGauge.panelOptions.withDescription('The time since the topic last received a message.')
        + g.panel.barGauge.standardOptions.withUnit('s')
        + g.panel.barGauge.options.withOrientation('horizontal')
        + g.panel.barGauge.options.withDisplayMode('basic')
        + g.panel.barGauge.options.withShowUnfilled(true)
        + g.panel.barGauge.options.reduceOptions.withCalcs(['lastNotNull']),

      topicSubscribers:
        commonlib.panels.generic.timeSeries.base.new('Topic subscribers', targets=[
          signals.topic.subscribers.asTarget(),
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The number of subscribers per topic.')
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.options.legend.withDisplayMode('list')
        + g.panel.timeSeries.options.legend.withPlacement('bottom'),

      topicPublishers:
        commonlib.panels.generic.timeSeries.base.new('Topic publishers', targets=[
          signals.topic.publishers.asTarget(),
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The number of publishers per topic.')
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.options.legend.withDisplayMode('list')
        + g.panel.timeSeries.options.legend.withPlacement('bottom'),

      subscriptionMessagesReceived:
        commonlib.panels.generic.timeSeries.base.new('Subscription messages received', targets=[
          signals.topic.subscriptionMessagesReceived.asTarget(),
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The number of messages a subscription receives.')
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
        + g.panel.timeSeries.options.legend.withDisplayMode('list')
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      subscriptionStatus:
        commonlib.panels.generic.table.base.new('Subscription status', targets=[signals.topic.subscriptionTimeSinceMessagePublished.asTableTarget()])
        + { options+: { enablePagination: true } }
        + g.panel.table.panelOptions.withDescription('A table for at a glance information about a subscription.')
        + g.panel.table.standardOptions.withUnit('s')
        + g.panel.table.queryOptions.withTransformations([
          g.panel.table.transformation.withId('organize')
          + g.panel.table.transformation.withOptions({
            excludeByName: {
              Time: true,
              __name__: true,
              instance: true,
              job: true,
              platform: true,
              subid: true,
            },
            indexByName: {
              Time: 6,
              Value: 5,
              __name__: 7,
              instance: 8,
              job: 9,
              mq_cluster: 1,
              platform: 10,
              qmgr: 0,
              subid: 11,
              subscription: 2,
              topic: 4,
              type: 3,
            },
          }),
          g.panel.table.transformation.withId('groupBy')
          + g.panel.table.transformation.withOptions({
            fields: {
              Value: {
                aggregations: ['last'],
                operation: 'aggregate',
              },
              mq_cluster: {
                aggregations: [],
                operation: 'groupby',
              },
              qmgr: {
                aggregations: [],
                operation: 'groupby',
              },
              subscription: {
                aggregations: [],
                operation: 'groupby',
              },
              topic: {
                aggregations: [],
                operation: 'groupby',
              },
              type: {
                aggregations: [],
                operation: 'groupby',
              },
            },
          }),
          g.panel.table.transformation.withId('organize')
          + g.panel.table.transformation.withOptions({
            renameByName: {
              'Value (last)': 'Time since last subscription message',
              'Value (lastNotNull)': 'Time since last subscription message',
            },
          }),
        ])
        + g.panel.table.options.footer.withEnablePagination(false),
    },
}
