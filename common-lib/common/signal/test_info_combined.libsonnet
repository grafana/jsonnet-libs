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
    local raw = m1.asTarget(),
    testResult: test.suite({
      testExpression: {
        actual: raw.expr,
        expect: 'go_info{job="abc",job=~"$job",instance=~"$instance"}',
      },
    }),
  },
  asStat:
    {
      local raw = m1.asStat(),
      testResult: test.suite({
        testTStitle: {
          actual: raw.title,
          expect: 'Go version',
        },
        testType: {
          actual: raw.type,
          expect: 'stat',
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
        testInfoLabel: {
          actual: raw.options.reduceOptions.fields,
          expect: '/^' + '(version|version2)' + '$/',
        },
      }),
    },

}
