// Tests for generic/timeSeries/percentage_unit.libsonnet.
local percentageUnit = import './percentage_unit.libsonnet';
local test = import 'jsonnetunit/test.libsonnet';

{
  percentageUnitStylize: {
    local result = percentageUnit.stylize(),
    testResult: test.suite({
      testUnit: {
        actual: result.fieldConfig.defaults.unit,
        expect: 'percentunit',
      },
      testMin: {
        actual: result.fieldConfig.defaults.min,
        expect: 0,
      },
      testMax: {
        actual: result.fieldConfig.defaults.max,
        expect: 1,
      },
      testDecimals: {
        actual: result.fieldConfig.defaults.decimals,
        expect: 1,
      },
      testColorMode: {
        actual: result.fieldConfig.defaults.color.mode,
        expect: 'continuous-BlYlRd',
      },
      testGradientMode: {
        actual: result.fieldConfig.defaults.custom.gradientMode,
        expect: 'scheme',
      },
    }),
  },
  percentageUnitStylizeTopLayer: {
    local result = percentageUnit.stylize(allLayers=false),
    testResult: test.suite({
      testUnit: {
        actual: result.fieldConfig.defaults.unit,
        expect: 'percentunit',
      },
      testMax: {
        actual: result.fieldConfig.defaults.max,
        expect: 1,
      },
      testNoBaseLayer: {
        actual: std.objectHas(result.fieldConfig.defaults.custom, 'lineWidth'),
        expect: false,
      },
    }),
  },
}
