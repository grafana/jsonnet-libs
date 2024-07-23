local signal = import './signal.libsonnet';
local test = import 'jsonnetunit/test.libsonnet';

local gauge1 = signal.init(
  aggLevel='group',
  filteringSelector=['job="integrations/agent"'],
).addSignal(
  name='Up metric',
  type='gauge',
  unit='short',
  description='abc',
  expr='up{%(queriesSelector)s}',
);

{

  asTarget: {
    raw:: gauge1.asTarget(),
    testResult: test.suite({
      testLegend: {
        actual: gauge1.asTarget().legendFormat,
        expect: '{{job}}: Up metric',
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
          actual: gauge1.asTimeSeries().fieldConfig.defaults.unit,
          expect: 'short',
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
