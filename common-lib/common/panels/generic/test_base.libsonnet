// Tests for generic/base.libsonnet: new(targets, description) and stylize().
local base = import './base.libsonnet';
local test = import 'jsonnetunit/test.libsonnet';

local minimalTargets = [
  {
    expr: 'up',
    refId: 'A',
    datasource: { type: 'prometheus', uid: 'ds' },
  },
];

{
  newPanel: {
    local result = base.new(minimalTargets, 'Panel description'),
    testResult: test.suite({
      testHasTargets: {
        actual: std.length(result.targets),
        expect: 1,
      },
      testTargetExpr: {
        actual: result.targets[0].expr,
        expect: 'up',
      },
      testDescription: {
        actual: result.description,
        expect: 'Panel description',
      },
      testDatasourceFromTargets: {
        actual: result.datasource.uid,
        expect: 'ds',
      },
      testStylizeThresholdsEmpty: {
        actual: result.fieldConfig.defaults.thresholds.steps,
        expect: [],
      },
    }),
  },
  stylize: {
    local result = base.stylize(),
    testResult: test.suite({
      testHasFieldConfigThresholds: {
        actual: std.objectHas(result.fieldConfig.defaults.thresholds, 'mode'),
        expect: true,
      },
      testThresholdsMode: {
        actual: result.fieldConfig.defaults.thresholds.mode,
        expect: 'absolute',
      },
    }),
  },
}
