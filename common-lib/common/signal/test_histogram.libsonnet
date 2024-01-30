local signal = import './signal.libsonnet';
local test = import 'jsonnetunit/test.libsonnet';

local m1 = signal.init(
  filteringSelector=['job="abc"'],
  interval='10m',
  aggLevel='group',
  aggFunction='avg',
).addSignal(
  name='API server duration',
  type='histogram',
  unit='seconds',
  description='API server call duration.',
  expr='apiserver_request_duration_seconds_bucket{%(queriesSelector)s}',
);

{
  asTarget: {
    raw: m1.asTarget(),
    testResult: test.suite({
      testLegend: {
        actual: m1.asTarget().legendFormat,
        expect: '{{job}}/{{instance}}: API server duration',
      },
      testExpression: {
        actual: m1.asTarget().expr,
        expect: 'avg by (job,instance) (histogram_quantile(0.95, sum(rate(apiserver_request_duration_seconds_bucket{job="abc",job=~"$job",instance=~"$instance"}[10m])) by (le,job,instance)))',
      },
    }),
  },
  asTimeSeries:
    {
      raw: m1.panels.asTimeSeries(),
      testResult: test.suite({
        testTStitle: {
          actual: m1.panels.asTimeSeries().title,
          expect: 'API server duration',
        },
        testUnit: {
          actual: m1.panels.asTimeSeries().fieldConfig.defaults.unit,
          expect: 'seconds',
        },
        testTStype: {
          actual: m1.panels.asTimeSeries().type,
          expect: 'timeseries',
        },
        testTSversion: {
          actual: m1.panels.asTimeSeries().pluginVersion,
          expect: 'v10.0.0',
        },
        testTSUid: {
          actual: m1.panels.asTimeSeries().datasource,
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
