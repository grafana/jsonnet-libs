local prom = import 'prom.libsonnet';
local promRuleGroupSet = prom.v1.ruleGroupSet;
local promRuleGroup = prom.v1.ruleGroup;
{
  prometheus_down::
    promRuleGroup.new('prometheus_down')
    + promRuleGroup.rule.new(
      'PrometheusDown', {
        alert: 'PrometheusDown',
        expr: 'up{job="prometheus"} == 0',
        'for': '5m',
        labels: {
          namespace: 'prometheus',
          severity: 'critical',
        },
        annotations: {
        },
      }
    ),

  prometheusAlerts+:
    promRuleGroupSet.new()
    + promRuleGroupSet.addGroup($.prometheus_down),
}
