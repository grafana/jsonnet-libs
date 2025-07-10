local signal = import './signal.libsonnet';
local test = import 'jsonnetunit/test.libsonnet';

{
  queriesSelectorGroupOnly: {
    local signalInit = signal.init(
      filteringSelector=['job="integrations/agent"'],
      groupLabels=['job'],
      instanceLabels=['instance'],
      aggLevel='group',
    ),

    local testSignal = signalInit.addSignal(
      name='Test metric',
      nameShort='test',
      type='gauge',
      unit='short',
      description='Test metric',
      sourceMaps=[
        {
          expr: 'test_metric{%(queriesSelectorGroupOnly)s}',
          exprWrappers: [],
          rangeFunction: 'rate',
          aggFunction: 'avg',
          aggKeepLabels: [],
          infoLabel: null,
          type: 'gauge',
          legendCustomTemplate: null,
          valueMappings: [],
          quantile: 0.95,
        },
      ],
    ),

    local raw = testSignal.asTarget(),
    testResult: test.suite({
      testExpression: {
        actual: raw.expr,
        expect: 'avg by (job) (\n  test_metric{job="integrations/agent",job=~"$job"}\n)',
      },
    }),
  },

  queriesSelectorFilterOnly: {
    local signalInit = signal.init(
      filteringSelector=['job="integrations/agent"'],
      groupLabels=['job'],
      instanceLabels=['instance'],
      aggLevel='group',
    ),

    local testSignal = signalInit.addSignal(
      name='Test metric',
      nameShort='test',
      type='gauge',
      unit='short',
      description='Test metric',
      sourceMaps=[
        {
          expr: 'test_metric{%(queriesSelectorFilterOnly)s}',
          exprWrappers: [],
          rangeFunction: 'rate',
          aggFunction: 'avg',
          aggKeepLabels: [],
          infoLabel: null,
          type: 'gauge',
          legendCustomTemplate: null,
          valueMappings: [],
          quantile: 0.95,
        },
      ],
    ),

    local raw = testSignal.asTarget(),
    testResult: test.suite({
      testExpression: {
        actual: raw.expr,
        expect: 'avg by (job) (\n  test_metric{job="integrations/agent"}\n)',
      },
    }),
  },

  // Test asRuleExpression - returns expression without Grafana variables, suitable for alerts
  asRuleExpression: {
    // Test with gauge type
    gauge: {
      local signalInit = signal.init(
        filteringSelector=['job="integrations/agent"'],
        groupLabels=['job'],
        instanceLabels=['instance'],
        aggLevel='group',
        alertsInterval='5m',
      ),

      local testSignal = signalInit.addSignal(
        name='Test metric',
        nameShort='test',
        type='gauge',
        unit='short',
        description='Test metric',
        sourceMaps=[
          {
            expr: 'test_metric{%(queriesSelector)s}',
            exprWrappers: [],
            rangeFunction: 'rate',
            aggFunction: 'avg',
            aggKeepLabels: [],
            infoLabel: null,
            type: 'gauge',
            legendCustomTemplate: null,
            valueMappings: [],
            quantile: 0.95,
          },
        ],
      ),

      local raw = testSignal.asRuleExpression(),
      testResult: test.suite({
        testExpression: {
          actual: raw,
          expect: 'test_metric{job="integrations/agent"}',
        },
      }),
    },

    // Test with counter type
    counter: {
      local signalInit = signal.init(
        filteringSelector=['job="integrations/agent"'],
        groupLabels=['job'],
        instanceLabels=['instance'],
        aggLevel='group',
        alertsInterval='5m',
      ),

      local testSignal = signalInit.addSignal(
        name='Test counter',
        nameShort='counter',
        type='counter',
        unit='requests',
        description='Test counter',
        sourceMaps=[
          {
            expr: 'test_counter_total{%(queriesSelector)s}',
            exprWrappers: [],
            rangeFunction: 'increase',
            aggFunction: 'avg',
            aggKeepLabels: [],
            infoLabel: null,
            type: 'counter',
            legendCustomTemplate: null,
            valueMappings: [],
            quantile: 0.95,
          },
        ],
      ),

      local raw = testSignal.asRuleExpression(),
      testResult: test.suite({
        testExpression: {
          actual: raw,
          expect: 'increase(test_counter_total{job="integrations/agent"}[5m:] offset -5m)',
        },
      }),
    },
  },

  // Test withFilteringSelectorMixin - adds additional filtering selector
  withFilteringSelectorMixin: {
    // Test basic filtering selector mixin
    basic: {
      local signalInit = signal.init(
        filteringSelector=['job="integrations/agent"'],
        groupLabels=['job'],
        instanceLabels=['instance'],
        aggLevel='group',
      ),

      local testSignal = signalInit.addSignal(
        name='Test metric',
        nameShort='test',
        type='gauge',
        unit='short',
        description='Test metric',
        sourceMaps=[
          {
            expr: 'test_metric{%(queriesSelector)s}',
            exprWrappers: [],
            rangeFunction: 'rate',
            aggFunction: 'avg',
            aggKeepLabels: [],
            infoLabel: null,
            type: 'gauge',
            legendCustomTemplate: null,
            valueMappings: [],
            quantile: 0.95,
          },
        ],
      ),

      local raw = testSignal.withFilteringSelectorMixin('environment="prod"').asTarget(),
      testResult: test.suite({
        testExpression: {
          actual: raw.expr,
          expect: 'avg by (job) (\n  test_metric{job="integrations/agent",job=~"$job",instance=~"$instance",environment="prod"}\n)',
        },
      }),
    },

    // Test filtering selector mixin with asRuleExpression
    withAsRuleExpression: {
      local signalInit = signal.init(
        filteringSelector=['job="integrations/agent"'],
        groupLabels=['job'],
        instanceLabels=['instance'],
        aggLevel='group',
        alertsInterval='5m',
      ),

      local testSignal = signalInit.addSignal(
        name='Test metric',
        nameShort='test',
        type='gauge',
        unit='short',
        description='Test metric',
        sourceMaps=[
          {
            expr: 'test_metric{%(queriesSelector)s}',
            exprWrappers: [],
            rangeFunction: 'rate',
            aggFunction: 'avg',
            aggKeepLabels: [],
            infoLabel: null,
            type: 'gauge',
            legendCustomTemplate: null,
            valueMappings: [],
            quantile: 0.95,
          },
        ],
      ),

      local raw = testSignal.withFilteringSelectorMixin('environment="prod"').asRuleExpression(),
      testResult: test.suite({
        testExpression: {
          actual: raw,
          expect: 'test_metric{job="integrations/agent",environment="prod"}',
        },
      }),
    },
  },
}
