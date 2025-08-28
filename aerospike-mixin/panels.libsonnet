local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this)::
    {
      local signals = this.signals,

      // ==========================
      // Overview Dashboard
      // ==========================

      nodesPanel:
        commonlib.panels.generic.table.base.new(
          'Nodes',
          targets=[
            signals.overview.nodesClusterSize.asTableTarget()
            + g.query.prometheus.withLegendFormat(''),  // Clear legend format for table
          ],
          description='Number of nodes in an Aerospike cluster.'
        )
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Value')
          + g.panel.table.fieldOverride.byName.withProperty('custom.hidden', true),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Time')
          + g.panel.table.fieldOverride.byName.withProperty('custom.hidden', true),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('instance')
          + g.panel.table.fieldOverride.byName.withProperty('displayName', 'Instance')
          + g.panel.table.fieldOverride.byName.withProperty('custom.filterable', true)
          + g.panel.table.fieldOverride.byName.withProperty('links', [
            {
              title: 'Instance overview',
              url: '/d/aerospike_instance_overview?var-instance=${__data.fields.Instance}&${__url_time_range}&var-datasource=${datasource}',
            },
          ]),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('aerospike_cluster')
          + g.panel.table.fieldOverride.byName.withProperty('displayName', 'Aerospike cluster'),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('job')
          + g.panel.table.fieldOverride.byName.withProperty('custom.hidden', true),
        ])
        + g.panel.table.options.withCellHeight('md')
        + g.panel.table.options.footer.withCountRows(false)
        + g.panel.table.options.footer.withFields([])
        + g.panel.table.options.footer.withReducer(['sum'])
        + g.panel.table.options.footer.withShow(false)
        + g.panel.table.options.withShowHeader(true)
        + g.panel.table.queryOptions.withTransformations([
          {
            id: 'sortBy',
            options: {
              fields: {},
              sort: [
                {
                  desc: true,
                  field: 'Time',
                },
              ],
            },
          },
        ]),

      namespacesPanel:
        commonlib.panels.generic.table.base.new(
          'Namespaces',
          targets=[
            signals.overview.namespacesClusterSize.asTableTarget()
            + g.query.prometheus.withLegendFormat(''),  // Clear legend format for table
          ],
          description='Number of namespaces in an Aerospike cluster.'
        )
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Value')
          + g.panel.table.fieldOverride.byName.withProperty('custom.hidden', true),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Time')
          + g.panel.table.fieldOverride.byName.withProperty('custom.hidden', true),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('aerospike_cluster')
          + g.panel.table.fieldOverride.byName.withProperty('displayName', 'Aerospike cluster'),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('instance')
          + g.panel.table.fieldOverride.byName.withProperty('displayName', 'Instance')
          + g.panel.table.fieldOverride.byName.withProperty('links', [
            {
              title: 'Instance overview',
              url: '/d/aerospike_instance_overview?var-instance=${__data.fields.Instance}&${__url_time_range}&var-datasource=${datasource}',
            },
          ]),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('ns')
          + g.panel.table.fieldOverride.byName.withProperty('displayName', 'Namespace')
          + g.panel.table.fieldOverride.byName.withProperty('links', [
            {
              title: 'Namespace overview',
              url: '/d/aerospike_namespace_overview?var-ns=${__data.fields.ns}&${__url_time_range}&var-datasource=${datasource}',
            },
          ]),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('job')
          + g.panel.table.fieldOverride.byName.withProperty('custom.hidden', true),
        ]),

      unavailablePartitionsPanel:
        commonlib.panels.generic.stat.info.new(
          'Unavailable partitions',
          targets=[signals.overview.unavailablePartitions.asTarget()],
          description='Number of unavailable partitions in Aerospike namespaces'
        )
        + g.panel.stat.standardOptions.withUnit('short')
        + { type: 'bargauge' }
        + g.panel.barGauge.standardOptions.color.withMode('fixed')
        + g.panel.barGauge.standardOptions.color.withFixedColor('green'),

      deadPartitionsPanel:
        commonlib.panels.generic.stat.info.new(
          'Dead partitions',
          targets=[signals.overview.deadPartitions.asTarget()],
          description='Number of dead partitions in Aerospike namespaces'
        )
        + g.panel.stat.standardOptions.withUnit('short')
        + { type: 'bargauge' }
        + g.panel.barGauge.standardOptions.color.withMode('fixed')
        + g.panel.barGauge.standardOptions.color.withFixedColor('green'),

      topNodesByMemoryUsagePanel:
        commonlib.panels.generic.table.base.new(
          'Top nodes by memory usage',
          targets=[
            signals.overview.topNodesByMemoryUsage.asTableTarget() { interval: '1m' }
            + g.query.prometheus.withLegendFormat(''),  // Clear legend format for table
          ],
          description='Memory utilization for the top k nodes in an Aerospike cluster.'
        )
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Value')
          + g.panel.table.fieldOverride.byName.withProperty('displayName', 'Usage')
          + g.panel.table.fieldOverride.byName.withProperty('unit', 'percent'),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Time')
          + g.panel.table.fieldOverride.byName.withProperty('custom.hidden', true),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('aerospike_cluster')
          + g.panel.table.fieldOverride.byName.withProperty('displayName', 'Aerospike cluster'),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('instance')
          + g.panel.table.fieldOverride.byName.withProperty('displayName', 'Instance')
          + g.panel.table.fieldOverride.byName.withProperty('links', [
            {
              title: 'Instance overview',
              url: '/d/aerospike_instance_overview?var-instance=${__data.fields.Instance}&${__url_time_range}&var-datasource=${datasource}',
            },
          ]),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('job')
          + g.panel.table.fieldOverride.byName.withProperty('custom.hidden', true),
        ]),

      topNodesByDiskUsagePanel:
        commonlib.panels.generic.table.base.new(
          'Top nodes by disk usage',
          targets=[
            signals.overview.topNodesByDiskUsage.asTableTarget() { interval: '1m' }
            + g.query.prometheus.withLegendFormat(''),  // Clear legend format for table
          ],
          description='Disk utilization for the top k nodes in an Aerospike cluster. Compatible with Aerospike versions < 7.0 using legacy metrics.'
        )
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Value')
          + g.panel.table.fieldOverride.byName.withProperty('displayName', 'Usage')
          + g.panel.table.fieldOverride.byName.withProperty('unit', 'percent'),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Time')
          + g.panel.table.fieldOverride.byName.withProperty('custom.hidden', true),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('aerospike_cluster')
          + g.panel.table.fieldOverride.byName.withProperty('displayName', 'Aerospike cluster'),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('instance')
          + g.panel.table.fieldOverride.byName.withProperty('displayName', 'Instance')
          + g.panel.table.fieldOverride.byName.withProperty('links', [
            {
              title: 'Instance overview',
              url: '/d/aerospike_instance_overview?var-instance=${__data.fields.instance}&${__url_time_range}&var-datasource=${datasource}',
            },
          ]),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('job')
          + g.panel.table.fieldOverride.byName.withProperty('custom.hidden', true),
        ]),

      topNodesByDiskUsage7Panel:
        commonlib.panels.generic.table.base.new(
          'Top nodes by disk usage',
          targets=[
            signals.overview.topNodesByDiskUsage7.asTableTarget() { interval: '1m' }
            + g.query.prometheus.withLegendFormat(''),  // Clear legend format for table
          ],
          description='Disk utilization for the top k nodes in an Aerospike cluster. Compatible with Database 7.0+ using data_used_pct metric.'
        )
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Value')
          + g.panel.table.fieldOverride.byName.withProperty('displayName', 'Usage')
          + g.panel.table.fieldOverride.byName.withProperty('unit', 'percent'),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Time')
          + g.panel.table.fieldOverride.byName.withProperty('custom.hidden', true),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('aerospike_cluster')
          + g.panel.table.fieldOverride.byName.withProperty('displayName', 'Aerospike cluster'),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('instance')
          + g.panel.table.fieldOverride.byName.withProperty('displayName', 'Instance')
          + g.panel.table.fieldOverride.byName.withProperty('links', [
            {
              title: 'Instance overview',
              url: '/d/aerospike_instance_overview?var-instance=${__data.fields.instance}&${__url_time_range}&var-datasource=${datasource}',
            },
          ]),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('job')
          + g.panel.table.fieldOverride.byName.withProperty('custom.hidden', true),
        ]),

      readTransactionsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Client reads',
          targets=[
            signals.overview.clientReadSuccess.asTarget() { interval: '1m' },
            signals.overview.clientReadError.asTarget() { interval: '1m' },
            signals.overview.clientReadTimeout.asTarget() { interval: '1m' },
            signals.overview.clientReadNotFound.asTarget() { interval: '1m' },
            signals.overview.clientReadFiltered.asTarget() { interval: '1m' },
          ],
          description='Rate of client read transactions in an Aerospike cluster organized by result.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.options.legend.withCalcs(['min', 'mean', 'max'])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      writeTransactionsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Client writes',
          targets=[
            signals.overview.clientWriteSuccess.asTarget() { interval: '1m' },
            signals.overview.clientWriteError.asTarget() { interval: '1m' },
            signals.overview.clientWriteTimeout.asTarget() { interval: '1m' },
            signals.overview.clientWriteFiltered.asTarget() { interval: '1m' },
          ],
          description='Rate of client write transactions in an Aerospike cluster organized by result.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.options.legend.withCalcs(['min', 'mean', 'max'])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      udfTransactionsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Client UDF transactions',
          targets=[
            signals.overview.clientUdfComplete.asTarget() { interval: '1m' },
            signals.overview.clientUdfError.asTarget() { interval: '1m' },
            signals.overview.clientUdfTimeout.asTarget() { interval: '1m' },
            signals.overview.clientUdfFiltered.asTarget() { interval: '1m' },
          ],
          description='Rate of client UDF transactions in an Aerospike cluster organized by result.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.options.legend.withCalcs(['min', 'mean', 'max'])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      clientConnectionsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Connections',
          targets=[
            signals.overview.clientConnections.asTarget() { interval: '1m' },
            signals.overview.fabricConnections.asTarget() { interval: '1m' },
            signals.overview.heartbeatConnections.asTarget() { interval: '1m' },
          ],
          description='Number of active connections to an Aerospike cluster.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('short')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      // ==========================
      // Instance Dashboard
      // ==========================

      instanceUnavailablePartitionsPanel:
        commonlib.panels.generic.stat.info.new(
          'Unavailable partitions',
          targets=[signals.instance.unavailablePartitions.asTarget()],
          description='Number of unavailable partitions in this Aerospike instance'
        )
        + g.panel.stat.standardOptions.withUnit('short')
        + { type: 'bargauge' }
        + g.panel.barGauge.standardOptions.color.withMode('fixed')
        + g.panel.barGauge.standardOptions.color.withFixedColor('green'),

      nodeMemoryUsagePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Memory usage',
          targets=[signals.instance.nodeMemoryUsage.asTarget()],
          description='Memory utilization in an Aerospike node.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(75)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      instanceDeadPartitionsPanel:
        commonlib.panels.generic.stat.info.new(
          'Dead partitions',
          targets=[signals.instance.deadPartitions.asTarget()],
          description='Number of dead partitions in this Aerospike instance'
        )
        + g.panel.stat.standardOptions.withUnit('short')
        + { type: 'bargauge' }
        + g.panel.barGauge.standardOptions.color.withMode('fixed')
        + g.panel.barGauge.standardOptions.color.withFixedColor('green'),

      instanceDiskUsagePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Disk usage (%)',
          targets=[signals.instance.diskUsage.asTarget()],
          description='Disk utilization per namespace on an Aerospike node. Compatible with Aerospike versions < 7.0 using legacy metrics.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      instanceDiskUsage7Panel:
        commonlib.panels.generic.timeSeries.base.new(
          'Disk usage bytes',
          targets=[signals.instance.diskUsage7.asTarget()],
          description='Disk usage in bytes on an Aerospike node. Compatible with Aerospike 7.0+ using new metrics.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      heapMemoryEfficiencyPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Heap memory efficiency',
          targets=[signals.instance.heapMemoryEfficiency.asTarget()],
          description='Fragmentation rate for the jemalloc heap in an Aerospike node.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(75)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      instanceClientConnectionsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Connections',
          targets=[
            signals.instance.clientConnections.asTarget() { interval: '1m' },
            signals.instance.fabricConnections.asTarget() { interval: '1m' },
            signals.instance.heartbeatConnections.asTarget() { interval: '1m' },
          ],
          description='Number of active connections to this Aerospike instance.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('short')
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.options.legend.withCalcs(['min', 'mean', 'max'])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(75)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      instanceReadTransactionsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Client reads',
          targets=[
            signals.instance.clientReadSuccess.asTarget() { interval: '1m' },
            signals.instance.clientReadError.asTarget() { interval: '1m' },
            signals.instance.clientReadTimeout.asTarget() { interval: '1m' },
            signals.instance.clientReadNotFound.asTarget() { interval: '1m' },
            signals.instance.clientReadFiltered.asTarget() { interval: '1m' },
          ],
          description='Rate of client read transactions in this Aerospike instance organized by result.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.options.legend.withCalcs(['min', 'mean', 'max'])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      instanceWriteTransactionsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Client writes',
          targets=[
            signals.instance.clientWriteSuccess.asTarget() { interval: '1m' },
            signals.instance.clientWriteError.asTarget() { interval: '1m' },
            signals.instance.clientWriteTimeout.asTarget() { interval: '1m' },
            signals.instance.clientWriteFiltered.asTarget() { interval: '1m' },
          ],
          description='Rate of client write transactions in this Aerospike instance organized by result.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.options.legend.withCalcs(['min', 'mean', 'max'])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      instanceUdfTransactionsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Client UDF transactions',
          targets=[
            signals.instance.clientUdfComplete.asTarget() { interval: '1m' },
            signals.instance.clientUdfError.asTarget() { interval: '1m' },
            signals.instance.clientUdfTimeout.asTarget() { interval: '1m' },
            signals.instance.clientUdfFiltered.asTarget() { interval: '1m' },
          ],
          description='Rate of client UDF transactions in this Aerospike instance organized by result.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.options.legend.withCalcs(['min', 'mean', 'max'])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      cacheReadUtilizationPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Cache read utilization',
          targets=[signals.namespace.cacheReadUtilization.asTarget()],
          description='Percentage of read transactions that are resolved by a cache hit.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      // ==========================
      // Namespace Dashboard
      // ==========================

      namespaceUnavailablePartitionsPanel:
        commonlib.panels.generic.stat.info.new(
          'Unavailable partitions',
          targets=[signals.namespace.unavailablePartitions.asTarget()],
          description='Number of unavailable partitions in this Aerospike namespace'
        )
        + g.panel.stat.standardOptions.withUnit('short')
        + { type: 'bargauge' }
        + g.panel.barGauge.standardOptions.color.withMode('fixed')
        + g.panel.barGauge.standardOptions.color.withFixedColor('green'),

      namespaceDiskUsagePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Disk usage (%)',
          targets=[signals.namespace.namespaceDiskUsage.asTarget()],
          description='Disk utilization in an Aerospike namespace. Compatible with Aerospike versions < 7.0 using legacy metrics.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      namespaceDiskUsage7Panel:
        commonlib.panels.generic.timeSeries.base.new(
          'Disk usage bytes',
          targets=[signals.namespace.namespaceDiskUsage7.asTarget()],
          description='Disk usage in bytes in an Aerospike namespace. Compatible with Aerospike 7.0+ using new metrics.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      namespaceDeadPartitionsPanel:
        commonlib.panels.generic.stat.info.new(
          'Dead partitions',
          targets=[signals.namespace.deadPartitions.asTarget()],
          description='Number of dead partitions in this Aerospike namespace'
        )
        + g.panel.stat.standardOptions.withUnit('short')
        + { type: 'bargauge' }
        + g.panel.barGauge.standardOptions.color.withMode('fixed')
        + g.panel.barGauge.standardOptions.color.withFixedColor('green'),

      namespaceMemoryUsagePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Memory usage (%)',
          targets=[signals.namespace.namespaceMemoryUsage.asTarget()],
          description='Memory utilization in an Aerospike namespace. Compatible with Aerospike versions < 7.0 using legacy metrics.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      namespaceMemoryUsageBytesPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Memory usage bytes',
          targets=[signals.namespace.namespaceMemoryUsageBytes.asTarget()],
          description='Memory utilization in an Aerospike namespace. Compatible with Aerospike 7.0+ using new metrics.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      namespaceReadTransactionsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Client reads',
          targets=[
            signals.namespace.readTransactionSuccess.asTarget() { interval: '1m' },
            signals.namespace.readTransactionError.asTarget() { interval: '1m' },
            signals.namespace.readTransactionTimeout.asTarget() { interval: '1m' },
            signals.namespace.readTransactionNotFound.asTarget() { interval: '1m' },
            signals.namespace.readTransactionFiltered.asTarget() { interval: '1m' },
          ],
          description='Rate of client read transactions in this Aerospike namespace organized by result.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.options.legend.withCalcs(['min', 'mean', 'max'])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      namespaceWriteTransactionsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Client writes',
          targets=[
            signals.namespace.writeTransactionSuccess.asTarget() { interval: '1m' },
            signals.namespace.writeTransactionError.asTarget() { interval: '1m' },
            signals.namespace.writeTransactionTimeout.asTarget() { interval: '1m' },
            signals.namespace.writeTransactionFiltered.asTarget() { interval: '1m' },
          ],
          description='Rate of client write transactions in this Aerospike namespace organized by result.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.options.legend.withCalcs(['min', 'mean', 'max'])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      namespaceUdfTransactionsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Client UDF transactions',
          targets=[
            signals.namespace.udfTransactionComplete.asTarget() { interval: '1m' },
            signals.namespace.udfTransactionError.asTarget() { interval: '1m' },
            signals.namespace.udfTransactionTimeout.asTarget() { interval: '1m' },
            signals.namespace.udfTransactionFiltered.asTarget() { interval: '1m' },
          ],
          description='Rate of client UDF transactions in this Aerospike namespace organized by result.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.options.legend.withCalcs(['min', 'mean', 'max'])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),
    },
}