local signal = import './signal.libsonnet';
local test = import 'jsonnetunit/test.libsonnet';

local m1 = signal.init(
  filteringSelector=['job="abc"'],
  interval='5m',
  aggLevel='instance',
  aggFunction='max',
).addSignal(
  name='API server requests',
  nameShort='requests',
  type='counter',
  unit='requests',
  description='API server calls.',
  sourceMaps=[
    {
      expr: 'apiserver_request_total{%(queriesSelector)s}',
      rangeFunction: 'rate',
      aggKeepLabels: [],
      legendCustomTemplate: null,
      infoLabel: null,
    },
  ],
)
;

{

  asTarget: {
    local raw = m1.asTarget(),
    testResult: test.suite({
      testLegend: {
        actual: raw.legendFormat,
        expect: '{{instance}}: requests',
      },
      testExpression: {
        actual: raw.expr,
        expect: 'max by (job,instance) (\n  rate(apiserver_request_total{job="abc",job=~"$job",instance=~"$instance"}[5m])\n)',
      },
    }),
  },
  asTimeSeries:
    {
      local raw = m1.asTimeSeries(),
      testResult: test.suite({
        testTStitle: {
          actual: raw.title,
          expect: 'API server requests',
        },
        testUnit: {
          actual: raw.fieldConfig.overrides[0].properties[0].value,
          expect: 'rps',
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

}
