// Tests for generic/table/base.libsonnet.
local tableBase = import './base.libsonnet';
local test = import 'jsonnetunit/test.libsonnet';

local minimalTargets = [
  {
    expr: 'up',
    refId: 'A',
    datasource: { type: 'prometheus', uid: 'ds' },
  },
];

{
  tableBaseNew: {
    local result = tableBase.new('Status table', minimalTargets, 'Service status'),
    testResult: test.suite({
      testType: {
        actual: result.type,
        expect: 'table',
      },
      testTitle: {
        actual: result.title,
        expect: 'Status table',
      },
      testDescription: {
        actual: result.description,
        expect: 'Service status',
      },
      testTargetsLength: {
        actual: std.length(result.targets),
        expect: 1,
      },
    }),
  },
  tableBaseSortBy: {
    local result = tableBase.transformations.sortBy('Value', desc=true),
    testResult: test.suite({
      testId: {
        actual: result.id,
        expect: 'sortBy',
      },
      testSortDesc: {
        actual: result.options.sort[0].desc,
        expect: true,
      },
      testSortField: {
        actual: result.options.sort[0].field,
        expect: 'Value',
      },
    }),
  },
}
