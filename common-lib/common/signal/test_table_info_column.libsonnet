local signal = import './signal.libsonnet';
local test = import 'jsonnetunit/test.libsonnet';

local m1 = signal.init(
  filteringSelector=['job="abc"'],
).addSignal(
  name='Go version',
  nameShort='Version',
  type='info',
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
  asTableColumn:
    {
      local raw = m1.asTableColumn(),
      testResult: test.suite({
        testOverrides: {
          actual: raw.fieldConfig.overrides,
          expect: [
            //show infoLabel as column instead:
            {
              matcher: { id: 'byName', options: 'version' },
              properties: [{ id: 'displayName', value: 'Version' }],
            },
          ],
        },
        testTransformations: {
          actual: raw.transformations,
          expect: [
            {
              id: 'filterFieldsByName',
              options: { exclude: { names: ['Go version'] } },
            },
          ],
        },
        testTargets: {
          actual: raw.targets,
          expect: [
            {
              datasource: { type: 'prometheus', uid: '${datasource}' },
              expr: 'avg by (job,instance,version) (\n  go_info{job="abc",job=~"$job",instance=~"$instance"}\n)',
              format: 'table',
              instant: true,
              legendFormat: '{{instance}}: Version',
              refId: 'Go version',
            },
          ],
        },

      }),
    },
  asTable:
    {
      local raw = m1.asTable(),
      testResult: test.suite({
        testOverrides: {
          actual: raw.fieldConfig.overrides,
          expect: [
            {
              matcher: { id: 'byName', options: 'version' },
              properties: [{ id: 'displayName', value: 'Version' }],
            },
          ],
        },
        testExcludeValue: {
          actual: raw.transformations[3].options.excludeByName,
          expect: { Value: true },
        },
      }),
    },

}
