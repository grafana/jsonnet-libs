local g = import './g.libsonnet';
local var = g.dashboard.variable;
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;

{
  new(this)::
    {
      local signals = this.signals,
      
      osRoles:
        g.panel.table.new('Roles')
        + g.panel.table.panelOptions.withDescription('OpenSearch node roles.')
        + g.panel.table.queryOptions.withTargets([
          signals.roles.node_role_last_seen.asTarget()
          + g.query.prometheus.withInstant(true),
        ])
        + g.panel.table.queryOptions.withTransformations([
          {id: 'labelsToFields', options: {mode: 'columns', valueLabel: 'role'}},
          {id: 'merge', options: {}},
          {
            id: 'organize',
            options: {
              excludeByName: {Time: true},
              indexByName: {
                Time: 0, node: 3, nodeid: 3, master: 104, data: 105,
                ingest: 106, remote_cluster_client: 107, cluster_manager: 108,
              } + {[k]: 3 for k in this.config.groupLabels + this.config.instanceLabels},
              renameByName: {
                Time: '', cluster: 'Cluster', cluster_manager: 'Cluster manager',
                data: 'Data', ingest: 'Ingest', master: 'Master',
                node: 'Node', nodeid: 'Nodeid', remote_cluster_client: 'Remote cluster client',
              },
            },
          },
        ])
        + g.panel.table.standardOptions.withMappings([
          g.panel.table.standardOptions.mapping.ValueMap.withType()
          + g.panel.table.standardOptions.mapping.ValueMap.withOptions({
            '0': {color: 'super-light-orange', index: 5, text: 'False'},
            '1': {color: 'light-green', index: 3, text: 'True'},
            Data: {color: 'light-purple', index: 0, text: 'data'},
            Ingest: {color: 'light-blue', index: 2, text: 'ingest'},
            Master: {color: 'light-green', index: 1, text: 'master'},
            'Remote cluster client': {color: 'light-orange', index: 4, text: 'remote_cluster_client'},
          }),
        ])
        + g.panel.table.standardOptions.withOverrides([
          g.panel.table.fieldOverride.byRegexp.new('/Data|Master|Ingest|Remote.+|Cluster.+/')
          + g.panel.table.fieldOverride.byRegexp.withProperty('custom.cellOptions', {type: 'color-text'}),
        ]),

      osRolesTimeline:
        g.panel.statusHistory.new('Roles timeline')
        + g.panel.statusHistory.panelOptions.withDescription('OpenSearch node roles over time.')
        + g.panel.statusHistory.options.withShowValue('never')
        + g.panel.statusHistory.options.withLegend(false)
        + g.panel.statusHistory.queryOptions.withMaxDataPoints(100)
        + g.panel.statusHistory.queryOptions.withTargets([
          signals.roles.node_role_data.asTarget(),
          signals.roles.node_role_master.asTarget(),
          signals.roles.node_role_ingest.asTarget(),
          signals.roles.node_role_cluster_manager.asTarget(),
          signals.roles.node_role_remote_cluster_client.asTarget(),
        ])
        + g.panel.statusHistory.standardOptions.withMappings([
          {
            type: 'value',
            options: {
              '2': {color: 'light-purple', index: 0, text: 'data'},
              '3': {color: 'light-green', index: 1, text: 'master'},
              '4': {color: 'light-blue', index: 2, text: 'ingest'},
              '5': {color: 'light-yellow', index: 3, text: 'cluster_manager'},
              '6': {color: 'super-light-red', index: 4, text: 'remote_cluster_client'},
            },
          },
        ]),

      // Cluster Overview Panels
      clusterStatusPanel:
        g.panel.stat.new('Cluster status')
        + g.panel.stat.panelOptions.withDescription('The overall health and availability of the OpenSearch cluster.')
        + g.panel.stat.queryOptions.withTargets([
          signals.cluster.cluster_status.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.stat.standardOptions.color.withMode('thresholds')
        + g.panel.stat.standardOptions.withMappings([
          g.panel.stat.standardOptions.mapping.ValueMap.withType()
          + g.panel.stat.standardOptions.mapping.ValueMap.withOptions({
            '0': {index: 0, text: 'Green'},
            '1': {index: 1, text: 'Yellow'},
            '2': {index: 2, text: 'Red'},
          }),
        ])
        + g.panel.stat.standardOptions.thresholds.withSteps([
          g.panel.stat.standardOptions.threshold.step.withColor('green')
          + g.panel.stat.standardOptions.threshold.step.withValue(null),
          g.panel.stat.standardOptions.threshold.step.withColor('green')
          + g.panel.stat.standardOptions.threshold.step.withValue(0),
          g.panel.stat.standardOptions.threshold.step.withColor('yellow')
          + g.panel.stat.standardOptions.threshold.step.withValue(1),
          g.panel.stat.standardOptions.threshold.step.withColor('red')
          + g.panel.stat.standardOptions.threshold.step.withValue(2),
        ])
        + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull']),

      nodeCountPanel:
        g.panel.stat.new('Node count')
        + g.panel.stat.panelOptions.withDescription('The number of running nodes across the OpenSearch cluster.')
        + g.panel.stat.queryOptions.withTargets([
          signals.cluster.cluster_nodes_number.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.stat.standardOptions.color.withMode('thresholds')
        + g.panel.stat.standardOptions.thresholds.withSteps([
          g.panel.stat.standardOptions.threshold.step.withColor('green')
          + g.panel.stat.standardOptions.threshold.step.withValue(null),
          g.panel.stat.standardOptions.threshold.step.withColor('red')
          + g.panel.stat.standardOptions.threshold.step.withValue(0),
          g.panel.stat.standardOptions.threshold.step.withColor('green')
          + g.panel.stat.standardOptions.threshold.step.withValue(1),
        ])
        + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull']),

      dataNodeCountPanel:
        g.panel.stat.new('Data node count')
        + g.panel.stat.panelOptions.withDescription('The number of data nodes in the OpenSearch cluster.')
        + g.panel.stat.queryOptions.withTargets([
          signals.cluster.cluster_datanodes_number.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.stat.standardOptions.color.withMode('thresholds')
        + g.panel.stat.standardOptions.thresholds.withSteps([
          g.panel.stat.standardOptions.threshold.step.withColor('green')
          + g.panel.stat.standardOptions.threshold.step.withValue(null),
          g.panel.stat.standardOptions.threshold.step.withColor('red')
          + g.panel.stat.standardOptions.threshold.step.withValue(0),
          g.panel.stat.standardOptions.threshold.step.withColor('green')
          + g.panel.stat.standardOptions.threshold.step.withValue(1),
        ])
        + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull']),

      shardCountPanel:
        g.panel.stat.new('Shard count')
        + g.panel.stat.panelOptions.withDescription('The number of shards in the OpenSearch cluster across all indices.')
        + g.panel.stat.queryOptions.withTargets([
          signals.cluster.cluster_shards_number_total.withExprWrappersMixin(['sum(', ')']).asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.stat.standardOptions.color.withMode('thresholds')
        + g.panel.stat.standardOptions.thresholds.withSteps([
          g.panel.stat.standardOptions.threshold.step.withColor('green')
          + g.panel.stat.standardOptions.threshold.step.withValue(null),
          g.panel.stat.standardOptions.threshold.step.withColor('red')
          + g.panel.stat.standardOptions.threshold.step.withValue(0),
          g.panel.stat.standardOptions.threshold.step.withColor('green')
          + g.panel.stat.standardOptions.threshold.step.withValue(1),
        ])
        + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull']),

      activeShardsPercentagePanel:
        g.panel.stat.new('Active shards %')
        + g.panel.stat.panelOptions.withDescription('Percent of active shards across the OpenSearch cluster.')
        + g.panel.stat.queryOptions.withTargets([
          signals.cluster.cluster_shards_active_percent.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.stat.standardOptions.color.withMode('thresholds')
        + g.panel.stat.standardOptions.thresholds.withSteps([
          g.panel.stat.standardOptions.threshold.step.withColor('green')
          + g.panel.stat.standardOptions.threshold.step.withValue(null),
          g.panel.stat.standardOptions.threshold.step.withColor('red')
          + g.panel.stat.standardOptions.threshold.step.withValue(0),
          g.panel.stat.standardOptions.threshold.step.withColor('yellow')
          + g.panel.stat.standardOptions.threshold.step.withValue(1),
          g.panel.stat.standardOptions.threshold.step.withColor('green')
          + g.panel.stat.standardOptions.threshold.step.withValue(100),
        ])
        + g.panel.stat.standardOptions.withUnit('percent')
        + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull']),
      
      topNodesByCPUUsagePanel:
        g.panel.barGauge.new('Top nodes by CPU usage')
        + g.panel.barGauge.panelOptions.withDescription('Top nodes by OS CPU usage across the OpenSearch cluster.')
        + g.panel.barGauge.queryOptions.withTargets([
          signals.topk.os_cpu_percent_topk.withExprWrappersMixin(['topk(10, sort_desc(', ')']).asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.barGauge.standardOptions.color.withMode('thresholds')
        + g.panel.barGauge.standardOptions.thresholds.withSteps([
          g.panel.barGauge.standardOptions.threshold.step.withColor('green')
          + g.panel.barGauge.standardOptions.threshold.step.withValue(null),
          g.panel.barGauge.standardOptions.threshold.step.withColor('red')
          + g.panel.barGauge.standardOptions.threshold.step.withValue(80),
        ])
        + g.panel.barGauge.standardOptions.withMin(0)
        + g.panel.barGauge.standardOptions.withMax(100)
        + g.panel.barGauge.standardOptions.withUnit('percent')
        + g.panel.barGauge.options.reduceOptions.withCalcs(['lastNotNull']),

      breakersTrippedPanel:
        g.panel.barGauge.new('Breakers tripped')
        + g.panel.barGauge.panelOptions.withDescription('The total count of circuit breakers tripped across the OpenSearch cluster.')
        + g.panel.barGauge.queryOptions.withTargets([
          signals.topk.circuitbreaker_tripped_count_sum.asTarget()
          + g.query.prometheus.withInterval('1m')
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.barGauge.standardOptions.color.withMode('thresholds')
        + g.panel.barGauge.standardOptions.thresholds.withSteps([
          g.panel.barGauge.standardOptions.threshold.step.withColor('green')
          + g.panel.barGauge.standardOptions.threshold.step.withValue(null),
          g.panel.barGauge.standardOptions.threshold.step.withColor('red')
          + g.panel.barGauge.standardOptions.threshold.step.withValue(80),
        ])
        + g.panel.barGauge.standardOptions.withUnit('trips')
        + g.panel.barGauge.options.reduceOptions.withCalcs(['lastNotNull']),

      shardStatusPanel:
        g.panel.barGauge.new('Shard status')
        + g.panel.barGauge.panelOptions.withDescription('Shard status counts across the OpenSearch cluster.')
        + g.panel.barGauge.queryOptions.withTargets([
          signals.cluster.cluster_shards_number_by_type.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
          ])
        + g.panel.barGauge.standardOptions.color.withMode('thresholds')
        + g.panel.barGauge.standardOptions.thresholds.withSteps([
          g.panel.barGauge.standardOptions.threshold.step.withColor('green')
          + g.panel.barGauge.standardOptions.threshold.step.withValue(null),
          g.panel.barGauge.standardOptions.threshold.step.withColor('red')
          + g.panel.barGauge.standardOptions.threshold.step.withValue(80),
        ])
        + g.panel.barGauge.standardOptions.withUnit('shards')
        + g.panel.barGauge.options.reduceOptions.withCalcs(['lastNotNull']),

      topNodesByDiskUsagePanel:
        g.panel.barGauge.new('Top nodes by disk usage')
        + g.panel.barGauge.panelOptions.withDescription('Top nodes by disk usage across the OpenSearch cluster.')
        + g.panel.barGauge.queryOptions.withTargets([
          signals.topk.fs_path_used_percent_topk.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.barGauge.standardOptions.color.withMode('thresholds')
        + g.panel.barGauge.standardOptions.thresholds.withSteps([
          g.panel.barGauge.standardOptions.threshold.step.withColor('green')
          + g.panel.barGauge.standardOptions.threshold.step.withValue(null),
          g.panel.barGauge.standardOptions.threshold.step.withColor('red')
          + g.panel.barGauge.standardOptions.threshold.step.withValue(80),
        ])
        + g.panel.barGauge.standardOptions.withMin(0)
        + g.panel.barGauge.standardOptions.withMax(100)
        + g.panel.barGauge.standardOptions.withUnit('percent')
        + g.panel.barGauge.options.reduceOptions.withCalcs(['lastNotNull']),

      totalDocumentsPanel:
        g.panel.timeSeries.new('Total documents')
        + g.panel.timeSeries.panelOptions.withDescription('The total count of documents indexed across the OpenSearch cluster.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.cluster.indices_indexing_index_count_avg.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('documents'),

      pendingTasksPanel:
        g.panel.timeSeries.new('Pending tasks')
        + g.panel.timeSeries.panelOptions.withDescription('The number of tasks waiting to be executed across the OpenSearch cluster.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.cluster.cluster_pending_tasks_number.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('tasks'),

      storeSizePanel:
        g.panel.timeSeries.new('Store size')
        + g.panel.timeSeries.panelOptions.withDescription('The total size of the store across the OpenSearch cluster.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.cluster.indices_store_size_bytes_avg.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('bytes'),

      maxTaskWaitTimePanel:
        g.panel.timeSeries.new('Max task wait time')
        + g.panel.timeSeries.panelOptions.withDescription('The max wait time for tasks to be executed across the OpenSearch cluster.')
        + g.panel.timeSeries.queryOptions.withTargets([signals.cluster.cluster_task_max_wait_seconds.asTarget()])
        + g.panel.timeSeries.standardOptions.withUnit('s'),

      topIndicesByRequestRatePanel:
        g.panel.timeSeries.new('Top indices by request rate')
        + g.panel.timeSeries.panelOptions.withDescription('Top indices by combined fetch, query, and scroll request rate across the OpenSearch cluster.')
        + g.panel.timeSeries.queryOptions.withTargets([signals.topk.search_current_inflight_topk.asTarget()])
        + g.panel.timeSeries.standardOptions.withUnit('reqps'),

      topIndicesByRequestLatencyPanel:
        g.panel.timeSeries.new('Top indices by request latency')
        + g.panel.timeSeries.panelOptions.withDescription('Top indices by combined fetch, query, and scroll latency across the OpenSearch cluster.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.topk.search_avg_latency_topk.asTarget()
          + g.query.prometheus.withInterval('1m'),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('s'),

      topIndicesByCombinedCacheHitRatioPanel:
        g.panel.timeSeries.new('Top indices by combined cache hit ratio')
        + g.panel.timeSeries.panelOptions.withDescription('Top indices by cache hit ratio for the combined request and query cache across the OpenSearch cluster.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.topk.request_query_cache_hit_rate_topk.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      topNodesByIngestRatePanel:
        g.panel.timeSeries.new('Top nodes by ingest rate')
        + g.panel.timeSeries.panelOptions.withDescription('Top nodes by rate of ingest across the OpenSearch cluster.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.topk.ingest_throughput_topk.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('Bps'),

      topNodesByIngestLatencyPanel:
        g.panel.timeSeries.new('Top nodes by ingest latency')
        + g.panel.timeSeries.panelOptions.withDescription('Top nodes by ingestion latency across the OpenSearch cluster.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.topk.ingest_latency_topk.asTarget()
          + g.query.prometheus.withInterval('1m')
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('s'),

      topNodesByIngestErrorsPanel:
        g.panel.timeSeries.new('Top nodes by ingest errors')
        + g.panel.timeSeries.panelOptions.withDescription('Top nodes by ingestion failures across the OpenSearch cluster.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.topk.ingest_failures_topk.asTarget()
          + g.query.prometheus.withInterval('1m')
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('errors'),

      topIndicesByIndexRatePanel:
        g.panel.timeSeries.new('Top indices by index rate')
        + g.panel.timeSeries.panelOptions.withDescription('Top indices by rate of document indexing across the OpenSearch cluster.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.topk.indexing_current_topk.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('documents/s'),

      topIndicesByIndexLatencyPanel:
        g.panel.timeSeries.new('Top indices by index latency')
        + g.panel.timeSeries.panelOptions.withDescription('Top indices by indexing latency across the OpenSearch cluster.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.topk.indexing_latency_topk.asTarget()
          + g.query.prometheus.withInterval('1m')
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('s'),

      topIndicesByIndexFailuresPanel:
        g.panel.timeSeries.new('Top indices by index failures')
        + g.panel.timeSeries.panelOptions.withDescription('Top indices by index document failures across the OpenSearch cluster.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.topk.indexing_failed_topk.asTarget()
          + g.query.prometheus.withInterval('1m')
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('failures'),

      // Node Overview Panels - Refactored to use modern patterns and signals

      // Node CPU usage
      nodeCpuUsage:
        g.panel.timeSeries.new('Node CPU usage')
        + g.panel.timeSeries.panelOptions.withDescription('CPU usage percentage of the node\'s Operating System.')
        + g.panel.timeSeries.queryOptions.withTargets([signals.node.os_cpu_percent.asTarget()])
        + g.panel.timeSeries.standardOptions.color.withMode('continuous-BlYlRd')
        + g.panel.timeSeries.standardOptions.withDecimals(1)
        + g.panel.timeSeries.standardOptions.withMax(100)
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(5)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('scheme')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineInterpolation('smooth')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never')
        + g.panel.timeSeries.options.tooltip.withMode('multi')
        + g.panel.timeSeries.options.tooltip.withSort('desc'),

      // Node memory usage
      nodeMemoryUsage:
        g.panel.timeSeries.new('Node memory usage')
        + g.panel.timeSeries.panelOptions.withDescription('Memory usage percentage of the node for the Operating System and OpenSearch')
        + g.panel.timeSeries.queryOptions.withTargets([signals.node.os_mem_used_percent.asTarget()])
        + g.panel.timeSeries.standardOptions.color.withMode('continuous-BlYlRd')
        + g.panel.timeSeries.standardOptions.withDecimals(1)
        + g.panel.timeSeries.standardOptions.withMax(100)
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(5)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('scheme')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineInterpolation('smooth')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never')
        + g.panel.timeSeries.options.tooltip.withMode('multi')
        + g.panel.timeSeries.options.tooltip.withSort('desc'),

      // Node I/O
      nodeIO:
        g.panel.timeSeries.new('Node I/O')
        + g.panel.timeSeries.panelOptions.withDescription('Node file system read and write data.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.node.fs_read_bps.asTarget(),
          signals.node.fs_write_bps.asTarget(),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('Bps')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(1)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('opacity')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineInterpolation('smooth')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never')
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
        + g.panel.timeSeries.standardOptions.withOverrides([
          g.panel.timeSeries.fieldOverride.byRegexp.new('/time|used|busy|util/')
          + g.panel.timeSeries.fieldOverride.byRegexp.withProperty('custom.axisSoftMax', 100)
          + g.panel.timeSeries.fieldOverride.byRegexp.withProperty('custom.drawStyle', 'points')
          + g.panel.timeSeries.fieldOverride.byRegexp.withProperty('unit', 'percent'),
        ])
        + g.panel.timeSeries.options.tooltip.withMode('multi')
        + g.panel.timeSeries.options.tooltip.withSort('desc'),

      // Node open connections
      nodeOpenConnections:
        g.panel.timeSeries.new('Node open connections')
        + g.panel.timeSeries.panelOptions.withDescription('Number of open connections for the selected node.')
        + g.panel.timeSeries.queryOptions.withTargets([signals.node.transport_open_connections.asTarget()])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(30)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('opacity')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineInterpolation('smooth')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never')
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
        + g.panel.timeSeries.options.tooltip.withMode('multi')
        + g.panel.timeSeries.options.tooltip.withSort('desc'),

      // Node disk usage
      nodeDiskUsage:
        g.panel.timeSeries.new('Node disk usage')
        + g.panel.timeSeries.panelOptions.withDescription('Disk usage percentage of the selected node.')
        + g.panel.timeSeries.queryOptions.withTargets([signals.node.fs_used_percent.asTarget()])
        + g.panel.timeSeries.standardOptions.color.withMode('continuous-BlYlRd')
        + g.panel.timeSeries.standardOptions.withDecimals(1)
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withMax(100)
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(1)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('scheme')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineInterpolation('smooth')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never')
        + g.panel.timeSeries.options.tooltip.withMode('multi')
        + g.panel.timeSeries.options.tooltip.withSort('desc'),

      // Node memory swap
      nodeMemorySwap:
        g.panel.timeSeries.new('Node memory swap')
        + g.panel.timeSeries.panelOptions.withDescription('Percentage of swap space used by OpenSearch and the Operating System on the selected node.')
        + g.panel.timeSeries.queryOptions.withTargets([signals.node.os_swap_used_percent.asTarget()])
        + g.panel.timeSeries.standardOptions.color.withMode('continuous-BlYlRd')
        + g.panel.timeSeries.standardOptions.withDecimals(1)
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withMax(100)
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(5)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('scheme')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineInterpolation('smooth')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never')
        + g.panel.timeSeries.options.tooltip.withMode('multi')
        + g.panel.timeSeries.options.tooltip.withSort('desc'),

      // Node network traffic
      nodeNetworkTraffic:
        g.panel.timeSeries.new('Node network traffic')
        + g.panel.timeSeries.panelOptions.withDescription('Network traffic on the node\'s Operating System.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.node.transport_rx_bps.asTarget(),
          signals.node.transport_tx_bps.asTarget(),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('Bps')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(5)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('scheme')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineInterpolation('smooth')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never'),

      // Circuit breakers
      circuitBreakers:
        g.panel.timeSeries.new('Circuit breakers')
        + g.panel.timeSeries.panelOptions.withDescription('Circuit breakers tripped on the selected node by type')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.node.circuitbreaker_tripped_sum_by_name.asTarget()
          + g.query.prometheus.withInterval('1m')
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('trips'),

      // JVM heap used vs committed
      jvmHeapUsedVsCommitted:
        g.panel.timeSeries.new('JVM heap used vs committed')
        + g.panel.timeSeries.panelOptions.withDescription('JVM heap memory usage vs committed.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.node.jvm_heap_used_bytes.asTarget(),
          signals.node.jvm_heap_committed_bytes.asTarget(),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(5)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('scheme')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineInterpolation('smooth')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never'),

      // JVM non-heap used vs committed
      jvmNonheapUsedVsCommitted:
        g.panel.timeSeries.new('JVM non-heap used vs committed')
        + g.panel.timeSeries.panelOptions.withDescription('JVM non-heap memory usage vs committed.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.node.jvm_nonheap_used_bytes.asTarget(),
          signals.node.jvm_nonheap_committed_bytes.asTarget(),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(5)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('scheme')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineInterpolation('smooth')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never'),

      // JVM threads
      jvmThreads:
        g.panel.timeSeries.new('JVM threads')
        + g.panel.timeSeries.panelOptions.withDescription('JVM thread count.')
        + g.panel.timeSeries.queryOptions.withTargets([signals.node.jvm_threads.asTarget()])
        + g.panel.timeSeries.standardOptions.withUnit('threads')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(5)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('scheme')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineInterpolation('smooth')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never'),

      // JVM buffer pools
      jvmBufferPools:
        g.panel.timeSeries.new('JVM buffer pools')
        + g.panel.timeSeries.panelOptions.withDescription('JVM buffer pool usage.')
        + g.panel.timeSeries.queryOptions.withTargets([signals.node.jvm_bufferpool_number.asTarget()])
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(5)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('scheme')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineInterpolation('smooth')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never'),

      // JVM uptime
      jvmUptime:
        g.panel.timeSeries.new('JVM uptime')
        + g.panel.timeSeries.panelOptions.withDescription('JVM uptime in seconds.')
        + g.panel.timeSeries.queryOptions.withTargets([signals.node.jvm_uptime.asTarget()])
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(5)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('scheme')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineInterpolation('smooth')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never'),

      // JVM garbage collections
      jvmGarbageCollections:
        g.panel.timeSeries.new('JVM garbage collections')
        + g.panel.timeSeries.panelOptions.withDescription('JVM garbage collection count.')
        + g.panel.timeSeries.queryOptions.withTargets([signals.node.jvm_gc_collections.asTarget()])
        + g.panel.timeSeries.standardOptions.withUnit('collections')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(5)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('scheme')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineInterpolation('smooth')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never'),

      // JVM garbage collection time
      jvmGarbageCollectionTime:
        g.panel.timeSeries.new('JVM garbage collection time')
        + g.panel.timeSeries.panelOptions.withDescription('JVM garbage collection time in milliseconds.')
        + g.panel.timeSeries.queryOptions.withTargets([signals.node.jvm_gc_time.asTarget()])
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(5)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('scheme')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineInterpolation('smooth')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2),

      // JVM buffer pool usage
      jvmBufferPoolUsage:
        g.panel.timeSeries.new('JVM buffer pool usage')
        + g.panel.timeSeries.panelOptions.withDescription('JVM buffer pool usage by pool.')
        + g.panel.timeSeries.queryOptions.withTargets([signals.node.jvm_bufferpool_used_percent.asTarget()])
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(5)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('scheme')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineInterpolation('smooth')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never'),

      // Thread pool threads
      threadPoolThreads:
        g.panel.timeSeries.new('Thread pool threads')
        + g.panel.timeSeries.panelOptions.withDescription('Thread pool thread count.')
        + g.panel.timeSeries.queryOptions.withTargets([signals.node.threadpool_threads.asTarget()])
        + g.panel.timeSeries.standardOptions.withUnit('threads')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(5)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('scheme')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineInterpolation('smooth')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never'),

      // Thread pool tasks
      threadPoolTasks:
        g.panel.timeSeries.new('Thread pool tasks')
        + g.panel.timeSeries.panelOptions.withDescription('Thread pool task count.')
        + g.panel.timeSeries.queryOptions.withTargets([signals.node.threadpool_tasks.asTarget()])
        + g.panel.timeSeries.standardOptions.withUnit('tasks')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(5)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('scheme')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineInterpolation('smooth')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never'),

      // Search and Index Overview Panels - Refactored to use modern patterns and signals
      // Search Performance Panels
      searchRequestRatePanel:
        g.panel.timeSeries.new('Request rate')
        + g.panel.timeSeries.panelOptions.withDescription('Rate of fetch, scroll, and query requests by selected index.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.search.search_query_current_avg.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
          signals.search.search_fetch_current_avg.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
          signals.search.search_scroll_current_avg.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.standardOptions.withOverrides([
          {
            matcher: {id: 'byValue', options: {reducer: 'allIsZero', op: 'gte', value: 0}},
            properties: [{id: 'custom.hideFrom', value: {tooltip: true, viz: false, legend: true}}],
          },
        ])
        + g.panel.timeSeries.options.tooltip.withMode('multi'),

      searchRequestLatencyPanel:
        g.panel.timeSeries.new('Request latency')
        + g.panel.timeSeries.panelOptions.withDescription('Latency of fetch, scroll, and query requests by selected index.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.search.search_query_latency_avg.asTarget()
          + g.query.prometheus.withInterval('1m')
          + g.query.prometheus.withIntervalFactor(2),
          signals.search.search_fetch_latency_avg.asTarget()
          + g.query.prometheus.withInterval('1m')
          + g.query.prometheus.withIntervalFactor(2),
          signals.search.search_scroll_latency_avg.asTarget()
          + g.query.prometheus.withInterval('1m')
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.standardOptions.withOverrides([
          {
            matcher: {id: 'byValue', options: {op: 'gte', reducer: 'allIsZero', value: 0}},
            properties: [{id: 'custom.hideFrom', value: {legend: true, tooltip: true, viz: false}}],
          },
        ])
        + g.panel.timeSeries.options.tooltip.withMode('multi'),

      searchCacheHitRatioPanel:
        g.panel.timeSeries.new('Cache hit ratio')
        + g.panel.timeSeries.panelOptions.withDescription('Ratio of query cache and request cache hits and misses.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.search.request_cache_hit_rate.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
          signals.search.query_cache_hit_rate.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.standardOptions.withOverrides([
          {
            matcher: {id: 'byValue', options: {op: 'gte', reducer: 'allIsZero', value: 0}},
            properties: [{id: 'custom.hideFrom', value: {legend: true, tooltip: true, viz: false}}],
          },
        ])
        + g.panel.timeSeries.options.tooltip.withMode('multi'),

      searchCacheEvictionsPanel:
        g.panel.timeSeries.new('Evictions')
        + g.panel.timeSeries.panelOptions.withDescription('Total evictions count by cache type for the selected index.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.search.query_cache_evictions.asTarget()
          + g.query.prometheus.withInterval('1m')
          + g.query.prometheus.withIntervalFactor(2),
          signals.search.request_cache_evictions.asTarget()
          + g.query.prometheus.withInterval('1m')
          + g.query.prometheus.withIntervalFactor(2),
          signals.search.fielddata_evictions.asTarget()
          + g.query.prometheus.withInterval('1m')
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('evictions')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.standardOptions.threshold.step.withColor('green')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(null),
          g.panel.timeSeries.standardOptions.threshold.step.withColor('red')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(80),
        ])
        + g.panel.timeSeries.standardOptions.withOverrides([
          {
            matcher: {id: 'byValue', options: {op: 'gte', reducer: 'allIsZero', value: 0}},
            properties: [{id: 'custom.hideFrom', value: {legend: true, tooltip: true, viz: false}}],
          },
        ])
        + g.panel.timeSeries.options.tooltip.withMode('multi'),

      // Indexing Performance Panels
      indexingRatePanel:
        g.panel.timeSeries.new('Index rate')
        + g.panel.timeSeries.panelOptions.withDescription('Rate of indexed documents for the selected index.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.indexing.indexing_current.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('documents/s')
        + g.panel.timeSeries.standardOptions.withOverrides([
          {
            matcher: {id: 'byValue', options: {op: 'gte', reducer: 'allIsZero', value: 0}},
            properties: [{id: 'custom.hideFrom', value: {legend: true, tooltip: true, viz: false}}],
          },
        ]),

      indexingLatencyPanel:
        g.panel.timeSeries.new('Index latency')
        + g.panel.timeSeries.panelOptions.withDescription('Document indexing latency for the selected index.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.indexing.indexing_latency.asTarget()
          + g.query.prometheus.withInterval('1m'),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.standardOptions.threshold.step.withColor('green')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(null),
          g.panel.timeSeries.standardOptions.threshold.step.withColor('red')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(80),
        ]),

      indexingFailuresPanel:
        g.panel.timeSeries.new('Index failures')
        + g.panel.timeSeries.panelOptions.withDescription('Number of indexing failures for the selected index.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.indexing.indexing_failed.asTarget()
          + g.query.prometheus.withInterval('1m')
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('failures')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.standardOptions.threshold.step.withColor('green')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(null),
          g.panel.timeSeries.standardOptions.threshold.step.withColor('red')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(80),
        ])
        + g.panel.timeSeries.standardOptions.withOverrides([
          g.panel.timeSeries.fieldOverride.byValue.new({op: 'gte', reducer: 'allIsZero', value: 0})
          + g.panel.timeSeries.fieldOverride.byValue.withProperty('custom.hideFrom', {legend: true, tooltip: true, viz: false}),
        ]),

      // Index Operations Panels
      flushLatencyPanel:
        g.panel.timeSeries.new('Flush latency')
        + g.panel.timeSeries.panelOptions.withDescription('Index flush latency for the selected index.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.indexing.flush_latency.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.standardOptions.threshold.step.withColor('green')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(null),
          g.panel.timeSeries.standardOptions.threshold.step.withColor('red')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(80),
        ])
        + g.panel.timeSeries.standardOptions.withOverrides([
          g.panel.timeSeries.fieldOverride.byValue.new({op: 'gte', reducer: 'allIsZero', value: 0})
          + g.panel.timeSeries.fieldOverride.byValue.withProperty('custom.hideFrom', {legend: true, tooltip: true, viz: false}),
        ]),

      mergeTimePanel:
        g.panel.timeSeries.new('Merge time')
        + g.panel.timeSeries.panelOptions.withDescription('Index merge time for the selected index.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.indexing.merge_time.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
          signals.indexing.merge_stopped_time.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
          signals.indexing.merge_throttled_time.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withDrawStyle('points')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.standardOptions.threshold.step.withColor('green')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(null),
          g.panel.timeSeries.standardOptions.threshold.step.withColor('red')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(80),
        ])
        + g.panel.timeSeries.standardOptions.withOverrides([
          g.panel.timeSeries.fieldOverride.byValue.new({op: 'gte', reducer: 'allIsZero', value: 0})
          + g.panel.timeSeries.fieldOverride.byValue.withProperty('custom.hideFrom', {legend: true, tooltip: true, viz: false}),
        ])
        + g.panel.timeSeries.options.tooltip.withMode('multi'),

      refreshLatencyPanel:
        g.panel.timeSeries.new('Refresh latency')
        + g.panel.timeSeries.panelOptions.withDescription('Index refresh latency for the selected index.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.indexing.refresh_latency.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.standardOptions.threshold.step.withColor('green')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(null),
          g.panel.timeSeries.standardOptions.threshold.step.withColor('red')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(80),
        ])
        + g.panel.timeSeries.standardOptions.withOverrides([
          g.panel.timeSeries.fieldOverride.byValue.new({op: 'gte', reducer: 'allIsZero', value: 0})
          + g.panel.timeSeries.fieldOverride.byValue.withProperty('custom.hideFrom', {legend: true, tooltip: true, viz: false}),
        ]),

      // Index Statistics Panels
      translogOperationsPanel:
        g.panel.timeSeries.new('Translog operations')
        + g.panel.timeSeries.panelOptions.withDescription('Current number of translog operations for the selected index.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.indexing.translog_ops.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('operations')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.standardOptions.threshold.step.withColor('green')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(null),
          g.panel.timeSeries.standardOptions.threshold.step.withColor('red')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(80),
        ])
        + g.panel.timeSeries.standardOptions.withOverrides([
          g.panel.timeSeries.fieldOverride.byValue.new({op: 'gte', reducer: 'allIsZero', value: 0})
          + g.panel.timeSeries.fieldOverride.byValue.withProperty('custom.hideFrom', {legend: true, tooltip: true, viz: false}),
        ]),

      docsDeletedPanel:
        g.panel.timeSeries.new('Docs deleted')
        + g.panel.timeSeries.panelOptions.withDescription('Rate of documents deleted for the selected index.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.indexing.indexing_delete_current.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('documents/s')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.standardOptions.threshold.step.withColor('green')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(null),
          g.panel.timeSeries.standardOptions.threshold.step.withColor('red')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(80),
        ])
        + g.panel.timeSeries.standardOptions.withOverrides([
          g.panel.timeSeries.fieldOverride.byValue.new({op: 'gte', reducer: 'allIsZero', value: 0})
          + g.panel.timeSeries.fieldOverride.byValue.withProperty('custom.hideFrom', {legend: true, tooltip: true, viz: false}),
        ]),

      documentsIndexedPanel:
        g.panel.timeSeries.new('Documents indexed')
        + g.panel.timeSeries.panelOptions.withDescription('Number of indexed documents for the selected index.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.indexing.indexing_count.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('documents')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.standardOptions.threshold.step.withColor('green')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(null),
          g.panel.timeSeries.standardOptions.threshold.step.withColor('red')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(80),
        ])
        + g.panel.timeSeries.standardOptions.withOverrides([
          g.panel.timeSeries.fieldOverride.byValue.new({op: 'gte', reducer: 'allIsZero', value: 0})
          + g.panel.timeSeries.fieldOverride.byValue.withProperty('custom.hideFrom', {legend: true, tooltip: true, viz: false}),
        ]),

      // Index Structure Panels
      segmentCountPanel:
        g.panel.timeSeries.new('Segment count')
        + g.panel.timeSeries.panelOptions.withDescription('Current number of segments for the selected index.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.indexing.segments_number.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('segments')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.standardOptions.threshold.step.withColor('green')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(null),
          g.panel.timeSeries.standardOptions.threshold.step.withColor('red')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(80),
        ])
        + g.panel.timeSeries.standardOptions.withOverrides([
          g.panel.timeSeries.fieldOverride.byValue.new({op: 'gte', reducer: 'allIsZero', value: 0})
          + g.panel.timeSeries.fieldOverride.byValue.withProperty('custom.hideFrom', {legend: true, tooltip: true, viz: false}),
        ]),

      mergeCountPanel:
        g.panel.timeSeries.new('Merge count')
        + g.panel.timeSeries.panelOptions.withDescription('Number of merge operations for the selected index.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.indexing.merge_docs.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('merges')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withDrawStyle('points')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.standardOptions.threshold.step.withColor('green')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(null),
          g.panel.timeSeries.standardOptions.threshold.step.withColor('red')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(80),
        ])
        + g.panel.timeSeries.standardOptions.withOverrides([
          g.panel.timeSeries.fieldOverride.byValue.new({op: 'gte', reducer: 'allIsZero', value: 0})
          + g.panel.timeSeries.fieldOverride.byValue.withProperty('custom.hideFrom', {legend: true, tooltip: true, viz: false}),
        ]),

      // Cache and Memory Panels
      cacheSizePanel:
        g.panel.timeSeries.new('Cache size')
        + g.panel.timeSeries.panelOptions.withDescription('Size of query cache and request cache.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.search.query_cache_memory.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
          signals.search.request_cache_memory.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.standardOptions.threshold.step.withColor('green')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(null),
          g.panel.timeSeries.standardOptions.threshold.step.withColor('red')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(80),
        ])
        + g.panel.timeSeries.standardOptions.withOverrides([
          g.panel.timeSeries.fieldOverride.byValue.new({op: 'gte', reducer: 'allIsZero', value: 0})
          + g.panel.timeSeries.fieldOverride.byValue.withProperty('custom.hideFrom', {legend: true, tooltip: true, viz: false}),
        ])
        + g.panel.timeSeries.options.tooltip.withMode('multi'),

      searchAndIndexStoreSizePanel:
        g.panel.timeSeries.new('Store size')
        + g.panel.timeSeries.panelOptions.withDescription('Size of the store in bytes for the selected index.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.indexing.store_size_bytes.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.standardOptions.threshold.step.withColor('green')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(null),
          g.panel.timeSeries.standardOptions.threshold.step.withColor('red')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(80),
        ])
        + g.panel.timeSeries.standardOptions.withOverrides([
          g.panel.timeSeries.fieldOverride.byValue.new({op: 'gte', reducer: 'allIsZero', value: 0})
          + g.panel.timeSeries.fieldOverride.byValue.withProperty('custom.hideFrom', {legend: true, tooltip: true, viz: false}),
        ]),

      segmentSizePanel:
        g.panel.timeSeries.new('Segment size')
        + g.panel.timeSeries.panelOptions.withDescription('Memory used by segments for the selected index.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.indexing.segments_memory_bytes.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.standardOptions.threshold.step.withColor('green')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(null),
          g.panel.timeSeries.standardOptions.threshold.step.withColor('red')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(80),
        ])
        + g.panel.timeSeries.standardOptions.withOverrides([
          g.panel.timeSeries.fieldOverride.byValue.new({op: 'gte', reducer: 'allIsZero', value: 0})
          + g.panel.timeSeries.fieldOverride.byValue.withProperty('custom.hideFrom', {legend: true, tooltip: true, viz: false}),
        ]),

      mergeSizePanel:
        g.panel.timeSeries.new('Merge size')
        + g.panel.timeSeries.panelOptions.withDescription('Size of merge operations in bytes for the selected index.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.indexing.merge_current_size.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withDrawStyle('points')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.standardOptions.threshold.step.withColor('green')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(null),
          g.panel.timeSeries.standardOptions.threshold.step.withColor('red')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(80),
        ])
        + g.panel.timeSeries.standardOptions.withOverrides([
          g.panel.timeSeries.fieldOverride.byValue.new({op: 'gte', reducer: 'allIsZero', value: 0})
          + g.panel.timeSeries.fieldOverride.byValue.withProperty('custom.hideFrom', {legend: true, tooltip: true, viz: false}),
        ]),

      searchAndIndexShardCountPanel:
        g.panel.timeSeries.new('Shard count')
        + g.panel.timeSeries.panelOptions.withDescription('The number of index shards for the selected index.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.indexing.shards_per_index.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('shards')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.standardOptions.threshold.step.withColor('green')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(null),
          g.panel.timeSeries.standardOptions.threshold.step.withColor('red')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(80),
        ])
        + g.panel.timeSeries.standardOptions.withOverrides([
          g.panel.timeSeries.fieldOverride.byValue.new({op: 'gte', reducer: 'allIsZero', value: 0})
          + g.panel.timeSeries.fieldOverride.byValue.withProperty('custom.hideFrom', {legend: true, tooltip: true, viz: false}),
        ]),
    },
}
