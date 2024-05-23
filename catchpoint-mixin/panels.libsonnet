local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;

{
  new(this):
    {
      local t = this.grafana.targets,
      local stat = g.panel.stat,
      local fieldOverride = g.panel.table.fieldOverride,
      local alertList = g.panel.alertList,
      local pieChart = g.panel.pieChart,
      local barGauge = g.panel.barGauge,

      // Catchpoint Overview dashboard Panels
      topAvgLoadTimeTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top average total load time by test name',
          targets=[t.topAvgLoadTimeTestName],
          description='The top average total load time among all test names over the specified interval.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      topAvgTotalLoadTimeNodeName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top average total load time by node name',
          targets=[t.topAvgTotalLoadTimeNodeName],
          description='The top average total load time among all node names over the specified interval.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true')
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      topAvgDocumentCompletionTimeTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top average document completion time by test name',
          targets=[t.topAvgDocumentCompletionTimeTestName],
          description='The top average document completion time among all test names over the specified interval.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true')
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      topAvgDocumentCompletionTimeNodeName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top average document completion time by node name',
          targets=[t.topAvgDocumentCompletionTimeNodeName],
          description='The top average document completion time among all node names over the specified interval.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true')
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      bottomAvgRequestRatioTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Bottom average success request ratio by test name',
          targets=[t.bottomAvgRequestSuccessRatioTestName],
          description='The lowest average success request ratio among all test names over the specified interval.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true')
        + g.panel.timeSeries.standardOptions.withMax(1)
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withUnit('percentunit'),

      bottomAvgRequestSuccessRatioNodeName:
        commonlib.panels.generic.timeSeries.base.new(
          'Bottom average success request ratio by node name',
          targets=[t.bottomAvgRequestSuccessRatioNodeName],
          description='The lowest average success request ratio among all node names over the specified interval.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true')
        + g.panel.timeSeries.standardOptions.withMax(1)
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withUnit('percentunit'),

      topAvgConnectionSetupTimeTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top average connection setup time by test name',
          targets=[t.topAvgConnectionSetupTimeTestName],
          description='The top average connection setup time among all test names over the specified interval.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true')
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      topAvgConnectionSetupTimeNodeName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top average connection setup time by node name',
          targets=[t.topAvgConnectionSetupTimeNodeName],
          description='The top average connection setup time among all node names over the specified interval.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true')
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      topAvgContentLoadingTimeTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top average content loading time',
          targets=[t.topAvgContentLoadingTimeTestName],
          description='The top average content loading time among all test names over the specified interval.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true')
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      topAvgContentLoadingTimeNodeName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top average content loading time by node name',
          targets=[t.topAvgContentLoadingTimeNodeName],
          description='The top average content loading time among all node names over the specified interval.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true')
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      topAvgRedirectsTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top average redirects by test name',
          targets=[t.topAvgRedirectsTestName],
          description='The top average number of redirects among all test names over the specified interval.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      topAvgRedirectsNodeName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top average redirects by node name',
          targets=[t.topAvgRedirectsNodeName],
          description='The top average number of redirects among all node names over the specified interval.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      alertsPanel:
        alertList.new('Catchpoint alerts')
        + alertList.options.UnifiedAlertListOptions.withAlertInstanceLabelFilter(this.grafana.variables.queriesGroupSelectorAdvanced),

      topErrorsByTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top errors by test name',
          targets=[t.topErrorsByTestName],
          description='The top number of errors encountered among all test names over the specified interval.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      // Web Performance by Test Name Dashboard Panels
      pageCompletionTime:
        commonlib.panels.generic.timeSeries.base.new(
          'Page completion time',
          targets=[t.pageCompletionTime, t.pageTotalLoadTime],
          description='Time taken for the browser to fully render the page after all resources are downloaded.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      DNSResolution:
        commonlib.panels.generic.timeSeries.base.new(
          'Connection and DNS resolution',
          targets=[t.DNSResolution, t.SSLTime, t.connectTime],
          description='Time taken to establish an SSL handshake, DNS resolution, and connect.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      contentHandling:
        commonlib.panels.generic.timeSeries.base.new(
          'Content handling',
          targets=[t.contentHandlingLoad, t.contentHandlingRender],
          description='Time taken to load and render content on the webpage.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      clientProcessing:
        commonlib.panels.generic.timeSeries.base.new(
          'Client processing',
          targets=[t.clientProcessing],
          description='Client processing time, which reflects the time spent on client-side processing, including script execution and rendering.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      additionalDelay:
        commonlib.panels.generic.timeSeries.base.new(
          'Additional delays',
          targets=[t.additionalDelay, t.waitTime],
          description='Additional delays encountered due to redirects, as well as time from successful connection to receiving the first byte.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      responseContentSize:
        commonlib.panels.generic.timeSeries.base.new(
          'Response content size',
          targets=[t.responseContentSize, t.responseHeaderSize],
          description='Size of the HTTP response content.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('decbytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      totalContentSize:
        commonlib.panels.generic.timeSeries.base.new(
          'Total content size',
          targets=[t.totalContentSize, t.totalHeaderSize],
          description='Total size of the HTTP response content and headers.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('decbytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      networkConnections:
        commonlib.panels.generic.timeSeries.base.new(
          'Network connections',
          targets=[t.networkConnections],
          description='Number of connections made.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('conn')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      hostsContacted:
        commonlib.panels.generic.timeSeries.base.new(
          'Hosts contacted',
          targets=[t.hostsContacted],
          description='Number of hosts contacted.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('hosts')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),


      cacheAccess:
        commonlib.panels.generic.timeSeries.base.new(
          'Cache access',
          targets=[t.cacheAccess],
          description='Number of cached elements accessed.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      requestSucessRatio:
        commonlib.panels.generic.timeSeries.base.new(
          'Requests success ratio',
          targets=[t.requestSuccessRatio],
          description='Success ratio of requests made.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percentunit')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      redirections:
        commonlib.panels.generic.timeSeries.base.new(
          'Redirects',
          targets=[t.redirections],
          description='Number of HTTP redirections encountered.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      contentTypesLoadedBySize:
        pieChart.new(title='Content types loaded by size')
        + pieChart.queryOptions.withTargets([t.imageLoadedBySize, t.htmlLoadedBySize, t.cssLoadedBySize, t.scriptLoadedBySize, t.fontLoadedBySize, t.xmlLoadedBySize, t.mediaLoadedBySize])
        + pieChart.options.legend.withPlacement('right')
        + pieChart.options.withTooltipMixin({
          mode: 'multi',
          sort: 'desc',
        })
        + pieChart.panelOptions.withDescription('Size of content loaded.')
        + pieChart.standardOptions.withUnit('decbytes'),

      contentLoadedByType:
        barGauge.new(title='Content loaded by type')
        + barGauge.queryOptions.withTargets([t.imageLoadedByType, t.htmlLoadedByType, t.cssLoadedByType, t.scriptLoadedByType, t.fontLoadedByType, t.xmlLoadedByType, t.mediaLoadedByType])
        + barGauge.panelOptions.withDescription('Number of elements loaded.')
        + barGauge.options.withOrientation('horizontal')
        + barGauge.standardOptions.thresholds.withSteps([
          barGauge.thresholdStep.withColor('super-light-green'),
        ]),


      errors:
        barGauge.new(title='Errors')
        + barGauge.queryOptions.withTargets([t.objectLoadedError, t.DNSError, t.loadError, t.timeoutError, t.connectionError, t.transactionError])
        + barGauge.panelOptions.withDescription('Indicates various potential errors that are occuring.')
        + barGauge.options.withOrientation('horizontal')
        + barGauge.standardOptions.withMax(1)
        + barGauge.standardOptions.thresholds.withSteps([
          barGauge.thresholdStep.withColor('super-light-green'),
          barGauge.standardOptions.threshold.step.withValue(1) + barGauge.thresholdStep.withColor('super-light-red'),
        ]),

    },
}
