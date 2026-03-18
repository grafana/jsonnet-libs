// Tests for generic/stat/base.libsonnet.
local statBase = import './base.libsonnet';
local test = import 'jsonnetunit/test.libsonnet';

local minimalTargets = [
  {
    expr: 'up',
    refId: 'A',
    datasource: { type: 'prometheus', uid: 'ds' },
  },
];

{
  statBaseNew: {
    local result = statBase.new('Service up', minimalTargets, 'Whether the service is up'),
    testResult: test.suite({
      testType: {
        actual: result.type,
        expect: 'stat',
      },
      testTitle: {
        actual: result.title,
        expect: 'Service up',
      },
      testDescription: {
        actual: result.description,
        expect: 'Whether the service is up',
      },
      testTargetsLength: {
        actual: std.length(result.targets),
        expect: 1,
      },
    }),
  },
  statStylize: {
    local result = statBase.stylize(),
    testResult: test.suite({
      testHasThresholds: {
        actual: std.objectHas(result.fieldConfig.defaults, 'thresholds'),
        expect: true,
      },
      testThresholdsStepsLength: {
        actual: std.length(result.fieldConfig.defaults.thresholds.steps),
        expect: 1,
      },
    }),
  },
}
