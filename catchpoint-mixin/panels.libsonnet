local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;

{
  new(this):
    {
      local signals = this.signals,
      local stat = g.panel.stat,
      local fieldOverride = g.panel.table.fieldOverride,
      local alertList = g.panel.alertList,
      local pieChart = g.panel.pieChart,
      local barGauge = g.panel.barGauge,

      // Selector mixins appended to each signal's job/instance selector to
      // reproduce the legacy pureTestNameSelector / testNameSelector.
      local pureSel = 'test_name=~"$test_name"',
      local testSel = 'test_name=~"$test_name",node_name=~"$node_name"',

      // Overview: topk(1, avg by (<by>) (avg_over_time(<metric>[$__interval:])))
      local topAvg(signal, by) =
        signal
        .withFilteringSelectorMixin(pureSel)
        .withExprWrappersMixin(['avg_over_time(', '[$__interval:])'])
        .withExprWrappersMixin(['avg by (' + by + ') (', ')'])
        .withTopK(1)
        .withLegendFormat('{{' + by + '}}')
        .asTarget(),

      // Overview: topk(1, sum by (<by>) (sum_over_time(<metric>[$__interval:])))
      local topSum(signal, by) =
        signal
        .withFilteringSelectorMixin(pureSel)
        .withExprWrappersMixin(['sum_over_time(', '[$__interval:])'])
        .withExprWrappersMixin(['sum by (' + by + ') (', ')'])
        .withTopK(1)
        .withLegendFormat('{{' + by + '}}')
        .asTarget(),

      // Overview: bottomk(1, avg by (<by>) (avg_over_time(<successRatio>[$__interval:])))
      local bottomRatio(by) =
        signals.network.requestSuccessRatio
        .withFilteringSelectorMixin(pureSel)
        .withExprWrappersMixin(['avg_over_time(', '[$__interval:])'])
        .withExprWrappersMixin(['avg by (' + by + ') (', ')'])
        .withExprWrappersMixin(['bottomk(1, ', ')'])
        .withLegendFormat('{{' + by + '}}')
        .asTarget(),

      // Performance dashboards: sum by (<by>) (<metric>{testNameSelector})
      local sumBy(signal, by, legend) =
        signal
        .withFilteringSelectorMixin(testSel)
        .withExprWrappersMixin(['sum by (' + by + ') (', ')'])
        .withLegendFormat(legend)
        .asTarget(),

      // Performance dashboards: ratio-of-averages (aggregation baked in signal)
      local ratioBy(signal, legend) =
        signal
        .withFilteringSelectorMixin(testSel)
        .withLegendFormat(legend)
        .asTarget(),

      // Catchpoint Overview dashboard Panels
      topAvgLoadTimeTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top average total load time by tests',
          targets=[topAvg(signals.timing.loadTime, 'test_name')],
          description='The top average total load time among all tests over the specified interval.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      topAvgTotalLoadTimeNodeName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top average total load time by nodes',
          targets=[topAvg(signals.timing.loadTime, 'node_name')],
          description='The top average total load time among all nodes over the specified interval.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      topAvgDocumentCompletionTimeTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top average document completion time by tests',
          targets=[topAvg(signals.timing.documentCompleteTime, 'test_name')],
          description='The top average document completion time among all tests over the specified interval.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true')
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      topAvgDocumentCompletionTimeNodeName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top average document completion time by nodes',
          targets=[topAvg(signals.timing.documentCompleteTime, 'node_name')],
          description='The top average document completion time among all nodes over the specified interval.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      bottomAvgRequestRatioTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Bottom average success request ratio by tests',
          targets=[bottomRatio('test_name')],
          description='The lowest average success request ratio among all tests over the specified interval.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.standardOptions.withUnit('percentunit'),

      bottomAvgRequestSuccessRatioNodeName:
        commonlib.panels.generic.timeSeries.base.new(
          'Bottom average success request ratio by nodes',
          targets=[bottomRatio('node_name')],
          description='The lowest average success request ratio among all nodes over the specified interval.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.standardOptions.withUnit('percentunit'),

      topAvgConnectionSetupTimeTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top average connection setup time by tests',
          targets=[topAvg(signals.timing.connectTime, 'test_name')],
          description='The top average connection setup time among all tests over the specified interval.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      topAvgConnectionSetupTimeNodeName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top average connection setup time by nodes',
          targets=[topAvg(signals.timing.connectTime, 'node_name')],
          description='The top average connection setup time among all nodes over the specified interval.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      topAvgContentLoadingTimeTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top average content loading time',
          targets=[topAvg(signals.timing.contentLoadTime, 'test_name')],
          description='The top average content loading time among all tests over the specified interval.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      topAvgContentLoadingTimeNodeName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top average content loading time by nodes',
          targets=[topAvg(signals.timing.contentLoadTime, 'node_name')],
          description='The top average content loading time among all nodes over the specified interval.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      topAvgRedirectsTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top average redirects by tests',
          targets=[topAvg(signals.timing.redirectTime, 'test_name')],
          description='The top average number of redirects among all tests over the specified interval.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      topAvgRedirectsNodeName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top average redirects by nodes',
          targets=[topAvg(signals.timing.redirectTime, 'node_name')],
          description='The top average number of redirects among all nodes over the specified interval.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      alertsPanel:
        alertList.new('Catchpoint alerts')
        + alertList.options.UnifiedAlertListOptions.withAlertInstanceLabelFilter(this.grafana.variables.queriesGroupSelectorAdvanced),

      topErrorsByTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top errors by tests',
          targets=[topSum(signals.errors.anyError, 'test_name')],
          description='The top number of errors encountered among all tests over the specified interval.'
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.options.legend.withCalcs('lastNotNull')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      // Web Performance by Tests Dashboard Panels
      pageCompletionTime:
        commonlib.panels.generic.timeSeries.base.new(
          'Page completion time',
          targets=[
            sumBy(signals.timing.documentCompleteTime, 'node_name', '{{node_name}} - completion'),
            sumBy(signals.timing.totalTime, 'node_name', '{{node_name}} - load'),
          ],
          description='Time taken for the browser to fully render the page after all resources are downloaded.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.options.legend.withCalcs('lastNotNull')
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      DNSResolution:
        commonlib.panels.generic.timeSeries.base.new(
          'Connection and DNS resolution',
          targets=[
            sumBy(signals.timing.dnsTime, 'node_name', '{{node_name}} - DNS'),
            sumBy(signals.timing.sslTime, 'node_name', '{{node_name}} - SSL'),
            sumBy(signals.timing.connectTime, 'node_name', '{{node_name}} - connect'),
          ],
          description='Time taken to establish an SSL handshake, DNS resolution, and connect.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.options.legend.withCalcs('lastNotNull')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      contentHandling:
        commonlib.panels.generic.timeSeries.base.new(
          'Content handling',
          targets=[
            sumBy(signals.timing.contentLoadTime, 'node_name', '{{node_name}} - load'),
            sumBy(signals.timing.renderStartTime, 'node_name', '{{node_name}} - render'),
          ],
          description='Time taken to load and render content on the webpage.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.options.legend.withCalcs('lastNotNull')
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      clientProcessing:
        commonlib.panels.generic.timeSeries.base.new(
          'Client processing',
          targets=[sumBy(signals.timing.clientTime, 'node_name', '{{node_name}}')],
          description='Client processing time, which reflects the time spent on client-side processing, including script execution and rendering.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      additionalDelay:
        commonlib.panels.generic.timeSeries.base.new(
          'Additional delays',
          targets=[
            sumBy(signals.timing.redirectTime, 'node_name', '{{node_name}} - redirect'),
            sumBy(signals.timing.waitTime, 'node_name', '{{node_name}} - wait'),
          ],
          description='Additional delays encountered due to redirects, as well as time from successful connection to receiving the first byte.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.options.legend.withCalcs('lastNotNull')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      responseContentSize:
        commonlib.panels.generic.timeSeries.base.new(
          'Response content size',
          targets=[
            sumBy(signals.network.responseContentSize, 'node_name', '{{node_name}} - content'),
            sumBy(signals.network.responseHeaderSize, 'node_name', '{{node_name}} - header'),
          ],
          description='Size of the HTTP response content.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('decbytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      totalContentSize:
        commonlib.panels.generic.timeSeries.base.new(
          'Total content size',
          targets=[
            sumBy(signals.network.totalContentSize, 'node_name', '{{node_name}} - content'),
            sumBy(signals.network.totalHeaderSize, 'node_name', '{{node_name}} - header'),
          ],
          description='Total size of the HTTP response content and headers.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('decbytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withStacking({ mode: 'normal' })
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      networkConnections:
        commonlib.panels.generic.timeSeries.base.new(
          'Network connections',
          targets=[sumBy(signals.network.connectionsCount, 'node_name', '{{node_name}}')],
          description='Number of connections made.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('conn')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      hostsContacted:
        commonlib.panels.generic.timeSeries.base.new(
          'Hosts contacted',
          targets=[sumBy(signals.network.hostsCount, 'node_name', '{{node_name}}')],
          description='Number of hosts contacted.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('hosts')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      cacheAccess:
        commonlib.panels.generic.timeSeries.base.new(
          'Cache access',
          targets=[sumBy(signals.network.cachedCount, 'node_name', '{{node_name}}')],
          description='Number of cached elements accessed.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      requestSucessRatio:
        commonlib.panels.generic.timeSeries.base.new(
          'Requests success ratio',
          targets=[ratioBy(signals.network.requestSuccessRatioByNode, '{{node_name}}')],
          description='Success ratio of requests made.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.standardOptions.withUnit('percentunit')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      redirections:
        commonlib.panels.generic.timeSeries.base.new(
          'Redirects',
          targets=[sumBy(signals.network.redirectionsCount, 'node_name', '{{node_name}}')],
          description='Number of HTTP redirections encountered.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      contentTypesLoadedBySize:
        pieChart.new(title='Content types loaded by size')
        + pieChart.queryOptions.withTargets([
          sumBy(signals.content.imageContentSize, 'test_name', 'image'),
          sumBy(signals.content.htmlContentSize, 'test_name', 'html'),
          sumBy(signals.content.cssContentSize, 'test_name', 'css'),
          sumBy(signals.content.scriptContentSize, 'test_name', 'script'),
          sumBy(signals.content.fontContentSize, 'test_name', 'font'),
          sumBy(signals.content.xmlContentSize, 'test_name', 'xml'),
          sumBy(signals.content.mediaContentSize, 'test_name', 'media'),
        ])
        + pieChart.options.legend.withPlacement('right')
        + pieChart.options.withTooltipMixin({
          mode: 'multi',
          sort: 'desc',
        })
        + pieChart.panelOptions.withDescription('Size of content loaded.')
        + pieChart.standardOptions.withUnit('decbytes'),

      contentLoadedByType:
        barGauge.new(title='Content loaded by type')
        + barGauge.queryOptions.withTargets([
          sumBy(signals.content.imageCount, 'test_name', 'image'),
          sumBy(signals.content.htmlCount, 'test_name', 'html'),
          sumBy(signals.content.cssCount, 'test_name', 'css'),
          sumBy(signals.content.scriptCount, 'test_name', 'script'),
          sumBy(signals.content.fontCount, 'test_name', 'font'),
          sumBy(signals.content.xmlCount, 'test_name', 'xml'),
          sumBy(signals.content.mediaCount, 'test_name', 'media'),
        ])
        + barGauge.panelOptions.withDescription('Number of elements loaded.')
        + barGauge.options.withOrientation('horizontal')
        + barGauge.standardOptions.thresholds.withSteps([
          barGauge.thresholdStep.withColor('super-light-green'),
        ]),

      errors:
        barGauge.new(title='Errors')
        + barGauge.queryOptions.withTargets([
          sumBy(signals.errors.errorObjectsLoaded, 'test_name', 'object loaded'),
          sumBy(signals.errors.dnsError, 'test_name', 'DNS'),
          sumBy(signals.errors.loadError, 'test_name', 'load'),
          sumBy(signals.errors.timeoutError, 'test_name', 'timeout'),
          sumBy(signals.errors.connectionError, 'test_name', 'connection'),
          sumBy(signals.errors.transactionError, 'test_name', 'transaction'),
        ])
        + barGauge.panelOptions.withDescription('Indicates various errors that are occuring.')
        + barGauge.options.withOrientation('horizontal')
        + barGauge.standardOptions.withMax(1)
        + barGauge.standardOptions.thresholds.withSteps([
          barGauge.thresholdStep.withColor('super-light-green'),
          barGauge.standardOptions.threshold.step.withValue(1) + barGauge.thresholdStep.withColor('super-light-red'),
        ]),

      // Web Performance by Nodes Dashboard Panels
      pageCompletionTimeNodeName:
        commonlib.panels.generic.timeSeries.base.new(
          'Page completion time',
          targets=[
            sumBy(signals.timing.documentCompleteTime, 'test_name', '{{test_name}} - completion'),
            sumBy(signals.timing.totalTime, 'test_name', '{{test_name}} - load'),
          ],
          description='Time taken for the browser to fully render the page after all resources are downloaded.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.options.legend.withCalcs('lastNotNull')
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      DNSResolutionNodeName:
        commonlib.panels.generic.timeSeries.base.new(
          'Connection and DNS resolution',
          targets=[
            sumBy(signals.timing.dnsTime, 'test_name', '{{test_name}} - DNS'),
            sumBy(signals.timing.sslTime, 'test_name', '{{test_name}} - SSL'),
            sumBy(signals.timing.connectTime, 'test_name', '{{test_name}} - connect'),
          ],
          description='Time taken establish an SSL handshake, DNS resolution and connect.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.options.legend.withCalcs('lastNotNull')
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      contentHandlingNodeName:
        commonlib.panels.generic.timeSeries.base.new(
          'Content handling',
          targets=[
            sumBy(signals.timing.contentLoadTime, 'node_name', '{{node_name}} - load'),
            sumBy(signals.timing.renderStartTime, 'node_name', '{{node_name}} - render'),
          ],
          description='Time taken to load and render content on the webpage.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.options.legend.withCalcs('lastNotNull')
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      clientProcessingNodeName:
        commonlib.panels.generic.timeSeries.base.new(
          'Client processing',
          targets=[sumBy(signals.timing.clientTime, 'test_name', '{{test_name}}')],
          description='Client processing time, which reflects the time spent on client-side processing, including script execution and rendering.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      additionalDelayNodeName:
        commonlib.panels.generic.timeSeries.base.new(
          'Additional delays',
          targets=[
            sumBy(signals.timing.redirectTime, 'test_name', '{{test_name}} - redirect'),
            sumBy(signals.timing.waitTime, 'test_name', '{{test_name}} - wait'),
          ],
          description='Additional delays encountered due to redirects as well as time from successful connection to receiving the first byte.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.options.legend.withCalcs('lastNotNull')
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      responseContentSizeNodeName:
        commonlib.panels.generic.timeSeries.base.new(
          'Response content size',
          targets=[
            sumBy(signals.network.responseContentSize, 'test_name', '{{test_name}} - content'),
            sumBy(signals.network.responseHeaderSize, 'test_name', '{{test_name}} - header'),
          ],
          description='Size of the HTTP response content in bytes.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('decbytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      totalContentSizeNodeName:
        commonlib.panels.generic.timeSeries.base.new(
          'Total content size',
          targets=[
            sumBy(signals.network.totalContentSize, 'test_name', '{{test_name}} - content'),
            sumBy(signals.network.totalHeaderSize, 'test_name', '{{test_name}} - header'),
          ],
          description='Total size of the HTTP response content and headers in bytes.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('decbytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withStacking({ mode: 'normal' })
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      networkConnectionsNodeName:
        commonlib.panels.generic.timeSeries.base.new(
          'Network connections',
          targets=[sumBy(signals.network.connectionsCount, 'test_name', '{{test_name}}')],
          description='Number of connections made.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('conn')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      hostsContactedNodeName:
        commonlib.panels.generic.timeSeries.base.new(
          'Hosts contacted',
          targets=[sumBy(signals.network.hostsCount, 'test_name', '{{test_name}}')],
          description='Number of hosts contacted.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('hosts')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      cacheAccessNodeName:
        commonlib.panels.generic.timeSeries.base.new(
          'Cache access',
          targets=[sumBy(signals.network.cachedCount, 'test_name', '{{test_name}}')],
          description='Number of cached elements accessed.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      requestSucessRatioNodeName:
        commonlib.panels.generic.timeSeries.base.new(
          'Requests success ratio',
          targets=[ratioBy(signals.network.requestSuccessRatioByTest, '{{test_name}}')],
          description='Success ratio of requests made.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.standardOptions.withUnit('percentunit')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      redirectionsNodeName:
        commonlib.panels.generic.timeSeries.base.new(
          'Redirects',
          targets=[sumBy(signals.network.redirectionsCount, 'test_name', '{{test_name}}')],
          description='Number of HTTP redirections encountered.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      contentTypesLoadedBySizeNodeName:
        pieChart.new(title='Content types loaded by size')
        + pieChart.queryOptions.withTargets([
          sumBy(signals.content.imageContentSize, 'node_name', 'image'),
          sumBy(signals.content.htmlContentSize, 'node_name', 'html'),
          sumBy(signals.content.cssContentSize, 'node_name', 'css'),
          sumBy(signals.content.scriptContentSize, 'node_name', 'script'),
          sumBy(signals.content.fontContentSize, 'node_name', 'font'),
          sumBy(signals.content.xmlContentSize, 'node_name', 'xml'),
          sumBy(signals.content.mediaContentSize, 'node_name', 'media'),
        ])
        + pieChart.options.legend.withPlacement('right')
        + pieChart.options.withTooltipMixin({
          mode: 'multi',
          sort: 'desc',
        })
        + pieChart.panelOptions.withDescription('Size of content loaded in bytes')
        + pieChart.standardOptions.withUnit('decbytes'),

      contentLoadedByTypeNodeName:
        barGauge.new(title='Content loaded by type')
        + barGauge.queryOptions.withTargets([
          sumBy(signals.content.imageCount, 'node_name', 'image'),
          sumBy(signals.content.htmlCount, 'node_name', 'html'),
          sumBy(signals.content.cssCount, 'node_name', 'css'),
          sumBy(signals.content.scriptCount, 'node_name', 'script'),
          sumBy(signals.content.fontCount, 'node_name', 'font'),
          sumBy(signals.content.xmlCount, 'node_name', 'xml'),
          sumBy(signals.content.mediaCount, 'node_name', 'media'),
        ])
        + barGauge.panelOptions.withDescription('Number of elements loaded.')
        + barGauge.options.withOrientation('horizontal')
        + barGauge.standardOptions.thresholds.withSteps([
          barGauge.thresholdStep.withColor('super-light-green'),
        ]),

      errorsNodeName:
        barGauge.new(title='Errors')
        + barGauge.queryOptions.withTargets([
          sumBy(signals.errors.errorObjectsLoaded, 'node_name', 'object loaded'),
          sumBy(signals.errors.dnsError, 'node_name', 'DNS'),
          sumBy(signals.errors.loadError, 'node_name', 'load'),
          sumBy(signals.errors.timeoutError, 'node_name', 'timeout'),
          sumBy(signals.errors.connectionError, 'node_name', 'connection'),
          sumBy(signals.errors.transactionError, 'node_name', 'transaction'),
        ])
        + barGauge.panelOptions.withDescription('Indicates various errors that are occuring.')
        + barGauge.options.withOrientation('horizontal')
        + barGauge.standardOptions.withMax(1)
        + barGauge.standardOptions.thresholds.withSteps([
          barGauge.thresholdStep.withColor('super-light-green'),
          barGauge.standardOptions.threshold.step.withValue(1) + barGauge.thresholdStep.withColor('super-light-red'),
        ]),
    },
}
