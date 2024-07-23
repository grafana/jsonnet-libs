local signal = import './signal.libsonnet';
local test = import 'jsonnetunit/test.libsonnet';

local m1 = signal.init(
  filteringSelector=['job="abc"'],
  interval='5m',
  aggLevel='instance',
  aggFunction='max',
).addSignal(
  name='API server requests',
  type='counter',
  unit='requests',
  description='API server calls.',
  expr='apiserver_request_total{%(queriesSelector)s}',
);

{

  asTarget: {
    raw:: m1.asTarget(),
    testResult: test.suite({
      testLegend: {
        actual: m1.asTarget().legendFormat,
        expect: '{{instance}}: API server requests',
      },
      testExpression: {
        actual: m1.asTarget().expr,
        expect: 'max by (job,instance) (\n  rate(apiserver_request_total{job="abc",job=~"$job",instance=~"$instance"}[5m])\n)',
      },
    }),
  },
  asTimeSeries:
    {
      raw:: m1.asTimeSeries(),
      testResult: test.suite({
        testTStitle: {
          actual: m1.asTimeSeries().title,
          expect: 'API server requests',
        },
        testUnit: {
          actual: m1.asTimeSeries().fieldConfig.defaults.unit,
          expect: 'rps',
        },
        testTStype: {
          actual: m1.asTimeSeries().type,
          expect: 'timeseries',
        },
        testTSversion: {
          actual: m1.asTimeSeries().pluginVersion,
          expect: 'v11.0.0',
        },
        testTSUid: {
          actual: m1.asTimeSeries().datasource,
          expect: {
            uid: '${datasource}',
            type: 'prometheus',
          },
        },
      }),
    },

}
