// Tests for generic/table/percentage.libsonnet.
local percentage = import './percentage.libsonnet';
local test = import 'jsonnetunit/test.libsonnet';

{
  stylizeByName: {
    local result = percentage.stylizeByName('CPU'),
    local overrides = result.fieldConfig.overrides,
    local override = overrides[0],
    local propsById = { [p.id]: p.value for p in override.properties },
    testResult: test.suite({
      testMatcherName: {
        actual: override.matcher.options,
        expect: 'CPU',
      },
      testCellOptionsGauge: {
        actual: propsById['custom.cellOptions'].type,
        expect: 'gauge',
      },
      testCellOptionsBasic: {
        actual: propsById['custom.cellOptions'].mode,
        expect: 'basic',
      },
      testUnit: {
        actual: propsById['unit'],
        expect: 'percent',
      },
      testMin: {
        actual: propsById['min'],
        expect: 0,
      },
      testMax: {
        actual: propsById['max'],
        expect: 100,
      },
    }),
  },
}
