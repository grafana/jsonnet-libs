// Tests for generic/stat/info.libsonnet.
local info = import './info.libsonnet';
local test = import 'jsonnetunit/test.libsonnet';

{
  infoStylize: {
    local result = info.stylize(),
    testResult: test.suite({
      testGraphMode: {
        actual: result.options.graphMode,
        expect: 'none',
      },
      testHasReduceOptionsCalcs: {
        actual: std.length(result.options.reduceOptions.calcs),
        expect: 1,
      },
      testCalcsLastNotNull: {
        actual: result.options.reduceOptions.calcs[0],
        expect: 'lastNotNull',
      },
    }),
  },
}
