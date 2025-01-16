local signal = import './signal.libsonnet';
local test = import 'jsonnetunit/test.libsonnet';

local m1 = signal.init(
  filteringSelector=['job="abc"'],
).addSignal(
  name='Go version',
  nameShort='Version',
  type='info',
  description='Go version.',
  sourceMaps=[
    {
      expr: 'go_info{%(queriesSelector)s}',
      infoLabel: 'version',
      aggKeepLabels: [],
      legendCustomTemplate: null,
    },
    {
      expr: 'go_info{%(queriesSelector)s}',
      infoLabel: 'version2',
      aggKeepLabels: [],
      legendCustomTemplate: null,
    },
    {
      expr: 'go_info{%(queriesSelector)s}',
      infoLabel: 'version',
      aggKeepLabels: [],
      legendCustomTemplate: null,
    },
  ]
);

{

  asTarget: {
    raw:: m1.asTarget(),
    testResult: test.suite({
      testExpression: {
        actual: m1.asTarget().expr,
        expect: 'go_info{job="abc",job=~"$job",instance=~"$instance"}',
      },
    }),
  },
  asStat:
    {
      raw:: m1.asStat(),
      testResult: test.suite({
        testTStitle: {
          actual: m1.asStat().title,
          expect: 'Go version',
        },
        testType: {
          actual: m1.asStat().type,
          expect: 'stat',
        },
        testTSversion: {
          actual: m1.asStat().pluginVersion,
          expect: 'v11.0.0',
        },
        testTSUid: {
          actual: m1.asStat().datasource,
          expect: {
            uid: '${datasource}',
            type: 'prometheus',
          },
        },
        testInfoLabel: {
          actual: m1.asStat().options.reduceOptions.fields,
          expect: '/^' + '(version|version2)' + '$/',
        },
      }),
    },

}
