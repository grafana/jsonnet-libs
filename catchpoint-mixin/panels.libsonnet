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
          targets=[t.pageCompletionTime],
          description=''
        ),

      DNSResolution:
        commonlib.panels.generic.timeSeries.base.new(
          'Connection and DNS resolution',
          targets=[t.DNSResolution],
          description=''
        ),
      contentHandling:
        commonlib.panels.generic.timeSeries.base.new(
          'Content handling',
          targets=[t.contentHandlingLoad, t.contentHandlingRender],
          description=''
        ),

      clientProcessing:
        commonlib.panels.generic.timeSeries.base.new(
          'Client processing',
          targets=[t.clientProcessing],
          description=''
        ),

      additionalDelay:
        commonlib.panels.generic.timeSeries.base.new(
          'Additional delays',
          targets=[t.additionalDelay],
          description=''
        ),

      responseContentSize:
        commonlib.panels.generic.timeSeries.base.new(
          'Response content size',
          targets=[t.responseContentSize, t.responseHeaderSize],
          description=''
        ),

      totalContentSize:
        commonlib.panels.generic.timeSeries.base.new(
          'Total content size',
          targets=[t.totalContentSize, t.totalHeaderSize],
          description=''
        ),

      networkConnections:
        commonlib.panels.generic.timeSeries.base.new(
          'Network connections',
          targets=[t.networkConnections],
          description=''
        ),

      hostsContacted:
        commonlib.panels.generic.timeSeries.base.new(
          'Hosts contacted',
          targets=[t.hostsContacted],
          description=''
        ),

      cacheAccess:
        commonlib.panels.generic.timeSeries.base.new(
          'Cache access',
          targets=[t.cacheAccess],
          description=''
        ),

      requestsRatio:
        commonlib.panels.generic.timeSeries.base.new(
          'Requests success/failure ratio',
          targets=[t.requestsSuccessRatio, t.requestsFailureRatio],
          description=''
        ),

      redirections:
        commonlib.panels.generic.timeSeries.base.new(
          'Redirects',
          targets=[t.redirections],
          description=''
        ),

      contentTypesLoadedBySize:
        pieChart.new(title='Content types loaded by size')
        + pieChart.queryOptions.withTargets([t.imageLoadedBySize, t.htmlLoadedBySize, t.cssLoadedBySize, t.scriptLoadedBySize, t.fontLoadedBySize, t.xmlLoadedBySize, t.mediaLoadedBySize])
        + pieChart.options.legend.withPlacement('right')
        + pieChart.options.withTooltipMixin({
          mode: 'multi',
          sort: 'desc',
        })
        + pieChart.panelOptions.withDescription(''),


      contentLoadedByType:
        barGauge.new(title='Content loaded by type')
        + barGauge.queryOptions.withTargets([t.imageLoadedByType, t.htmlLoadedByType, t.cssLoadedByType, t.scriptLoadedByType, t.fontLoadedByType, t.xmlLoadedByType, t.mediaLoadedByType])
        + barGauge.panelOptions.withDescription('')
        + barGauge.options.withOrientation('horizontal'),

      errors:
        commonlib.panels.generic.timeSeries.base.new(
          'Errors',
          targets=[t.errors],
          description=''
        ),
    },
}
