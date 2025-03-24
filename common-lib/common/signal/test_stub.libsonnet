local signal = import './signal.libsonnet';
local test = import 'jsonnetunit/test.libsonnet';

local m1 = signal.init(
  filteringSelector=['job="abc"'],
).addSignal(
  name='Go version',
  nameShort='Version',
  type='stub',
  aggLevel='instance',
  description='Go version.',
  sourceMaps=[
    {
      expr: 'go_info{%(queriesSelector)s}',
      infoLabel: 'version',
      legendCustomTemplate: null,
      aggKeepLabels: [],
    },
  ]
);

{

  asStat:
    {
      local raw = m1.asStat(),
      testResult: test.suite({
        testTStitle: {
          actual: raw.title,
          expect: '',  // empty title for stub panels
        },
        testType: {
          actual: raw.type,
          expect: 'text',
        },
        testTSversion: {
          actual: raw.pluginVersion,
          expect: 'v11.0.0',
        },
        testTSUid: {
          actual: raw.datasource,
          expect: {
            uid: '-- Mixed --',
            type: 'datasource',
          },
        },
      }),
    },
  asTableTarget:
    {
      local raw = m1.asTableTarget(),
      testResult: test.suite({
        testTStitle: {
          actual: raw,
          expect: {},
        },
      }),
    },

}
