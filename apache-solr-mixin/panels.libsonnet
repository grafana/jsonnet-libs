local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

local promDatasource = { uid: '${prometheus_datasource}' };

// The three cluster-state tables all render a single 0/1 availability metric
// alongside its label columns, so they share mappings, cell styling and the
// column show/hide/rename machinery.
local availabilityMappings = [
  g.panel.table.standardOptions.mapping.ValueMap.withType()
  + g.panel.table.standardOptions.mapping.ValueMap.withOptions({
    '0': { color: 'red', index: 1, text: 'Unavailable' },
    '1': { color: 'green', index: 0, text: 'Available' },
  }),
];

// Column show/hide/rename: common-lib has no field-override helper, so these
// use grafonnet's fieldOverride builder directly.
local hiddenColumns(names) = [
  g.panel.table.fieldOverride.byName.new(name)
  + g.panel.table.fieldOverride.byName.withProperty('custom.hidden', true)
  for name in names
];

local renamedColumns(names) = [
  g.panel.table.fieldOverride.byName.new(name)
  + g.panel.table.fieldOverride.byName.withProperty('displayName', names[name])
  for name in std.objectFields(names)
];

local availabilityTable(title, target, description, hidden, renamed) =
  commonlib.panels.generic.table.base.new(title, targets=[target], description=description)
  // Unit and the color/cell/align styling are not part of the table base: the
  // value column is a mapped 0/1 status, so it must render as plain colored
  // text rather than the base's numeric formatting.
  + g.panel.table.standardOptions.withUnit('none')
  + g.panel.table.standardOptions.color.withMode('fixed')
  + g.panel.table.standardOptions.color.withFixedColor('text')
  + g.panel.table.standardOptions.withMappings(availabilityMappings)
  + g.panel.table.fieldConfig.defaults.custom.withAlign('left')
  + g.panel.table.fieldConfig.defaults.custom.cellOptions.TableColorTextCellOptions.withType()
  + g.panel.table.standardOptions.withOverrides(hiddenColumns(hidden) + renamedColumns(renamed));

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
        // Two signals share this panel, so the unit lives here rather than
        // coming from a single signal definition.
        + g.panel.timeSeries.standardOptions.withUnit('short'),

      nodeCoreFSUsage:
        signals.node.coreRootFsBytes.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      garbageCollections:
        signals.jvm.garbageCollections.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.queryOptions.withInterval('1m')
        + { targets: [super.targets[0] { intervalFactor: 2 }] },

      garbageCollectionTime:
        signals.jvm.garbageCollectionTime.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.queryOptions.withInterval('1m')
        + { targets: [super.targets[0] { intervalFactor: 2 }] },

      cpuAverageLoad:
        commonlib.panels.generic.timeSeries.base.new(
          'CPU load',
          targets=[signals.jvm.cpuLoad.asTarget()],
          description='CPU load caused by the JVM.',
        )
        // Not .percentage: its stylize() adds decimals=1 and gradientMode='scheme'
        // and would fight the explicit threshold steps below.
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withMax(100)
        + g.panel.timeSeries.standardOptions.color.withMode('continuous-BlYlRd')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
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
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.standardOptions.color.withMode('continuous-BlYlRd'),

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
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.standardOptions.color.withMode('continuous-BlYlRd'),

      memoryCommitted:
        commonlib.panels.generic.timeSeries.base.new(
          'Memory committed',
          targets=[
            signals.jvm.memoryHeapCommitted.asTarget(),
            signals.jvm.memoryNonHeapCommitted.asTarget(),
          ],
          description='The heap and non-heap memory committed by the JVM.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.standardOptions.color.withMode('continuous-BlYlRd'),

      requests:
        signals.jetty.requests.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.queryOptions.withInterval('1m')
        + { targets: [super.targets[0] { intervalFactor: 2 }] },

      responses:
        signals.jetty.responses.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.queryOptions.withInterval('1m')
        + { targets: [super.targets[0] { intervalFactor: 2 }] },

      dispatches:
        signals.jetty.dispatches.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.queryOptions.withInterval('1m')
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
        + g.panel.timeSeries.standardOptions.withUnit('short'),

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
        + g.panel.timeSeries.queryOptions.withInterval('1m')
        + { targets: [super.targets[0] { intervalFactor: 2 }] },

      cacheHitRatio:
        commonlib.panels.generic.timeSeries.base.new(
          'Cache hit ratio',
          targets=[signals.query.cacheHitRatio.withFilteringSelectorMixin(coreFilter).asTarget()],
          description='The cache hit ratio for various cache activities.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withMax(100)
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          { color: 'green' },
          { color: 'red', value: 80 },
        ]),

      coreTimeouts:
        signals.query.coreTimeouts.withFilteringSelectorMixin(coreFilter).asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.queryOptions.withInterval('1m')
        + { targets: [super.targets[0] { intervalFactor: 2 }] },

      nodeTimeouts:
        signals.query.nodeTimeouts.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.queryOptions.withInterval('1m')
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
        + g.panel.stat.standardOptions.withMin(0)
        + g.panel.stat.standardOptions.color.withMode('thresholds')
        + g.panel.stat.standardOptions.thresholds.withSteps([
          { color: 'red', value: null },
          { color: 'green', value: 1 },
        ])
        + g.panel.stat.options.withGraphMode('none')
        + g.panel.stat.options.withTextMode('value'),

      shardState:
        signalsCluster.cluster.shardState.asStat()
        + commonlib.panels.generic.stat.base.stylize()
        + g.panel.stat.standardOptions.withMin(0)
        + g.panel.stat.standardOptions.withMax(100)
        + g.panel.stat.standardOptions.color.withMode('thresholds')
        + g.panel.stat.standardOptions.thresholds.withSteps([
          { color: 'red', value: null },
          { color: 'yellow', value: 80 },
          { color: 'green', value: 95 },
        ])
        + g.panel.stat.options.withGraphMode('none')
        + g.panel.stat.options.withTextMode('value'),

      replicaState:
        signalsCluster.cluster.replicaState.asStat()
        + commonlib.panels.generic.stat.base.stylize()
        + g.panel.stat.standardOptions.withMin(0)
        + g.panel.stat.standardOptions.withMax(100)
        + g.panel.stat.standardOptions.color.withMode('thresholds')
        + g.panel.stat.standardOptions.thresholds.withSteps([
          { color: 'red', value: null },
          { color: 'yellow', value: 80 },
          { color: 'green', value: 95 },
        ])
        + g.panel.stat.options.withGraphMode('none')
        + g.panel.stat.options.withTextMode('value'),

      zookeeperEnsembleSize:
        signalsCluster.cluster.zookeeperEnsembleSize.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      topCPULoadByNode:
        signalsCluster.jvm.topCpuLoad.withTopK('$k').asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withMax(100)
        + g.panel.timeSeries.standardOptions.color.withMode('continuous-BlYlRd')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          { color: 'blue' },
          { color: 'yellow', value: 90 },
          { color: 'red', value: 80 },
        ]),

      topHeapMemoryUsageByNode:
        signalsCluster.jvm.heapMemoryUsage.withTopK('$k').asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withMax(100)
        + g.panel.timeSeries.standardOptions.color.withMode('continuous-BlYlRd')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          { color: 'blue' },
          { color: 'yellow', value: 90 },
          { color: 'red', value: 80 },
        ]),

      topMeanQueriesByNode:
        signalsCluster.query.queryMeanRate.withFilteringSelectorMixin(coreFilter).withTopK('$k').asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      topUpdateHandlersByNode:
        signalsCluster.query.topUpdateHandlerAdds.withFilteringSelectorMixin(coreFilter).withTopK('$k').asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.queryOptions.withInterval('1m')
        + { targets: [super.targets[0] { intervalFactor: 2 }] },

      topIndexSizeByNode:
        signalsCluster.node.indexSize.withFilteringSelectorMixin(coreFilter).withTopK('$k').asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      topCacheHitRatioByNode:
        signalsCluster.query.topCacheHitRatio.withFilteringSelectorMixin(coreFilter).withExprWrappersMixin(['bottomk($k,', ')']).asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withMax(100)
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          { color: 'green' },
          { color: 'yellow', value: 90 },
          { color: 'red', value: 80 },
        ]),

      topCoreErrorsByNode:
        signalsCluster.node.coreErrors.withFilteringSelectorMixin(coreFilter).withTopK('$k').asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.queryOptions.withInterval('1m')
        + { targets: [super.targets[0] { intervalFactor: 2 }] },

      topNodeErrors:
        signalsCluster.node.nodeErrors.withTopK('$k').asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.queryOptions.withInterval('1m')
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
        availabilityTable(
          'Zookeeper status',
          signalsCluster.cluster.zookeeperStatus.asTableTarget(),
          'Status of ZooKeeper, integral for cluster coordination.',
          hidden=['Time', 'job', '__name__', 'status'],
          renamed={
            solr_cluster: 'Solr cluster',
            zk_host: 'Zookeeper host',
            Value: 'Status',
          },
        ),

      shardStatus:
        availabilityTable(
          'Shard status',
          signalsCluster.cluster.shardStateTable.asTableTarget(),
          'Shows the state of various shards in the cluster.',
          hidden=['Time', 'job', '__name__', 'solr_cluster', 'zk_host'],
          renamed={
            Value: 'Status',
            instance: 'Instance',
            shard: 'Shard',
            collection: 'Collection',
          },
        ),

      replicaStatus:
        availabilityTable(
          'Replica status',
          signalsCluster.cluster.replicaStateTable.asTableTarget(),
          'State of replicas within a Solr collection.',
          hidden=[
            'Time',
            'job',
            '__name__',
            'solr_cluster',
            'collection',
            'shard',
            'replica',
            'base_url',
            'node_name',
            'type',
            'state',
            'zk_host',
          ],
          renamed={
            Value: 'Status',
            core: 'Core',
            instance: 'Instance',
            replica_name: 'Replica name',
          },
        ),
    },
}
