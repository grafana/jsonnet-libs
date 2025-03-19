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
    varAdHocEnabled: true,
    varAdHocLabels: ['env', 'zone'],
    signals: {
      abc: {
        name: 'ABC',
        type: 'gauge',
        description: 'ABC',
        unit: 's',
        expr: 'abc{%(queriesSelector)s}',
      },
    },
  };

local signals = signal.unmarshallJson(jsonSignals);

{
  multiChoice: {
    local raw = signals.getVariablesMultiChoice(),
    testResult: test.suite({
      testAdhocMulti: {
        actual: raw[3],
        expect:
          {
            datasource:
              { type: 'prometheus', uid: '${custom_datasource}' },
            defaultKeys:
              [{ text: 'env', value: 'env' }, { text: 'zone', value: 'zone' }],
            description: 'Add additional filters',
            label: 'Ad hoc filters',
            name: 'adhoc',
            type: 'adhoc',
          },
      },
    }),
  },
  singleChoice: {
    local raw = signals.getVariablesSingleChoice(),
    testResult: test.suite({
      testAdhocSingle: {
        actual: raw[3],
        expect: {
          datasource: { type: 'prometheus', uid: '${custom_datasource}' },
          defaultKeys: [{ text: 'env', value: 'env' }, { text: 'zone', value: 'zone' }],
          description: 'Add additional filters',
          label: 'Ad hoc filters',
          name: 'adhoc',
          type: 'adhoc',
        },
      },
    }),
  },

}
