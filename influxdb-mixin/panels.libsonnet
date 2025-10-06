local g = (import './g.libsonnet');
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this)::
    {
      local signals = this.signals,
      local groupLabels = this.config.groupLabels,
      local shownGroupLabels = std.filter(function(l) l != 'job', groupLabels),

      //
      // Cluster Overview Dashboard Panels
      //

      // Alert panel
      alertsPanel: {
        title: 'Alerts',
        type: 'alertlist',
        targets: [],
        options: {
          alertInstanceLabelFilter: '{job=~"${job:regex}", influxdb_cluster=~"${influxdb_cluster:regex}"}',
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

      serversPanel:
        commonlib.panels.generic.table.base.new(
          'Servers',
          targets=[
            signals.overview.uptime.asTableTarget(),
            signals.overview.buckets.asTableTarget(),
            signals.overview.users.asTableTarget(),
            signals.overview.replications.asTableTarget(),
            signals.overview.remotes.asTableTarget(),
            signals.overview.scrapers.asTableTarget(),
            signals.overview.dashboards.asTableTarget(),
          ],
          description='Statistics for each instance in the cluster.',
        )
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('instance')
          + g.panel.table.fieldOverride.byName.withProperty('displayName', 'Instance')
          + g.panel.table.fieldOverride.byName.withProperty('links', [
            {
              title: 'Instance overview',
              url: '/d/influxdb_instance_overview?var-instance=${__data.fields.Instance}&${__url_time_range}&var-datasource=${datasource}',
            },
          ]),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Uptime')
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('s')
          ),
        ])
        + g.panel.table.queryOptions.withTransformationsMixin([
          {
            id: 'joinByField',
            options: {
              byField: 'instance',
              mode: 'outer',
            },
          },
          {
            id: 'filterFieldsByName',
            options: {
              include: {
                pattern:
                  std.join(' 1$|', shownGroupLabels) + ' 1$|'
                  + 'instance' + '|'
                  + '^cluster$|cluster 1$|'
                  + 'Value.+',
              },
            },
          },
          {
            id: 'organize',
            options: {
              excludeByName: {
                Time: true,
                id: true,
                'id 1': true,
                job: true,
                'job 1': true,
              },
              renameByName: {
                Time: '',
                'cluster 1': 'Cluster',
                'influxdb_cluster 1': 'InfluxDB cluster',
              },
            },
          },
          {
            id: 'renameByRegex',
            options: {
              regex: 'Value #(.*)',
              renamePattern: '$1',
            },
          },
        ]),


      // HTTP API panels
      topInstancesByHTTPAPIRequestsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Top instances by HTTP API requests',
          targets=[
            signals.overview.topInstancesByHTTPAPIRequests.asTarget() { interval: '1m' },
          ],
          description='HTTP API request rate for the instances with the most traffic in the cluster.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps'),


      httpAPIRequestDurationPanel:
        g.panel.histogram.new('HTTP API request duration')
        + g.panel.histogram.panelOptions.withDescription('Time taken to respond to HTTP API requests for the cluster.')
        + g.panel.histogram.queryOptions.withTargets([
          signals.overview.httpAPIRequestDuration.asTarget() { interval: '1m' },
        ])
        + g.panel.histogram.standardOptions.withUnit('s'),

      httpAPIResponseCodesPanel:
        g.panel.pieChart.new(
          'HTTP API response codes',
        )
        + g.panel.pieChart.panelOptions.withDescription('Rate of different HTTP response codes for the entire cluster.')
        + g.panel.pieChart.queryOptions.withTargets([
          signals.overview.httpAPIResponseCodes.asTarget() { interval: '1m' },
        ])
        + g.panel.pieChart.standardOptions.withUnit('reqps')
        + g.panel.pieChart.options.legend.withPlacement('right')
        + g.panel.pieChart.options.reduceOptions.withCalcs(['sum']),

      // Query operations panels
      httpOperationsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP operations',
          targets=[
            signals.overview.httpQueryOperations.asTarget() { interval: '1m' },
            signals.overview.httpWriteOperations.asTarget() { interval: '1m' },
          ],
          description='Rate of database operations from HTTP for the cluster.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      httpOperationsDataPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP operation data',
          targets=[
            signals.overview.httpQueryRequestOperationsData.asTarget() { interval: '1m' },
            signals.overview.httpQueryResponseOperationsData.asTarget() { interval: '1m' },
            signals.overview.httpWriteRequestOperationsData.asTarget() { interval: '1m' },
            signals.overview.httpWriteResponseOperationsData.asTarget() { interval: '1m' },
          ],
          description='Rate of data transferred for HTTP query and write operations in the cluster.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.options.legend.withPlacement('right'),


      // InfluxQL panels
      topInstancesByIQLQueryRatePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Top instances by IQL query rate',
          targets=[
            signals.overview.topInstancesByIQLQueryRate.asTarget() { interval: '1m' },
          ],
          description='Rate of InfluxQL queries for the instances with the most traffic in the cluster.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps'),

      iqlQueryResponseTimePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'IQL query response time',
          targets=[
            signals.overview.iqlQueryResponseTime.asTarget() { interval: '1m' },
          ],
          description='Response time for recent InfluxQL queries, organized by result.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('s'),

      boltdbOperationsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'BoltDB operations',
          targets=[
            signals.overview.boltdbReadOperations.asTarget() { interval: '1m' },
            signals.overview.boltdbWriteOperations.asTarget() { interval: '1m' },
          ],
          description='Rate of reads and writes to the underlying BoltDB storage engine for the entire cluster.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      // Task scheduler panels
      activeTasksPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Active tasks',
          targets=[
            signals.overview.activeTasks.asTarget() { interval: '1m' },
          ],
          description='Number of tasks currently being executed for the cluster.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      activeWorkersPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Active workers',
          targets=[
            signals.overview.activeWorkers.asTarget() { interval: '1m' },
          ],
          description='Number of workers currently running tasks on the cluster.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('none'),


      executionTotalsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Executions',
          targets=[
            signals.overview.executionTotals.asTarget() { interval: '1m' },
            signals.overview.executionFailures.asTarget() { interval: '1m' },
          ],
          description='Rate of execution operations and execution failures for the cluster.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('none'),


      scheduleTotalsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Schedules',
          targets=[
            signals.overview.scheduleTotals.asTarget() { interval: '1m' },
            signals.overview.scheduleFailures.asTarget() { interval: '1m' },
          ],
          description='Rate of schedule operations and schedule operation failures for the cluster.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      // Memory and performance panels
      topInstancesByHeapMemoryUsagePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Top instances by heap memory usage',
          targets=[
            signals.overview.topInstancesByHeapMemoryUsage.asTarget() { interval: '1m' },
          ],
          description='Heap memory usage for the largest instances in the cluster.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('percentunit'),


      topInstancesByGCCPUUsagePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Top instances by GC CPU usage',
          targets=[
            signals.overview.topInstancesByGCCPUUsage.asTarget() { interval: '1m' },
          ],
          description='Fraction of CPU time used for garbage collection for the top instances in the cluster.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      //
      // Instance Overview Dashboard Panels
      //

      instanceUptimePanel:
        commonlib.panels.generic.stat.base.new(
          'Uptime',
          targets=[signals.instance.uptime.asTarget()],
          description='Time that the InfluxDB process has been running.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.stat.standardOptions.color.withFixedColor('light-green')
        + g.panel.stat.options.withGraphMode('none'),

      instanceBucketsPanel:
        commonlib.panels.generic.stat.base.new(
          'Buckets',
          targets=[signals.instance.buckets.asTarget()],
          description='Number of buckets on the server.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.stat.standardOptions.color.withFixedColor('light-green')
        + g.panel.stat.options.withGraphMode('none'),

      instanceUsersPanel:
        commonlib.panels.generic.stat.base.new(
          'Users',
          targets=[signals.instance.users.asTarget()],
          description='Total number of users for the server.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.stat.standardOptions.color.withFixedColor('light-green')
        + g.panel.stat.options.withGraphMode('none'),

      instanceReplicationsPanel:
        commonlib.panels.generic.stat.base.new(
          'Replications',
          targets=[signals.instance.replications.asTarget()],
          description='Number of replication configurations on the server.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.stat.standardOptions.color.withFixedColor('light-green')
        + g.panel.stat.options.withGraphMode('none'),


      instanceRemotesPanel:
        commonlib.panels.generic.stat.base.new(
          'Remotes',
          targets=[signals.instance.remotes.asTarget()],
          description='Number of remote connections configured on the server.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.stat.standardOptions.color.withFixedColor('light-green')
        + g.panel.stat.options.withGraphMode('none'),

      instanceScrapersPanel:
        commonlib.panels.generic.stat.base.new(
          'Scrapers',
          targets=[signals.instance.scrapers.asTarget()],
          description='Number of scrapers on the server.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.stat.standardOptions.color.withFixedColor('light-green')
        + g.panel.stat.options.withGraphMode('none'),

      instanceDashboardsPanel:
        commonlib.panels.generic.stat.base.new(
          'Dashboards',
          targets=[signals.instance.dashboards.asTarget()],
          description='Number of dashboards on the server.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.stat.standardOptions.color.withFixedColor('light-green')
        + g.panel.stat.options.withGraphMode('none'),

      instanceThreadsPanel:
        commonlib.panels.generic.stat.base.new(
          'Threads',
          targets=[signals.instance.goThreads.asTarget()],
          description='Number of threads currenty active on the server.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.stat.standardOptions.color.withFixedColor('light-green')
        + g.panel.stat.options.withGraphMode('none'),

      instanceHTTPAPIRequestsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP API requests',
          targets=[signals.instance.httpAPIRequests.asTarget() { interval: '1m' }],
          description='Rate of HTTP API requests to the API, organized by response code.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      instanceActiveQueriesPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Active queries',
          targets=[
            signals.instance.compilingActiveQueries.asTarget() { interval: '1m' },
            signals.instance.queuingQueries.asTarget() { interval: '1m' },
            signals.instance.executingQueries.asTarget() { interval: '1m' },
          ],
          description='Number of queries compiling, queuing, and executing on this instance.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      instanceHTTPOperationsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP operations',
          targets=[
            signals.instance.httpOperationQueries.asTarget() { interval: '1m' },
            signals.instance.httpOperationWrites.asTarget() { interval: '1m' },
          ],
          description='Rate of HTTP query and write operations handled by this instance.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      instanceHTTPOperationDataPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP operation data',
          targets=[
            signals.instance.httpOperationsDataQueryRequests.asTarget() { interval: '1m' },
            signals.instance.httpOperationsDataQueryResponses.asTarget() { interval: '1m' },
            signals.instance.httpOperationsDataWriteRequests.asTarget() { interval: '1m' },
            signals.instance.httpOperationsDataWriteResponses.asTarget() { interval: '1m' },
          ],
          description='Bytes per second for HTTP query and write request/response bodies.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      instanceIQLRatePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'IQL query rate',
          targets=[signals.instance.iqlQueryRate.asTarget() { interval: '1m' }],
          description='Rate of InfluxQL queries executed by this instance.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('query/s'),

      instanceIQLResponseTimePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'IQL response time / $__interval',
          targets=[signals.instance.iqlQueryResponseTime.asTarget() { interval: '2m' }],
          description='Total time spent executing InfluxQL queries during each $__interval.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('s'),

      instanceBoltDBOperationsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'BoltDB operations',
          targets=[
            signals.instance.boltdbReadOperations.asTarget() { interval: '1m' },
            signals.instance.boltdbWriteOperations.asTarget() { interval: '1m' },
          ],
          description='Rate of reads and writes to the underlying BoltDB storage engine for the server.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      instanceActiveTasksPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Active tasks',
          targets=[signals.instance.activeTasks.asTarget() { interval: '1m' }],
          description='Number of tasks currently being executed for the server.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      instanceActiveWorkersPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Active workers',
          targets=[signals.instance.activeWorkers.asTarget() { interval: '1m' }],
          description='Number of workers currently running tasks on the server.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      instanceWorkerUsagePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Worker usage',
          targets=[signals.instance.workerUsage.asTarget() { interval: '1m' }],
          description='Percentage of available workers that are currently busy.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      instanceExecutionsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Executions',
          targets=[
            signals.instance.executionsTotal.asTarget() { interval: '1m' },
            signals.instance.executionsFailures.asTarget() { interval: '1m' },
          ],
          description='Rate of executions and execution failures for the server.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      instanceSchedulesPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Schedules',
          targets=[
            signals.instance.scheduleTotals.asTarget() { interval: '1m' },
            signals.instance.scheduleFailures.asTarget() { interval: '1m' },
          ],
          description='Rate of schedule operations and schedule operation failures for the server.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('none'),


      // Go metrics
      instanceGoLastGCPanel:
        commonlib.panels.generic.stat.base.new(
          'Time since last GC',
          targets=[signals.instance.timeSinceLastGC.asTarget()],
          description='Amount of time since the last garbage collection cycle.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.stat.standardOptions.color.withFixedColor('light-green')
        + g.panel.stat.options.withGraphMode('none'),

      instanceGoGCTimePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'GC time',
          targets=[signals.instance.gcTime.asTarget() { interval: '2m' }],
          description='Server CPU time spent on garbage collection.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('s'),


      instanceGoGCCPUUsagePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'GC CPU usage',
          targets=[signals.instance.gcCPUUsage.asTarget()],
          description='Percent of server CPU time used for garbage collection.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      instanceGoHeapMemoryUsagePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Heap memory usage',
          targets=[signals.instance.goHeapMemoryUsage.asTarget()],
          description='Heap memory usage for the server.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent'),


      instanceGoThreadsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Threads',
          targets=[signals.instance.goThreads.asTarget()],
          description='Number of OS threads created for the server.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('none'),


    },
}
