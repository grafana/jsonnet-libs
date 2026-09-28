local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this):
    {
      local signals = this.signals,

      // Shared styling for the drilldown time series: a filled area, spanned
      // gaps (Catchpoint reports per test run, so the series are sparse), and a
      // right-hand table legend on the panels that carry several series.
      //
      // commonlib.panels.generic.timeSeries.base.stylize() applies exactly the
      // styling that base.new() applies, so the signal-built panels below
      // (asTimeSeries(), which keeps unit/description/overrides on the signals
      // layer) render identically to the hand-built multi-target panels that do
      // call base.new().
      local stylize =
        commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(true),
      local tableLegend =
        g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.options.legend.withCalcs(['lastNotNull']),

      // Catchpoint overview dashboard
      topAvgLoadTimeTestName:
        signals.overview.loadTimeByTest.asTimeSeries() + stylize,
      topAvgTotalLoadTimeNodeName:
        signals.overview.loadTimeByNode.asTimeSeries() + stylize,
      topAvgDocumentCompletionTimeTestName:
        signals.overview.documentCompleteTimeByTest.asTimeSeries() + stylize,
      topAvgDocumentCompletionTimeNodeName:
        signals.overview.documentCompleteTimeByNode.asTimeSeries() + stylize,
      // Not timeSeries.percentage.new: these are `percentunit` ratios (0-1), and
      // that helper hardcodes unit='percent' with min=0/max=100.
      bottomAvgRequestRatioTestName:
        signals.overview.requestSuccessRatioByTest.asTimeSeries() + stylize,
      bottomAvgRequestSuccessRatioNodeName:
        signals.overview.requestSuccessRatioByNode.asTimeSeries() + stylize,
      topAvgConnectionSetupTimeTestName:
        signals.overview.connectTimeByTest.asTimeSeries() + stylize,
      topAvgConnectionSetupTimeNodeName:
        signals.overview.connectTimeByNode.asTimeSeries() + stylize,
      topAvgContentLoadingTimeTestName:
        signals.overview.contentLoadTimeByTest.asTimeSeries() + stylize,
      topAvgContentLoadingTimeNodeName:
        signals.overview.contentLoadTimeByNode.asTimeSeries() + stylize,
      topAvgRedirectsTestName:
        signals.overview.redirectTimeByTest.asTimeSeries() + stylize,
      topAvgRedirectsNodeName:
        signals.overview.redirectTimeByNode.asTimeSeries() + stylize,

      topErrorsByTestName:
        signals.overview.anyErrorByTest.asTimeSeries() + stylize + tableLegend,

      // Spelled out in full: common-lib has no generic alertList helper
      // (commonlib.panels.generic covers timeSeries, stat, table and
      // statusHistory only), and an alert list has no targets for the generic
      // base to style.
      alertsPanel:
        g.panel.alertList.new('Catchpoint alerts')
        + g.panel.alertList.options.UnifiedAlertListOptions.withAlertInstanceLabelFilter(
          this.grafana.variables.queriesSelectorAdvancedSyntax
        ),

      // Web performance drilldowns. Both dashboards render the same panels; the
      // only difference is which signal set they draw from, so each panel is
      // built once by a local function and instantiated per pivot below.
      local pageCompletionTimePanel(timing) =
        commonlib.panels.generic.timeSeries.base.new(
          'Page completion time',
          targets=[
            timing.documentCompleteTime.asTarget(),
            timing.totalTime.asTarget(),
          ],
          description='Time taken for the browser to fully render the page after all resources are downloaded.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + stylize
        + tableLegend,

      local dnsResolutionPanel(timing) =
        commonlib.panels.generic.timeSeries.base.new(
          'Connection and DNS resolution',
          targets=[
            timing.dnsTime.asTarget(),
            timing.sslTime.asTarget(),
            timing.connectTime.asTarget(),
          ],
          description='Time taken to establish an SSL handshake, DNS resolution, and connect.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + stylize
        + tableLegend,

      local contentHandlingPanel(timing) =
        commonlib.panels.generic.timeSeries.base.new(
          'Content handling',
          targets=[
            timing.contentLoadTime.asTarget(),
            timing.renderStartTime.asTarget(),
          ],
          description='Time taken to load and render content on the webpage.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + stylize
        + tableLegend,

      local additionalDelayPanel(timing) =
        commonlib.panels.generic.timeSeries.base.new(
          'Additional delays',
          targets=[
            timing.redirectTime.asTarget(),
            timing.waitTime.asTarget(),
          ],
          description='Additional delays encountered due to redirects, as well as time from successful connection to receiving the first byte.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + stylize
        + tableLegend,

      local responseContentSizePanel(network) =
        commonlib.panels.generic.timeSeries.base.new(
          'Response content size',
          targets=[
            network.responseContentSize.asTarget(),
            network.responseHeaderSize.asTarget(),
          ],
          description='Size of the HTTP response content.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('decbytes')
        + stylize,

      local totalContentSizePanel(network) =
        commonlib.panels.generic.timeSeries.base.new(
          'Total content size',
          targets=[
            network.totalContentSize.asTarget(),
            network.totalHeaderSize.asTarget(),
          ],
          description='Total size of the HTTP response content and headers.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('decbytes')
        + stylize
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

      // Spelled out in full: common-lib has no generic pieChart helper, and the
      // generic base only emits timeSeries-shaped field config, so it cannot
      // style a pie chart.
      local contentTypesLoadedBySizePanel(content) =
        g.panel.pieChart.new('Content types loaded by size')
        + g.panel.pieChart.panelOptions.withDescription('Size of content loaded.')
        + g.panel.pieChart.queryOptions.withTargets([
          content.imageContentSize.asTarget(),
          content.htmlContentSize.asTarget(),
          content.cssContentSize.asTarget(),
          content.scriptContentSize.asTarget(),
          content.fontContentSize.asTarget(),
          content.xmlContentSize.asTarget(),
          content.mediaContentSize.asTarget(),
        ])
        + g.panel.pieChart.standardOptions.withUnit('decbytes')
        + g.panel.pieChart.options.legend.withPlacement('right')
        + g.panel.pieChart.options.tooltip.withMode('multi')
        + g.panel.pieChart.options.tooltip.withSort('desc'),

      // Spelled out in full: common-lib has no generic barGauge helper. The
      // nearest match, table.cold_hot_gauge, renders a table with an embedded
      // gauge cell rather than the horizontal bar row per content type that this
      // panel needs.
      local contentLoadedByTypePanel(content) =
        g.panel.barGauge.new('Content loaded by type')
        + g.panel.barGauge.panelOptions.withDescription('Number of elements loaded.')
        + g.panel.barGauge.queryOptions.withTargets([
          content.imageCount.asTarget(),
          content.htmlCount.asTarget(),
          content.cssCount.asTarget(),
          content.scriptCount.asTarget(),
          content.fontCount.asTarget(),
          content.xmlCount.asTarget(),
          content.mediaCount.asTarget(),
        ])
        + g.panel.barGauge.options.withOrientation('horizontal')
        + g.panel.barGauge.standardOptions.thresholds.withSteps([
          g.panel.barGauge.thresholdStep.withColor('super-light-green'),
        ]),

      // Spelled out in full for the same reason as contentLoadedByTypePanel
      // above. Every metric here is a 0/1 indicator, so the gauge tops out at 1
      // and turns red as soon as an error is reported.
      local errorsPanel(errors) =
        g.panel.barGauge.new('Errors')
        + g.panel.barGauge.panelOptions.withDescription('Indicates various errors that are occuring.')
        + g.panel.barGauge.queryOptions.withTargets([
          errors.errorObjectsLoaded.asTarget(),
          errors.dnsError.asTarget(),
          errors.loadError.asTarget(),
          errors.timeoutError.asTarget(),
          errors.connectionError.asTarget(),
          errors.transactionError.asTarget(),
        ])
        + g.panel.barGauge.options.withOrientation('horizontal')
        + g.panel.barGauge.standardOptions.withMax(1)
        + g.panel.barGauge.standardOptions.thresholds.withSteps([
          g.panel.barGauge.thresholdStep.withColor('super-light-green'),
          g.panel.barGauge.thresholdStep.withColor('super-light-red')
          + g.panel.barGauge.thresholdStep.withValue(1),
        ]),

      // Web performance by tests: one test broken down by node.
      pageCompletionTime: pageCompletionTimePanel(signals.timingByNode),
      DNSResolution: dnsResolutionPanel(signals.timingByNode),
      contentHandling: contentHandlingPanel(signals.timingByNode),
      additionalDelay: additionalDelayPanel(signals.timingByNode),
      clientProcessing:
        signals.timingByNode.clientTime.asTimeSeries() + stylize,
      responseContentSize: responseContentSizePanel(signals.networkByNode),
      totalContentSize: totalContentSizePanel(signals.networkByNode),
      networkConnections:
        signals.networkByNode.connectionsCount.asTimeSeries() + stylize,
      hostsContacted:
        signals.networkByNode.hostsCount.asTimeSeries() + stylize,
      cacheAccess:
        signals.networkByNode.cachedCount.asTimeSeries() + stylize,
      requestSucessRatio:
        signals.networkByNode.requestSuccessRatio.asTimeSeries() + stylize,
      redirections:
        signals.networkByNode.redirectionsCount.asTimeSeries() + stylize,
      contentTypesLoadedBySize: contentTypesLoadedBySizePanel(signals.contentByTest),
      contentLoadedByType: contentLoadedByTypePanel(signals.contentByTest),
      errors: errorsPanel(signals.errorsByTest),

      // Web performance by nodes: one node broken down by test.
      pageCompletionTimeNodeName: pageCompletionTimePanel(signals.timingByTest),
      DNSResolutionNodeName: dnsResolutionPanel(signals.timingByTest),
      contentHandlingNodeName: contentHandlingPanel(signals.timingByTest),
      additionalDelayNodeName: additionalDelayPanel(signals.timingByTest),
      clientProcessingNodeName:
        signals.timingByTest.clientTime.asTimeSeries() + stylize,
      responseContentSizeNodeName: responseContentSizePanel(signals.networkByTest),
      totalContentSizeNodeName: totalContentSizePanel(signals.networkByTest),
      networkConnectionsNodeName:
        signals.networkByTest.connectionsCount.asTimeSeries() + stylize,
      hostsContactedNodeName:
        signals.networkByTest.hostsCount.asTimeSeries() + stylize,
      cacheAccessNodeName:
        signals.networkByTest.cachedCount.asTimeSeries() + stylize,
      requestSucessRatioNodeName:
        signals.networkByTest.requestSuccessRatio.asTimeSeries() + stylize,
      redirectionsNodeName:
        signals.networkByTest.redirectionsCount.asTimeSeries() + stylize,
      contentTypesLoadedBySizeNodeName: contentTypesLoadedBySizePanel(signals.contentByNode),
      contentLoadedByTypeNodeName: contentLoadedByTypePanel(signals.contentByNode),
      errorsNodeName: errorsPanel(signals.errorsByNode),
    },
}
