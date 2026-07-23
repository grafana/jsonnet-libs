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

      // Each helper returns the SIGNAL with the legacy call-site modifiers
      // applied. Single-signal panels render it directly with asTimeSeries();
      // multi-signal, pieChart and barGauge panels append .asTarget().

      // Overview: topk(1, avg by (<by>) (avg_over_time(<metric>[$__interval:])))
      local topAvg(signal, by) =
        signal
        .withFilteringSelectorMixin(pureSel)
        .withExprWrappersMixin(['avg_over_time(', '[$__interval:])'])
        .withExprWrappersMixin(['avg by (' + by + ') (', ')'])
        .withTopK(1)
        .withLegendFormat('{{' + by + '}}'),

      // Overview: topk(1, sum by (<by>) (sum_over_time(<metric>[$__interval:])))
      local topSum(signal, by) =
        signal
        .withFilteringSelectorMixin(pureSel)
        .withExprWrappersMixin(['sum_over_time(', '[$__interval:])'])
        .withExprWrappersMixin(['sum by (' + by + ') (', ')'])
        .withTopK(1)
        .withLegendFormat('{{' + by + '}}'),

      // Overview: bottomk(1, avg by (<by>) (avg_over_time(<successRatio>[$__interval:])))
      local bottomRatio(by) =
        signals.network.requestSuccessRatio
        .withFilteringSelectorMixin(pureSel)
        .withExprWrappersMixin(['avg_over_time(', '[$__interval:])'])
        .withExprWrappersMixin(['avg by (' + by + ') (', ')'])
        .withExprWrappersMixin(['bottomk(1, ', ')'])
        .withLegendFormat('{{' + by + '}}'),

      // Performance dashboards: sum by (<by>) (<metric>{testNameSelector})
      local sumBy(signal, by, legend) =
        signal
        .withFilteringSelectorMixin(testSel)
        .withExprWrappersMixin(['sum by (' + by + ') (', ')'])
        .withLegendFormat(legend),

      // Performance dashboards: ratio-of-averages (aggregation baked in signal)
      local ratioBy(signal, legend) =
        signal
        .withFilteringSelectorMixin(testSel)
        .withLegendFormat(legend),

      // Catchpoint Overview dashboard Panels
      topAvgLoadTimeTestName:
        topAvg(signals.timing.loadTime, 'test_name')
        .withName('Top average total load time by tests')
        .asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.panelOptions.withDescription('The top average total load time among all tests over the specified interval.')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      topAvgTotalLoadTimeNodeName:
        topAvg(signals.timing.loadTime, 'node_name')
        .withName('Top average total load time by nodes')
        .asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.panelOptions.withDescription('The top average total load time among all nodes over the specified interval.')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

      topAvgDocumentCompletionTimeTestName:
        topAvg(signals.timing.documentCompleteTime, 'test_name')
        .withName('Top average document completion time by tests')
        .asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.panelOptions.withDescription('The top average document completion time among all tests over the specified interval.')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      topAvgDocumentCompletionTimeNodeName:
        topAvg(signals.timing.documentCompleteTime, 'node_name')
        .withName('Top average document completion time by nodes')
        .asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.panelOptions.withDescription('The top average document completion time among all nodes over the specified interval.')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

      bottomAvgRequestRatioTestName:
        bottomRatio('test_name')
        .withName('Bottom average success request ratio by tests')
        .asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.panelOptions.withDescription('The lowest average success request ratio among all tests over the specified interval.')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

      bottomAvgRequestSuccessRatioNodeName:
        bottomRatio('node_name')
        .withName('Bottom average success request ratio by nodes')
        .asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.panelOptions.withDescription('The lowest average success request ratio among all nodes over the specified interval.')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

      topAvgConnectionSetupTimeTestName:
        topAvg(signals.timing.connectTime, 'test_name')
        .withName('Top average connection setup time by tests')
        .asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.panelOptions.withDescription('The top average connection setup time among all tests over the specified interval.')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

      topAvgConnectionSetupTimeNodeName:
        topAvg(signals.timing.connectTime, 'node_name')
        .withName('Top average connection setup time by nodes')
        .asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.panelOptions.withDescription('The top average connection setup time among all nodes over the specified interval.')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

      topAvgContentLoadingTimeTestName:
        topAvg(signals.timing.contentLoadTime, 'test_name')
        .withName('Top average content loading time')
        .asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.panelOptions.withDescription('The top average content loading time among all tests over the specified interval.')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

      topAvgContentLoadingTimeNodeName:
        topAvg(signals.timing.contentLoadTime, 'node_name')
        .withName('Top average content loading time by nodes')
        .asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.panelOptions.withDescription('The top average content loading time among all nodes over the specified interval.')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10),

      topAvgRedirectsTestName:
        topAvg(signals.timing.redirectTime, 'test_name')
        .withName('Top average redirects by tests')
        .withUnit('')
        .asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.panelOptions.withDescription('The top average number of redirects among all tests over the specified interval.')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      topAvgRedirectsNodeName:
        topAvg(signals.timing.redirectTime, 'node_name')
        .withName('Top average redirects by nodes')
        .withUnit('')
        .asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.panelOptions.withDescription('The top average number of redirects among all nodes over the specified interval.')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      alertsPanel:
        alertList.new('Catchpoint alerts')
        + alertList.options.UnifiedAlertListOptions.withAlertInstanceLabelFilter(this.grafana.variables.queriesGroupSelectorAdvanced),

      topErrorsByTestName:
        topSum(signals.errors.anyError, 'test_name')
        .asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
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
            sumBy(signals.timing.documentCompleteTime, 'node_name', '{{node_name}} - completion').asTarget(),
            sumBy(signals.timing.totalTime, 'node_name', '{{node_name}} - load').asTarget(),
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
            sumBy(signals.timing.dnsTime, 'node_name', '{{node_name}} - DNS').asTarget(),
            sumBy(signals.timing.sslTime, 'node_name', '{{node_name}} - SSL').asTarget(),
            sumBy(signals.timing.connectTime, 'node_name', '{{node_name}} - connect').asTarget(),
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
            sumBy(signals.timing.contentLoadTime, 'node_name', '{{node_name}} - load').asTarget(),
            sumBy(signals.timing.renderStartTime, 'node_name', '{{node_name}} - render').asTarget(),
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
        sumBy(signals.timing.clientTime, 'node_name', '{{node_name}}')
        .asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      additionalDelay:
        commonlib.panels.generic.timeSeries.base.new(
          'Additional delays',
          targets=[
            sumBy(signals.timing.redirectTime, 'node_name', '{{node_name}} - redirect').asTarget(),
            sumBy(signals.timing.waitTime, 'node_name', '{{node_name}} - wait').asTarget(),
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
            sumBy(signals.network.responseContentSize, 'node_name', '{{node_name}} - content').asTarget(),
            sumBy(signals.network.responseHeaderSize, 'node_name', '{{node_name}} - header').asTarget(),
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
            sumBy(signals.network.totalContentSize, 'node_name', '{{node_name}} - content').asTarget(),
            sumBy(signals.network.totalHeaderSize, 'node_name', '{{node_name}} - header').asTarget(),
          ],
          description='Total size of the HTTP response content and headers.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('decbytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withStacking({ mode: 'normal' })
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      networkConnections:
        sumBy(signals.network.connectionsCount, 'node_name', '{{node_name}}')
        .asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      hostsContacted:
        sumBy(signals.network.hostsCount, 'node_name', '{{node_name}}')
        .asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      cacheAccess:
        sumBy(signals.network.cachedCount, 'node_name', '{{node_name}}')
        .asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      requestSucessRatio:
        ratioBy(signals.network.requestSuccessRatioByNode, '{{node_name}}')
        .asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      redirections:
        sumBy(signals.network.redirectionsCount, 'node_name', '{{node_name}}')
        .asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      contentTypesLoadedBySize:
        pieChart.new(title='Content types loaded by size')
        + pieChart.queryOptions.withTargets([
          sumBy(signals.content.imageContentSize, 'test_name', 'image').asTarget(),
          sumBy(signals.content.htmlContentSize, 'test_name', 'html').asTarget(),
          sumBy(signals.content.cssContentSize, 'test_name', 'css').asTarget(),
          sumBy(signals.content.scriptContentSize, 'test_name', 'script').asTarget(),
          sumBy(signals.content.fontContentSize, 'test_name', 'font').asTarget(),
          sumBy(signals.content.xmlContentSize, 'test_name', 'xml').asTarget(),
          sumBy(signals.content.mediaContentSize, 'test_name', 'media').asTarget(),
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
          sumBy(signals.content.imageCount, 'test_name', 'image').asTarget(),
          sumBy(signals.content.htmlCount, 'test_name', 'html').asTarget(),
          sumBy(signals.content.cssCount, 'test_name', 'css').asTarget(),
          sumBy(signals.content.scriptCount, 'test_name', 'script').asTarget(),
          sumBy(signals.content.fontCount, 'test_name', 'font').asTarget(),
          sumBy(signals.content.xmlCount, 'test_name', 'xml').asTarget(),
          sumBy(signals.content.mediaCount, 'test_name', 'media').asTarget(),
        ])
        + barGauge.panelOptions.withDescription('Number of elements loaded.')
        + barGauge.options.withOrientation('horizontal')
        + barGauge.standardOptions.thresholds.withSteps([
          barGauge.thresholdStep.withColor('super-light-green'),
        ]),

      errors:
        barGauge.new(title='Errors')
        + barGauge.queryOptions.withTargets([
          sumBy(signals.errors.errorObjectsLoaded, 'test_name', 'object loaded').asTarget(),
          sumBy(signals.errors.dnsError, 'test_name', 'DNS').asTarget(),
          sumBy(signals.errors.loadError, 'test_name', 'load').asTarget(),
          sumBy(signals.errors.timeoutError, 'test_name', 'timeout').asTarget(),
          sumBy(signals.errors.connectionError, 'test_name', 'connection').asTarget(),
          sumBy(signals.errors.transactionError, 'test_name', 'transaction').asTarget(),
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
            sumBy(signals.timing.documentCompleteTime, 'test_name', '{{test_name}} - completion').asTarget(),
            sumBy(signals.timing.totalTime, 'test_name', '{{test_name}} - load').asTarget(),
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
            sumBy(signals.timing.dnsTime, 'test_name', '{{test_name}} - DNS').asTarget(),
            sumBy(signals.timing.sslTime, 'test_name', '{{test_name}} - SSL').asTarget(),
            sumBy(signals.timing.connectTime, 'test_name', '{{test_name}} - connect').asTarget(),
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
            sumBy(signals.timing.contentLoadTime, 'node_name', '{{node_name}} - load').asTarget(),
            sumBy(signals.timing.renderStartTime, 'node_name', '{{node_name}} - render').asTarget(),
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
        sumBy(signals.timing.clientTime, 'test_name', '{{test_name}}')
        .asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      additionalDelayNodeName:
        commonlib.panels.generic.timeSeries.base.new(
          'Additional delays',
          targets=[
            sumBy(signals.timing.redirectTime, 'test_name', '{{test_name}} - redirect').asTarget(),
            sumBy(signals.timing.waitTime, 'test_name', '{{test_name}} - wait').asTarget(),
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
            sumBy(signals.network.responseContentSize, 'test_name', '{{test_name}} - content').asTarget(),
            sumBy(signals.network.responseHeaderSize, 'test_name', '{{test_name}} - header').asTarget(),
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
            sumBy(signals.network.totalContentSize, 'test_name', '{{test_name}} - content').asTarget(),
            sumBy(signals.network.totalHeaderSize, 'test_name', '{{test_name}} - header').asTarget(),
          ],
          description='Total size of the HTTP response content and headers in bytes.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('decbytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withStacking({ mode: 'normal' })
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      networkConnectionsNodeName:
        sumBy(signals.network.connectionsCount, 'test_name', '{{test_name}}')
        .asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      hostsContactedNodeName:
        sumBy(signals.network.hostsCount, 'test_name', '{{test_name}}')
        .asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      cacheAccessNodeName:
        sumBy(signals.network.cachedCount, 'test_name', '{{test_name}}')
        .asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      requestSucessRatioNodeName:
        ratioBy(signals.network.requestSuccessRatioByTest, '{{test_name}}')
        .asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      redirectionsNodeName:
        sumBy(signals.network.redirectionsCount, 'test_name', '{{test_name}}')
        .asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      contentTypesLoadedBySizeNodeName:
        pieChart.new(title='Content types loaded by size')
        + pieChart.queryOptions.withTargets([
          sumBy(signals.content.imageContentSize, 'node_name', 'image').asTarget(),
          sumBy(signals.content.htmlContentSize, 'node_name', 'html').asTarget(),
          sumBy(signals.content.cssContentSize, 'node_name', 'css').asTarget(),
          sumBy(signals.content.scriptContentSize, 'node_name', 'script').asTarget(),
          sumBy(signals.content.fontContentSize, 'node_name', 'font').asTarget(),
          sumBy(signals.content.xmlContentSize, 'node_name', 'xml').asTarget(),
          sumBy(signals.content.mediaContentSize, 'node_name', 'media').asTarget(),
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
          sumBy(signals.content.imageCount, 'node_name', 'image').asTarget(),
          sumBy(signals.content.htmlCount, 'node_name', 'html').asTarget(),
          sumBy(signals.content.cssCount, 'node_name', 'css').asTarget(),
          sumBy(signals.content.scriptCount, 'node_name', 'script').asTarget(),
          sumBy(signals.content.fontCount, 'node_name', 'font').asTarget(),
          sumBy(signals.content.xmlCount, 'node_name', 'xml').asTarget(),
          sumBy(signals.content.mediaCount, 'node_name', 'media').asTarget(),
        ])
        + barGauge.panelOptions.withDescription('Number of elements loaded.')
        + barGauge.options.withOrientation('horizontal')
        + barGauge.standardOptions.thresholds.withSteps([
          barGauge.thresholdStep.withColor('super-light-green'),
        ]),

      errorsNodeName:
        barGauge.new(title='Errors')
        + barGauge.queryOptions.withTargets([
          sumBy(signals.errors.errorObjectsLoaded, 'node_name', 'object loaded').asTarget(),
          sumBy(signals.errors.dnsError, 'node_name', 'DNS').asTarget(),
          sumBy(signals.errors.loadError, 'node_name', 'load').asTarget(),
          sumBy(signals.errors.timeoutError, 'node_name', 'timeout').asTarget(),
          sumBy(signals.errors.connectionError, 'node_name', 'connection').asTarget(),
          sumBy(signals.errors.transactionError, 'node_name', 'transaction').asTarget(),
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
