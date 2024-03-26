local signal = import './signal.libsonnet';
local test = import 'jsonnetunit/test.libsonnet';

local signalInit = signal.init(
  aggLevel='group',
  filteringSelector=['job="integrations/agent"'],
);

{
  multiChoice: {
    local raw = signalInit.getVariablesMultiChoice(),
    raw:: raw,
    testResult: test.suite({
      testDS: {
        actual: raw[0],
        expect: { label: 'Data source', name: 'datasource', query: 'prometheus', regex: '', type: 'datasource' },
      },
      testGroupSelector: {
        actual: raw[1],
        expect: { allValue: '.+', datasource: { type: 'prometheus', uid: '${datasource}' }, includeAll: true, label: 'Job', multi: true, name: 'job', query: 'label_values(up{job="integrations/agent"}, job)', refresh: 2, sort: 1, type: 'query' },
      },
      testInstanceSelector: {
        actual: raw[2],
        expect: { allValue: '.+', datasource: { type: 'prometheus', uid: '${datasource}' }, includeAll: true, label: 'Instance', multi: true, name: 'instance', query: 'label_values(up{job="integrations/agent",job=~"$job"}, instance)', refresh: 2, sort: 1, type: 'query' },
      },
    }),
  },
  singleChoice: {
    local raw = signalInit.getVariablesSingleChoice(),
    raw:: raw,
    testResult: test.suite({
      testDS: {
        actual: raw[0],
        expect: { label: 'Data source', name: 'datasource', query: 'prometheus', regex: '', type: 'datasource' },
      },
      testGroupSelector: {
        actual: raw[1],
        expect: { allValue: '.+', datasource: { type: 'prometheus', uid: '${datasource}' }, includeAll: true, label: 'Job', multi: true, name: 'job', query: 'label_values(up{job="integrations/agent"}, job)', refresh: 2, sort: 1, type: 'query' },
      },
      testInstanceSelector: {
        actual: raw[2],
        expect: { allValue: '.+', datasource: { type: 'prometheus', uid: '${datasource}' }, includeAll: false, label: 'Instance', multi: false, name: 'instance', query: 'label_values(up{job="integrations/agent",job=~"$job"}, instance)', refresh: 2, sort: 1, type: 'query' },
      },
    }),
  },

}
