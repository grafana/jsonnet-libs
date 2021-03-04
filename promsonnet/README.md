# PromSonnet

`PromSonnet` is intended as a very simple library for creating Prometheus
alerts and rules. It is 'patching friendly', as in, it maintains the
rules internally as a map, which allows users to easily patch alerts and
recording rules after the fact. In contrast, lists require complex
iteration logic.

It also provides useful functions for patching existing rules and rule
groups, along with patching these embedded in [monitoring mixins](https://github.com/monitoring-mixins/docs).

## Creating Rule Groups with PromSonnet
Take this example:

```
local prom = import 'prom.libsonnet';
local promRuleGroupSet = prom.v1.ruleGroupSet;
local promRuleGroup = prom.v1.ruleGroup;
{
  prometheus_metamon::
    promRuleGroup.new('prometheus_metamon')
    + promRuleGroup.rule.newAlert(
      'PrometheusDown', {
        expr: 'up{job="prometheus"}==0',
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
    + promRuleGroupSet.addGroup($.prometheus_metamon),
}
```

If we wanted to change the `for` from `5m` to `10m`, we could do this
simply with code such as:

```
{
  prometheusAlerts+: {
    groups_map+:: {
      prometheus_metamon+:: {
        rules+:: {
          PrometheusDown+:: {
            for: '10m',
          },
        },
      },
    },
  },
}
```

We no longer need to iterate over all alerts to do so.

## Patching Rules
The power of Jsonnet is its ability to patch existing resources. PromSonnet provides support for
patching existing rule groups, e.g.:
```
prometheusAlerts+: prom.v1.patchRule('prometheus_metamon', 'PrometheusDown', { 'for': '10m' }),
```

You can execute either of these examples in the `promsonnet` directory
via:
```
$ jsonnet example.jsonnet
$ # or:
$ jsonnet patch.jsonnet
```
> NOTE: This `v1.patchRule` function is intelligent: it can work with PromSonnet created rule groups
as well as ones that were created manually (without the `groups_map` for example).

## Working with Mixins
Given that we often want to patch existing rules, and those often exist within mixins,
we can also do:
```
mixins+: prom.v1.mixin.patchRule('base', 'prometheus_metamon', 'PrometheusDown', { 'for': '10m' }),
```
This will apply the same patch to the `base` mixin.

## 'Upgrading' existing rule groups and mixins
PromSonnet provides a `v1.legacy` API which includes functions for 'upgrading' rule groups without the
`groups_map` element into ones that do. This can make manual patching easier. It doesn't make any
significant difference if using the PromSonnet patch functions. When working with mixins, there are
two available approaches:
```
local mixin = 'my-mixin.libsonnet';
{
  mixins+:: {
    mymixin: mixin + prom.v1.legacy.mixin.update,
  }
}

```
Or, if the mixin has already been added to your `$.mixins`, perhaps by code you don't control:
```
local mixin = 'my-mixin.libsonnet';
{
  mixins+:: {
    mymixin: mixin,
  }
} + {
  mixins+:: prom.v1.legacy.mixin.updateExisting('mymixin'),
}
```
