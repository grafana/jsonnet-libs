# Redis Mixin

This mixin contains shared dashboards and alerts for our Redis Kubernetes deployment. 

It only provides dashboards as part of the mixin itself, whereas alerts should be created by end users of the library.

## Dashboards

In order to use the mixin and import dashboards, you can simply import it and add to your other mixins:

```jsonnet
local redis_mixin = import 'redis-mixin/mixin.libsonnet';

{
  redis_mixin: redis_mixin {
    _config+:: {
      // It's possible to customize default datasource,
      // e.g. based on environment or cluster name, etc.
      datasource:
        if env == 'dev'
        then 'dev-datasource'
        else 'prod-datasource',
    },
  },
}
```

Make sure you only add it to your default namespace, because dashboards do not support namespacing.

## Alerts

In order to use alerts you should add them to your application's mixin. It's also possible to adjust alert thresholds, evaluation windows and severity:

```jsonnet
local redis = import 'redis-mixin/alerts.libsonnet';

local namespace = 'my-app-namespace';

{
  prometheusAlerts+:: {
    groups: [
      {
        name: 'Redis',
        rules: [
          redis.multipleMastersAlert(namespace),
          redis.noMasterAlert(namespace),
          redis
            .slaveMasterLinkAlert(namespace, 1)
            .withSeverity('warning')
            .withEvaluationWindow('20m'),
          redis
            .memoryUtilisationAlert(namespace, threshold=90)
            .withSeverity('critical')
        ],
      }
    ],
  },
}
```