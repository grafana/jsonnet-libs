local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;

{
  new(this):
    {
      local t = this.grafana.targets,
      local stat = g.panel.stat,
      local barGauge = g.panel.barGauge,
      local fieldOverride = g.panel.table.fieldOverride,
      local alertList = g.panel.alertList,
      topAvgLoadTimeTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top average total load time by test name',
          targets=[t.topAvgLoadTimeTestName],
          description='Average total time it took to load the webpage by test name, helping assess the responsiveness and speed of the monitored webpage.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      topMaxTotalLoadTime:
        commonlib.panels.generic.timeSeries.base.new(
          'Top max total load time',
          targets=[t.topMaxTotalLoadTime],
          description='Maximum total time it took to load the webpage by test name, indicating the worst-case scenario for webpage loading performance.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true')
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      topAvgDocumentCompletionTimeTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top average document completion time by test name',
          targets=[t.topAvgDocumentCompletionTimeTestName],
          description='Average time taken for the browser to fully render the page after all resources are downloaded by test name, serving as a key indicator of end-user perceived load time.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true')
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      topMaxDocumentCompletionTime:
        commonlib.panels.generic.timeSeries.base.new(
          'Top max document completion time',
          targets=[t.topMaxDocumentCompletionTime],
          description='Maximum time taken for the browser to fully render the page after all resources are downloaded by test name, highlighting the worst-case scenario for end-user perceived load time.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true')
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      bottomAvgRequestRatioTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Bottom average success request ratio by test name',
          targets=[t.bottomAvgRequestSuccessRatioTestName],
          description='Worst average succesful request ratio by test name.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true')
        + g.panel.timeSeries.standardOptions.withUnit('percentunit'),

      topMaxFailedRequestRatioTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top max failed request ratio',
          targets=[t.topMaxFailedRequestRatioTestName],
          description='Highest failure request ratio.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true')
        + g.panel.timeSeries.standardOptions.withUnit('percentunit'),

      topAvgConnectionSetupTimeTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top average connection setup time by test name',
          targets=[t.topAvgConnectionSetupTimeTestName],
          description='Average time taken to establish a connection to the URL by test names.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true')
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      topMaxConnectionSetupTimeTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top max connection setup time by test name',
          targets=[t.topMaxConnectionSetupTimeTestName],
          description='Maximum time taken to establish a connection to the URL by test name, indicating the worst-case scenario for network connectivity and infrastructure performance.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true')
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      topAvgContentLoadingTimeTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top average content loading time by test name',
          targets=[t.topAvgContentLoadingTimeTestName],
          description='Average time taken to load content on the webpage by test name.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true')
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      topMaxContentLoadingTimeTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top average content loading time by test name',
          targets=[t.topMaxContentLoadingTimeTestName],
          description='Maximum time taken to load content on the webpage by test name, highlighting the worst-case scenario for content delivery and display speed.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true')
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      topAvgRedirectsTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top average redirects by test name',
          targets=[t.topAvgRedirectsTestName],
          description='Average number of HTTP redirections by test name, which is important for assessing the impact of redirects on overall page load time.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      topMaxRedirectsTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top max redirects by test name',
          targets=[t.topMaxRedirectsTestName],
          description='Maximum number of HTTP redirections encountered by test name, indicating the worst-case scenario for the impact of redirects on page load time.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),

      alertsPanel:
        alertList.new('Catchpoint alerts')
        + alertList.options.UnifiedAlertListOptions.withAlertInstanceLabelFilter(this.grafana.variables.queriesGroupSelectorAdvanced),

      topErrorsByTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top errors by test name',
          targets=[t.topErrorsByTestName],
          description='Errors encountered by test name.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls('true'),
    },
}
