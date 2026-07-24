local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

local timeSeries = g.panel.timeSeries;
local stat = g.panel.stat;
local table = g.panel.table;

local promDatasource = { uid: '${prometheus_datasource}' };

{
  new(this):: {
    local signals = this.signals,
    local signalsCluster = this.signalsCluster,
    // extra selector for panels filterable by the collection/core variables
    local coreFilter = 'collection=~"$solr_collection", core=~"$solr_core"',

    //
    // Resource monitoring dashboard
    //

    connections:
      commonlib.panels.generic.timeSeries.base.new(
        'Connections',
        targets=[signals.node.connections.asTarget()],
        description='Number of connections to the Solr node.',
      )
      + timeSeries.standardOptions.withUnit('none'),

    threads:
      commonlib.panels.generic.timeSeries.base.new(
        'Threads / $__interval',
        targets=[
          signals.node.threadPoolSubmitted.asTarget(),
          signals.node.threadPoolCompleted.asTarget(),
        ],
        description='Total number of tasks submitted and completed in the thread pool.',
      )
      + timeSeries.standardOptions.withUnit('none'),

    nodeCoreFSUsage:
      commonlib.panels.generic.timeSeries.base.new(
        'Node core FS usage',
        targets=[signals.node.coreRootFsBytes.asTarget()],
        description="Disk space used by Solr node's root file system.",
      )
      + timeSeries.standardOptions.withUnit('bytes'),

    garbageCollections:
      commonlib.panels.generic.timeSeries.base.new(
        'Garbage collections / $__interval',
        targets=[signals.jvm.garbageCollections.asTarget() + { interval: '1m' }],
        description='Counts the total number of garbage collection events.',
      )
      + timeSeries.standardOptions.withUnit('none'),

    garbageCollectionTime:
      commonlib.panels.generic.timeSeries.base.new(
        'Garbage collection time / $__interval',
        targets=[signals.jvm.garbageCollectionTime.asTarget() + { interval: '1m' }],
        description='Total time spent in garbage collection.',
      )
      + timeSeries.standardOptions.withUnit('s'),

    cpuAverageLoad:
      commonlib.panels.generic.timeSeries.base.new(
        'CPU load',
        targets=[signals.jvm.cpuLoad.asTarget()],
        description='CPU load caused by the JVM.',
      )
      + timeSeries.standardOptions.withUnit('percent')
      + timeSeries.standardOptions.withMin(0)
      + timeSeries.standardOptions.withMax(100)
      + timeSeries.standardOptions.color.withMode('continuous-BlYlRd')
      + timeSeries.standardOptions.thresholds.withSteps([
        { color: 'green' },
        { color: 'yellow', value: 90 },
        { color: 'red', value: 80 },
      ]),

    osMemory:
      commonlib.panels.generic.timeSeries.base.new(
        'OS memory',
        targets=[
          signals.jvm.osMemoryFree.asTarget(),
          signals.jvm.osMemoryTotal.asTarget(),
          signals.jvm.osMemoryVirtual.asTarget(),
        ],
        description="The operating system's virtual committed memory, free physical memory and total physical memory usage.",
      )
      + timeSeries.standardOptions.withUnit('bytes')
      + timeSeries.standardOptions.color.withMode('continuous-BlYlRd'),

    numberOfFileDescriptors:
      commonlib.panels.generic.timeSeries.base.new(
        'File descriptors',
        targets=[signals.jvm.fileDescriptors.asTarget()],
        description='Number of open file descriptors.',
      )
      + timeSeries.standardOptions.withUnit('none'),

    memoryUsed:
      commonlib.panels.generic.timeSeries.base.new(
        'Memory used',
        targets=[
          signals.jvm.memoryHeapUsed.asTarget(),
          signals.jvm.memoryNonHeapUsed.asTarget(),
        ],
        description='The heap and non-heap memory used by the JVM.',
      )
      + timeSeries.standardOptions.withUnit('bytes')
      + timeSeries.standardOptions.color.withMode('continuous-BlYlRd'),

    memoryCommitted:
      commonlib.panels.generic.timeSeries.base.new(
        'Memory committed',
        targets=[
          signals.jvm.memoryHeapCommitted.asTarget(),
          signals.jvm.memoryNonHeapCommitted.asTarget(),
        ],
        description='The heap and non-heap memory committed by the JVM.',
      )
      + timeSeries.standardOptions.withUnit('bytes')
      + timeSeries.standardOptions.color.withMode('continuous-BlYlRd'),

    requests:
      commonlib.panels.generic.timeSeries.base.new(
        'Requests  / $__interval',
        targets=[signals.jetty.requests.asTarget() + { interval: '1m' }],
        description='Total number of requests received by Jetty.',
      )
      + timeSeries.standardOptions.withUnit('none'),

    responses:
      commonlib.panels.generic.timeSeries.base.new(
        'Responses  / $__interval',
        targets=[signals.jetty.responses.asTarget() + { interval: '1m' }],
        description='Total number of responses generated by Jetty.',
      )
      + timeSeries.standardOptions.withUnit('none'),

    dispatches:
      commonlib.panels.generic.timeSeries.base.new(
        'Dispatches  / $__interval',
        targets=[signals.jetty.dispatches.asTarget() + { interval: '1m' }],
        description='Total count of dispatches handled by Jetty.',
      )
      + timeSeries.standardOptions.withUnit('none'),

    //
    // Query performance dashboard
    //

    updateHandlers:
      commonlib.panels.generic.timeSeries.base.new(
        'Update handlers / $__interval',
        targets=[signals.query.updateHandlerAdds.withFilteringSelectorMixin(coreFilter).asTarget() + { interval: '1m' }],
        description='Counts the increase in document additions over the specified interval.',
      )
      + timeSeries.standardOptions.withUnit('none'),

    coreSearchAndRetrievalQueryLoad:
      commonlib.panels.generic.timeSeries.base.new(
        'Core search and retrieval query load',
        targets=[signals.query.queryLoad5min.withFilteringSelectorMixin(coreFilter).asTarget()],
        description='Measures the average rate of queries per second over a 5-minute period for core search and retrieval operations.',
      )
      + timeSeries.standardOptions.withUnit('reqps'),

    coreSearchAndRetrieval95pQueryLatency:
      commonlib.panels.generic.timeSeries.base.new(
        'Core search and retrieval 95p query latency',
        targets=[signals.query.queryP95.withFilteringSelectorMixin(coreFilter).asTarget()],
        description='Represents the 95th percentile latency for core search and retrieval queries.',
      )
      + timeSeries.standardOptions.withUnit('ms'),

    coreSearchAndRetrieval99pQueryLatency:
      commonlib.panels.generic.timeSeries.base.new(
        'Core search and retrieval 99p query latency',
        targets=[signals.query.queryP99.withFilteringSelectorMixin(coreFilter).asTarget()],
        description='Represents the 99th percentile latency for core search and retrieval queries, measured in milliseconds.',
      )
      + timeSeries.standardOptions.withUnit('ms'),

    coreSearchAndRetrievalLocalQueryLoad:
      commonlib.panels.generic.timeSeries.base.new(
        'Core search and retrieval local query load',
        targets=[signals.query.queryLocalLoad5min.withFilteringSelectorMixin(coreFilter).asTarget()],
        description='Indicates the average rate of local queries per second over a 5-minute period for core search and retrieval operations.',
      )
      + timeSeries.standardOptions.withUnit('reqps'),

    coreSearchAndRetrievalLocal95pQueryLatency:
      commonlib.panels.generic.timeSeries.base.new(
        'Core search and retrieval local p95 query latency',
        targets=[signals.query.queryLocalP95.withFilteringSelectorMixin(coreFilter).asTarget()],
        description='Represents the 95th percentile latency for local core search and retrieval queries.',
      )
      + timeSeries.standardOptions.withUnit('ms'),

    coreSearchAndRetrievalLocal99pQueryLatency:
      commonlib.panels.generic.timeSeries.base.new(
        'Core search and retrieval 99p local query latency',
        targets=[signals.query.queryLocalP99.withFilteringSelectorMixin(coreFilter).asTarget()],
        description='Represents the 99th percentile latency for local core search and retrieval queries.',
      )
      + timeSeries.standardOptions.withUnit('ms'),

    specializedQueryLoad:
      commonlib.panels.generic.timeSeries.base.new(
        'Specialized query load',
        targets=[signals.query.specializedQueryLoad5min.withFilteringSelectorMixin(coreFilter).asTarget()],
        description='Measures the average rate of specialized queries per second over a 5-minute period.',
      )
      + timeSeries.standardOptions.withUnit('reqps'),

    specialized95pQueryLatency:
      commonlib.panels.generic.timeSeries.base.new(
        'Specialized 95p query latency',
        targets=[signals.query.specializedQueryP95.withFilteringSelectorMixin(coreFilter).asTarget()],
        description='Displays the 993ith percentile latency for specialized query types.',
      )
      + timeSeries.standardOptions.withUnit('ms'),

    specialized99pQueryLatency:
      commonlib.panels.generic.timeSeries.base.new(
        'Specialized 99p query latency',
        targets=[signals.query.specializedQueryP99.withFilteringSelectorMixin(coreFilter).asTarget()],
        description='Displays the 99th percentile latency for specialized query types.',
      )
      + timeSeries.standardOptions.withUnit('ms'),

    specializedLocalQueryLoad:
      commonlib.panels.generic.timeSeries.base.new(
        'Specialized local query load',
        targets=[signals.query.specializedLocalLoad5min.withFilteringSelectorMixin(coreFilter).asTarget()],
        description='Indicates the average rate of local specialized queries per second over a 5-minute period.',
      )
      + timeSeries.standardOptions.withUnit('reqps'),

    specializedLocal95pQueryLatency:
      commonlib.panels.generic.timeSeries.base.new(
        'Specialized local 95p query latency',
        targets=[signals.query.specializedLocalP95.withFilteringSelectorMixin(coreFilter).asTarget()],
        description='Shows the 95th percentile latency for specialized local queries.',
      )
      + timeSeries.standardOptions.withUnit('ms'),

    specializedLocal99pQueryLatency:
      commonlib.panels.generic.timeSeries.base.new(
        'Specialized local 99p query latency',
        targets=[signals.query.specializedLocalP99.withFilteringSelectorMixin(coreFilter).asTarget()],
        description='Shows the 99th percentile latency for specialized local queries.',
      )
      + timeSeries.standardOptions.withUnit('ms'),

    cacheEvictions:
      commonlib.panels.generic.timeSeries.base.new(
        'Cache evictions / $__interval',
        targets=[signals.query.cacheEvictions.withFilteringSelectorMixin(coreFilter).asTarget() + { interval: '1m' }],
        description='Tracks the number of cache evictions.',
      )
      + timeSeries.standardOptions.withUnit('none'),

    cacheHitRatio:
      commonlib.panels.generic.timeSeries.base.new(
        'Cache hit ratio',
        targets=[signals.query.cacheHitRatio.withFilteringSelectorMixin(coreFilter).asTarget()],
        description='The cache hit ratio for various cache activities.',
      )
      + timeSeries.standardOptions.withUnit('percent')
      + timeSeries.standardOptions.withMin(0)
      + timeSeries.standardOptions.withMax(100)
      + timeSeries.standardOptions.thresholds.withSteps([
        { color: 'green' },
        { color: 'red', value: 80 },
      ]),

    coreTimeouts:
      commonlib.panels.generic.timeSeries.base.new(
        'Core timeouts / $__interval',
        targets=[signals.query.coreTimeouts.withFilteringSelectorMixin(coreFilter).asTarget() + { interval: '1m' }],
        description='Tracks the increase in the number of query timeouts over the specified time interval.',
      )
      + timeSeries.standardOptions.withUnit('none'),

    nodeTimeouts:
      commonlib.panels.generic.timeSeries.base.new(
        'Node timeouts / $__interval',
        targets=[signals.query.nodeTimeouts.asTarget() + { interval: '1m' }],
        description='Tracks the increase in node-level query timeouts over the specified interval.',
      )
      + timeSeries.standardOptions.withUnit('none'),

    queryErrorRate:
      commonlib.panels.generic.timeSeries.base.new(
        'Query error rate',
        targets=[signals.query.queryErrorRate.withFilteringSelectorMixin(coreFilter).asTarget()],
        description='Measures the rate of query errors over a 1-minute period.',
      )
      + timeSeries.standardOptions.withUnit('errors / min'),

    queryClientErrors:
      commonlib.panels.generic.timeSeries.base.new(
        'Query client errors',
        targets=[signals.query.queryClientErrors.withFilteringSelectorMixin(coreFilter).asTarget()],
        description='This metric represents the rate of client errors over a 1-minute period.',
      )
      + timeSeries.standardOptions.withUnit('errors / min'),

    //
    // Cluster overview dashboard
    //

    liveNodes:
      commonlib.panels.generic.stat.base.new(
        'Live nodes',
        targets=[signalsCluster.cluster.liveNodes.asTarget()],
        description='Number of live nodes in the Solr cluster.',
      )
      + stat.standardOptions.withUnit('none')
      + stat.standardOptions.withMin(0)
      + stat.standardOptions.color.withMode('thresholds')
      + stat.standardOptions.thresholds.withSteps([
        { color: 'red', value: null },
        { color: 'green', value: 1 },
      ])
      + stat.options.withColorMode('value')
      + stat.options.withGraphMode('none')
      + stat.options.withTextMode('value'),

    shardState:
      commonlib.panels.generic.stat.base.new(
        'Running shards',
        targets=[signalsCluster.cluster.shardState.asTarget()],
        description='Percent of running shards in the cluster.',
      )
      + stat.standardOptions.withUnit('percent')
      + stat.standardOptions.withMin(0)
      + stat.standardOptions.withMax(100)
      + stat.standardOptions.color.withMode('thresholds')
      + stat.standardOptions.thresholds.withSteps([
        { color: 'red', value: null },
        { color: 'yellow', value: 80 },
        { color: 'green', value: 95 },
      ])
      + stat.options.withColorMode('value')
      + stat.options.withGraphMode('none')
      + stat.options.withTextMode('value'),

    replicaState:
      commonlib.panels.generic.stat.base.new(
        'Running replicas',
        targets=[signalsCluster.cluster.replicaState.asTarget()],
        description='Shows the total percent of running shards in the cluster.',
      )
      + stat.standardOptions.withUnit('percent')
      + stat.standardOptions.withMin(0)
      + stat.standardOptions.withMax(100)
      + stat.standardOptions.color.withMode('thresholds')
      + stat.standardOptions.thresholds.withSteps([
        { color: 'red', value: null },
        { color: 'yellow', value: 80 },
        { color: 'green', value: 95 },
      ])
      + stat.options.withColorMode('value')
      + stat.options.withGraphMode('none')
      + stat.options.withTextMode('value'),

    zookeeperEnsembleSize:
      commonlib.panels.generic.timeSeries.base.new(
        'Zookeeper ensemble size',
        targets=[signalsCluster.cluster.zookeeperEnsembleSize.asTarget()],
        description='Size of the ZooKeeper ensemble.',
      )
      + timeSeries.standardOptions.withUnit('none'),

    topCPULoadByNode:
      commonlib.panels.generic.timeSeries.base.new(
        'Top nodes by CPU load',
        targets=[signalsCluster.jvm.cpuLoad.withTopK('$k').asTarget()],
        description='Top nodes by CPU load caused by the JVM.',
      )
      + timeSeries.standardOptions.withUnit('percent')
      + timeSeries.standardOptions.withMin(0)
      + timeSeries.standardOptions.withMax(100)
      + timeSeries.standardOptions.color.withMode('continuous-BlYlRd')
      + timeSeries.standardOptions.thresholds.withSteps([
        { color: 'blue' },
        { color: 'yellow', value: 90 },
        { color: 'red', value: 80 },
      ]),

    topHeapMemoryUsageByNode:
      commonlib.panels.generic.timeSeries.base.new(
        'Top nodes by heap memory usage',
        targets=[signalsCluster.jvm.heapMemoryUsage.withTopK('$k').asTarget()],
        description='Top nodes by the JVM heap memory usage.',
      )
      + timeSeries.standardOptions.withUnit('percent')
      + timeSeries.standardOptions.withMin(0)
      + timeSeries.standardOptions.withMax(100)
      + timeSeries.standardOptions.color.withMode('continuous-BlYlRd')
      + timeSeries.standardOptions.thresholds.withSteps([
        { color: 'blue' },
        { color: 'yellow', value: 90 },
        { color: 'red', value: 80 },
      ]),

    topMeanQueriesByNode:
      commonlib.panels.generic.timeSeries.base.new(
        'Top cores by mean queries',
        targets=[signalsCluster.query.queryMeanRate.withFilteringSelectorMixin(coreFilter).withTopK('$k').asTarget()],
        description='Top cores by the average rate of query processing in the cluster.',
      )
      + timeSeries.standardOptions.withUnit('reqps'),

    topUpdateHandlersByNode:
      commonlib.panels.generic.timeSeries.base.new(
        'Top cores by update handlers / $__interval',
        targets=[signalsCluster.query.updateHandlerAdds.withFilteringSelectorMixin(coreFilter).withTopK('$k').asTarget() + { interval: '1m' }],
        description='Top cores by the number of total document additions in the cluster.',
      )
      + timeSeries.standardOptions.withUnit('documents'),

    topIndexSizeByNode:
      commonlib.panels.generic.timeSeries.base.new(
        'Top cores by index size',
        targets=[signalsCluster.node.indexSize.withFilteringSelectorMixin(coreFilter).withTopK('$k').asTarget()],
        description='Top cores by the Solr index size.',
      )
      + timeSeries.standardOptions.withUnit('bytes'),

    topCacheHitRatioByNode:
      commonlib.panels.generic.timeSeries.base.new(
        'Top cores by cache hit ratio',
        targets=[signalsCluster.query.cacheHitRatio.withFilteringSelectorMixin(coreFilter).withExprWrappersMixin(['bottomk($k,', ')']).asTarget()],
        description='Top cores by the cache hit ratio in Solr searchers.',
      )
      + timeSeries.standardOptions.withUnit('percent')
      + timeSeries.standardOptions.withMin(0)
      + timeSeries.standardOptions.withMax(100)
      + timeSeries.standardOptions.thresholds.withSteps([
        { color: 'green' },
        { color: 'yellow', value: 90 },
        { color: 'red', value: 80 },
      ]),

    topCoreErrorsByNode:
      commonlib.panels.generic.timeSeries.base.new(
        'Top cores by core errors / $__interval',
        targets=[signalsCluster.node.coreErrors.withFilteringSelectorMixin(coreFilter).withTopK('$k').asTarget() + { interval: '1m' }],
        description='Top cores by Solr core errors.',
      )
      + timeSeries.standardOptions.withUnit('none'),

    topNodeErrors:
      commonlib.panels.generic.timeSeries.base.new(
        'Top nodes by node errors / $__interval',
        targets=[signalsCluster.node.nodeErrors.withTopK('$k').asTarget() + { interval: '1m' }],
        description='Top nodes by Solr node errors.',
      )
      + timeSeries.standardOptions.withUnit('none'),

    alerts:
      {
        datasource: promDatasource,
        targets: [
          {
            datasource: promDatasource,
            expr: '',
            format: 'time_series',
            intervalFactor: 2,
            legendFormat: '',
          },
        ],
        type: 'alertlist',
        title: 'Alerts',
        description: 'Panel to report on the status of firing alerts.',
        options: {
          alertInstanceLabelFilter: '{%(solrSelector)s, solr_cluster=~"$solr_cluster"}' % this.config,
          alertName: '',
          dashboardAlerts: false,
          groupBy: [],
          groupMode: 'default',
          maxItems: 20,
          sortOrder: 1,
          stateFilter: {
            'error': true,
            firing: true,
            noData: false,
            normal: false,
            pending: true,
          },
          viewMode: 'list',
        },
      },

    zookeeperStatus:
      {
        datasource: promDatasource,
        targets: [
          signalsCluster.cluster.zookeeperStatus.asTableTarget(),
        ],
        type: 'table',
        title: 'Zookeeper status',
        description: 'Status of ZooKeeper, integral for cluster coordination.',
        fieldConfig: {
          defaults: {
            color: {
              mode: 'fixed',
            },
            custom: {
              align: 'left',
              cellOptions: {
                type: 'color-text',
              },
              inspect: false,
            },
            mappings: [
              {
                options: {
                  '0': {
                    color: 'red',
                    index: 1,
                    text: 'Unavailable',
                  },
                  '1': {
                    color: 'green',
                    index: 0,
                    text: 'Available',
                  },
                },
                type: 'value',
              },
            ],
            thresholds: {
              mode: 'absolute',
              steps: [
                {
                  color: 'green',
                  value: null,
                },
              ],
            },
            unit: 'none',
          },
          overrides: [
            {
              matcher: {
                id: 'byName',
                options: 'Time',
              },
              properties: [
                {
                  id: 'custom.hidden',
                  value: true,
                },
              ],
            },
            {
              matcher: {
                id: 'byName',
                options: 'job',
              },
              properties: [
                {
                  id: 'custom.hidden',
                  value: true,
                },
              ],
            },
            {
              matcher: {
                id: 'byName',
                options: '__name__',
              },
              properties: [
                {
                  id: 'custom.hidden',
                  value: true,
                },
              ],
            },
            {
              matcher: {
                id: 'byName',
                options: 'status',
              },
              properties: [
                {
                  id: 'custom.hidden',
                  value: true,
                },
              ],
            },
            {
              matcher: {
                id: 'byName',
                options: 'solr_cluster',
              },
              properties: [
                {
                  id: 'displayName',
                  value: 'Solr cluster',
                },
              ],
            },
            {
              matcher: {
                id: 'byName',
                options: 'zk_host',
              },
              properties: [
                {
                  id: 'displayName',
                  value: 'Zookeeper host',
                },
              ],
            },
            {
              matcher: {
                id: 'byName',
                options: 'Value',
              },
              properties: [
                {
                  id: 'displayName',
                  value: 'Status',
                },
              ],
            },
          ],
        },
        options: {
          cellHeight: 'sm',
          footer: {
            countRows: false,
            fields: [],
            reducer: [
              'sum',
            ],
            show: false,
          },
          showHeader: true,
        },
        pluginVersion: '9.4.3',
      },

    shardStatus:
      {
        datasource: promDatasource,
        targets: [
          signalsCluster.cluster.shardStateTable.asTableTarget(),
        ],
        type: 'table',
        title: 'Shard status',
        description: 'Shows the state of various shards in the cluster.',
        fieldConfig: {
          defaults: {
            color: {
              mode: 'fixed',
            },
            custom: {
              align: 'left',
              cellOptions: {
                type: 'color-text',
              },
              inspect: false,
            },
            mappings: [
              {
                options: {
                  '0': {
                    color: 'red',
                    index: 1,
                    text: 'Unavailable',
                  },
                  '1': {
                    color: 'green',
                    index: 0,
                    text: 'Available',
                  },
                },
                type: 'value',
              },
            ],
            thresholds: {
              mode: 'absolute',
              steps: [
                {
                  color: 'green',
                  value: null,
                },
              ],
            },
            unit: 'none',
          },
          overrides: [
            {
              matcher: {
                id: 'byName',
                options: 'Time',
              },
              properties: [
                {
                  id: 'custom.hidden',
                  value: true,
                },
              ],
            },
            {
              matcher: {
                id: 'byName',
                options: 'job',
              },
              properties: [
                {
                  id: 'custom.hidden',
                  value: true,
                },
              ],
            },
            {
              matcher: {
                id: 'byName',
                options: '__name__',
              },
              properties: [
                {
                  id: 'custom.hidden',
                  value: true,
                },
              ],
            },
            {
              matcher: {
                id: 'byName',
                options: 'solr_cluster',
              },
              properties: [
                {
                  id: 'custom.hidden',
                  value: true,
                },
              ],
            },
            {
              matcher: {
                id: 'byName',
                options: 'zk_host',
              },
              properties: [
                {
                  id: 'custom.hidden',
                  value: true,
                },
              ],
            },
            {
              matcher: {
                id: 'byName',
                options: 'Value',
              },
              properties: [
                {
                  id: 'displayName',
                  value: 'Status',
                },
              ],
            },
            {
              matcher: {
                id: 'byName',
                options: 'instance',
              },
              properties: [
                {
                  id: 'displayName',
                  value: 'Instance',
                },
              ],
            },
            {
              matcher: {
                id: 'byName',
                options: 'shard',
              },
              properties: [
                {
                  id: 'displayName',
                  value: 'Shard',
                },
              ],
            },
            {
              matcher: {
                id: 'byName',
                options: 'collection',
              },
              properties: [
                {
                  id: 'displayName',
                  value: 'Collection',
                },
              ],
            },
          ],
        },
        options: {
          cellHeight: 'sm',
          footer: {
            countRows: false,
            fields: [],
            reducer: [
              'sum',
            ],
            show: false,
          },
          showHeader: true,
        },
        pluginVersion: '9.4.3',
      },

    replicaStatus:
      {
        datasource: promDatasource,
        targets: [
          signalsCluster.cluster.replicaStateTable.asTableTarget(),
        ],
        type: 'table',
        title: 'Replica status',
        description: 'State of replicas within a Solr collection.',
        fieldConfig: {
          defaults: {
            color: {
              mode: 'fixed',
            },
            custom: {
              align: 'left',
              cellOptions: {
                type: 'color-text',
              },
              inspect: false,
            },
            mappings: [
              {
                options: {
                  '0': {
                    color: 'red',
                    index: 1,
                    text: 'Unavailable',
                  },
                  '1': {
                    color: 'green',
                    index: 0,
                    text: 'Available',
                  },
                },
                type: 'value',
              },
            ],
            thresholds: {
              mode: 'absolute',
              steps: [
                {
                  color: 'green',
                  value: null,
                },
              ],
            },
            unit: 'none',
          },
          overrides: [
            {
              matcher: {
                id: 'byName',
                options: 'Time',
              },
              properties: [
                {
                  id: 'custom.hidden',
                  value: true,
                },
              ],
            },
            {
              matcher: {
                id: 'byName',
                options: 'job',
              },
              properties: [
                {
                  id: 'custom.hidden',
                  value: true,
                },
              ],
            },
            {
              matcher: {
                id: 'byName',
                options: '__name__',
              },
              properties: [
                {
                  id: 'custom.hidden',
                  value: true,
                },
              ],
            },
            {
              matcher: {
                id: 'byName',
                options: 'solr_cluster',
              },
              properties: [
                {
                  id: 'custom.hidden',
                  value: true,
                },
              ],
            },
            {
              matcher: {
                id: 'byName',
                options: 'collection',
              },
              properties: [
                {
                  id: 'custom.hidden',
                  value: true,
                },
              ],
            },
            {
              matcher: {
                id: 'byName',
                options: 'shard',
              },
              properties: [
                {
                  id: 'custom.hidden',
                  value: true,
                },
              ],
            },
            {
              matcher: {
                id: 'byName',
                options: 'replica',
              },
              properties: [
                {
                  id: 'custom.hidden',
                  value: true,
                },
              ],
            },
            {
              matcher: {
                id: 'byName',
                options: 'base_url',
              },
              properties: [
                {
                  id: 'custom.hidden',
                  value: true,
                },
              ],
            },
            {
              matcher: {
                id: 'byName',
                options: 'node_name',
              },
              properties: [
                {
                  id: 'custom.hidden',
                  value: true,
                },
              ],
            },
            {
              matcher: {
                id: 'byName',
                options: 'type',
              },
              properties: [
                {
                  id: 'custom.hidden',
                  value: true,
                },
              ],
            },
            {
              matcher: {
                id: 'byName',
                options: 'state',
              },
              properties: [
                {
                  id: 'custom.hidden',
                  value: true,
                },
              ],
            },
            {
              matcher: {
                id: 'byName',
                options: 'zk_host',
              },
              properties: [
                {
                  id: 'custom.hidden',
                  value: true,
                },
              ],
            },
            {
              matcher: {
                id: 'byName',
                options: 'Value',
              },
              properties: [
                {
                  id: 'displayName',
                  value: 'Status',
                },
              ],
            },
            {
              matcher: {
                id: 'byName',
                options: 'core',
              },
              properties: [
                {
                  id: 'displayName',
                  value: 'Core',
                },
              ],
            },
            {
              matcher: {
                id: 'byName',
                options: 'instance',
              },
              properties: [
                {
                  id: 'displayName',
                  value: 'Instance',
                },
              ],
            },
            {
              matcher: {
                id: 'byName',
                options: 'replica_name',
              },
              properties: [
                {
                  id: 'displayName',
                  value: 'Replica name',
                },
              ],
            },
          ],
        },
        options: {
          cellHeight: 'sm',
          footer: {
            countRows: false,
            fields: [],
            reducer: [
              'sum',
            ],
            show: false,
          },
          showHeader: true,
        },
        pluginVersion: '9.4.3',
      },
  },
}
