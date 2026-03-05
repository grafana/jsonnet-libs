// Tests for generic/timeSeries/threshold.libsonnet.
local threshold = import './threshold.libsonnet';
local test = import 'jsonnetunit/test.libsonnet';

{
  thresholdStylize: {
    local result = threshold.stylize(),
    testResult: test.suite({
      testFillOpacity: {
        actual: result.fieldConfig.defaults.custom.fillOpacity,
        expect: 0,
      },
      testLineStyleFill: {
        actual: result.fieldConfig.defaults.custom.lineStyle.fill,
        expect: 'dash',
      },
    }),
  },
}
