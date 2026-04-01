// Tests for generic/timeSeries/topk_percentage.libsonnet.
local topkPercentage = import './topk_percentage.libsonnet';
local test = import 'jsonnetunit/test.libsonnet';

local minimalTarget = {
  expr: 'cpu_usage',
  refId: 'A',
  datasource: { type: 'prometheus', uid: 'ds' },
};

{
  topkPercentageNew: {
    local result = topkPercentage.new(
      'CPU by instance',
      minimalTarget,
      topk=5,
      instanceLabels=['instance'],
      drillDownDashboardUid='drill',
      description='Top 5'
    ),
    testResult: test.suite({
      testTargetsLength: {
        actual: std.length(result.targets),
        expect: 2,
      },
      testFirstTargetHasTopk: {
        actual: std.substr(result.targets[0].expr, 0, 7),
        expect: 'topk(5,',
      },
      testDescription: {
        actual: result.description,
        expect: 'Top 5',
      },
    }),
  },
  topkPercentageStylize: {
    local result = topkPercentage.stylize(),
    testResult: test.suite({
      testLegendDisplayMode: {
        actual: result.options.legend.displayMode,
        expect: 'table',
      },
      testLegendPlacement: {
        actual: result.options.legend.placement,
        expect: 'right',
      },
    }),
  },
}
