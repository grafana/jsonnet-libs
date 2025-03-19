local signal = import './signal.libsonnet';
local test = import 'jsonnetunit/test.libsonnet';

local gauge1 = signal.init(
  aggLevel='group',
  filteringSelector=['job="integrations/agent"'],
).addSignal(
  name='Up metric',
  nameShort='Up',
  type='gauge',
  unit='short',
  description='abc',
  sourceMaps=[
    {
      expr: 'up{%(queriesSelector)s}',
      rangeFunction: null,
      aggKeepLabels: [],
      legendCustomTemplate: null,
      infoLabel: null,
      valueMappings: [{
        type: 'value',
        options: {
          '1': {
            text: 'Up',
            color: 'light-green',
            index: 1,
          },
          '0': {
            text: 'Down',
            color: 'light-red',
            index: 0,
          },
        },
      }],
    },
  ]
);

{

  asTarget: {
    raw:: gauge1.asTarget(),
    testResult: test.suite({
      testLegend: {
        actual: gauge1.asTarget().legendFormat,
        expect: '{{job}}: Up',
      },
      testExpression: {
        actual: gauge1.asTarget().expr,
        expect: 'avg by (job) (\n  up{job="integrations/agent",job=~"$job",instance=~"$instance"}\n)',
      },
    }),
  },
  asTargetWithcombinedTransformations: {
    local raw = gauge1
                .withTopK(3)
                .withOffset('30m')
                .withFilteringSelectorMixin('region="us-east"')
                .asTarget(),
    testResult: test.suite({
      testExpression: {
        actual: raw.expr,
        expect: 'topk(3,\n  avg by (job) (\n  (up{job="integrations/agent",job=~"$job",instance=~"$instance",region="us-east"} offset 30m)\n)\n)',
      },
      testLegend: {
        actual: raw.legendFormat,
        expect: '{{job}}: Up',
      },
    }),
  },
  asTimeSeries:
    {
      local raw = gauge1.asTimeSeries(),
      testResult: test.suite({
        testTStitle: {
          actual: raw.title,
          expect: 'Up metric',
        },
        testUnit: {
          actual: raw.fieldConfig.overrides[0].properties[1].value,
          expect: 'short',
        },
        testValueMapping: {
          actual: raw.fieldConfig.overrides[0].properties[0].value,
          expect: [{ options: { '0': { color: 'light-red', index: 0, text: 'Down' }, '1': { color: 'light-green', index: 1, text: 'Up' } }, type: 'value' }],
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
