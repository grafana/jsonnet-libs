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
    },
}
