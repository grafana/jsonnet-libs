local signal = import './signal.libsonnet';
local test = import 'jsonnetunit/test.libsonnet';

local gauge1 = signal.init(
  aggLevel='none',
).addSignal(
  name='API server errors percentage',
  type='gauge',
  unit='percent',
  description='errs',
  expr=
  |||
    sum without (code) (increase(apiserver_request_total{%(queriesSelector)s, code=~"5.."}[%(interval)s]))/
    sum without (code) (increase(apiserver_request_total{%(queriesSelector)s}[%(interval)s]))*100
  |||,
);


{
  asTarget: {
    raw: gauge1.asTarget(),
    testResult: test.suite({
      testLegend: {
        actual: gauge1.asTarget().legendFormat,
        expect: 'API server errors percentage',
      },
      testExpression: {
        actual: gauge1.asTarget().expr,
        expect:
          |||
            sum without (code) (increase(apiserver_request_total{job=integrations/agent,job=~"$job",instance=~"$instance", code=~"5.."}[$__rate_interval]))/
            sum without (code) (increase(apiserver_request_total{job=integrations/agent,job=~"$job",instance=~"$instance"}[$__rate_interval]))*100
          |||,
      },
    }),
  },
  asTimeSeries:
    {
      raw: gauge1.asTimeSeries(),
      testResult: test.suite({
        testTStitle: {
          actual: gauge1.asTimeSeries().title,
          expect: 'API server errors percentage',
        },
        testUnit: {
          actual: gauge1.asTimeSeries().fieldConfig.defaults.unit,
          expect: 'percent',
        },
        testTStype: {
          actual: gauge1.asTimeSeries().type,
          expect: 'timeseries',
        },
        testTSversion: {
          actual: gauge1.asTimeSeries().pluginVersion,
          expect: 'v10.0.0',
        },
        testTSUid: {
          actual: gauge1.asTimeSeries().datasource,
          expect: {
            uid: 'DS_PROMETHEUS',
            type: 'prometheus',
          },
        },
      }),
    },
}

// test.suite({
//     testIdentity: {actual: 1, expect: 1},
//     testNeg:      {actual: "YAML", expectNot: "Markup Language"},
//     testFact: {
//         local fact(n) = if n == 0 then 1 else n * fact(n-1),

//         actual: fact(10),
//         expect: 3628800
//     },
// })
