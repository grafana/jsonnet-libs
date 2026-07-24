local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

local timeSeries = g.panel.timeSeries;
local stat = g.panel.stat;
local table = g.panel.table;

local promDatasource = { uid: '${prometheus_datasource}' };

{
  new(this)::
    local signals = this.signals;
    local signalsCluster = this.signalsCluster;
    // extra selector for panels filterable by the collection/core variables
    local coreFilter = 'collection=~"$solr_collection", core=~"$solr_core"';

    {

      //
      // Resource monitoring dashboard
      //

      connections:
        signals.node.connections.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      threads:
        commonlib.panels.generic.timeSeries.base.new(
          'Threads / $__interval',
          targets=[
            signals.node.threadPoolSubmitted.asTarget() + { intervalFactor: 2 },
            signals.node.threadPoolCompleted.asTarget() + { intervalFactor: 2 },
          ],
          description='Total number of tasks submitted and completed in the thread pool.',
        )
        + timeSeries.standardOptions.withUnit('none'),

      nodeCoreFSUsage:
        signals.node.coreRootFsBytes.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      garbageCollections:
        signals.jvm.garbageCollections.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + timeSeries.queryOptions.withInterval('1m')
        + { targets: [super.targets[0] { intervalFactor: 2 }] },

      garbageCollectionTime:
        signals.jvm.garbageCollectionTime.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + timeSeries.queryOptions.withInterval('1m')
        + { targets: [super.targets[0] { intervalFactor: 2 }] },

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
        signals.jvm.fileDescriptors.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

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
        signals.jetty.requests.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + timeSeries.queryOptions.withInterval('1m')
        + { targets: [super.targets[0] { intervalFactor: 2 }] },

      responses:
        signals.jetty.responses.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + timeSeries.queryOptions.withInterval('1m')
        + { targets: [super.targets[0] { intervalFactor: 2 }] },

      dispatches:
        signals.jetty.dispatches.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + timeSeries.queryOptions.withInterval('1m')
        + { targets: [super.targets[0] { intervalFactor: 2 }] },

      //
      // Query performance dashboard
      //

      updateHandlers:
        commonlib.panels.generic.timeSeries.base.new(
          'Update handlers / $__interval',
          targets=[signals.query.updateHandlerAdds.withFilteringSelectorMixin(coreFilter).asTarget() + { interval: '1m', intervalFactor: 2 }],
          description='Counts the increase in document additions over the specified interval.',
        )
        + timeSeries.standardOptions.withUnit('none'),

      coreSearchAndRetrievalQueryLoad:
        signals.query.queryLoad5min.withFilteringSelectorMixin(coreFilter).asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      coreSearchAndRetrieval95pQueryLatency:
        signals.query.queryP95.withFilteringSelectorMixin(coreFilter).asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      coreSearchAndRetrieval99pQueryLatency:
        signals.query.queryP99.withFilteringSelectorMixin(coreFilter).asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      coreSearchAndRetrievalLocalQueryLoad:
        signals.query.queryLocalLoad5min.withFilteringSelectorMixin(coreFilter).asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      coreSearchAndRetrievalLocal95pQueryLatency:
        signals.query.queryLocalP95.withFilteringSelectorMixin(coreFilter).asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      coreSearchAndRetrievalLocal99pQueryLatency:
        signals.query.queryLocalP99.withFilteringSelectorMixin(coreFilter).asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      specializedQueryLoad:
        signals.query.specializedQueryLoad5min.withFilteringSelectorMixin(coreFilter).asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      specialized95pQueryLatency:
        signals.query.specializedQueryP95.withFilteringSelectorMixin(coreFilter).asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      specialized99pQueryLatency:
        signals.query.specializedQueryP99.withFilteringSelectorMixin(coreFilter).asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      specializedLocalQueryLoad:
        signals.query.specializedLocalLoad5min.withFilteringSelectorMixin(coreFilter).asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      specializedLocal95pQueryLatency:
        signals.query.specializedLocalP95.withFilteringSelectorMixin(coreFilter).asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      specializedLocal99pQueryLatency:
        signals.query.specializedLocalP99.withFilteringSelectorMixin(coreFilter).asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      cacheEvictions:
        signals.query.cacheEvictions.withFilteringSelectorMixin(coreFilter).asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + timeSeries.queryOptions.withInterval('1m')
        + { targets: [super.targets[0] { intervalFactor: 2 }] },

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
        signals.query.coreTimeouts.withFilteringSelectorMixin(coreFilter).asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + timeSeries.queryOptions.withInterval('1m')
        + { targets: [super.targets[0] { intervalFactor: 2 }] },

      nodeTimeouts:
        signals.query.nodeTimeouts.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + timeSeries.queryOptions.withInterval('1m')
        + { targets: [super.targets[0] { intervalFactor: 2 }] },

      queryErrorRate:
        signals.query.queryErrorRate.withFilteringSelectorMixin(coreFilter).asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      queryClientErrors:
        signals.query.queryClientErrors.withFilteringSelectorMixin(coreFilter).asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      //
      // Cluster overview dashboard
      //

      liveNodes:
        signalsCluster.cluster.liveNodes.asStat()
        + commonlib.panels.generic.stat.base.stylize()
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
        signalsCluster.cluster.shardState.asStat()
        + commonlib.panels.generic.stat.base.stylize()
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
        signalsCluster.cluster.replicaState.asStat()
        + commonlib.panels.generic.stat.base.stylize()
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
        signalsCluster.cluster.zookeeperEnsembleSize.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

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
        signalsCluster.jvm.heapMemoryUsage.withTopK('$k').asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + timeSeries.standardOptions.withMin(0)
        + timeSeries.standardOptions.withMax(100)
        + timeSeries.standardOptions.color.withMode('continuous-BlYlRd')
        + timeSeries.standardOptions.thresholds.withSteps([
          { color: 'blue' },
          { color: 'yellow', value: 90 },
          { color: 'red', value: 80 },
        ]),

      topMeanQueriesByNode:
        signalsCluster.query.queryMeanRate.withFilteringSelectorMixin(coreFilter).withTopK('$k').asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      topUpdateHandlersByNode:
        commonlib.panels.generic.timeSeries.base.new(
          'Top cores by update handlers / $__interval',
          targets=[signalsCluster.query.updateHandlerAdds.withFilteringSelectorMixin(coreFilter).withTopK('$k').asTarget() + { interval: '1m', intervalFactor: 2 }],
          description='Top cores by the number of total document additions in the cluster.',
        )
        + timeSeries.standardOptions.withUnit('documents'),

      topIndexSizeByNode:
        signalsCluster.node.indexSize.withFilteringSelectorMixin(coreFilter).withTopK('$k').asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

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
        signalsCluster.node.coreErrors.withFilteringSelectorMixin(coreFilter).withTopK('$k').asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + timeSeries.queryOptions.withInterval('1m')
        + { targets: [super.targets[0] { intervalFactor: 2 }] },

      topNodeErrors:
        signalsCluster.node.nodeErrors.withTopK('$k').asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + timeSeries.queryOptions.withInterval('1m')
        + { targets: [super.targets[0] { intervalFactor: 2 }] },

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
