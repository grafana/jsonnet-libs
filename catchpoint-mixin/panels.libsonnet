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
          description='Average total time it took to load the webpage by test name, helping assess the responsiveness and speed of the monitored webpage.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      topMaxTotalLoadTime:
        commonlib.panels.generic.timeSeries.base.new(
          'Top max total load time',
          targets=[t.topMaxTotalLoadTime],
          description='Maximum total time it took to load the webpage by test name, indicating the worst-case scenario for webpage loading performance.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      topAvgDocumentCompletionTimeTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top average document completion time by test name',
          targets=[t.topAvgDocumentCompletionTimeTestName],
          description='Average time taken for the browser to fully render the page after all resources are downloaded by test name, serving as a key indicator of end-user perceived load time.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      topMaxDocumentCompletionTime:
        commonlib.panels.generic.timeSeries.base.new(
          'Top max document completion time',
          targets=[t.topMaxDocumentCompletionTime],
          description='Maximum time taken for the browser to fully render the page after all resources are downloaded by test name, highlighting the worst-case scenario for end-user perceived load time.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      topAvgRequestRatioTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top average request ratio by test name',
          targets=[t.topAvgRequestSuccessRatioTestName, t.topAvgRequestFailureRatioTestName],
          description='Average ratio of successful and failed requests by test name.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percentunit'),

      topMaxRequestRatioTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top max request ratio by test name',
          targets=[t.topMaxRequestSuccessRatioTestName, t.topMaxRequestFailureRatioTestName],
          description=''
        )
        + g.panel.timeSeries.standardOptions.withUnit('percentunit'),

      topAvgConnectionSetupTimeTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top average connection setup time by test name',
          targets=[t.topAvgConnectionSetupTimeTestName],
          description='Average time taken to establish a connection to the URL by test names.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      topMaxConnectionSetupTimeTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top max connection setup time by test name',
          targets=[t.topMaxConnectionSetupTimeTestName],
          description='Maximum time taken to establish a connection to the URL by test name, indicating the worst-case scenario for network connectivity and infrastructure performance.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      topAvgContentLoadingTimeTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top average content loading time by test name',
          targets=[t.topAvgContentLoadingTimeTestName],
          description='Average time taken to load content on the webpage by test name.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      topMaxContentLoadingTimeTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top average content loading time by test name',
          targets=[t.topMaxContentLoadingTimeTestName],
          description='Maximum time taken to load content on the webpage by test name, highlighting the worst-case scenario for content delivery and display speed.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      topAvgRedirectsTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top average redirects by test name',
          targets=[t.topAvgRedirectsTestName],
          description='Average number of HTTP redirections by test name, which is important for assessing the impact of redirects on overall page load time.'
        ),

      topMaxRedirectsTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top max redirects by test name',
          targets=[t.topMaxRedirectsTestName],
          description='Maximum number of HTTP redirections encountered by test name, indicating the worst-case scenario for the impact of redirects on page load time.'
        ),

      alertsPanel:
        alertList.new('Catchpoint alerts')
        + alertList.options.UnifiedAlertListOptions.withAlertInstanceLabelFilter(this.grafana.variables.queriesGroupSelectorAdvanced),

      topErrorsByTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top errors by test name',
          targets=[t.topErrorsByTestName],
          description='Errors encountered by test name.'
        ),

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
        + g.panel.timeSeries.standardOptions.withMax(1)
        + g.panel.timeSeries.standardOptions.withMin(0)
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

      // Web Performance by Node Name Dashboard Panels
      pageCompletionTimeNodeName:
        commonlib.panels.generic.timeSeries.base.new(
          'Page completion time',
          targets=[t.pageCompletionTimeNodeName],
          description='Time taken for the browser to fully render the page after all resources are downloaded.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      DNSResolutionNodeName:
        commonlib.panels.generic.timeSeries.base.new(
          'Connection and DNS resolution',
          targets=[t.DNSResolutionNodeName],
          description='Time taken to establish a connection to the URL and resolve the domain name, which is critical for identifying network connectivity and DNS resolution issues.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      contentHandlingNodeName:
        commonlib.panels.generic.timeSeries.base.new(
          'Content handling',
          targets=[t.contentHandlingLoadNodeName, t.contentHandlingRenderNodeName],
          description='Time taken to load and render content on the webpage.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      clientProcessingNodeName:
        commonlib.panels.generic.timeSeries.base.new(
          'Client processing',
          targets=[t.clientProcessingNodeName],
          description='Client processing time, which reflects the time spent on client-side processing, including script execution and rendering.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      additionalDelayNodeName:
        commonlib.panels.generic.timeSeries.base.new(
          'Additional delays',
          targets=[t.additionalDelayNodeName],
          description='Additional delays encountered due to redirects.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      responseContentSizeNodeName:
        commonlib.panels.generic.timeSeries.base.new(
          'Response content size',
          targets=[t.responseContentSizeNodeName, t.responseHeaderSizeNodeName],
          description='Size of the HTTP response content in bytes.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('decbytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      totalContentSizeNodeName:
        commonlib.panels.generic.timeSeries.base.new(
          'Total content size',
          targets=[t.totalContentSizeNodeName, t.totalHeaderSizeNodeName],
          description='Total size of the HTTP response content and headers in bytes.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('decbytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      networkConnectionsNodeName:
        commonlib.panels.generic.timeSeries.base.new(
          'Network connections',
          targets=[t.networkConnectionsNodeName],
          description='Number of connections made.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('conn')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      hostsContactedNodeName:
        commonlib.panels.generic.timeSeries.base.new(
          'Hosts contacted',
          targets=[t.hostsContactedNodeName],
          description='Number of hosts contacted.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('hosts')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),


      cacheAccessNodeName:
        commonlib.panels.generic.timeSeries.base.new(
          'Cache access',
          targets=[t.cacheAccessNodeName],
          description='Number of cached elements accessed.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      requestsRatioNodeName:
        commonlib.panels.generic.timeSeries.base.new(
          'Requests success/failure ratio',
          targets=[t.requestsSuccessRatioNodeName],
          description='Success ratio of requests made.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percentunit')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      redirectionsNodeName:
        commonlib.panels.generic.timeSeries.base.new(
          'Redirects',
          targets=[t.redirectionsNodeName],
          description='Number of HTTP redirections encountered.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      contentTypesLoadedBySizeNodeName:
        pieChart.new(title='Content types loaded by size')
        + pieChart.queryOptions.withTargets([t.imageLoadedBySizeNodeName, t.htmlLoadedBySizeNodeName, t.cssLoadedBySizeNodeName, t.scriptLoadedBySizeNodeName, t.fontLoadedBySizeNodeName, t.xmlLoadedBySizeNodeName, t.mediaLoadedBySizeNodeName])
        + pieChart.options.legend.withPlacement('right')
        + pieChart.options.withTooltipMixin({
          mode: 'multi',
          sort: 'desc',
        })
        + pieChart.panelOptions.withDescription('Size of content loaded in bytes')
        + pieChart.standardOptions.withUnit('decbytes'),

      contentLoadedByTypeNodeName:
        barGauge.new(title='Content loaded by type')
        + barGauge.queryOptions.withTargets([t.imageLoadedByTypeNodeName, t.htmlLoadedByTypeNodeName, t.cssLoadedByTypeNodeName, t.scriptLoadedByTypeNodeName, t.fontLoadedByTypeNodeName, t.xmlLoadedByTypeNodeName, t.mediaLoadedByTypeNodeName])
        + barGauge.panelOptions.withDescription('Number of elements loaded.')
        + barGauge.options.withOrientation('horizontal')
        + barGauge.standardOptions.thresholds.withSteps([
          barGauge.thresholdStep.withColor('super-light-green'),
        ]),

      errorsNodeName:
        commonlib.panels.generic.timeSeries.base.new(
          'Errors',
          targets=[t.errorsNodeName],
          description='Indicates if any errors occurred.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('err')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),
    },
}
