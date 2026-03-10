// Tests for generic/statusHistory/base.libsonnet.
local statusHistoryBase = import './base.libsonnet';
local test = import 'jsonnetunit/test.libsonnet';

local minimalTargets = [
  {
    expr: 'up',
    refId: 'A',
    datasource: { type: 'prometheus', uid: 'ds' },
  },
];

{
  statusHistoryBaseNew: {
    local result = statusHistoryBase.new('Status over time', minimalTargets, 'Up/down status'),
    testResult: test.suite({
      testType: {
        actual: result.type,
        expect: 'status-history',
      },
      testTitle: {
        actual: result.title,
        expect: 'Status over time',
      },
      testDescription: {
        actual: result.description,
        expect: 'Up/down status',
      },
      testTargetsLength: {
        actual: std.length(result.targets),
        expect: 1,
      },
    }),
  },
}
