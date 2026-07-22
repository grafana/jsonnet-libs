local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(signals, config): {
    local tsPanel = g.panel.timeSeries,

    // Replica set state value mappings
    local replicaSetStateMappings =
      g.panel.stat.standardOptions.mapping.ValueMap.withType()
      + g.panel.stat.standardOptions.mapping.ValueMap.withOptions({
        '0': { index: 0, text: 'STARTUP' },
        '1': { index: 1, text: 'PRIMARY (Healthy)' },
        '2': { index: 2, text: 'SECONDARY (Healthy)' },
        '3': { index: 3, text: 'RECOVERING' },
        '5': { index: 4, text: 'STARTUP2' },
        '6': { index: 5, text: 'UNKNOWN' },
        '7': { index: 6, text: 'ARBITER' },
        '8': { index: 7, text: 'DOWN' },
        '9': { index: 8, text: 'ROLLBACK' },
        '10': { index: 9, text: 'REMOVED' },
      }),

    local instanceSelector = 'job=~"$job",mongodb_cluster=~"$mongodb_cluster",service_name=~"$service_name"',
    local overviewTableTarget(refId, expr) =
      signals.instance.uptime.asTarget()
      + g.query.prometheus.withRefId(refId)
      + g.query.prometheus.withExpr(expr)
      + g.query.prometheus.withInstant(true)
      + g.query.prometheus.withFormat('table'),

    instanceOverviewTable:
      commonlib.panels.generic.table.base.new(
        'Instances',
        targets=[
          overviewTableTarget('Uptime', 'max by (instance) (mongodb_instance_uptime_seconds{%s})' % instanceSelector),
          overviewTableTarget('QPS', 'sum by (instance) (irate(mongodb_mongod_op_counters_total{%(sel)s, type!="command"}[$__rate_interval]) or irate(mongodb_op_counters_total{%(sel)s, type!="command"}[$__rate_interval]))' % { sel: instanceSelector }) + g.query.prometheus.withInterval('2m'),
          overviewTableTarget('State', 'max by (instance) (mongodb_mongod_replset_my_state{%s})' % instanceSelector),
          overviewTableTarget('Latency', 'max by (instance) (irate(mongodb_mongod_op_latencies_latency_total{%(sel)s, type="command"}[$__rate_interval]) / (irate(mongodb_mongod_op_latencies_ops_total{%(sel)s, type="command"}[$__rate_interval]) > 0))' % { sel: instanceSelector }) + g.query.prometheus.withInterval('2m'),
        ],
        description='Per-instance overview: uptime, QPS, replica set state and command latency.'
      )
      + g.panel.table.queryOptions.withTransformations([
        { id: 'joinByField', options: { byField: 'instance', mode: 'outer' } },
        {
          id: 'organize',
          options: {
            excludeByName: { Time: true },
            indexByName: { instance: 0, 'Value #Uptime': 1, 'Value #QPS': 2, 'Value #State': 3, 'Value #Latency': 4 },
            renameByName: {
              instance: 'Instance',
              'Value #Uptime': 'Uptime',
              'Value #QPS': 'QPS',
              'Value #State': 'Replica set',
              'Value #Latency': 'Latency',
            },
          },
        },
      ])
      + g.panel.table.standardOptions.withOverrides([
        { matcher: { id: 'byName', options: 'Uptime' }, properties: [{ id: 'unit', value: 's' }] },
        { matcher: { id: 'byName', options: 'QPS' }, properties: [{ id: 'unit', value: 'ops' }] },
        { matcher: { id: 'byName', options: 'Latency' }, properties: [{ id: 'unit', value: 'µs' }] },
        { matcher: { id: 'byName', options: 'Replica set' }, properties: [{ id: 'mappings', value: [replicaSetStateMappings] }] },
      ]),

    instanceUptime:
      commonlib.panels.generic.stat.base.new(
        'Uptime',
        targets=[signals.instance.uptime.asTarget()],
        description='The uptime of the MongoDB instance.'
      )
      + g.panel.stat.standardOptions.withUnit('s')
      + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
      + g.panel.stat.options.withGraphMode('none'),

    instanceQps:
      commonlib.panels.generic.stat.base.new(
        'QPS',
        targets=[signals.instance.qps.asTarget() + g.query.prometheus.withInterval('2m')],
        description='Queries per second.'
      )
      + g.panel.stat.standardOptions.withUnit('ops')
      + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
      + g.panel.stat.options.withGraphMode('none'),

    instanceReplicaSetState:
      commonlib.panels.generic.stat.base.new(
        'Replica set',
        targets=[signals.instance.replicaSetState.asTarget()],
        description='Current replica set state of the member (for example PRIMARY or SECONDARY). See https://www.mongodb.com/docs/manual/reference/replica-states/ for the meaning of each value.'
      )
      + g.panel.stat.standardOptions.withMappings([replicaSetStateMappings])
      + g.panel.stat.standardOptions.withDisplayName('${__field.labels.instance}')
      + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
      + g.panel.stat.options.withGraphMode('none'),

    instanceLatency:
      commonlib.panels.generic.stat.base.new(
        'Latency',
        targets=[signals.instance.commandLatency.asTarget() + g.query.prometheus.withInterval('2m')],
        description='Average command latency.'
      )
      + g.panel.stat.standardOptions.withUnit('µs')
      + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
      + g.panel.stat.options.withGraphMode('none'),

    instanceReplicaSetStateGauge:
      commonlib.panels.generic.stat.base.new(
        'Current replica set state',
        targets=[signals.instance.replicaSetState.asTarget()],
        description='Current state of the replica set member.'
      )
      + g.panel.stat.standardOptions.withMappings([replicaSetStateMappings])
      + g.panel.stat.standardOptions.withDisplayName('${__field.labels.instance}')
      + g.panel.stat.options.withGraphMode('none')
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.standardOptions.thresholds.withSteps([
        g.panel.stat.standardOptions.threshold.step.withColor('green')
        + g.panel.stat.standardOptions.threshold.step.withValue(null),
        g.panel.stat.standardOptions.threshold.step.withColor('green')
        + g.panel.stat.standardOptions.threshold.step.withValue(1),
        g.panel.stat.standardOptions.threshold.step.withColor('blue')
        + g.panel.stat.standardOptions.threshold.step.withValue(2),
        g.panel.stat.standardOptions.threshold.step.withColor('orange')
        + g.panel.stat.standardOptions.threshold.step.withValue(3),
        g.panel.stat.standardOptions.threshold.step.withColor('red')
        + g.panel.stat.standardOptions.threshold.step.withValue(8),
      ])
      + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull']),

    instanceCommandOps:
      commonlib.panels.generic.timeSeries.base.new(
        'Operations by type',
        targets=[
          signals.instance.opCountersTotal.asTarget() + g.query.prometheus.withInterval('2m'),
          signals.instance.opCountersReplTotal.asTarget() + g.query.prometheus.withInterval('2m'),
          signals.instance.ttlDeletedDocuments.asTarget() + g.query.prometheus.withInterval('2m'),
        ],
        description='Rate of operations by type.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('ops'),

    instanceConnections:
      commonlib.panels.generic.timeSeries.base.new(
        'Connections',
        targets=[signals.instance.connectionsCurrent.asTarget()],
        description='Number of current connections.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('short'),

    instanceDocumentOps:
      commonlib.panels.generic.timeSeries.base.new(
        'Document operations',
        targets=[signals.instance.documentOps.asTarget() + g.query.prometheus.withInterval('2m')],
        description='Rate of document operations by state.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('ops'),

    instanceLatencyDetail:
      commonlib.panels.generic.timeSeries.base.new(
        'Latency detail',
        targets=[signals.instance.latencyDetail.asTarget() + g.query.prometheus.withInterval('2m')],
        description='Average operation latency by type.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('µs'),

    instanceQueuedOps:
      commonlib.panels.generic.timeSeries.base.new(
        'Queued operations',
        targets=[signals.instance.queuedOps.asTarget()],
        description='Number of operations queued due to a lock.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('short'),

    instanceCursors:
      commonlib.panels.generic.timeSeries.base.new(
        'Cursors',
        targets=[signals.instance.cursorsOpen.asTarget()],
        description='Number of open cursors by state.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('short'),

    instanceScannedAndMoved:
      commonlib.panels.generic.timeSeries.base.new(
        'Scanned and moved objects',
        targets=[
          signals.instance.queryExecutor.asTarget() + g.query.prometheus.withInterval('2m'),
          signals.instance.recordMoves.asTarget() + g.query.prometheus.withInterval('2m'),
        ],
        description='Rate of scanned objects and record moves.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('ops'),

    instanceAsserts:
      commonlib.panels.generic.timeSeries.base.new(
        'Assert events',
        targets=[signals.instance.asserts.asTarget() + g.query.prometheus.withInterval('2m')],
        description='Rate of assert events by type.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('ops'),

    instanceGetLastErrorWriteOps:
      commonlib.panels.generic.timeSeries.base.new(
        'getLastError write operations',
        targets=[
          signals.instance.getLastErrorNum.asTarget() + g.query.prometheus.withInterval('2m'),
          signals.instance.getLastErrorTimeouts.asTarget() + g.query.prometheus.withInterval('2m'),
        ],
        description='Rate of getLastError write operations and timeouts.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('ops'),

    instanceQueryEfficiency:
      commonlib.panels.generic.timeSeries.base.new(
        'Query efficiency',
        targets=[
          signals.instance.queryEfficiencyDoc.asTarget() + g.query.prometheus.withInterval('2m'),
          signals.instance.queryEfficiencyIndex.asTarget() + g.query.prometheus.withInterval('2m'),
        ],
        description='Query efficiency ratios (higher is better). Documents: fraction of scanned objects that were returned; Index: fraction of scanned objects reached via an index. Low values point to collection scans or missing indexes.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('percentunit')
      + g.panel.timeSeries.standardOptions.withMin(0),

    instanceGetLastErrorWriteTime:
      commonlib.panels.generic.timeSeries.base.new(
        'getLastError write time',
        targets=[signals.instance.getLastErrorWriteTime.asTarget() + g.query.prometheus.withInterval('2m')],
        description='Rate of getLastError write wait time.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('ms'),

    instancePageFaults:
      commonlib.panels.generic.timeSeries.base.new(
        'Page faults',
        targets=[signals.instance.pageFaults.asTarget() + g.query.prometheus.withInterval('2m')],
        description='Rate of page faults.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('ops')
      + g.panel.timeSeries.standardOptions.withMin(0)
      + g.panel.timeSeries.fieldConfig.defaults.custom.withAxisSoftMax(1),
  },
}
