local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this)::
    {
      local signals = this.signals,

      // ==========================
      // Cluster Dashboard Panels
      // ==========================

      masterStatusHistoryPanel:
        g.panel.statusHistory.new('Master status history')
        + g.panel.statusHistory.panelOptions.withDescription('Displays the current active and backup masters.')
        + g.panel.statusHistory.queryOptions.withTargets([
          signals.cluster.masterStatusHistoryNumRegionServers.asTarget(),
          signals.cluster.nonMasterStatusHistoryNumRegionServers.asTarget(),
        ])
        + g.panel.statusHistory.standardOptions.withMappings([
          {
            options: {
              '0': {
                color: 'yellow',
                index: 1,
                text: 'Backup',
              },
              '1': {
                color: 'blue',
                index: 0,
                text: 'Active',
              },
            },
            type: 'value',
          },
        ])
        + g.panel.statusHistory.fieldConfig.defaults.custom.withLineWidth(1)
        + g.panel.statusHistory.options.withShowValue('never')
        + g.panel.statusHistory.options.legend.withShowLegend(true)
        + g.panel.statusHistory.options.legend.withDisplayMode('list')
        + g.panel.statusHistory.options.legend.withPlacement('bottom')
        + g.panel.statusHistory.queryOptions.withMaxDataPoints(100)
        + g.panel.statusHistory.standardOptions.thresholds.withSteps([]),

      liveRegionServersPanel:
        commonlib.panels.generic.stat.info.new(
          'Live RegionServers',
          targets=[signals.cluster.liveRegionServers.asTarget()],
          description='Number of RegionServers that are currently live.'
        )
        + g.panel.stat.standardOptions.withUnit('short'),

      deadRegionServersPanel:
        commonlib.panels.generic.stat.info.new(
          'Dead RegionServers',
          targets=[signals.cluster.deadRegionServers.asTarget()],
          description='Number of RegionServers that are currently dead.'
        )
        + g.panel.stat.standardOptions.withUnit('short')
        + g.panel.stat.standardOptions.thresholds.withSteps([
          { color: 'green', value: null },
          { color: 'red', value: 1 },
        ]),

      serversPanel:
        g.panel.table.new('Servers')
        + g.panel.table.panelOptions.withDescription('Servers for a cluster.')
        + g.panel.table.queryOptions.withTargets([
          signals.cluster.serverList.asTableTarget(),
          signals.cluster.regionServerList.asTableTarget(),
        ])
        + g.panel.table.queryOptions.withTransformations([
          { id: 'merge', options: {} },
          {
            id: 'organize',
            options: {
              excludeByName: {
                Time: true,
                'Time 1': true,
                'Time 2': true,
                Value: true,
                'Value #A': true,
                'Value #B': true,
                __name__: true,
                '__name__ 1': true,
                '__name__ 2': true,
                clusterid: true,
                'clusterid 1': true,
                'clusterid 2': true,
                context: true,
                'context 1': true,
                'context 2': true,
                hbase_cluster: false,
                'hbase_cluster 1': true,
                'hbase_cluster 2': true,
                instance: true,
                'instance 1': false,
                'instance 2': true,
                isactivemaster: false,
                'isactivemaster 1': false,
                'isactivemaster 2': true,
                job: true,
                'job 1': true,
                'job 2': true,
                liveregionservers: true,
                'liveregionservers 1': true,
                'liveregionservers 2': true,
                servername: false,
                'servername 1': false,
                'servername 2': true,
                zookeeperquorum: true,
                'zookeeperquorum 1': true,
                'zookeeperquorum 2': true,
              },
              indexByName: {
                Time: 5,
                'Value #A': 12,
                'Value #B': 13,
                __name__: 6,
                clusterid: 7,
                context: 8,
                hbase_cluster: 4,
                hostname: 1,
                instance: 2,
                isactivemaster: 3,
                job: 9,
                liveregionservers: 10,
                servername: 0,
                zookeeperquorum: 11,
              },
              renameByName: {
                Time: '',
                deadregionservers: 'Dead server',
                hbase_cluster: 'Cluster',
                hostname: 'Hostname',
                instance: 'Instance',
                'instance 1': '',
                isactivemaster: 'Role',
                'isactivemaster 1': 'Master',
                master_instance: 'Master',
                region_server_instance: 'RegionServer',
                servername: 'Servername',
                'servername 1': 'Servername',
              },
            },
          },
        ])
        + g.panel.table.standardOptions.withOverrides([
          g.panel.table.fieldOverride.byName.new('RegionServer')
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withLinks([
              {
                title: '',
                url: '/d/' + this.grafana.dashboards['apache-hbase-regionserver-overview.json'].uid + '?from=${__from}&to=${__to}&var-instance=${__data.fields["RegionServer"]}',
              },
            ])
          ),
          g.panel.table.fieldOverride.byName.new('Role')
          + g.panel.table.fieldOverride.byName.withProperty('noValue', 'RegionServer')
          + g.panel.table.fieldOverride.byName.withProperty('mappings', [
            {
              options: {
                'false': { index: 1, text: 'backup master' },
                'true': { color: 'text', index: 0, text: 'active master' },
              },
              type: 'value',
            },
          ]),
        ]),

      alertsPanel:
        {
          type: 'alertlist',
          title: 'Alerts',
          description: 'Panel to report on the status of integration alerts.',
          targets: [
            signals.cluster.masterConnections.asTarget(),
          ],
          options: {
            alertInstanceLabelFilter: '{job=~"${job:regex}", hbase_cluster=~"${hbase_cluster:regex}"}',
            dashboardAlerts: false,
            groupBy: [],
            groupMode: 'default',
            maxItems: 20,
            sortOrder: 1,
            stateFilter: {
              firing: true,
              pending: true,
              noData: true,
              normal: true,
              'error': true,
            },
          },
        },

      jvmHeapMemoryUsagePanel:
        commonlib.panels.memory.timeSeries.usagePercent.new(
          'JVM heap memory usage',
          targets=[signals.cluster.masterJvmHeapMemoryUsage.asTarget()],
          description='Heap memory usage for the JVM.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percentunit')
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withMax(1)
        + g.panel.timeSeries.standardOptions.color.withMode('continuous-BlYlRd'),

      connectionsPanel:
        commonlib.panels.network.timeSeries.base.new(
          'Connections',
          targets=[
            signals.cluster.masterConnections.asTarget(),
            signals.cluster.regionServerConnections.asTarget(),
          ],
          description='Number of open connections to the cluster.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('short')
        + g.panel.timeSeries.standardOptions.withDecimals(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),


      authenticationsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Authentications',
          targets=[
            signals.cluster.masterAuthenticationSuccess.asTarget(),
            signals.cluster.masterAuthenticationFailure.asTarget(),
            signals.cluster.regionServerAuthenticationSuccess.asTarget(),
            signals.cluster.regionServerAuthenticationFailure.asTarget(),
          ],
          description='Volume of successful and unsuccessful authentications.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.options.legend.withCalcs(['min', 'mean', 'max']),

      masterQueueSizePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Master queue size',
          targets=[signals.cluster.masterQueueSize.asTarget()],
          description='The size of the queue of requests, operations, and tasks to be processed by the master.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('short'),

      masterQueuedCallsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Master queued calls',
          targets=[
            signals.cluster.masterCallsInGeneralQueue.asTarget(),
            signals.cluster.masterCallsInReplicationQueue.asTarget(),
            signals.cluster.masterCallsInReadQueue.asTarget(),
            signals.cluster.masterCallsInWriteQueue.asTarget(),
            signals.cluster.masterCallsInScanQueue.asTarget(),
            signals.cluster.masterCallsInPriorityQueue.asTarget(),
          ],
          description='The number of calls waiting to be processed by the master.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('short')
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.options.legend.withCalcs(['min', 'mean', 'max']),

      regionsInTransitionPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Regions in transition',
          targets=[
            signals.cluster.regionsInTransition.asTarget(),
            signals.cluster.oldRegionsInTransition.asTarget(),
          ],
          description='The number of regions in transition for the cluster.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('short'),


      oldestRegionInTransitionPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Oldest region in transition',
          targets=[signals.cluster.oldestRegionInTransitionAge.asTarget()],
          description='The age of the longest region in transition for the master of the cluster.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms'),


      // ==========================
      // RegionServer Dashboard Panels
      // ==========================

      regionsPanel:
        commonlib.panels.generic.stat.info.new(
          'Regions',
          targets=[signals.regionserver.regionCountAggregated.asTarget()],
          description='The number of regions hosted by the RegionServer.'
        )
        + g.panel.stat.standardOptions.withUnit('short'),

      storeFilesPanel:
        commonlib.panels.generic.stat.info.new(
          'Store files',
          targets=[signals.regionserver.storeFileCountAggregated.asTarget()],
          description='The number of store files on disk currently managed by the RegionServer.'
        )
        + g.panel.stat.standardOptions.withUnit('short'),

      storeFileSizePanel:
        commonlib.panels.generic.stat.info.new(
          'Store file size',
          targets=[signals.regionserver.storeFileSizeAggregated.asTarget()],
          description='The total size of the store files on disk managed by the RegionServer.'
        )
        + g.panel.stat.standardOptions.withUnit('decbytes'),


      rpcConnectionsPanel:
        commonlib.panels.generic.stat.info.new(
          'RPC connections',
          targets=[signals.regionserver.rpcConnectionsAggregated.asTarget()],
          description='The number of open connections to the RegionServer.'
        )
        + g.panel.stat.standardOptions.withUnit('short'),

      regionServerJvmHeapMemoryUsagePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'JVM heap memory usage',
          targets=[signals.regionserver.jvmHeapMemoryUsage.asTarget()],
          description='Heap memory usage for the JVM.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percentunit')
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withMax(1),

      requestsReceivedPanel:
        commonlib.panels.requests.timeSeries.rate.new(
          'Requests received',
          targets=[signals.regionserver.totalRequestRate.asTarget()],
          description='The rate of requests received by the RegionServer.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps'),

      requestsOverviewPanel:
        g.panel.pieChart.new('Requests overview')
        + g.panel.pieChart.panelOptions.withDescription('Requests received by the RegionServer, broken down by type.')
        + g.panel.pieChart.queryOptions.withTargets([
          signals.regionserver.readRequestRate.asTarget(),
          signals.regionserver.writeRequestRate.asTarget(),
          signals.regionserver.cpRequestRate.asTarget(),
          signals.regionserver.filteredReadRequestRate.asTarget(),
          signals.regionserver.rpcGetRequestRate.asTarget(),
          signals.regionserver.rpcScanRequestRate.asTarget(),
          signals.regionserver.rpcFullScanRequestRate.asTarget(),
          signals.regionserver.rpcMutateRequestRate.asTarget(),
          signals.regionserver.rpcMultiRequestRate.asTarget(),
        ])
        + g.panel.pieChart.standardOptions.withUnit('reqps')
        + g.panel.pieChart.options.legend.withDisplayMode('list')
        + g.panel.pieChart.options.legend.withPlacement('right')
        + g.panel.pieChart.options.legend.withShowLegend(true)
        + g.panel.pieChart.options.withPieType('pie')
        + g.panel.pieChart.options.reduceOptions.withCalcs(['lastNotNull'])
        + g.panel.pieChart.options.tooltip.withMode('multi'),

      regionCountPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Region count',
          targets=[signals.regionserver.regionCount.asTarget()],
          description='The number of regions hosted by the RegionServer.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('short'),


      rpcConnectionCountPanel:
        commonlib.panels.network.timeSeries.base.new(
          'RPC connection count',
          targets=[signals.regionserver.rpcConnections.asTarget()],
          description='The number of open connections to the RegionServer.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('short')
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

      storeFileCountPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Store file count',
          targets=[signals.regionserver.storeFileCount.asTarget()],
          description='The number of store files on disk currently managed by the RegionServer.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('short'),

      storeFileSizeTimeseriesPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Store file size',
          targets=[signals.regionserver.storeFileSize.asTarget()],
          description='The total size of the store files on disk managed by the RegionServer.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('decbytes')

        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineInterpolation('smooth')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      queuedCallsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Queued calls',
          targets=[
            signals.regionserver.callsInGeneralQueue.asTarget(),
            signals.regionserver.callsInReplicationQueue.asTarget(),
            signals.regionserver.callsInReadQueue.asTarget(),
            signals.regionserver.callsInWriteQueue.asTarget(),
            signals.regionserver.callsInScanQueue.asTarget(),
            signals.regionserver.callsInPriorityQueue.asTarget(),
          ],
          description='The number of calls waiting to be processed by the RegionServer.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('short')
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.options.legend.withCalcs(['min', 'mean', 'max']),

      slowOperationsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Slow operations',
          targets=[
            signals.regionserver.slowAppendRate.asTarget(),
            signals.regionserver.slowPutRate.asTarget(),
            signals.regionserver.slowDeleteRate.asTarget(),
            signals.regionserver.slowGetRate.asTarget(),
            signals.regionserver.slowIncrementRate.asTarget(),
          ],
          description='The rate of operations that are slow, as determined by HBase.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ops')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineInterpolation('smooth')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false)
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.options.legend.withCalcs(['min', 'mean', 'max']),

      cacheHitPercentagePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Cache hit percentage',
          targets=[signals.regionserver.blockCacheHitPercent.asTarget()],
          description='The percent of time that requests hit the cache.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withMax(100),

      regionServerAuthenticationsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Authentications',
          targets=[
            signals.cluster.regionServerAuthenticationSuccess.asTarget(),
            signals.cluster.regionServerAuthenticationFailure.asTarget(),
          ],
          description='The rate of successful and unsuccessful authentications.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right'),
    },
}
