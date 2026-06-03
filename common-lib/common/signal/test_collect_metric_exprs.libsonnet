local signal = import './signal.libsonnet';
local test = import 'jsonnetunit/test.libsonnet';

local jsonSignals = {
  aggLevel: 'group',
  groupLabels: ['job'],
  instanceLabels: ['instance'],
  filteringSelector: 'job="integrations/agent"',
  aggKeepLabels: ['xxx'],
  signals: {
    abc: {
      name: 'ABC',
      type: 'gauge',
      description: 'ABC',
      unit: 's',
      sources: {
        prometheus: {
          expr: 'abc{%(queriesSelector)s}',
        },
      },
    },
    bar: {
      name: 'BAR',
      type: 'counter',
      description: 'BAR',
      unit: 'ns',
      sources: {
        prometheus: {
          expr: 'bar{%(queriesSelector)s}',
        },
      },
    },
    // optional signal with no matching source -> becomes a stub.
    // asPanelExpression() returns {} and must be filtered out.
    stubbed: {
      name: 'Stubbed',
      type: 'gauge',
      description: 'stub',
      unit: 'short',
      optional: true,
      sources: {
        otel: {
          expr: 'stubbed_otel_only{%(queriesSelector)s}',
        },
      },
    },
  },
};

local signals = signal.unmarshallJsonMulti(jsonSignals, 'prometheus');
local exprs = signal.collectMetricExprs(signals);

{
  collectMetricExprs: {
    raw:: exprs,
    testResult: test.suite({
      testCount: {
        actual: std.length(exprs),
        expect: 2,
      },
      testAllStrings: {
        actual: std.all([std.isString(e) for e in exprs]),
        expect: true,
      },
      testContainsAbc: {
        actual: std.member(exprs, 'avg by (job,xxx) (\n  abc{job="integrations/agent",job=~"$job",instance=~"$instance"}\n)'),
        expect: true,
      },
      testContainsBar: {
        actual: std.any([std.length(std.findSubstr('bar{job="integrations/agent"', e)) > 0 for e in exprs]),
        expect: true,
      },
      testNoEmptyObjects: {
        actual: std.any([!std.isString(e) for e in exprs]),
        expect: false,
      },
    }),
  },
}
