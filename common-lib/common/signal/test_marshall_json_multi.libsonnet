local signal = import './signal.libsonnet';
local test = import 'jsonnetunit/test.libsonnet';

local jsonSignals =
  {
    aggLevel: 'group',
    groupLabels: ['job'],
    instanceLabels: ['instance'],
    filteringSelector: 'job="integrations/agent"',
    aggKeepLabels: ['xxx'],
    discoveryMetric: {
      otel: 'up2',
    },
    signals: {
      abc: {
        name: 'ABC',
        type: 'gauge',
        description: 'ABC',
        unit: 's',
        sources: {
          otel: {
            expr: 'abc{%(queriesSelector)s}',
          },
          prometheus: {
            expr: 'abc{%(queriesSelector)s}',
          },
        },
      },
      bar: {
        name: 'BAR',
        type: 'counter',
        description: 'BAR',
        unit: 'ns',
        sources: {
          otel: {
            expr: 'bar{%(queriesSelector)s}',
          },
          prometheus: {
            expr: 'bar{%(queriesSelector)s}',
          },
        },
      },
      foo_info: {
        name: 'foo info',
        type: 'info',
        description: 'foo',
        unit: 'short',
        sources: {
          otel: {
            expr: 'foo_info{%(queriesSelector)s}',

            infoLabel: 'version',
          },
          prometheus: {},
        },
      },
      status: {
        name: 'Status',
        type: 'gauge',
        description: 'status',
        unit: 'short',
        sources: {
          otel: {
            expr: 'status{%(queriesSelector)s}',
            valueMapping: {
              type: 'value',
              options: {
                '1': {
                  text: 'Up',
                  color: 'light-green',
                  index: 1,
                },
                '0': {
                  text: 'Down',
                  color: 'light-red',
                  index: 0,
                },
              },
            },
          },
        },

      },
    },
  };

local signals = signal.unmarshallJsonMulti(jsonSignals, 'otel');

{
  multiChoice: {
    local raw = signals.getVariablesMultiChoice(),
    raw:: raw,
    testResult: test.suite({
      testDS: {
        actual: raw[0],
        expect: { label: 'Data source', name: 'datasource', query: 'prometheus', regex: '', type: 'datasource' },
      },
      testGroupSelector: {
        actual: raw[1],
        expect: { allValue: '.+', datasource: { type: 'prometheus', uid: '${datasource}' }, includeAll: true, label: 'Job', multi: true, name: 'job', query: 'label_values(up2{job="integrations/agent"}, job)', refresh: 2, sort: 1, type: 'query' },
      },
      testInstanceSelector: {
        actual: raw[2],
        expect: { allValue: '.+', datasource: { type: 'prometheus', uid: '${datasource}' }, includeAll: true, label: 'Instance', multi: true, name: 'instance', query: 'label_values(up2{job="integrations/agent",job=~"$job"}, instance)', refresh: 2, sort: 1, type: 'query' },
      },
    }),
  },
  singleChoice: {
    local raw = signals.getVariablesSingleChoice(),
    raw:: raw,
    testResult: test.suite({
      testDS: {
        actual: raw[0],
        expect: { label: 'Data source', name: 'datasource', query: 'prometheus', regex: '', type: 'datasource' },
      },
      testGroupSelector: {
        actual: raw[1],
        expect: { allValue: '.+', datasource: { type: 'prometheus', uid: '${datasource}' }, includeAll: true, label: 'Job', multi: true, name: 'job', query: 'label_values(up2{job="integrations/agent"}, job)', refresh: 2, sort: 1, type: 'query' },
      },
      testInstanceSelector: {
        actual: raw[2],
        expect: { allValue: '.+', datasource: { type: 'prometheus', uid: '${datasource}' }, includeAll: false, label: 'Instance', multi: false, name: 'instance', query: 'label_values(up2{job="integrations/agent",job=~"$job"}, instance)', refresh: 2, sort: 1, type: 'query' },
      },
    }),
  },
  asTarget: {
    local panel = signals.abc.asTarget(),
    raw:: panel,
    testResult: test.suite({
      testExpression: {
        actual: panel.expr,
        expect: 'avg by (job,xxx) (\n  abc{job="integrations/agent",job=~"$job",instance=~"$instance"}\n)',
      },
    }),
  },
  asStatusHistory:
    {
      local panel = signals.bar.asStatusHistory(),
      raw:: panel,
      testResult: test.suite({
        testTitle: {
          actual: panel.title,
          expect: 'BAR',
        },
        testType: {
          actual: panel.type,
          expect: 'status-history',
        },
        testVersion: {
          actual: panel.pluginVersion,
          expect: 'v11.0.0',
        },
        testUid: {
          actual: panel.datasource,
          expect: {
            uid: '${datasource}',
            type: 'prometheus',
          },
        },
      }),
    },

}
