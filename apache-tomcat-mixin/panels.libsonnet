local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this)::
    {
      local signals = this.signals,

      // Overview Panels

      overviewNumberOfClustersPanel:
        commonlib.panels.generic.stat.info.new(
          'Number of clusters',
          targets=[signals.overview.numberOfClusters.asTarget()]
        )
        + g.panel.stat.standardOptions.withUnit('none')
        + g.panel.stat.panelOptions.withDescription('The number of Apache Tomcat clusters.'),

      overviewNumberOfNodesPanel:
        commonlib.panels.generic.stat.info.new(
          'Number of nodes',
          targets=[signals.overview.numberOfNodes.asTarget()]
        )
        + g.panel.stat.standardOptions.withUnit('none')
        + g.panel.stat.panelOptions.withDescription('The number of Apache Tomcat nodes.'),

      overviewCPUUsageStatPanel:
        commonlib.panels.cpu.stat.usage.new(
          'CPU usage',
          targets=[signals.overview.cpuUsage.asTarget()]
        )
        + g.panel.stat.panelOptions.withDescription('The CPU usage of the JVM of the instance.'),

      overviewMemoryUtilizationStatPanel:
        commonlib.panels.memory.stat.usage.new(
          'Memory utilization',
          targets=[signals.overview.memoryUtilization.asTarget()]
        )
        + g.panel.stat.panelOptions.withDescription('The memory utilization of the JVM of the instance.'),

      overviewInstancesTablePanel:
        commonlib.panels.generic.table.base.new(
          'Instances',
          targets=[
            signals.overview.cpuUsage.asTableTarget()
            + g.query.prometheus.withInstant(true)
            + g.query.prometheus.withRefId('cpu_usage'),
            signals.overview.memoryUtilization.asTableTarget()
            + g.query.prometheus.withInstant(true)
            + g.query.prometheus.withRefId('memory_utilization'),
          ],
        )
        {
          options+: {
            enablePagination: true,
          },
        }
        + g.panel.table.panelOptions.withDescription('Overview of Apache Tomcat instances with key metrics.')
        + g.panel.table.standardOptions.withNoValue('NA')
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
                names: [
                  'instance',
                  'job 1',
                  'cluster',
                  'Value #cpu_usage',
                  'Value #memory_utilization',
                ],
              },
            },
          },
          {
            id: 'organize',
            options: {
              includeByName: {
                instance: {},
                'job 1': {},
                cluster: {},
                'Value #cpu_usage': {},
                'Value #memory_utilization': {},
              },
              indexByName: {
                instance: 0,
                'job 1': 1,
                cluster: 2,
                'Value #cpu_usage': 3,
                'Value #memory_utilization': 4,
              },
              renameByName: {
                instance: 'Instance',
                'job 1': 'Job',
                cluster: 'Cluster',
                'Value #cpu_usage': 'CPU usage',
                'Value #memory_utilization': 'Memory utilization',
              },
            },
          },
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Instance')
          + g.panel.table.fieldOverride.byName.withProperty('custom.filterable', true),

          g.panel.table.fieldOverride.byName.new('Cluster')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 150)
          + g.panel.table.fieldOverride.byName.withProperty('custom.displayMode', 'basic')
          + g.panel.table.fieldOverride.byName.withProperty('custom.filterable', true)
          + g.panel.table.fieldOverride.byName.withProperty('custom.noValue', 'NA'),


          g.panel.table.fieldOverride.byName.new('CPU usage')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 120)
          + g.panel.table.fieldOverride.byName.withProperty('custom.displayMode', 'basic')
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            commonlib.panels.cpu.timeSeries.utilization.stylize()
          ),

          g.panel.table.fieldOverride.byName.new('Memory utilization')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 150)
          + g.panel.table.fieldOverride.byName.withProperty('custom.displayMode', 'basic')
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            commonlib.panels.memory.timeSeries.usagePercent.stylize()
          ),
        ]),
      overviewMemoryUsagePanel:
        commonlib.panels.memory.timeSeries.usageBytes.new(
          'Memory usage',
          targets=[signals.overview.memoryUsage.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The memory usage of the JVM of the instance.'),

      overviewCPUUsagePanel:
        commonlib.panels.cpu.timeSeries.utilization.new(
          'CPU usage',
          targets=[signals.overview.cpuUsage.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The CPU usage of the JVM process.'),

      overviewTrafficSentPanel:
        commonlib.panels.network.timeSeries.traffic.new(
          'Traffic sent',
          targets=[
            signals.overview.trafficSentTotal.asTarget() { interval: '2m' },
            signals.overview.trafficSentRate.asTarget() { interval: '2m' },
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The traffic sent for a Tomcat connector.')
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      overviewTrafficReceivedPanel:
        commonlib.panels.network.timeSeries.traffic.new(
          'Traffic received',
          targets=[
            signals.overview.trafficReceivedTotal.asTarget() { interval: '2m' },
            signals.overview.trafficReceivedRate.asTarget() { interval: '2m' },
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The traffic received for a Tomcat connector.')
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      overviewRequestsPanel:
        commonlib.panels.requests.timeSeries.base.new(
          'Requests',
          targets=[
            signals.overview.requestsTotal.asTarget() { interval: '2m' },
            signals.overview.requestsRate.asTarget() { interval: '2m' },
            signals.overview.requestsErrors.asTarget() { interval: '2m' },
            signals.overview.requestsErrorsRate.asTarget() { interval: '2m' },
          ]
        )
        + g.panel.timeSeries.standardOptions.withUnit('r/s')
        + g.panel.timeSeries.panelOptions.withDescription('The total requests and errors for a Tomcat connector.')
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      overviewProcessingTimePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Processing time',
          targets=[
            signals.overview.processingTimeTotal.asTarget() { interval: '2m' },
            signals.overview.processingTimeRate.asTarget() { interval: '2m' },
          ]
        )
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.panelOptions.withDescription('The average time taken to process recent requests for a Tomcat connector.')
        + g.panel.timeSeries.standardOptions.withUnit('ms'),


      overviewThreadsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Threads',
          targets=[
            signals.overview.totalConnectionThreads.asTarget(),
            signals.overview.totalPollerThreads.asTarget(),
            signals.overview.totalIdleThreads.asTarget(),
            signals.overview.totalActiveThreads.asTarget(),
            signals.overview.connectionThreads.asTarget(),
            signals.overview.pollerThreads.asTarget(),
            signals.overview.idleThreads.asTarget(),
            signals.overview.activeThreads.asTarget(),
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The number of various threads used by a Tomcat connector.')
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      // Hosts Panels

      hostsSessionsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Sessions',
          targets=[
            signals.hosts.totalSessions.asTarget() { interval: '2m' },
            signals.hosts.rejectedSessions.asTarget() { interval: '2m' },
            signals.hosts.expiredSessions.asTarget() { interval: '2m' },
            signals.hosts.sessionRate.asTarget() { interval: '2m' },
            signals.hosts.rejectedSessionRate.asTarget() { interval: '2m' },
            signals.hosts.expiredSessionRate.asTarget() { interval: '2m' },
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The number of different types of sessions created for a Tomcat host.')
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      hostsSessionProcessingTimePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Session processing time',
          targets=[
            signals.hosts.totalSessionProcessingTime.asTarget() { interval: '2m' },
            signals.hosts.sessionProcessingTime.asTarget() { interval: '2m' },
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The average time taken to process recent sessions for a Tomcat host.')
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      hostsServletPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Servlet',
          targets=[
            signals.hosts.totalServletRequests.asTarget() { interval: '2m' },
            signals.hosts.totalServletErrors.asTarget() { interval: '2m' },
            signals.hosts.servletRequestRate.asTarget() { interval: '2m' },
            signals.hosts.servletErrorRate.asTarget() { interval: '2m' },
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The total requests and errors for a Tomcat servlet.')
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      hostsServletProcessingTimePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Servlet processing time',
          targets=[
            signals.hosts.totalServletProcessingTime.asTarget() { interval: '2m' },
            signals.hosts.servletProcessingTime.asTarget() { interval: '2m' },
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The average time taken to process recent servlet requests for a Tomcat host.')
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withPlacement('right'),

    },
}
