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
          description=''
        )
        + stat.options.withGraphMode('none'),

      topMaxTotalLoadTime:
        commonlib.panels.generic.timeSeries.base.new(
          'Top max total load time',
          targets=[t.topMaxTotalLoadTime],
          description=''
        )
        + stat.options.withGraphMode('none'),

      topAvgDocumentCompletionTimeTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top average document completion time by test name',
          targets=[t.topAvgDocumentCompletionTimeTestName],
          description=''
        )
        + stat.options.withGraphMode('none'),

      topMaxDocumentCompletionTime:
        commonlib.panels.generic.timeSeries.base.new(
          'Top max document completion time',
          targets=[t.topMaxDocumentCompletionTime],
          description=''
        )
        + stat.options.withGraphMode('none'),

      topAvgRequestRatioTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top average request ratio by test name',
          targets=[t.topAvgRequestSuccessRatioTestName, t.topAvgRequestFailureRatioTestName],
          description=''
        )
        + stat.options.withGraphMode('none'),

      topMaxRequestRatioTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top max request ratio by test name',
          targets=[t.topMaxRequestSuccessRatioTestName, t.topMaxRequestFailureRatioTestName],
          description=''
        )
        + stat.options.withGraphMode('none'),

      topAvgConnectionSetupTimeTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top average connection setup time by test name',
          targets=[t.topAvgConnectionSetupTimeTestName],
          description=''
        )
        + stat.options.withGraphMode('none'),

      topMaxConnectionSetupTimeTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top max connection setup time by test name',
          targets=[t.topMaxConnectionSetupTimeTestName],
          description=''
        )
        + stat.options.withGraphMode('none'),

      topAvgContentLoadingTimeTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top average content loading time by test name',
          targets=[t.topAvgContentLoadingTimeTestName],
          description=''
        )
        + stat.options.withGraphMode('none'),

      topMaxContentLoadingTimeTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top average content loading time by test name',
          targets=[t.topMaxContentLoadingTimeTestName],
          description=''
        )
        + stat.options.withGraphMode('none'),

      topAvgRedirectsTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top average redirects by test name',
          targets=[t.topAvgRedirectsTestName],
          description=''
        )
        + stat.options.withGraphMode('none'),

      topMaxRedirectsTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top max redirects by test name',
          targets=[t.topMaxRedirectsTestName],
          description=''
        )
        + stat.options.withGraphMode('none'),

      alertsPanel:
        alertList.new('Catchpoint alerts')
        + alertList.options.UnifiedAlertListOptions.withAlertInstanceLabelFilter(this.grafana.variables.queriesGroupSelectorAdvanced),

      topErrorsByTestName:
        commonlib.panels.generic.timeSeries.base.new(
          'Top errors by test name',
          targets=[t.topErrorsByTestName],
          description=''
        )
        + stat.options.withGraphMode('none'),

    },
}
