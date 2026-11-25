// Tests for generic/stat/percentage_unit.libsonnet.
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
      testColorMode: {
        actual: result.options.colorMode,
        expect: 'value',
      },
      testDecimals: {
        actual: result.fieldConfig.defaults.decimals,
        expect: 1,
      },
      testReduceCalcs: {
        actual: result.options.reduceOptions.calcs,
        expect: ['lastNotNull'],
      },
    }),
  },
}
