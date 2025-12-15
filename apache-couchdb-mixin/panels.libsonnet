local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this)::
    {
      local signals = this.signals,
      /**
       * Overview dashboard panels
       */
      overviewNumberOfClustersPanel:
        commonlib.panels.generic.stat.info.new(
          'Number of clusters',
          targets=[signals.overview.clusterCount.asTarget()],
        ) + g.panel.stat.panelOptions.withDescription('The number of clusters being reported.'),

      overviewNumberOfNodesPanel:
        commonlib.panels.generic.stat.info.new(
          'Number of nodes',
          targets=[signals.overview.nodeCount.asTarget()],
        ) + g.panel.stat.panelOptions.withDescription('The number of nodes being reported.'),

      overviewClusterHealthPanel:
        g.panel.stat.new(title='Clusters healthy')
        + g.panel.stat.queryOptions.withTargets([signals.overview.clusterHealth.asTarget()])
        + g.panel.stat.panelOptions.withDescription('Percentage of clusters that have all nodes that are currently reporting healthy.')
        + g.panel.stat.standardOptions.withUnit('percent')
        + g.panel.stat.options.withColorMode('value')
        + g.panel.stat.options.withGraphMode('none')
        + g.panel.stat.standardOptions.thresholds.withSteps([
          g.panel.stat.thresholdStep.withColor('yellow'),
          g.panel.stat.thresholdStep.withColor('red') + g.panel.stat.thresholdStep.withValue(0),
          g.panel.stat.thresholdStep.withColor('yellow') + g.panel.stat.thresholdStep.withValue(1),
          g.panel.stat.thresholdStep.withColor('green') + g.panel.stat.thresholdStep.withValue(100),
        ]),

      overviewOpenOSFilesPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Open OS files',
          targets=[signals.overview.openOSFiles.asTarget()],
        )
        + g.panel.timeSeries.panelOptions.withDescription('The total number of file descriptors open aggregated across all nodes.'),

      overviewOpenDatabasesPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Open databases',
          targets=[signals.overview.openDatabases.asTarget()],
        )
        + g.panel.timeSeries.panelOptions.withDescription('The total number of open databases aggregated across all nodes.'),

      overviewDatabaseWritesPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Database writes',
          targets=[signals.overview.databaseWrites.asTarget() { interval: '2m' }],
        )
        + g.panel.timeSeries.panelOptions.withDescription('The total number of database writes aggregated across all nodes.')
        + g.panel.timeSeries.standardOptions.withUnit('wps'),

      overviewDatabaseReadsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Database reads',
          targets=[signals.overview.databaseReads.asTarget() { interval: '2m' }],
        )
        + g.panel.timeSeries.panelOptions.withDescription('The total number of database reads aggregated across all nodes.')
        + g.panel.timeSeries.standardOptions.withUnit('rps'),

      overviewViewReadsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'View reads',
          targets=[signals.overview.viewReads.asTarget() { interval: '2m' }],
        )
        + g.panel.timeSeries.panelOptions.withDescription('The total number of view reads aggregated across all nodes.')
        + g.panel.timeSeries.standardOptions.withUnit('rps'),


      overviewViewTimeoutsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'View timeouts',
          targets=[signals.overview.viewTimeouts.asTarget() { interval: '2m' }],
        )
        + g.panel.timeSeries.panelOptions.withDescription('The total number of view requests that timed out aggregated across all nodes.')
        + g.panel.timeSeries.standardOptions.withUnit('reqps'),

      overviewTemporaryViewReadsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Temporary view reads',
          targets=[signals.overview.temporaryViewReads.asTarget() { interval: '2m' }],
        )
        + g.panel.timeSeries.panelOptions.withDescription('The total number of temporary view reads aggregated across all nodes.')
        + g.panel.timeSeries.standardOptions.withUnit('rps'),

      overviewRequestMethodsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Request methods',
          targets=[signals.overview.requestMethods.asTarget() { interval: '2m' }],
        )
        + g.panel.timeSeries.panelOptions.withDescription('The request rate split by HTTP Method aggregated across all nodes.')
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      overviewRequestLatencyPanel:
        g.panel.histogram.new(title='Request latency quantiles')
        + g.panel.histogram.queryOptions.withTargets([
          signals.overview.requestLatency.asTarget()
          + g.query.prometheus.withInstant(true)
          + g.query.prometheus.withFormat('timeseries'),
        ])
        + g.panel.histogram.panelOptions.withDescription('The request latency aggregated across all nodes.')
        + g.panel.histogram.standardOptions.color.withMode('thresholds')
        + g.panel.histogram.fieldConfig.defaults.custom.stacking.withMode('normal')
        + g.panel.histogram.options.withBucketCount(60)
        + g.panel.histogram.options.legend.withAsTable(true)
        + g.panel.histogram.options.legend.withPlacement('right')
        + g.panel.histogram.standardOptions.withUnit('s'),

      overviewBulkRequestsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Bulk requests',
          targets=[signals.overview.bulkRequests.asTarget() { interval: '2m' }],
        )
        + g.panel.timeSeries.panelOptions.withDescription('The total number of bulk requests aggregated across all nodes.')
        + g.panel.timeSeries.standardOptions.withUnit('rps'),

      overviewResponseStatusOverviewPanel:
        g.panel.pieChart.new('Response status overview')
        + g.panel.pieChart.queryOptions.withTargets([
          signals.overview.responseStatus2xx.asTarget() { interval: '2m' },
          signals.overview.responseStatus3xx.asTarget() { interval: '2m' },
          signals.overview.responseStatus4xx.asTarget() { interval: '2m' },
          signals.overview.responseStatus5xx.asTarget() { interval: '2m' },
        ]) + g.panel.pieChart.panelOptions.withDescription('The responses grouped by HTTP status type (2xx, 3xx, 4xx, and 5xx) aggregated across all nodes by default. If you want to see the data for a specific node, you can filter by instance.'),

      overviewGoodResponseStatusesPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Good response statuses',
          targets=[signals.overview.goodResponseStatuses.asTarget() { interval: '2m' }],
        )
        + g.panel.timeSeries.panelOptions.withDescription('The total number of good response (HTTP 2xx-3xx) statuses aggregated across all nodes.')
        + g.panel.timeSeries.standardOptions.withUnit('reqps'),

      overviewErrorResponseStatusesPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Error response statuses',
          targets=[signals.overview.errorResponseStatuses.asTarget() { interval: '2m' }],
        )
        + g.panel.timeSeries.panelOptions.withDescription('The total number of error response statuses (HTTP 4xx-5xx) aggregated across all nodes.')
        + g.panel.timeSeries.standardOptions.withUnit('reqps'),


      overviewReplicatorChangesManagerDeathsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Replicator changes manager deaths',
          targets=[signals.replicator.changesManagerDeaths.asTarget() { interval: '2m' }],
        )
        + g.panel.timeSeries.panelOptions.withDescription('Number of replicator changes manager processor deaths across all nodes.'),

      overviewReplicatorChangesQueueDeathsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Replicator changes queue deaths',
          targets=[signals.replicator.changesQueueDeaths.asTarget()],
        )
        + g.panel.timeSeries.panelOptions.withDescription('Number of replicator changes queue processor deaths across all nodes.')
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      overviewReplicatorChangesReaderDeathsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Replicator changes reader deaths',
          targets=[signals.replicator.changesReaderDeaths.asTarget()],
        )
        + g.panel.timeSeries.panelOptions.withDescription('Number of replicator changes reader processor deaths across all nodes.')
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      overviewReplicatorConnectionOwnerCrashesPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Replicator connection owner crashes',
          targets=[signals.replicator.connectionOwnerCrashes.asTarget()],
        )
        + g.panel.timeSeries.panelOptions.withDescription('Number of replicator connection owner crashes across all nodes.')
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      overviewReplicatorConnectionWorkerCrashesPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Replicator connection worker crashes',
          targets=[signals.replicator.connectionWorkerCrashes.asTarget()],
        )
        + g.panel.timeSeries.panelOptions.withDescription('Number of replicator connection worker crashes across all nodes.')
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      overviewReplicatorJobsCrashesPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Replicator jobs crashes',
          targets=[signals.replicator.jobsCrashes.asTarget()],
        )
        + g.panel.timeSeries.panelOptions.withDescription('Number of replicator jobs crashes across all nodes.')
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      overviewReplicatorJobsQueuedPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Replicator jobs queued',
          targets=[signals.replicator.jobsQueued.asTarget() { interval: '2m' }],
        )
        + g.panel.timeSeries.panelOptions.withDescription('Number of replicator jobs queued across all nodes.')
        + g.panel.timeSeries.standardOptions.withUnit('none'),


      /**
       Node dashboard panels
       */

      nodeErlangMemoryUsagePanel:
        commonlib.panels.memory.timeSeries.usageBytes.new(
          'Erlang memory usage',
          targets=[signals.nodes.erlangMemoryUsage.asTarget()],
        )
        + g.panel.timeSeries.standardOptions.withUnit('decbytes')
        + g.panel.timeSeries.panelOptions.withDescription("The amount of memory used by a node's Erlang Virtual Machine."),

      nodeOpenOSFilesPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Open OS files',
          targets=[signals.nodes.openOSFiles.asTarget()],
        )
        + g.panel.timeSeries.panelOptions.withDescription('The total number of file descriptors open on a node.')
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      nodeOpenDatabasesPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Open databases',
          targets=[signals.nodes.openDatabases.asTarget()],
        )
        + g.panel.timeSeries.panelOptions.withDescription('The total number of open databases on a node.')
        + g.panel.timeSeries.standardOptions.withUnit(value='none'),

      nodeDatabaseWritesPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Database writes',
          targets=[signals.nodes.databaseWrites.asTarget() { interval: '2m' }],
        )
        + g.panel.timeSeries.panelOptions.withDescription('The total number of database writes on a node.')
        + g.panel.timeSeries.standardOptions.withUnit('wps'),

      nodeDatabaseReadsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Database reads',
          targets=[signals.nodes.databaseReads.asTarget() { interval: '2m' }],
        )
        + g.panel.timeSeries.panelOptions.withDescription('The total number of database reads on a node.')
        + g.panel.timeSeries.standardOptions.withUnit('rps'),

      nodeViewReadsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'View reads',
          targets=[signals.nodes.viewReads.asTarget() { interval: '2m' }],
        )
        + g.panel.timeSeries.panelOptions.withDescription('The total number of view reads on a node.')
        + g.panel.timeSeries.standardOptions.withUnit('rps'),

      nodeViewTimeoutsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'View timeouts',
          targets=[signals.nodes.viewTimeouts.asTarget() { interval: '2m' }],
        )
        + g.panel.timeSeries.panelOptions.withDescription('The total number of view requests that timed out on a node.')
        + g.panel.timeSeries.standardOptions.withUnit('reqps'),

      nodeTemporaryViewReadsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Temporary view reads',
          targets=[signals.nodes.temporaryViewReads.asTarget() { interval: '2m' }],
        )
        + g.panel.timeSeries.panelOptions.withDescription('The total number of temporary view reads on a node.')
        + g.panel.timeSeries.standardOptions.withUnit('rps'),

      nodeRequestMethodsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Request methods',
          targets=[signals.nodes.requestMethods.asTarget() { interval: '2m' }],
        )
        + g.panel.timeSeries.panelOptions.withDescription('The request rate split by HTTP Method for a node.')
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      nodeAverageRequestLatencyPanel:
        g.panel.histogram.new(title='Request latency quantiles')
        + g.panel.histogram.queryOptions.withTargets([
          signals.nodes.averageRequestLatency.asTarget()
          + g.query.prometheus.withInstant(true)
          + g.query.prometheus.withFormat('timeseries'),
        ])
        + g.panel.histogram.standardOptions.color.withMode('thresholds')
        + g.panel.histogram.options.legend.withPlacement('right')
        + g.panel.histogram.fieldConfig.defaults.custom.stacking.withMode('normal')
        + g.panel.histogram.options.withBucketCount(60)
        + g.panel.histogram.panelOptions.withDescription('The average request latency for a node.')
        + g.panel.histogram.standardOptions.withUnit('s'),

      nodeBulkRequestsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Bulk requests',
          targets=[signals.nodes.bulkRequests.asTarget() { interval: '2m' }],
        )
        + g.panel.timeSeries.panelOptions.withDescription('The total number of bulk requests on a node.')
        + g.panel.timeSeries.standardOptions.withUnit('rps'),

      nodeResponseStatusOverviewPanel:
        g.panel.pieChart.new('Response status overview')
        + g.panel.pieChart.queryOptions.withTargets([
          signals.nodes.responseStatus2xx.asTarget() { interval: '2m' },
          signals.nodes.responseStatus3xx.asTarget() { interval: '2m' },
          signals.nodes.responseStatus4xx.asTarget() { interval: '2m' },
          signals.nodes.responseStatus5xx.asTarget() { interval: '2m' },
        ])
        + g.panel.pieChart.panelOptions.withDescription('Responses grouped by HTTP status type (2xx, 3xx, 4xx, 5xx). Filter by instance to see specific node data.')
        + g.panel.pieChart.standardOptions.withUnit('none')
        + g.panel.pieChart.options.legend.withAsTable(true)
        + g.panel.pieChart.options.legend.withPlacement('right'),

      nodeGoodResponseStatusesPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Good response statuses',
          targets=[signals.nodes.goodResponseStatuses.asTarget() { interval: '2m' }],
        )
        + g.panel.timeSeries.panelOptions.withDescription('The total number of good response (HTTP 2xx-3xx) statuses on a node.')
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      nodeErrorResponseStatusesPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Error response statuses',
          targets=[signals.nodes.errorResponseStatuses.asTarget() { interval: '2m' }],
        )
        + g.panel.timeSeries.panelOptions.withDescription('The total number of error response (HTTP 4xx-5xx) statuses on a node.')
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withPlacement('right'),


      nodeLogTypesPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Log types',
          targets=[signals.nodes.logTypes.asTarget() { interval: '2m' }],
        )
        + g.panel.timeSeries.panelOptions.withDescription('The number of logged messages for a node.')
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withPlacement('right'),
    },
}
