// Tests for generic/table/cold_hot_gauge.libsonnet.
local coldHotGauge = import './cold_hot_gauge.libsonnet';
local test = import 'jsonnetunit/test.libsonnet';

{
  stylizeByName: {
    local result = coldHotGauge.stylizeByName('RPS'),
    local overrides = result.fieldConfig.overrides,
    local override = overrides[0],
    local propsById = { [p.id]: p.value for p in override.properties },
    testResult: test.suite({
      testMatcherName: {
        actual: override.matcher.options,
        expect: 'RPS',
      },
      testCellOptionsGauge: {
        actual: propsById['custom.cellOptions'].type,
        expect: 'gauge',
      },
      testCellOptionsBasic: {
        actual: propsById['custom.cellOptions'].mode,
        expect: 'basic',
      },
      testFieldMinMax: {
        actual: propsById.fieldMinMax,
        expect: true,
      },
      testColorColdhot: {
        actual: std.substr(propsById.color.mode, 0, 11),
        expect: 'continuous-',
      },
    }),
  },
}
