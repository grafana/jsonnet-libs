local signal = import './signal.libsonnet';
local test = import 'jsonnetunit/test.libsonnet';

local gauge1 = signal.init(
  aggLevel='group',
).addSignal(
  name='Up metric',
  type='gauge',
  unit='short',
  description='abc',
  expr='up{%(queriesSelector)s}'
);

{
  asTarget: {
    raw: gauge1.asTarget(),
    testResult: test.suite({
      testLegend: {
        actual: gauge1.asTarget().legendFormat,
        expect: '{{job}}/{{instance}}: Up metric',
      },
      testExpression: {
        actual: gauge1.asTarget().expr,
        expect: 'avg by (job,instance) (up{job=integrations/agent,job=~"$job",instance=~"$instance"})',
      },
    }),
  },
  asTimeSeries:
    {
      raw: gauge1.panels.asTimeSeries(),
      testResult: test.suite({
        testTStitle: {
          actual: gauge1.panels.asTimeSeries().title,
          expect: 'Up metric',
        },
        testUnit: {
          actual: gauge1.panels.asTimeSeries().fieldConfig.defaults.unit,
          expect: 'short',
        },
        testTStype: {
          actual: gauge1.panels.asTimeSeries().type,
          expect: 'timeseries',
        },
        testTSversion: {
          actual: gauge1.panels.asTimeSeries().pluginVersion,
          expect: 'v10.0.0',
        },
        testTSUid: {
          actual: gauge1.panels.asTimeSeries().datasource,
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
