local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this)::
    {
      local signals = this.signals,

      interserverConnectionsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Interserver connections',
          targets=[signals.replica.interserverConnections.asTarget()],
          description='Number of connections due to interserver communication'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      replicaQueueSizePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Replica queue size',
          targets=[signals.replica.replicasMaxQueueSize.asTarget()],
          description='Number of replica tasks in queue'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      replicaOperationsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Replica operations',
          targets=[signals.replica.replicatedPartFetches.asTarget(), signals.replica.replicatedPartMerges.asTarget(), signals.replica.replicatedPartMutations.asTarget(), signals.replica.replicatedPartChecks.asTarget()],
          description='Replica Operations over time to other nodes'
        )
        + g.panel.timeSeries.standardOptions.withUnit('/ sec')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      replicaReadOnlyPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Replica read only',
          targets=[signals.replica.readonlyReplica.asTarget()],
          description='Shows replicas in read-only state over time'
        )
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      zooKeeperWatchesPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'ZooKeeper watches',
          targets=[signals.zookeeper.zooKeeperWatches.asTarget()],
          description='Current number of watches in ZooKeeper'
        )
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      zooKeeperSessionsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'ZooKeeper sessions',
          targets=[signals.zookeeper.zooKeeperSessions.asTarget()],
          description='Current number of sessions to ZooKeeper'
        )
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      zooKeeperRequestsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'ZooKeeper requests',
          targets=[signals.zookeeper.zooKeeperRequests.asTarget()],
          description='Current number of active requests to ZooKeeper'
        )
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      successfulQueriesPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Successful queries',
          targets=[signals.queries.selectQueries.asTarget(), signals.queries.insertQueries.asTarget(), signals.queries.asyncInsertQueries.asTarget()],
          description='Rate of successful queries per second'
        )
        + g.panel.timeSeries.standardOptions.withUnit('/ sec')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      failedQueriesPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Failed queries',
          targets=[signals.queries.failedSelectQueries.asTarget(), signals.queries.failedInsertQueries.asTarget()],
          description='Rate of failed queries per second'
        )
        + g.panel.timeSeries.standardOptions.withUnit('/ sec')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      rejectedInsertsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Rejected inserts',
          targets=[signals.queries.rejectedInserts.asTarget()],
          description='Number of rejected inserts per second'
        )
        + g.panel.timeSeries.standardOptions.withUnit('/ sec')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      memoryUsagePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Memory usage',
          targets=[signals.memory.memoryUsage.asTarget()],
          description='Memory usage over time'
        )
        + g.panel.timeSeries.standardOptions.withUnit('decbytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      memoryUsageGaugePanel:
        g.panel.gauge.new('Memory usage')
        + g.panel.gauge.queryOptions.withTargets([signals.memory.memoryUsagePercent.asTarget()])
        + g.panel.gauge.queryOptions.withDatasource('prometheus', '${' + this.grafana.variables.datasources.prometheus.name + '}')
        + g.panel.gauge.panelOptions.withDescription('Percentage of memory allocated by ClickHouse compared to OS total')
        + g.panel.gauge.options.withShowThresholdLabels(true)
        + g.panel.gauge.standardOptions.thresholds.withSteps([
          g.panel.gauge.standardOptions.threshold.step.withColor('super-light-green')
          + g.panel.gauge.standardOptions.threshold.step.withValue(0),
          g.panel.gauge.standardOptions.threshold.step.withColor('#EAB839')
          + g.panel.gauge.standardOptions.threshold.step.withValue(80),
          g.panel.gauge.standardOptions.threshold.step.withColor('super-light-red')
          + g.panel.gauge.standardOptions.threshold.step.withValue(90),
        ])
        + g.panel.gauge.standardOptions.withUnit('percent'),

      activeConnectionsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Active connections',
          targets=[signals.connections.tcpConnections.asTarget(), signals.connections.httpConnections.asTarget(), signals.connections.mysqlConnections.asTarget(), signals.connections.postgresqlConnections.asTarget()],
          description='Current number of connections to ClickHouse'
        )
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      networkReceivedPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Network received',
          targets=[signals.network.networkReceiveBytes.asTarget()],
          description='Received network throughput'
        )
        + g.panel.timeSeries.standardOptions.withUnit('Bps')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      networkTransmittedPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Network transmitted',
          targets=[signals.network.networkSendBytes.asTarget()],
          description='Transmitted network throughput'
        )
        + g.panel.timeSeries.standardOptions.withUnit('Bps')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      diskReadLatencyPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Disk read latency',
          targets=[signals.disk.diskReadLatency.asTarget()],
          description='Time spent waiting for read syscall'
        )
        + g.panel.timeSeries.standardOptions.withUnit('µs')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      diskWriteLatencyPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Disk write latency',
          targets=[signals.disk.diskWriteLatency.asTarget()],
          description='Time spent waiting for write syscall'
        )
        + g.panel.timeSeries.standardOptions.withUnit('µs')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      networkTransmitLatencyInboundPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Network receive latency',
          targets=[signals.network.networkReceiveLatency.asTarget()],
          description='Latency of inbound network traffic'
        )
        + g.panel.timeSeries.standardOptions.withUnit('µs')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      networkTransmitLatencyOutboundPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Network transmit latency',
          targets=[signals.network.networkSendLatency.asTarget()],
          description='Latency of outbound network traffic'
        )
        + g.panel.timeSeries.standardOptions.withUnit('µs')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      zooKeeperWaitTimePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'ZooKeeper wait time',
          targets=[signals.zookeeper.zooKeeperWaitTime.asTarget()],
          description='Time spent waiting for ZooKeeper request to process'
        )
        + g.panel.timeSeries.standardOptions.withUnit('µs')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),
    },
}
