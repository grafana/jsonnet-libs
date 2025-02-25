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
    local raw = m1.withOffset('10m').asTarget(),
    testResult: test.suite({
      testLegend: {
        actual: raw.legendFormat,
        expect: '{{instance}}: requests',
      },
      testExpression: {
        actual: raw.expr,
        expect: 'max by (job,instance) (\n  rate((apiserver_request_total{job="abc",job=~"$job",instance=~"$instance"} offset 10m)[5m])\n)',
      },
    }),
  },

}
