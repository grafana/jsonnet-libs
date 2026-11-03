local signal = import './signal.libsonnet';
local test = import 'jsonnetunit/test.libsonnet';

// Rules (alerts / recording rules) are evaluated at "now", so a forward-shifted subquery such as
// `increase(x[5m:] offset -5m)` reads the window (now, now+5m], which holds no samples: the
// result is always 0 and `increase(...) > 0` can never fire.
// asRuleExpression() must therefore use a plain trailing range for every range function,
// while dashboard queries keep the forward-shifted subquery.

local counterSignal(rangeFunction, interval='5m', alertsInterval='5m') =
  signal.init(
    filteringSelector=['job="abc"'],
    interval=interval,
    alertsInterval=alertsInterval,
    aggLevel='group',
    aggFunction='sum',
    groupLabels=['job'],
    instanceLabels=['instance'],
  ).addSignal(
    name='Failures',
    nameShort='failures',
    type='counter',
    unit='short',
    description='Failures.',
    sourceMaps=[
      {
        expr: 'failures_total{%(queriesSelector)s}',
        rangeFunction: rangeFunction,
        aggKeepLabels: [],
        legendCustomTemplate: null,
        infoLabel: null,
      },
    ],
  );

local hasSubqueryOrOffset(expr) =
  std.length(std.findSubstr('offset', expr)) > 0 || std.length(std.findSubstr(':]', expr)) > 0;

{
  // The three functions that used to get the forward-shifted subquery in rules.
  ruleUsesPlainRange: test.suite({
    testIncrease: {
      actual: counterSignal('increase').asRuleExpression(),
      expect: 'increase(failures_total{job="abc"}[5m])',
    },
    testDelta: {
      actual: counterSignal('delta').asRuleExpression(),
      expect: 'delta(failures_total{job="abc"}[5m])',
    },
    testIdelta: {
      actual: counterSignal('idelta').asRuleExpression(),
      expect: 'idelta(failures_total{job="abc"}[5m])',
    },
  }),

  // Functions that never had the subquery must be unchanged.
  ruleKeepsPlainRangeForRateFunctions: test.suite({
    testRate: {
      actual: counterSignal('rate').asRuleExpression(),
      expect: 'rate(failures_total{job="abc"}[5m])',
    },
    testIrate: {
      actual: counterSignal('irate').asRuleExpression(),
      expect: 'irate(failures_total{job="abc"}[5m])',
    },
  }),

  // Invariant: no rule expression may look into the future or use a subquery, for any range function.
  ruleNeverShiftsWindowForward: test.suite({
    testNoOffsetOrSubquery: {
      actual: [
        hasSubqueryOrOffset(counterSignal(f).asRuleExpression())
        for f in ['rate', 'irate', 'increase', 'delta', 'idelta']
      ],
      expect: [false, false, false, false, false],
    },
  }),

  // Rules take their range from alertsInterval, not from the dashboard interval.
  ruleUsesAlertsInterval: test.suite({
    testIncrease: {
      actual: counterSignal('increase', interval='1m', alertsInterval='15m').asRuleExpression(),
      expect: 'increase(failures_total{job="abc"}[15m])',
    },
  }),

  // Signals combined with withOffset() (for example "uptime 10m ago") keep their own offset, applied inside the selector.
  ruleKeepsExplicitOffset: test.suite({
    testIncreaseWithOffset: {
      actual: counterSignal('increase').withOffset('10m').asRuleExpression(),
      expect: 'increase((failures_total{job="abc"} offset 10m)[5m])',
    },
  }),

  // Dashboards must keep the forward-shifted subquery: it is what aligns bucket totals for increase/delta/idelta.
  dashboardKeepsForwardShiftedSubquery: test.suite({
    testIncrease: {
      actual: counterSignal('increase').asTarget().expr,
      expect: 'sum by (job) (\n  increase(failures_total{job="abc",job=~"$job",instance=~"$instance"}[$__interval:] offset -$__interval)\n)',
    },
    testDelta: {
      actual: counterSignal('delta').asTarget().expr,
      expect: 'sum by (job) (\n  delta(failures_total{job="abc",job=~"$job",instance=~"$instance"}[$__interval:] offset -$__interval)\n)',
    },
    testIdelta: {
      actual: counterSignal('idelta').asTarget().expr,
      expect: 'sum by (job) (\n  idelta(failures_total{job="abc",job=~"$job",instance=~"$instance"}[$__interval:] offset -$__interval)\n)',
    },
    testRateUsesConfiguredInterval: {
      actual: counterSignal('rate').asTarget().expr,
      expect: 'sum by (job) (\n  rate(failures_total{job="abc",job=~"$job",instance=~"$instance"}[5m])\n)',
    },
  }),
}
