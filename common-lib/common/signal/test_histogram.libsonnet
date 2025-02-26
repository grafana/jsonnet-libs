local signal = import './signal.libsonnet';
local test = import 'jsonnetunit/test.libsonnet';

local m1 = signal.init(
  filteringSelector=['job="abc"'],
  interval='10m',
  aggLevel='group',
  aggFunction='avg',
).addSignal(
  name='API server duration',
  nameShort='duration',
  type='histogram',
  unit='seconds',
  description='API server call duration.',
  sourceMaps=[
    {
      expr: 'apiserver_request_duration_seconds_bucket{%(queriesSelector)s}',
      rangeFunction: 'rate',
      aggKeepLabels: [],
      legendCustomTemplate: null,
      infoLabel: null,
    },
  ],

);

{
  asTarget: {
    local raw = m1.asTarget(),
    testResult: test.suite({
      testLegend: {
        actual: raw.legendFormat,
        expect: '{{job}}: duration',
      },
      testExpression: {
        actual: raw.expr,
        expect: 'avg by (job) (\n  histogram_quantile(0.95, sum(rate(apiserver_request_duration_seconds_bucket{job="abc",job=~"$job",instance=~"$instance"}[10m])) by (le,job))\n)',
      },
    }),
  },
  asTimeSeries:
    {
      local raw = m1.asTimeSeries(),
      testResult: test.suite({
        testTStitle: {
          actual: raw.title,
          expect: 'API server duration',
        },
        testUnit: {
          actual: raw.fieldConfig.overrides[0].properties[0].value,
          expect: 'seconds',
        },
        testTStype: {
          actual: raw.type,
          expect: 'timeseries',
        },
        testTSversion: {
          actual: raw.pluginVersion,
          expect: 'v11.0.0',
        },
        testTSUid: {
          actual: raw.datasource,
          expect: {
            uid: '${datasource}',
            type: 'prometheus',
          },
        },
      }),
    },
  withCustomQuantile: {
    local customHistogram = signal.init(
      filteringSelector=['job="abc"'],
      interval='10m',
      aggLevel='group',
      aggFunction='avg',
    ).addSignal(
      name='Custom quantile',
      nameShort='p99',
      type='histogram',
      unit='seconds',
      description='99th percentile',

      sourceMaps=[{
        expr: 'http_request_duration_seconds_bucket{%(queriesSelector)s}',
        rangeFunction: 'rate',
        aggKeepLabels: ['handler'],
        quantile: 0.99,
        infoLabel: null,
      }],
    ),

    testResult: test.suite({
      testDefaultQuantile: {
        actual: customHistogram.asTarget().expr,
        expect: 'avg by (job,handler) (\n  histogram_quantile(0.99, sum(rate(http_request_duration_seconds_bucket{job="abc",job=~"$job",instance=~"$instance"}[10m])) by (le,job,handler))\n)',
      },
      testCustomQuantile: {
        actual: customHistogram.withQuantile(quantile=0.50).asTarget().expr,
        expect: 'avg by (job,handler) (\n  histogram_quantile(0.50, sum(rate(http_request_duration_seconds_bucket{job="abc",job=~"$job",instance=~"$instance"}[10m])) by (le,job,handler))\n)',
      },
    }),
  },
}
