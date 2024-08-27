local signal = import './signal.libsonnet';
local test = import 'jsonnetunit/test.libsonnet';

local m1 = signal.init(
  filteringSelector=['job="abc"'],
  interval='5m',
  aggLevel='instance',
  aggFunction='max',
).addSignal(
  name='API server requests',
  type='counter',
  unit='requests',
  description='API server calls.',
  sourceMaps=[
    {
      expr: 'apiserver_request_total{%(queriesSelector)s}',
      rangeFunction: 'rate',
      aggKeepLabels: [],
    },
  ],


);

{

  asTableColumn: {
    raw:: m1.asTableColumn(),
    testResult: test.suite({
      testFormat: {
        actual: m1.asTableColumn().targets[0].format,
        expect: 'table',
      },
      testExpression: {
        actual: m1.asTableColumn().targets[0].expr,
        expect: 'max by (job,instance) (\n  rate(apiserver_request_total{job="abc",job=~"$job",instance=~"$instance"}[5m])\n)',
      },
      testInstant: {
        actual: m1.asTableColumn().targets[0].instant,
        expect: true,
      },
    }),
  },
  asTableColumnWithTimeSeries: {
    raw:: m1.asTableColumn(format='time_series'),
    testResult: test.suite({
      testFormat: {
        actual: m1.asTableColumn(format='time_series').targets[0].format,
        expect: 'time_series',
      },
      testExpression: {
        actual: m1.asTableColumn(format='time_series').targets[0].expr,
        expect: 'max by (job,instance) (\n  rate(apiserver_request_total{job="abc",job=~"$job",instance=~"$instance"}[5m])\n)',
      },
      testInstant: {
        actual: m1.asTableColumn(format='time_series').targets[0].instant,
        expect: false,
      },
    }),
  },
  asTable:
    {
      raw:: m1.asTable(),
      testResult: test.suite({
        testTStitle: {
          actual: m1.asTable().title,
          expect: 'API server requests',
        },
        testUnit: {
          actual: m1.asTable().fieldConfig.overrides[0].properties[1].value,
          expect: 'rps',
        },
        testTStype: {
          actual: m1.asTable().type,
          expect: 'table',
        },
        testTSversion: {
          actual: m1.asTimeSeries().pluginVersion,
          expect: 'v11.0.0',
        },
        testTSUid: {
          actual: m1.asTimeSeries().datasource,
          expect: {
            uid: '${datasource}',
            type: 'prometheus',
          },
        },
      }),
    },

}
