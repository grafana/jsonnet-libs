// Tests for generic/timeSeries/percentage.libsonnet.
local percentage = import './percentage.libsonnet';
local test = import 'jsonnetunit/test.libsonnet';

{
  percentageStylize: {
    local result = percentage.stylize(),
    testResult: test.suite({
      testUnit: {
        actual: result.fieldConfig.defaults.unit,
        expect: 'percent',
      },
      testMin: {
        actual: result.fieldConfig.defaults.min,
        expect: 0,
      },
      testMax: {
        actual: result.fieldConfig.defaults.max,
        expect: 100,
      },
      testDecimals: {
        actual: result.fieldConfig.defaults.decimals,
        expect: 1,
      },
    }),
  },
}
