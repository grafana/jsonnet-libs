local signal = import './signal.libsonnet';
local test = import 'jsonnetunit/test.libsonnet';

local jsonSignals =
  {
    datasource: 'custom_datasource',
    datasourceLabel: 'Custom datasource',
    aggLevel: 'group',
    groupLabels: ['job'],
    instanceLabels: ['instance'],
    filteringSelector: 'job="integrations/agent"',
    discoveryMetric: 'up2',
    signals: {
      abc: {
        name: 'ABC',
        type: 'gauge',
        description: 'ABC',
        unit: 's',
        expr: 'abc{%(queriesSelector)s}',
      },
      bar: {
        name: 'BAR',
        type: 'counter',
        description: 'BAR',
        unit: 'ns',
        expr: 'bar{%(queriesSelector)s}',
      },
      foo_info: {
        name: 'foo info',
        type: 'info',
        description: 'foo',
        unit: 'short',
        infoLabel: 'version',
        expr: 'foo_info{%(queriesSelector)s}',
      },
      status: {
        name: 'Status',
        type: 'gauge',
        description: 'status',
        unit: 'short',
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
  };

local signals = signal.unmarshallJson(jsonSignals);

{
  multiChoice: {
    local raw = signals.getVariablesMultiChoice(),
    raw:: raw,
    testResult: test.suite({
      testDS: {
        actual: raw[0],
        expect: { label: 'Custom datasource', name: 'custom_datasource', query: 'prometheus', regex: '', type: 'datasource' },
      },
      testGroupSelector: {
        actual: raw[1],
        expect: { allValue: '.+', datasource: { type: 'prometheus', uid: '${custom_datasource}' }, includeAll: true, label: 'Job', multi: true, name: 'job', query: 'label_values(up2{job="integrations/agent"}, job)', refresh: 2, sort: 1, type: 'query' },
      },
      testInstanceSelector: {
        actual: raw[2],
        expect: { allValue: '.+', datasource: { type: 'prometheus', uid: '${custom_datasource}' }, includeAll: true, label: 'Instance', multi: true, name: 'instance', query: 'label_values(up2{job="integrations/agent",job=~"$job"}, instance)', refresh: 2, sort: 1, type: 'query' },
      },
    }),
  },
  singleChoice: {
    local raw = signals.getVariablesSingleChoice(),
    raw:: raw,
    testResult: test.suite({
      testDS: {
        actual: raw[0],
        expect: { label: 'Custom datasource', name: 'custom_datasource', query: 'prometheus', regex: '', type: 'datasource' },
      },
      testGroupSelector: {
        actual: raw[1],
        expect: { allValue: '.+', datasource: { type: 'prometheus', uid: '${custom_datasource}' }, includeAll: true, label: 'Job', multi: true, name: 'job', query: 'label_values(up2{job="integrations/agent"}, job)', refresh: 2, sort: 1, type: 'query' },
      },
      testInstanceSelector: {
        actual: raw[2],
        expect: { allValue: '.+', datasource: { type: 'prometheus', uid: '${custom_datasource}' }, includeAll: false, label: 'Instance', multi: false, name: 'instance', query: 'label_values(up2{job="integrations/agent",job=~"$job"}, instance)', refresh: 2, sort: 1, type: 'query' },
      },
    }),
  },
  asTarget: {
    local panel = signals.abc.asTarget(),
    raw:: panel,
    testResult: test.suite({
      testExpression: {
        actual: panel.expr,
        expect: 'avg by (job) (\n  abc{job="integrations/agent",job=~"$job",instance=~"$instance"}\n)',
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
          expect: 'v10.0.0',
        },
        testUid: {
          actual: panel.datasource,
          expect: {
            uid: '${custom_datasource}',
            type: 'prometheus',
          },
        },
      }),
    },

}
