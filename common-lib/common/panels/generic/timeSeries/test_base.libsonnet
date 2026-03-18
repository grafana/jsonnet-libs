// Tests for generic/timeSeries/base.libsonnet.
local timeSeriesBase = import './base.libsonnet';
local test = import 'jsonnetunit/test.libsonnet';

local minimalTargets = [
  {
    expr: 'rate(http_requests_total[5m])',
    refId: 'A',
    datasource: { type: 'prometheus', uid: 'ds' },
  },
];

{
  timeSeriesBaseNew: {
    local result = timeSeriesBase.new('Request rate', minimalTargets, 'Requests per second'),
    testResult: test.suite({
      testType: {
        actual: result.type,
        expect: 'timeseries',
      },
      testTitle: {
        actual: result.title,
        expect: 'Request rate',
      },
      testDescription: {
        actual: result.description,
        expect: 'Requests per second',
      },
      testTargetsLength: {
        actual: std.length(result.targets),
        expect: 1,
      },
      testTooltipMode: {
        actual: result.options.tooltip.mode,
        expect: 'multi',
      },
    }),
  },
}
