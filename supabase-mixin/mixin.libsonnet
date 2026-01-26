local patchPanel = function(p) p {
  [if std.objectHas(p, 'datasource') then 'datasource' else null]: {
    uid: '${prometheus_datasource}',
  },
  [if std.objectHas(p, 'targets') then 'targets' else null]: [
    t {
      expr: std.strReplace(t.expr, 'supabase_project_ref=', 'job=~"$job", supabase_project_ref='),
      datasource+: {
        uid: '${prometheus_datasource}',
      },
    }
    for t in p.targets
  ],
  [if std.objectHas(p, 'panels') then 'panels' else null]: [patchPanel(pp) for pp in p.panels],
};
{
  grafanaDashboards+:: {
    'supabase.json': (import 'github.com/supabase/supabase-grafana/dashboard.json') + {
      uid: 'd402d94e-da48-48e4-ac52-53026b96a000',
      editable: false,
      __inputs: null,
      __elements: null,
      __requires: null,
      panels: [patchPanel(p) for p in super.panels],
      templating+: {
        list: [
          {
            hide: 0,
            includeAll: false,
            label: 'Data source',
            multi: false,
            name: 'prometheus_datasource',
            options: [],
            query: 'prometheus',
            refresh: 1,
            regex: '',
            skipUrlSync: false,
            type: 'datasource',
          },
          {
            datasource: {
              type: 'prometheus',
              uid: '${prometheus_datasource}',
            },
            definition: 'label_values(supabase_usage_metrics_user_queries_total,job)',
            name: 'job',
            label: 'Job',
            options: [],
            query: {
              qryType: 1,
              query: 'label_values(supabase_usage_metrics_user_queries_total,job)',
              refId: 'PrometheusVariableQueryEditor-VariableQuery',
            },
            includeAll: false,
            multi: true,
            refresh: 2,
            regex: '',
            regexApplyTo: 'value',
            type: 'query',
          },
          {
            current: {},
            datasource: {
              type: 'prometheus',
              uid: '${prometheus_datasource}',
            },
            definition: 'label_values({job=~"$job"},supabase_project_ref)',
            includeAll: false,
            label: 'Project Ref',
            name: 'project',
            options: [],
            query: {
              query: 'label_values({job=~"$job"},supabase_project_ref)',
              refId: 'PrometheusVariableQueryEditor-VariableQuery',
            },
            refresh: 2,
            regex: '',
            type: 'query',
          },
          {
            current: {
              text: '[a-z]+|nvme[0-9]+n[0-9]+|mmcblk[0-9]+',
              value: '[a-z]+|nvme[0-9]+n[0-9]+|mmcblk[0-9]+',
            },
            hide: 2,
            includeAll: false,
            name: 'diskdevices',
            options: [
              {
                selected: true,
                text: '[a-z]+|nvme[0-9]+n[0-9]+|mmcblk[0-9]+',
                value: '[a-z]+|nvme[0-9]+n[0-9]+|mmcblk[0-9]+',
              },
            ],
            query: '[a-z]+|nvme[0-9]+n[0-9]+|mmcblk[0-9]+',
            type: 'custom',
          },
          {
            allowCustomValue: false,
            current: {},
            datasource: {
              type: 'prometheus',
              uid: '${prometheus_datasource}',
            },
            definition: 'label_values({job=~"$job"},supabase_identifier)',
            includeAll: false,
            label: 'Supabase Identifier',
            name: 'supabase_identifier',
            options: [],
            query: {
              query: 'label_values({job=~"$job"},supabase_identifier)',
              refId: 'Prometheus-supabase_identifier-Variable-Query',
            },
            refresh: 2,
            regex: '',
            type: 'query',
          },
        ],
      },
    },
  },
}
