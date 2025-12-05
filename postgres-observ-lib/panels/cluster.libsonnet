local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(signals, config):: {
    clusterStatus:
      signals.cluster.clusterStatus.asStat()
      + commonlib.panels.generic.stat.info.stylize()
      + g.panel.stat.options.withGraphMode('none')
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.options.withColorMode('value')
      + g.panel.stat.standardOptions.thresholds.withSteps([
        { value: 0, color: 'red' },
        { value: 1, color: 'green' },
      ])
      + g.panel.stat.standardOptions.withMappings([
        {
          type: 'value',
          options: {
            '0': { text: 'DOWN', color: 'red', index: 0 },
            '1': { text: 'UP', color: 'green', index: 1 },
          },
        },
      ])
      + g.panel.stat.panelOptions.withDescription(
        'Cluster status. Shows DOWN if any instance in the cluster is down.'
      ),

    // Total instances
    totalInstances:
      signals.cluster.totalInstances.asStat()
      + commonlib.panels.generic.stat.info.stylize()
      + g.panel.stat.options.withGraphMode('none')
      + g.panel.stat.panelOptions.withDescription(
        'Total number of PostgreSQL instances in the cluster.'
      ),

    // Up instances
    upInstances:
      signals.cluster.upInstances.asStat()
      + commonlib.panels.generic.stat.info.stylize()
      + g.panel.stat.options.withGraphMode('none')
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.options.withColorMode('value')
      + g.panel.stat.panelOptions.withDescription(
        'Number of instances currently up and responding.'
      ),

    // Primary count
    primaryCount:
      signals.cluster.primaryCount.asStat()
      + commonlib.panels.generic.stat.info.stylize()
      + g.panel.stat.options.withGraphMode('none')
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.options.withColorMode('value')
      + g.panel.stat.standardOptions.thresholds.withSteps([
        { value: 0, color: 'red' },  // No primary = critical
        { value: 1, color: 'green' },  // Exactly 1 = healthy
        { value: 2, color: 'yellow' },  // Multiple primaries = split brain warning
      ])
      + g.panel.stat.panelOptions.withDescription(
        'Number of primary instances. Should be exactly 1 for a healthy cluster.'
      ),

    // Replica count
    replicaCount:
      signals.cluster.replicaCount.asStat()
      + commonlib.panels.generic.stat.info.stylize()
      + g.panel.stat.options.withGraphMode('none')
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.options.withColorMode('value')
      + g.panel.stat.standardOptions.thresholds.withSteps([
        { value: 0, color: 'yellow' },  // No replicas = warning
        { value: 1, color: 'green' },  // At least 1 = good
      ])
      + g.panel.stat.panelOptions.withDescription(
        'Number of replica instances in the cluster.'
      ),

    // Max replication lag
    maxReplicationLag:
      signals.cluster.maxReplicationLag.asStat()
      + commonlib.panels.generic.stat.info.stylize()
      + g.panel.stat.standardOptions.withUnit('s')
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.options.withColorMode('value')
      + g.panel.stat.standardOptions.thresholds.withSteps([
        { value: 0, color: 'green' },
        { value: 5, color: 'yellow' },
        { value: 30, color: 'orange' },
        { value: 60, color: 'red' },
      ])
      + g.panel.stat.panelOptions.withDescription(
        'Maximum replication lag in seconds across all replicas.'
      ),

    worstCacheHitRatio:
      signals.cluster.worstCacheHitRatio.asGauge()
      + g.panel.gauge.standardOptions.withUnit('percentunit')
      + g.panel.gauge.standardOptions.withMin(0)
      + g.panel.gauge.standardOptions.withMax(1)
      + g.panel.gauge.standardOptions.thresholds.withSteps([
        { value: 0, color: 'red' },
        { value: 0.8, color: 'orange' },
        { value: 0.9, color: 'yellow' },
        { value: 0.95, color: 'green' },
      ])
      + g.panel.gauge.options.withMinVizHeight(200)
      + g.panel.gauge.options.withMinVizWidth(200)
      + g.panel.gauge.options.withShowThresholdLabels(false)
      + g.panel.gauge.panelOptions.withDescription(
        'Lowest cache hit ratio across all instances.'
      ),

    worstConnectionUtilization:
      signals.cluster.worstConnectionUtilization.asGauge()
      + g.panel.gauge.standardOptions.withUnit('percentunit')
      + g.panel.gauge.standardOptions.withMin(0)
      + g.panel.gauge.standardOptions.withMax(1)
      + g.panel.gauge.standardOptions.thresholds.withSteps([
        { value: 0, color: 'green' },
        { value: 0.7, color: 'yellow' },
        { value: 0.85, color: 'orange' },
        { value: 0.95, color: 'red' },
      ])
      + g.panel.gauge.options.withMinVizHeight(200)
      + g.panel.gauge.options.withMinVizWidth(200)
      + g.panel.gauge.options.withShowThresholdLabels(false)
      + g.panel.gauge.panelOptions.withDescription(
        'Highest connection utilization across all instances.'
      ),

    // Total deadlocks
    totalDeadlocks:
      signals.cluster.totalDeadlocks.asStat()
      + commonlib.panels.generic.stat.info.stylize()
      + g.panel.stat.options.withReduceOptions({ calcs: ['diff'] })
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.options.withColorMode('value')
      + g.panel.stat.standardOptions.thresholds.withSteps([
        { value: 0, color: 'green' },
        { value: 1, color: 'red' },
      ])
      + g.panel.stat.panelOptions.withDescription(
        'Total deadlocks detected across all instances in the selected time range.'
      ),

    instanceTable:
      g.panel.table.new('Cluster Instances')
      + g.panel.table.panelOptions.withDescription(
        'All PostgreSQL instances in the cluster. Click a row to view instance details.'
      )
      + g.panel.table.queryOptions.withTargets([
        // Instance status
        signals.cluster.instanceStatus.asTarget()
        + g.query.prometheus.withFormat('table')
        + g.query.prometheus.withInstant(true),
        // Instance role
        signals.cluster.instanceRole.asTarget()
        + g.query.prometheus.withFormat('table')
        + g.query.prometheus.withInstant(true),
        // Instance uptime
        signals.cluster.instanceUptime.asTarget()
        + g.query.prometheus.withFormat('table')
        + g.query.prometheus.withInstant(true),
        // Instance connection utilization
        signals.cluster.instanceConnectionUtilization.asTarget()
        + g.query.prometheus.withFormat('table')
        + g.query.prometheus.withInstant(true),
        // Instance cache hit ratio
        signals.cluster.instanceCacheHitRatio.asTarget()
        + g.query.prometheus.withFormat('table')
        + g.query.prometheus.withInstant(true),
        // Instance replication lag
        signals.cluster.instanceReplicationLag.asTarget()
        + g.query.prometheus.withFormat('table')
        + g.query.prometheus.withInstant(true),
      ])
      + g.panel.table.queryOptions.withTransformations([
        // Merge all queries by instance
        g.panel.table.transformation.withId('merge'),
        // Organize fields
        g.panel.table.transformation.withId('organize')
        + g.panel.table.transformation.withOptions({
          excludeByName: {
            Time: true,
            __name__: true,
            job: true,
            cluster: true,
            server_id: true,
            environment: true,
          },
          renameByName: {
            instance: 'Instance',
            'Value #Instance status': 'Status',
            'Value #Instance role': 'Role',
            'Value #Instance uptime': 'Uptime',
            'Value #Instance connection utilization': 'Conn %',
            'Value #Instance cache hit ratio': 'Cache %',
            'Value #Instance replication lag': 'Lag',
          },
          indexByName: {
            instance: 0,
            'Value #Instance role': 1,
            'Value #Instance status': 2,
            'Value #Instance uptime': 3,
            'Value #Instance connection utilization': 4,
            'Value #Instance cache hit ratio': 5,
            'Value #Instance replication lag': 6,
          },
        }),
      ])
      + g.panel.table.standardOptions.withOverrides([
        // Instance column - auto width to fill space
        {
          matcher: { id: 'byName', options: 'Instance' },
          properties: [
            { id: 'custom.width', value: 400 },
          ],
        },
        // Status column
        {
          matcher: { id: 'byName', options: 'Status' },
          properties: [
            { id: 'mappings', value: [
              { type: 'value', options: { '0': { text: '🔴 DOWN', color: 'red' }, '1': { text: '🟢 UP', color: 'green' } } },
            ] },
            { id: 'custom.cellOptions', value: { type: 'color-text' } },
            { id: 'custom.width', value: 80 },
          ],
        },
        // Role column
        {
          matcher: { id: 'byName', options: 'Role' },
          properties: [
            { id: 'mappings', value: [
              { type: 'value', options: { '0': { text: 'PRIMARY', color: 'blue' }, '1': { text: 'REPLICA', color: 'purple' } } },
            ] },
            { id: 'custom.cellOptions', value: { type: 'color-text' } },
            { id: 'custom.width', value: 100 },
          ],
        },
        // Uptime column
        {
          matcher: { id: 'byName', options: 'Uptime' },
          properties: [
            { id: 'unit', value: 'dtdurations' },
            { id: 'custom.width', value: 100 },
          ],
        },
        // Conn % column
        {
          matcher: { id: 'byName', options: 'Conn %' },
          properties: [
            { id: 'unit', value: 'percentunit' },
            { id: 'custom.cellOptions', value: { type: 'gauge', mode: 'lcd' } },
            { id: 'thresholds', value: { mode: 'absolute', steps: [
              { value: null, color: 'green' },
              { value: 0.7, color: 'yellow' },
              { value: 0.85, color: 'red' },
            ] } },
            { id: 'min', value: 0 },
            { id: 'max', value: 1 },
            { id: 'custom.width', value: 200 },
          ],
        },
        // Cache % column - thresholds match instance dashboard
        {
          matcher: { id: 'byName', options: 'Cache %' },
          properties: [
            { id: 'unit', value: 'percentunit' },
            { id: 'custom.cellOptions', value: { type: 'gauge', mode: 'lcd' } },
            { id: 'thresholds', value: { mode: 'absolute', steps: [
              { value: null, color: 'red' },
              { value: 0.8, color: 'orange' },
              { value: 0.9, color: 'yellow' },
              { value: 0.95, color: 'green' },
            ] } },
            { id: 'min', value: 0 },
            { id: 'max', value: 1 },
            { id: 'custom.width', value: 200 },
          ],
        },
        // Lag column
        {
          matcher: { id: 'byName', options: 'Lag' },
          properties: [
            { id: 'unit', value: 's' },
            { id: 'custom.cellOptions', value: { type: 'color-text' } },
            { id: 'thresholds', value: { mode: 'absolute', steps: [
              { value: null, color: 'green' },
              { value: 5, color: 'yellow' },
              { value: 30, color: 'red' },
            ] } },
            { id: 'custom.width', value: 80 },
          ],
        },
      ])
      + g.panel.table.options.withFooter({ enablePagination: false })
      + {
        // Add data links to drill down to instance dashboard
        fieldConfig+: {
          defaults+: {
            links: [
              {
                title: 'View Instance Details',
                url: '/d/' + config.uid + '-overview?var-instance=${__data.fields.Instance}&${__url_time_range}',
              },
            ],
          },
        },
      },

    currentPrimary:
      signals.cluster.currentPrimary.asStat()
      + commonlib.panels.generic.stat.info.stylize()
      + g.panel.stat.options.withGraphMode('none')
      + g.panel.stat.options.withTextMode('name')
      + g.panel.stat.options.withColorMode('background')
      + g.panel.stat.standardOptions.color.withMode('fixed')
      + g.panel.stat.standardOptions.color.withFixedColor('blue')
      + g.panel.stat.panelOptions.withDescription(
        'The instance currently acting as primary.'
      ),

    // Primary role history (state timeline)
    primaryRoleHistory:
      g.panel.stateTimeline.new('Primary Role History')
      + g.panel.stateTimeline.panelOptions.withDescription(
        'Timeline showing the role of each instance. Blue = Primary, Purple = Replica. Role changes indicate failover events.'
      )
      + signals.cluster.instanceRole.asPanelMixin()
      + g.panel.stateTimeline.options.withShowValue('never')
      + g.panel.stateTimeline.options.withAlignValue('center')
      + g.panel.stateTimeline.options.withMergeValues(true)
      + g.panel.stateTimeline.options.withRowHeight(0.8)
      + g.panel.stateTimeline.standardOptions.withMappings([
        {
          type: 'value',
          options: {
            '0': { text: 'PRIMARY', color: 'blue', index: 0 },
            '1': { text: 'REPLICA', color: 'purple', index: 1 },
          },
        },
      ])
      + g.panel.stateTimeline.options.legend.withShowLegend(true)
      + g.panel.stateTimeline.options.legend.withDisplayMode('list'),

    // Role changes / failover events
    failoverEvents:
      signals.cluster.roleChanges.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.panelOptions.withTitle('Failover Events')
      + g.panel.timeSeries.panelOptions.withDescription(
        'Detects role changes (failovers). Spikes indicate when an instance changed role.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('short')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withDrawStyle('bars')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(80)
      + g.panel.timeSeries.standardOptions.thresholds.withSteps([
        { value: 0, color: 'green' },
        { value: 1, color: 'red' },
      ])
      + g.panel.timeSeries.standardOptions.color.withMode('thresholds'),

    replicationLagTimeSeries:
      signals.cluster.replicationLagByInstance.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.panelOptions.withTitle('Replication Lag by Instance')
      + g.panel.timeSeries.panelOptions.withDescription(
        'Replication lag in seconds per replica instance.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('s')
      + g.panel.timeSeries.standardOptions.thresholds.withSteps([
        { value: 0, color: 'green' },
        { value: 5, color: 'yellow' },
        { value: 30, color: 'red' },
      ])
      + g.panel.timeSeries.fieldConfig.defaults.custom.thresholdsStyle.withMode('line'),

    // Replication slot lag by instance (time series)
    replicationSlotLagTimeSeries:
      signals.cluster.replicationSlotLagByInstance.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.panelOptions.withTitle('Replication Slot Lag')
      + g.panel.timeSeries.panelOptions.withDescription(
        'WAL bytes pending per replication slot. High values indicate slow replicas.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('bytes')
      + g.panel.timeSeries.standardOptions.thresholds.withSteps([
        { value: 0, color: 'green' },
        { value: 10485760, color: 'yellow' },  // 10MB
        { value: 104857600, color: 'red' },  // 100MB
      ])
      + g.panel.timeSeries.fieldConfig.defaults.custom.thresholdsStyle.withMode('line'),

    // WAL position (time series)
    walPositionTimeSeries:
      signals.cluster.walPosition.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.panelOptions.withTitle('WAL Position')
      + g.panel.timeSeries.panelOptions.withDescription(
        'Current WAL LSN position on the primary. Shows total WAL written over time.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('bytes')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('scheme'),

    totalLongRunningQueries:
      signals.cluster.totalLongRunningQueries.asStat()
      + commonlib.panels.generic.stat.info.stylize()
      + g.panel.stat.options.withGraphMode('area')
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.options.withColorMode('value')
      + g.panel.stat.standardOptions.thresholds.withSteps([
        { value: 0, color: 'green' },
        { value: 1, color: 'yellow' },
        { value: 3, color: 'red' },
      ])
      + g.panel.stat.panelOptions.withDescription(
        'Total queries running longer than threshold across all instances.'
      ),

    // Total blocked queries
    totalBlockedQueries:
      signals.cluster.totalBlockedQueries.asStat()
      + commonlib.panels.generic.stat.info.stylize()
      + g.panel.stat.options.withGraphMode('area')
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.options.withColorMode('value')
      + g.panel.stat.standardOptions.thresholds.withSteps([
        { value: 0, color: 'green' },
        { value: 1, color: 'yellow' },
        { value: 5, color: 'red' },
      ])
      + g.panel.stat.panelOptions.withDescription(
        'Total queries waiting for locks across all instances.'
      ),

    // Total idle in transaction
    totalIdleInTransaction:
      signals.cluster.totalIdleInTransaction.asStat()
      + commonlib.panels.generic.stat.info.stylize()
      + g.panel.stat.options.withGraphMode('area')
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.options.withColorMode('value')
      + g.panel.stat.standardOptions.thresholds.withSteps([
        { value: 0, color: 'green' },
        { value: 5, color: 'yellow' },
        { value: 20, color: 'red' },
      ])
      + g.panel.stat.panelOptions.withDescription(
        'Total connections idle in transaction across all instances.'
      ),

    // Total WAL archive failures
    totalWalArchiveFailures:
      signals.cluster.totalWalArchiveFailures.asStat()
      + commonlib.panels.generic.stat.info.stylize()
      + g.panel.stat.options.withReduceOptions({ calcs: ['diff'] })
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.options.withColorMode('value')
      + g.panel.stat.standardOptions.thresholds.withSteps([
        { value: 0, color: 'green' },
        { value: 1, color: 'red' },
      ])
      + g.panel.stat.panelOptions.withDescription(
        'Total WAL archive failures across all instances.'
      ),

    worstLockUtilization:
      signals.cluster.worstLockUtilization.asGauge()
      + g.panel.gauge.standardOptions.withUnit('percentunit')
      + g.panel.gauge.standardOptions.withMin(0)
      + g.panel.gauge.standardOptions.withMax(1)
      + g.panel.gauge.standardOptions.color.withMode('thresholds')
      + g.panel.gauge.standardOptions.thresholds.withSteps([
        { value: 0, color: 'green' },
        { value: 0.05, color: 'yellow' },
        { value: 0.1, color: 'orange' },
        { value: 0.2, color: 'red' },
      ])
      + g.panel.gauge.options.withMinVizHeight(150)
      + g.panel.gauge.options.withMinVizWidth(150)
      + g.panel.gauge.options.withShowThresholdLabels(false)
      + g.panel.gauge.panelOptions.withDescription(
        'Highest lock utilization across all instances.'
      ),

    // Total exporter errors
    totalExporterErrors:
      signals.cluster.totalExporterErrors.asStat()
      + commonlib.panels.generic.stat.info.stylize()
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.options.withColorMode('value')
      + g.panel.stat.standardOptions.thresholds.withSteps([
        { value: 0, color: 'green' },
        { value: 1, color: 'red' },
      ])
      + g.panel.stat.panelOptions.withDescription(
        'Total exporter scrape errors across all instances.'
      ),

    writeOperations:
      g.panel.timeSeries.new('Write Operations (Primary)')
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.panelOptions.withDescription(
        'Write operations (INSERT, UPDATE, DELETE) from the primary instance only.'
      )
      + signals.cluster.primaryInserts.asPanelMixin()
      + signals.cluster.primaryUpdates.asPanelMixin()
      + signals.cluster.primaryDeletes.asPanelMixin()
      + g.panel.timeSeries.standardOptions.withUnit('rows/s')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withStacking({ mode: 'normal' })
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(50),

    // Read operations per instance
    readOperations:
      signals.cluster.readsByInstance.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.panelOptions.withTitle('Read Operations by Instance')
      + g.panel.timeSeries.panelOptions.withDescription(
        'Rows fetched per second per instance. Shows read distribution across primary and replicas.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('rows/s'),

    // TPS per instance
    tpsByInstance:
      signals.cluster.tpsByInstance.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.panelOptions.withTitle('TPS by Instance')
      + g.panel.timeSeries.panelOptions.withDescription(
        'Transactions per second per instance. Compare workload distribution.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('ops'),

    // QPS by instance (requires pg_stat_statements)
    qpsByInstance:
      signals.cluster.qpsByInstance.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.panelOptions.withTitle('QPS by Instance')
      + g.panel.timeSeries.panelOptions.withDescription(
        'Queries per second per instance. Requires pg_stat_statements extension.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('ops'),

    // Read/Write ratio pie chart
    readWriteRatio:
      g.panel.pieChart.new('Read/Write Ratio')
      + g.panel.pieChart.panelOptions.withDescription(
        'Ratio of read operations to write operations cluster-wide.'
      )
      + signals.cluster.totalReads.asPanelMixin()
      + signals.cluster.totalWrites.asPanelMixin()
      + g.panel.pieChart.options.withPieType('donut')
      + g.panel.pieChart.options.withDisplayLabels([])  // No labels on the chart itself
      + g.panel.pieChart.options.legend.withShowLegend(true)
      + g.panel.pieChart.options.legend.withDisplayMode('table')
      + g.panel.pieChart.options.legend.withPlacement('right')
      + g.panel.pieChart.options.legend.withValues(['value', 'percent'])
      + g.panel.pieChart.options.legend.withWidth(350)  // Wider legend
      + g.panel.pieChart.standardOptions.withUnit('rows/s'),

    totalConnectionsTimeSeries:
      g.panel.timeSeries.new('Total Connections')
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.panelOptions.withDescription(
        'Total connections across all instances vs total max connections.'
      )
      + signals.cluster.totalConnections.asPanelMixin()
      + signals.cluster.totalMaxConnections.asPanelMixin()
      + g.panel.timeSeries.standardOptions.withUnit('short')
      + g.panel.timeSeries.standardOptions.withOverrides([
        {
          matcher: { id: 'byName', options: 'Total max connections' },
          properties: [
            { id: 'custom.lineStyle', value: { fill: 'dash', dash: [10, 10] } },
            { id: 'custom.fillOpacity', value: 0 },
          ],
        },
      ]),

    // Cache hit ratio by instance
    cacheHitRatioByInstanceTimeSeries:
      signals.cluster.cacheHitRatioByInstance.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.panelOptions.withTitle('Cache Hit Ratio by Instance')
      + g.panel.timeSeries.panelOptions.withDescription(
        'Cache hit ratio per instance over time.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('percentunit')
      + g.panel.timeSeries.standardOptions.withMin(0)
      + g.panel.timeSeries.standardOptions.withMax(1)
      + g.panel.timeSeries.standardOptions.thresholds.withSteps([
        { value: 0, color: 'red' },
        { value: 0.9, color: 'yellow' },
        { value: 0.95, color: 'green' },
      ])
      + g.panel.timeSeries.fieldConfig.defaults.custom.thresholdsStyle.withMode('line'),

    // Total database size
    totalDatabaseSize:
      signals.cluster.totalDatabaseSize.asStat()
      + commonlib.panels.generic.stat.info.stylize()
      + g.panel.stat.options.withGraphMode('area')
      + g.panel.stat.standardOptions.withUnit('bytes')
      + g.panel.stat.panelOptions.withDescription(
        'Total size of all databases on the primary.'
      ),

    // WAL position time series (already defined above, reuse)
    // walPositionTimeSeries is defined in Row 4
  },
}
