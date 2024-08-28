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
  sourceMaps=[
    {
      expr: 'apiserver_request_duration_seconds_bucket{%(queriesSelector)s}',
      rangeFunction: 'rate',
      aggKeepLabels: [],
      legendCustomTemplate: null,
    },
  ],

);

{
  asTarget: {
    raw:: m1.asTarget(),
    testResult: test.suite({
      testLegend: {
        actual: m1.asTarget().legendFormat,
        expect: '{{job}}: API server duration',
      },
      testExpression: {
        actual: m1.asTarget().expr,
        expect: 'avg by (job) (\n  histogram_quantile(0.95, sum(rate(apiserver_request_duration_seconds_bucket{job="abc",job=~"$job",instance=~"$instance"}[10m])) by (le,job))\n)',
      },
    }),
  },
  asTimeSeries:
    {
      raw:: m1.asTimeSeries(),
      testResult: test.suite({
        testTStitle: {
          actual: m1.asTimeSeries().title,
          expect: 'API server duration',
        },
        testUnit: {
          actual: m1.asTimeSeries().fieldConfig.overrides[0].properties[1].value,
          expect: 'seconds',
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
