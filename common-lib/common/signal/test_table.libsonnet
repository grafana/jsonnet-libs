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
        testRaw: {
          actual: raw,
          expect: {
            datasource:
              { type: 'prometheus', uid: '${datasource}' },
            description: 'API server calls.',
            fieldConfig: { defaults: { custom: { filterable: false } }, overrides: [{ matcher: { id: 'byName', options: 'API server requests' }, properties: [{ id: 'displayName', value: 'Requests' }, { id: 'unit', value: 'rps' }] }] },
            pluginVersion: 'v11.0.0',
            targets: [{ datasource: { type: 'prometheus', uid: '${datasource}' }, expr: 'max by (job,instance) (\n  rate(apiserver_request_total{job="abc",job=~"$job",instance=~"$instance"}[5m])\n)', format: 'table', instant: true, legendFormat: '{{instance}}: Requests', refId: 'API server requests' }],
            title: 'API server requests',
            transformations: [
              { id: 'merge' },
              { id: 'renameByRegex', options: { regex: 'Value #(.*)', renamePattern: '$1' } },
              { id: 'filterFieldsByName', options: { include: { pattern: '^(?!Time).*$' } } },
              {
                id: 'organize',
                options:
                  {
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
            type: 'table',
          },
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
        testTStitle: {
          actual: raw.title,
          expect: 'API server requests',
        },
        testColumnTitle: {
          actual: raw.fieldConfig.overrides[0].properties[0].value,
          expect: 'Requests',
        },
        testUnit: {
          actual: raw.fieldConfig.overrides[0].properties[1].value,
          expect: 'rps',
        },
        testTStype: {
          actual: raw.type,
          expect: 'table',
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
