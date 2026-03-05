local signal = import './signal.libsonnet';
local test = import 'jsonnetunit/test.libsonnet';

local m1 = signal.init(
  filteringSelector=['job="abc"'],
  interval='5m',
  aggLevel='instance',
  aggFunction='max',
).addSignal(
  name='API server requests',
  nameShort='Requests',
  type='counter',
  unit='rps',
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


);

{

  asTableColumn: {
    local raw = m1.asTableColumn(),
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
      testColumnTitle: {
        actual: m1.asTable().fieldConfig.overrides[0].properties[0].value,
        expect: 'Requests',
      },
      testUnit: {
        actual: m1.asTable().fieldConfig.overrides[0].properties[1].value,
        expect: 'rps',
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
      local raw = m1.asTable(),
      testResult: test.suite({
        testDescription: {
          actual: raw.description,
          expect: 'Requests (max): API server calls.  \n',
        },
        testDatasource: {
          actual: raw.datasource,
          expect: { type: 'prometheus', uid: '${datasource}' },
        },
        testFieldConfig: {
          actual: raw.fieldConfig,
          expect: { defaults: { custom: { filterable: false }, unit: 'rps' }, overrides: [{ matcher: { id: 'byName', options: 'API server requests' }, properties: [{ id: 'displayName', value: 'Requests' }, { id: 'unit', value: 'rps' }] }] },
        },
        testTargets: {
          actual: raw.targets,
          expect: [{ datasource: { type: 'prometheus', uid: '${datasource}' }, expr: 'max by (job,instance) (\n  rate(apiserver_request_total{job="abc",job=~"$job",instance=~"$instance"}[5m])\n)', format: 'table', instant: true, legendFormat: '{{instance}}: Requests', refId: 'API server requests' }],
        },
        testTitle: {
          actual: raw.title,
          expect: 'API server requests',
        },
        testType: {
          actual: raw.type,
          expect: 'table',
        },
        testPluginVersion: {
          actual: raw.pluginVersion,
          expect: 'v11.0.0',
        },
        testTransformations: {
          actual: raw.transformations,
          expect: [
            { id: 'merge' },
            {
              id: 'renameByRegex',
              options: {
                regex: 'Value #(.*)',
                renamePattern: '$1',
              },
            },
            {
              id: 'filterFieldsByName',
              options: { include: { pattern: '^(?!Time).*$' } },
            },
            {
              // Sort instance and job labels first
              // Capitalize instance and job labels
              id: 'organize',
              options: {
                indexByName: { instance: 1, job: 0 },
                renameByName:
                  {
                    Value: 'API server requests',
                    instance: 'Instance',
                    job: 'Job',
                  },
              },
            },
          ],
        },
        testColumnTitle: {
          actual: raw.fieldConfig.overrides[0].properties[0].value,
          expect: 'Requests',
        },
        testUnit: {
          actual: raw.fieldConfig.overrides[0].properties[1].value,
          expect: 'rps',
        },
      }),
    },

}
