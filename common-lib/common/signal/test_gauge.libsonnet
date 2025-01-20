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
  asTimeSeries:
    {
      raw:: gauge1.asTimeSeries(),
      testResult: test.suite({
        testTStitle: {
          actual: gauge1.asTimeSeries().title,
          expect: 'Up metric',
        },
        testUnit: {
          actual: gauge1.asTimeSeries().fieldConfig.overrides[0].properties[1].value,
          expect: 'short',
        },
        testValueMapping: {
          actual: gauge1.asTimeSeries().fieldConfig.overrides[0].properties[0].value,
          expect: [{ options: { '0': { color: 'light-red', index: 0, text: 'Down' }, '1': { color: 'light-green', index: 1, text: 'Up' } }, type: 'value' }],
        },
        testTStype: {
          actual: gauge1.asTimeSeries().type,
          expect: 'timeseries',
        },
        testTSversion: {
          actual: gauge1.asTimeSeries().pluginVersion,
          expect: 'v11.0.0',
        },
        testTSUid: {
          actual: gauge1.asTimeSeries().datasource,
          expect: {
            uid: '${datasource}',
            type: 'prometheus',
          },
        },
      }),
    },

}
