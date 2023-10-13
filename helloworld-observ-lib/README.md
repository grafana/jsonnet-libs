# Hello world observ lib

This lib can be used as a starter of modular observ lib.

## Import

```sh
jb init
jb install https://github.com/grafana/jsonnet-libs/hello-world-lib
```

## Examples

### Basic example

You can use lib to fill in monitoring-mixin structure:

```jsonnet
// mixin.libsonnet file

local helloworldlib = import './main.libsonnet';

local helloworld =
  helloworldlib.new(
    filteringSelector='job="integrations/helloworld"',
    uid='myhelloworld',
    groupLabels=['environment', 'cluster'],
    instanceLabels=['host'],
  );

// populate monitoring-mixin:
{
  grafanaDashboards+:: helloworld.grafana.dashboards,
  prometheusAlerts+:: helloworld.prometheus.alerts,
  prometheusRules+:: helloworld.prometheus.recordingRules,
}
```

### Logs collection

Grafana Loki is used to populate logs dashboard and also for quering annotations.

To opt-out, you can set `enableLokiLogs: false` in config:

```
local helloworldlib = import './main.libsonnet';

local helloworld =
  helloworldlib.new(
    filteringSelector='job="integrations/helloworld"',
    uid='myhelloworld',
    groupLabels=['environment', 'cluster'],
    instanceLabels=['host'],
  )
  + helloworldlib.withConfigMixin(
    {
      // disable loki logs
      enableLokiLogs: false,
    }
  );

// populate monitoring-mixin:
{
  grafanaDashboards+:: helloworld.grafana.dashboards,
  prometheusAlerts+:: helloworld.prometheus.alerts,
  prometheusRules+:: helloworld.prometheus.recordingRules,
}
```
