local signal = import './signal.libsonnet';
local test = import 'jsonnetunit/test.libsonnet';

local m1 = signal.init(
  filteringSelector=['foo="bar"'],
  interval='10m',
  aggLevel='group',
  aggFunction='avg',
).addSignal(
  name='Log query',
  nameShort='Log',
  type='log',
  unit='none',
  description='Log query.',
  sourceMaps=[
    {
      expr: '{%(queriesSelector)s} | json',
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
      testExpression: {
        actual: raw.expr,
        expect: '{foo="bar",job=~"$job",instance=~"$instance"} | json',
      },
      testTSUid: {
        actual: raw.datasource,
        expect: {
          uid: '${loki_datasource}',
          type: 'loki',
        },
      },
    }),
  },
}
