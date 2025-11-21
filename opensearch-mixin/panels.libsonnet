local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local var = g.dashboard.variable;

{
  new(this)::
    {
      local signals = this.signals,

      clusterOSRoles:
        g.panel.table.new('Roles')
        + g.panel.table.panelOptions.withDescription('OpenSearch node roles.')
        + g.panel.table.queryOptions.withDatasource('prometheus', '${prometheus_datasource}')
        + g.panel.table.queryOptions.withTargets([
          signals.clusterOverview.node_role_last_seen.asTarget()
          + g.query.prometheus.withInstant(true),
        ])
        + g.panel.table.queryOptions.withTransformations([
          { id: 'labelsToFields', options: { mode: 'columns', valueLabel: 'role' } },
          { id: 'merge', options: {} },
          {
            id: 'organize',
            options: {
              excludeByName: { Time: true },
              indexByName: {
                Time: 0,
                node: 3,
                nodeid: 3,
                master: 104,
                data: 105,
                ingest: 106,
                remote_cluster_client: 107,
                cluster_manager: 108,
              } + { [k]: 3 for k in this.config.groupLabels + this.config.instanceLabels },
              renameByName: {
                Time: '',
                cluster: 'Cluster',
                cluster_manager: 'Cluster manager',
                data: 'Data',
                ingest: 'Ingest',
                master: 'Master',
                node: 'Node',
                nodeid: 'Nodeid',
                remote_cluster_client: 'Remote cluster client',
              },
            },
          },
        ])
        + g.panel.table.standardOptions.withMappings([
          g.panel.table.standardOptions.mapping.ValueMap.withType()
          + g.panel.table.standardOptions.mapping.ValueMap.withOptions({
            '0': { color: 'super-light-orange', index: 5, text: 'False' },
            '1': { color: 'light-green', index: 3, text: 'True' },
            Data: { color: 'light-purple', index: 0, text: 'data' },
            Ingest: { color: 'light-blue', index: 2, text: 'ingest' },
            Master: { color: 'light-green', index: 1, text: 'master' },
            'Remote cluster client': { color: 'light-orange', index: 4, text: 'remote_cluster_client' },
          }),
        ])
        + g.panel.table.standardOptions.withOverrides([
          g.panel.table.fieldOverride.byRegexp.new('/Data|Master|Ingest|Remote.+|Cluster.+/')
          + g.panel.table.fieldOverride.byRegexp.withProperty('custom.cellOptions', { type: 'color-text' }),
        ]),

      clusterOSRolesTimeline:
        commonlib.panels.generic.statusHistory.base.new(
          'Roles timeline',
          targets=[
            signals.clusterOverview.node_role_data.asTarget(),
            signals.clusterOverview.node_role_master.asTarget(),
            signals.clusterOverview.node_role_ingest.asTarget(),
            signals.clusterOverview.node_role_cluster_manager.asTarget(),
            signals.clusterOverview.node_role_remote_cluster_client.asTarget(),
          ],
          description='OpenSearch node roles over time.'
        )
        + g.panel.statusHistory.queryOptions.withMaxDataPoints(100)
        + g.panel.statusHistory.options.withShowValue('never')
        + g.panel.statusHistory.options.withLegend(false)
        + g.panel.statusHistory.standardOptions.withMappings([
          {
            type: 'value',
            options: {
              '2': { color: 'light-purple', index: 0, text: 'data' },
              '3': { color: 'light-green', index: 1, text: 'master' },
              '4': { color: 'light-blue', index: 2, text: 'ingest' },
              '5': { color: 'light-yellow', index: 3, text: 'cluster_manager' },
              '6': { color: 'super-light-red', index: 4, text: 'remote_cluster_client' },
            },
          },
        ]),

      // Cluster Overview Panels
      clusterStatusPanel:
        commonlib.panels.generic.stat.base.new(
          'Cluster status',
          targets=[signals.clusterOverview.cluster_status.asTarget() { intervalFactor: 2 }],
          description='The overall health and availability of the OpenSearch cluster.'
        )
        + g.panel.stat.standardOptions.color.withMode('thresholds')
        + g.panel.stat.standardOptions.withMappings([
          g.panel.stat.standardOptions.mapping.ValueMap.withType()
          + g.panel.stat.standardOptions.mapping.ValueMap.withOptions({
            '0': { index: 0, text: 'Green' },
            '1': { index: 1, text: 'Yellow' },
            '2': { index: 2, text: 'Red' },
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
        + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
        + g.panel.stat.options.withGraphMode('none'),


      nodeCountPanel:
        commonlib.panels.generic.stat.base.new(
          'Node count',
          targets=[signals.clusterOverview.cluster_nodes_number.asTarget() { intervalFactor: 2 }],
          description='The number of running nodes across the OpenSearch cluster.'
        )
        + g.panel.stat.standardOptions.color.withMode('thresholds')
        + g.panel.stat.standardOptions.thresholds.withSteps([
          g.panel.stat.standardOptions.threshold.step.withColor('green')
          + g.panel.stat.standardOptions.threshold.step.withValue(null),
          g.panel.stat.standardOptions.threshold.step.withColor('red')
          + g.panel.stat.standardOptions.threshold.step.withValue(0),
          g.panel.stat.standardOptions.threshold.step.withColor('green')
          + g.panel.stat.standardOptions.threshold.step.withValue(1),
        ])
        + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
        + g.panel.stat.options.withGraphMode('none'),


      dataNodeCountPanel:
        commonlib.panels.generic.stat.base.new(
          'Data node count',
          targets=[signals.clusterOverview.cluster_datanodes_number.asTarget() { intervalFactor: 2 }],
          description='The number of data nodes in the OpenSearch cluster.'
        )
        + g.panel.stat.standardOptions.color.withMode('thresholds')
        + g.panel.stat.standardOptions.thresholds.withSteps([
          g.panel.stat.standardOptions.threshold.step.withColor('green')
          + g.panel.stat.standardOptions.threshold.step.withValue(null),
          g.panel.stat.standardOptions.threshold.step.withColor('red')
          + g.panel.stat.standardOptions.threshold.step.withValue(0),
          g.panel.stat.standardOptions.threshold.step.withColor('green')
          + g.panel.stat.standardOptions.threshold.step.withValue(1),
        ])
        + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
        + g.panel.stat.options.withGraphMode('none'),

      shardCountPanel:
        commonlib.panels.generic.stat.base.new(
          'Shard count',
          targets=[signals.clusterOverview.cluster_shards_number_total.asTarget() { intervalFactor: 2 }],
          description='The number of shards in the OpenSearch cluster across all indices.'
        )
        + g.panel.stat.standardOptions.color.withMode('thresholds')
        + g.panel.stat.standardOptions.thresholds.withSteps([
          g.panel.stat.standardOptions.threshold.step.withColor('green')
          + g.panel.stat.standardOptions.threshold.step.withValue(null),
          g.panel.stat.standardOptions.threshold.step.withColor('red')
          + g.panel.stat.standardOptions.threshold.step.withValue(0),
          g.panel.stat.standardOptions.threshold.step.withColor('green')
          + g.panel.stat.standardOptions.threshold.step.withValue(1),
        ])
        + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
        + g.panel.stat.options.withGraphMode('none'),

      activeShardsPercentagePanel:
        commonlib.panels.generic.stat.base.new(
          'Active shards %',
          targets=[signals.clusterOverview.cluster_shards_active_percent.asTarget() { intervalFactor: 2 }],
          description='Percent of active shards across the OpenSearch cluster.'
        )
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
        + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
        + g.panel.stat.options.withGraphMode('none'),

      topNodesByCPUUsagePanel:
        g.panel.barGauge.new('Top nodes by CPU usage')
        + g.panel.barGauge.panelOptions.withDescription('Top nodes by OS CPU usage across the OpenSearch cluster.')
        + g.panel.barGauge.queryOptions.withDatasource('prometheus', '${prometheus_datasource}')
        + g.panel.barGauge.queryOptions.withTargets([
          signals.clusterOverview.os_cpu_percent_topk.asTarget() { intervalFactor: 2 },
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
        + g.panel.barGauge.options.reduceOptions.withCalcs(['lastNotNull'])
        + g.panel.barGauge.options.withOrientation('horizontal'),

      breakersTrippedPanel:
        g.panel.barGauge.new('Breakers tripped')
        + g.panel.barGauge.panelOptions.withDescription('The total count of circuit breakers tripped across the OpenSearch cluster.')
        + g.panel.barGauge.queryOptions.withDatasource('prometheus', '${prometheus_datasource}')
        + g.panel.barGauge.queryOptions.withTargets([
          signals.clusterOverview.circuitbreaker_tripped_count_sum.asTarget() { interval: '2m', intervalFactor: 2 },
        ])
        + g.panel.barGauge.standardOptions.color.withMode('thresholds')
        + g.panel.barGauge.standardOptions.thresholds.withSteps([
          g.panel.barGauge.standardOptions.threshold.step.withColor('green')
          + g.panel.barGauge.standardOptions.threshold.step.withValue(null),
          g.panel.barGauge.standardOptions.threshold.step.withColor('red')
          + g.panel.barGauge.standardOptions.threshold.step.withValue(80),
        ])
        + g.panel.barGauge.standardOptions.withUnit('trips')
        + g.panel.barGauge.options.reduceOptions.withCalcs(['lastNotNull'])
        + g.panel.barGauge.options.withOrientation('horizontal'),

      shardStatusPanel:
        g.panel.barGauge.new('Shard status')
        + g.panel.barGauge.panelOptions.withDescription('Shard status counts across the OpenSearch cluster.')
        + g.panel.barGauge.queryOptions.withDatasource('prometheus', '${prometheus_datasource}')
        + g.panel.barGauge.queryOptions.withTargets([
          signals.clusterOverview.cluster_shards_number_by_type.asTarget() { intervalFactor: 2 },
        ])
        + g.panel.barGauge.standardOptions.color.withMode('thresholds')
        + g.panel.barGauge.standardOptions.thresholds.withSteps([
          g.panel.barGauge.standardOptions.threshold.step.withColor('green')
          + g.panel.barGauge.standardOptions.threshold.step.withValue(null),
          g.panel.barGauge.standardOptions.threshold.step.withColor('red')
          + g.panel.barGauge.standardOptions.threshold.step.withValue(80),
        ])
        + g.panel.barGauge.standardOptions.withUnit('shards')
        + g.panel.barGauge.options.reduceOptions.withCalcs(['lastNotNull'])
        + g.panel.barGauge.options.withOrientation('horizontal'),

      topNodesByDiskUsagePanel:
        g.panel.barGauge.new('Top nodes by disk usage')
        + g.panel.barGauge.panelOptions.withDescription('Top nodes by disk usage across the OpenSearch cluster.')
        + g.panel.barGauge.queryOptions.withDatasource('prometheus', '${prometheus_datasource}')
        + g.panel.barGauge.queryOptions.withTargets([
          signals.clusterOverview.fs_path_used_percent_topk.asTarget() { intervalFactor: 2 },
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
        + g.panel.barGauge.options.reduceOptions.withCalcs(['lastNotNull'])
        + g.panel.barGauge.options.withOrientation('horizontal'),

      totalDocumentsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Total documents',
          targets=[signals.clusterOverview.indices_indexing_index_count_avg.asTarget() { intervalFactor: 2 }],
          description='The total count of documents indexed across the OpenSearch cluster.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('documents'),

      pendingTasksPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Pending tasks',
          targets=[signals.clusterOverview.cluster_pending_tasks_number.asTarget() { intervalFactor: 2 }],
          description='The number of tasks waiting to be executed across the OpenSearch cluster.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('tasks'),

      storeSizePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Store size',
          targets=[signals.clusterOverview.indices_store_size_bytes_avg.asTarget() { intervalFactor: 2 }],
          description='The total size of the store across the OpenSearch cluster.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('bytes'),

      maxTaskWaitTimePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Max task wait time',
          targets=[signals.clusterOverview.cluster_task_max_wait_seconds.asTarget()],
          description='The max wait time for tasks to be executed across the OpenSearch cluster.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('s'),

      topIndicesByRequestRatePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Top indices by request rate',
          targets=[signals.clusterOverview.search_current_inflight_topk.asTarget()],
          description='Top indices by combined fetch, query, and scroll request rate across the OpenSearch cluster.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps'),

      topIndicesByRequestLatencyPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Top indices by request latency',
          targets=[signals.clusterOverview.search_avg_latency_topk.asTarget() { interval: '2m' }],
          description='Top indices by combined fetch, query, and scroll latency across the OpenSearch cluster.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('s'),

      topIndicesByCombinedCacheHitRatioPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Top indices by combined cache hit ratio',
          targets=[signals.clusterOverview.request_query_cache_hit_rate_topk.asTarget() { intervalFactor: 2 }],
          description='Top indices by cache hit ratio for the combined request and query cache across the OpenSearch cluster.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      topNodesByIngestRatePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Top nodes by ingest rate',
          targets=[signals.clusterOverview.ingest_throughput_topk.asTarget() { intervalFactor: 2 }],
          description='Top nodes by rate of ingest across the OpenSearch cluster.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('Bps'),

      topNodesByIngestLatencyPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Top nodes by ingest latency',
          targets=[signals.clusterOverview.ingest_latency_topk.asTarget() { interval: '2m', intervalFactor: 2 }],
          description='Top nodes by ingestion latency across the OpenSearch cluster.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('s'),

      topNodesByIngestErrorsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Top nodes by ingest errors',
          targets=[signals.clusterOverview.ingest_failures_topk.asTarget() { interval: '2m', intervalFactor: 2 }],
          description='Top nodes by ingestion failures across the OpenSearch cluster.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('errors'),

      topIndicesByIndexRatePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Top indices by index rate',
          targets=[signals.clusterOverview.indexing_current_topk.asTarget() { intervalFactor: 2 }],
          description='Top indices by rate of document indexing across the OpenSearch cluster.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('documents/s'),

      topIndicesByIndexLatencyPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Top indices by index latency',
          targets=[signals.clusterOverview.indexing_latency_topk.asTarget() { interval: '2m', intervalFactor: 2 }],
          description='Top indices by indexing latency across the OpenSearch cluster.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('s'),

      topIndicesByIndexFailuresPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Top indices by index failures',
          targets=[signals.clusterOverview.indexing_failed_topk.asTarget() { interval: '2m', intervalFactor: 2 }],
          description='Top indices by index document failures across the OpenSearch cluster.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('failures'),

      // Node Overview Panels - Refactored to use modern patterns and signals
      // Node CPU usage
      nodeCpuUsage:
        commonlib.panels.generic.timeSeries.base.new(
          'Node CPU usage',
          targets=[signals.nodeOverview.os_cpu_percent.asTarget()],
          description="CPU usage percentage of the node's Operating System."
        )
        + g.panel.timeSeries.standardOptions.color.withMode('continuous-BlYlRd')
        + g.panel.timeSeries.standardOptions.withMax(100)
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(15)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('scheme'),

      // Node memory usage
      nodeMemoryUsage:
        commonlib.panels.generic.timeSeries.base.new(
          'Node memory usage',
          targets=[signals.nodeOverview.os_mem_used_percent.asTarget()],
          description='Memory usage percentage of the node for the operating system and OpenSearch'
        )
        + g.panel.timeSeries.standardOptions.color.withMode('continuous-BlYlRd')
        + g.panel.timeSeries.standardOptions.withMax(100)
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(15)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('scheme'),

      // Node I/O
      nodeIO:
        commonlib.panels.generic.timeSeries.base.new(
          'Node I/O',
          targets=[
            signals.nodeOverview.fs_read_bps.asTarget() { interval: '2m' },
            signals.nodeOverview.fs_write_bps.asTarget() { interval: '2m' },
          ],
          description='Node file system read and write data.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('Bps')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(15)
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
        + g.panel.timeSeries.standardOptions.withOverrides([
          g.panel.timeSeries.fieldOverride.byRegexp.new('/time|used|busy|util/')
          + g.panel.timeSeries.fieldOverride.byRegexp.withProperty('custom.axisSoftMax', 100)
          + g.panel.timeSeries.fieldOverride.byRegexp.withProperty('custom.drawStyle', 'points')
          + g.panel.timeSeries.fieldOverride.byRegexp.withProperty('unit', 'percent'),
        ]),

      // Node open connections
      nodeOpenConnections:
        commonlib.panels.generic.timeSeries.base.new(
          'Node open connections',
          targets=[signals.nodeOverview.transport_open_connections.asTarget()],
          description='Number of open connections for the selected node.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('connections')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(15)
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

      // Node disk usage
      nodeDiskUsage:
        commonlib.panels.generic.timeSeries.base.new(
          'Node disk usage',
          targets=[signals.nodeOverview.fs_used_percent.asTarget()],
          description='Disk usage percentage of the selected node.'
        )
        + g.panel.timeSeries.standardOptions.color.withMode('continuous-BlYlRd')
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withMax(100)
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(15)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('scheme'),

      // Node memory swap
      nodeMemorySwap:
        commonlib.panels.generic.timeSeries.base.new(
          'Node memory swap',
          targets=[signals.nodeOverview.os_swap_used_percent.asTarget()],
          description='Percentage of swap space used by OpenSearch and the operating system on the selected node.'
        )
        + g.panel.timeSeries.standardOptions.color.withMode('continuous-BlYlRd')
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withMax(100)
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(15)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('scheme'),

      // Node network traffic
      nodeNetworkTraffic:
        commonlib.panels.generic.timeSeries.base.new(
          'Node network traffic',
          targets=[
            signals.nodeOverview.transport_rx_bps.asTarget() { interval: '2m' },
            signals.nodeOverview.transport_tx_bps.asTarget() { interval: '2m' },
          ],
          description="Network traffic on the node's operating system."
        )
        + g.panel.timeSeries.standardOptions.withUnit('Bps')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(15)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('scheme'),

      // Circuit breakers
      circuitBreakers:
        commonlib.panels.generic.timeSeries.base.new(
          'Circuit breakers',
          targets=[signals.nodeOverview.circuitbreaker_tripped_sum_by_name.asTarget() { interval: '2m', intervalFactor: 2 }],
          description='Circuit breakers tripped on the selected node by type'
        )
        + g.panel.timeSeries.standardOptions.withUnit('trips')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(15)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('scheme'),


      // Node roles timeline
      nodeOSRolesTimeline:
        commonlib.panels.generic.statusHistory.base.new(
          'Roles timeline',
          targets=[
            signals.nodeOverview.node_role_data.asTarget(),
            signals.nodeOverview.node_role_master.asTarget(),
            signals.nodeOverview.node_role_ingest.asTarget(),
            signals.nodeOverview.node_role_cluster_manager.asTarget(),
            signals.nodeOverview.node_role_remote_cluster_client.asTarget(),
          ],
          description='OpenSearch node roles over time.'
        )
        + g.panel.statusHistory.queryOptions.withMaxDataPoints(100)
        + g.panel.statusHistory.options.withShowValue('never')
        + g.panel.statusHistory.options.withLegend(false)
        + g.panel.statusHistory.standardOptions.withMappings([
          {
            type: 'value',
            options: {
              '2': { color: 'light-purple', index: 0, text: 'data' },
              '3': { color: 'light-green', index: 1, text: 'master' },
              '4': { color: 'light-blue', index: 2, text: 'ingest' },
              '5': { color: 'light-yellow', index: 3, text: 'cluster_manager' },
              '6': { color: 'super-light-red', index: 4, text: 'remote_cluster_client' },
            },
          },
        ]),

      // JVM heap used vs committed
      jvmHeapUsedVsCommitted:
        commonlib.panels.generic.timeSeries.base.new(
          'JVM heap used vs committed',
          targets=[
            signals.nodeOverview.jvm_heap_used_bytes.asTarget() { intervalFactor: 2 },
            signals.nodeOverview.jvm_heap_committed_bytes.asTarget() { intervalFactor: 2 },
          ],
          description='JVM heap memory usage vs committed.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(5),

      // JVM non-heap used vs committed
      jvmNonheapUsedVsCommitted:
        commonlib.panels.generic.timeSeries.base.new(
          'JVM non-heap used vs committed',
          targets=[
            signals.nodeOverview.jvm_nonheap_used_bytes.asTarget() { intervalFactor: 2 },
            signals.nodeOverview.jvm_nonheap_committed_bytes.asTarget() { intervalFactor: 2 },
          ],
          description='JVM non-heap memory usage vs committed.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(5),

      // JVM threads
      jvmThreads:
        commonlib.panels.generic.timeSeries.base.new(
          'JVM threads',
          targets=[signals.nodeOverview.jvm_threads.asTarget() { intervalFactor: 2 }],
          description='JVM thread count.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('threads')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(5),

      // JVM buffer pools
      jvmBufferPools:
        commonlib.panels.generic.timeSeries.base.new(
          'JVM buffer pools',
          targets=[signals.nodeOverview.jvm_bufferpool_number.asTarget() { intervalFactor: 2 }],
          description='JVM buffer pool usage.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(5),

      // JVM uptime
      jvmUptime:
        commonlib.panels.generic.timeSeries.base.new(
          'JVM uptime',
          targets=[signals.nodeOverview.jvm_uptime.asTarget() { intervalFactor: 2 }],
          description='JVM uptime in seconds.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(5),

      // JVM garbage collections
      jvmGarbageCollections:
        commonlib.panels.generic.timeSeries.base.new(
          'JVM garbage collections',
          targets=[signals.nodeOverview.jvm_gc_collections.asTarget() { interval: '2m', intervalFactor: 2 }],
          description='JVM garbage collection count.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('collections')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(5),

      // JVM garbage collection time
      jvmGarbageCollectionTime:
        commonlib.panels.generic.timeSeries.base.new(
          'JVM garbage collection time',
          targets=[signals.nodeOverview.jvm_gc_time.asTarget() { interval: '2m', intervalFactor: 2 }],
          description='JVM garbage collection time in milliseconds.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(5),

      // JVM buffer pool usage
      jvmBufferPoolUsage:
        commonlib.panels.generic.timeSeries.base.new(
          'JVM buffer pool usage',
          targets=[signals.nodeOverview.jvm_bufferpool_used_percent.asTarget() { intervalFactor: 2 }],
          description='JVM buffer pool usage by pool.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(5),

      // Thread pool threads
      threadPoolThreads:
        commonlib.panels.generic.timeSeries.base.new(
          'Thread pool threads',
          targets=[signals.nodeOverview.threadpool_threads.asTarget() { intervalFactor: 2 }],
          description='Thread pool thread count.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('threads')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(5),

      // Thread pool tasks
      threadPoolTasks:
        commonlib.panels.generic.timeSeries.base.new(
          'Thread pool tasks',
          targets=[signals.nodeOverview.threadpool_tasks.asTarget() { intervalFactor: 2 }],
          description='Thread pool task count.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('tasks')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(5),


      // Search and Index Overview Panels - Refactored to use modern patterns and signals
      // Search Performance Panels
      searchRequestRatePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Request rate',
          targets=[
            signals.searchAndIndexOverview.search_query_current_avg.asTarget() { intervalFactor: 2 },
            signals.searchAndIndexOverview.search_fetch_current_avg.asTarget() { intervalFactor: 2 },
            signals.searchAndIndexOverview.search_scroll_current_avg.asTarget() { intervalFactor: 2 },
          ],
          description='Rate of fetch, scroll, and query requests by selected index.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps'),

      searchRequestLatencyPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Request latency',
          targets=[
            signals.searchAndIndexOverview.search_query_latency_avg.asTarget() { interval: '2m', intervalFactor: 2 },
            signals.searchAndIndexOverview.search_fetch_latency_avg.asTarget() { interval: '2m', intervalFactor: 2 },
            signals.searchAndIndexOverview.search_scroll_latency_avg.asTarget() { interval: '2m', intervalFactor: 2 },
          ],
          description='Latency of fetch, scroll, and query requests by selected index.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('s'),

      searchCacheHitRatioPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Cache hit ratio',
          targets=[
            signals.searchAndIndexOverview.request_cache_hit_rate.asTarget() { intervalFactor: 2 },
            signals.searchAndIndexOverview.query_cache_hit_rate.asTarget() { intervalFactor: 2 },
          ],
          description='Ratio of query cache and request cache hits and misses.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      searchCacheEvictionsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Evictions',
          targets=[
            signals.searchAndIndexOverview.query_cache_evictions.asTarget() { interval: '2m', intervalFactor: 2 },
            signals.searchAndIndexOverview.request_cache_evictions.asTarget() { interval: '2m', intervalFactor: 2 },
            signals.searchAndIndexOverview.fielddata_evictions.asTarget() { interval: '2m', intervalFactor: 2 },
          ],
          description='Total evictions count by cache type for the selected index.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('evictions')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.standardOptions.threshold.step.withColor('green')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(null),
          g.panel.timeSeries.standardOptions.threshold.step.withColor('red')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(80),
        ]),

      // Indexing Performance Panels
      indexingRatePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Index rate',
          targets=[signals.searchAndIndexOverview.indexing_current.asTarget() { intervalFactor: 2 }],
          description='Rate of indexed documents for the selected index.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('documents/s'),

      indexingLatencyPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Index latency',
          targets=[signals.searchAndIndexOverview.indexing_latency.asTarget() { interval: '2m', intervalFactor: 2 }],
          description='Document indexing latency for the selected index.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.standardOptions.threshold.step.withColor('green')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(null),
          g.panel.timeSeries.standardOptions.threshold.step.withColor('red')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(80),
        ]),

      indexingFailuresPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Index failures',
          targets=[signals.searchAndIndexOverview.indexing_failed.asTarget() { interval: '2m', intervalFactor: 2 }],
          description='Number of indexing failures for the selected index.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('failures')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.standardOptions.threshold.step.withColor('green')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(null),
          g.panel.timeSeries.standardOptions.threshold.step.withColor('red')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(80),
        ]),

      // Index Operations Panels
      flushLatencyPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Flush latency',
          targets=[signals.searchAndIndexOverview.flush_latency.asTarget() { interval: '2m', intervalFactor: 2 }],
          description='Index flush latency for the selected index.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.standardOptions.threshold.step.withColor('green')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(null),
          g.panel.timeSeries.standardOptions.threshold.step.withColor('red')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(80),
        ]),

      mergeTimePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Merge time',
          targets=[
            signals.searchAndIndexOverview.merge_time.asTarget() { interval: '2m', intervalFactor: 2 },
            signals.searchAndIndexOverview.merge_stopped_time.asTarget() { interval: '2m', intervalFactor: 2 },
            signals.searchAndIndexOverview.merge_throttled_time.asTarget() { interval: '2m', intervalFactor: 2 },
          ],
          description='Index merge time for the selected index.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withDrawStyle('points')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.standardOptions.threshold.step.withColor('green')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(null),
          g.panel.timeSeries.standardOptions.threshold.step.withColor('red')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(80),
        ]),

      refreshLatencyPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Refresh latency',
          targets=[signals.searchAndIndexOverview.refresh_latency.asTarget() { interval: '2m', intervalFactor: 2 }],
          description='Index refresh latency for the selected index.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.standardOptions.threshold.step.withColor('green')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(null),
          g.panel.timeSeries.standardOptions.threshold.step.withColor('red')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(80),
        ]),

      // Index Statistics Panels
      translogOperationsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Translog operations',
          targets=[signals.searchAndIndexOverview.translog_ops.asTarget() { intervalFactor: 2 }],
          description='Current number of translog operations for the selected index.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('operations')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.standardOptions.threshold.step.withColor('green')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(null),
          g.panel.timeSeries.standardOptions.threshold.step.withColor('red')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(80),
        ]),

      docsDeletedPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Docs deleted',
          targets=[signals.searchAndIndexOverview.indexing_delete_current.asTarget() { intervalFactor: 2 }],
          description='Rate of documents deleted for the selected index.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('documents/s')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.standardOptions.threshold.step.withColor('green')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(null),
          g.panel.timeSeries.standardOptions.threshold.step.withColor('red')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(80),
        ]),

      documentsIndexedPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Documents indexed',
          targets=[signals.searchAndIndexOverview.indexing_count.asTarget() { intervalFactor: 2 }],
          description='Number of indexed documents for the selected index.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('documents')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.standardOptions.threshold.step.withColor('green')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(null),
          g.panel.timeSeries.standardOptions.threshold.step.withColor('red')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(80),
        ]),

      // Index Structure Panels
      segmentCountPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Segment count',
          targets=[signals.searchAndIndexOverview.segments_number.asTarget() { intervalFactor: 2 }],
          description='Current number of segments for the selected index.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('segments')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.standardOptions.threshold.step.withColor('green')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(null),
          g.panel.timeSeries.standardOptions.threshold.step.withColor('red')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(80),
        ]),

      mergeCountPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Merge count',
          targets=[signals.searchAndIndexOverview.merge_docs.asTarget() { intervalFactor: 2 }],
          description='Number of merge operations for the selected index.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('merges')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withDrawStyle('points')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.standardOptions.threshold.step.withColor('green')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(null),
          g.panel.timeSeries.standardOptions.threshold.step.withColor('red')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(80),
        ]),

      // Cache and Memory Panels
      cacheSizePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Cache size',
          targets=[
            signals.searchAndIndexOverview.query_cache_memory.asTarget() { intervalFactor: 2 },
            signals.searchAndIndexOverview.request_cache_memory.asTarget() { intervalFactor: 2 },
          ],
          description='Size of query cache and request cache.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.standardOptions.threshold.step.withColor('green')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(null),
          g.panel.timeSeries.standardOptions.threshold.step.withColor('red')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(80),
        ]),

      searchAndIndexStoreSizePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Store size',
          targets=[signals.searchAndIndexOverview.store_size_bytes.asTarget() { intervalFactor: 2 }],
          description='Size of the store in bytes for the selected index.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.standardOptions.threshold.step.withColor('green')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(null),
          g.panel.timeSeries.standardOptions.threshold.step.withColor('red')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(80),
        ]),

      segmentSizePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Segment size',
          targets=[signals.searchAndIndexOverview.segments_memory_bytes.asTarget() { intervalFactor: 2 }],
          description='Memory used by segments for the selected index.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.standardOptions.threshold.step.withColor('green')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(null),
          g.panel.timeSeries.standardOptions.threshold.step.withColor('red')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(80),
        ]),

      mergeSizePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Merge size',
          targets=[signals.searchAndIndexOverview.merge_current_size.asTarget() { intervalFactor: 2 }],
          description='Size of merge operations in bytes for the selected index.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withDrawStyle('points')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.standardOptions.threshold.step.withColor('green')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(null),
          g.panel.timeSeries.standardOptions.threshold.step.withColor('red')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(80),
        ]),

      searchAndIndexShardCountPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Shard count',
          targets=[signals.searchAndIndexOverview.shards_per_index.asTarget() { intervalFactor: 2 }],
          description='The number of index shards for the selected index.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('shards')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.standardOptions.threshold.step.withColor('green')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(null),
          g.panel.timeSeries.standardOptions.threshold.step.withColor('red')
          + g.panel.timeSeries.standardOptions.threshold.step.withValue(80),
        ]),
    },
}
