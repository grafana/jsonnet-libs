# Hello world observ lib

This lib can be used as a starter template of modular observ lib.


## Import

```sh
jb init
jb install https://github.com/grafana/jsonnet-libs/helloworld-observ-lib
```

## Modular observability lib format

```jsonnet

{
  config: {
    //common options
  },

  grafana: {
   
   // grafana templated variables to reuse across mutltiple dashboards
   variables: {
      datasources: {
        prometheus: {},
        loki: {},
      },
      multiInstance: [],
      singleInstace: [],
  	  queriesSelector: "",
   },

   // grafana targets (queries) to attach to panels
   targets: {
    target1: <target1>,
    target3: <target2>,
    ...
    targetN: <targetN>,
   },

   // grafana panels
   panels: {
    panel1: <panel1>,
    panel2: <panel2>,
    ...
    panelN: <panelN>,
   },

   // grafana dashboards
   dashboards: {
    dashboard1: <dashboard1>,
    dashboard2: <dashboard2>,
    ...
    dashboardN: <dashboardN>,
   },

   // grafana annotations
   annotations: {
    annotation1: <annotation1>,
    ...
   },
   
   // grafana dashboard links
   links: {
      //common dashobard links
   },
 },

 prometheus: {
  alerts: {},
  rules: {},
 },
}

```

## Pros of using modular observabilty format

- Uses (grafonnet)[https://monitoring.mixins.dev]
- Highly customizable and flexible:

Any object like `panel`, `target` (query) can be easily referenced by key and then overriden before output of the lib is provided by using jsonnet (patching)[https://tanka.dev/tutorial/environments#patching] technique:

```jsonnet
local helloworldlib = import './main.libsonnet';

local helloworld =
  helloworldlib.new(
    filteringSelector='job="integrations/helloworld"',
    uid='myhelloworld',
    groupLabels=['environment', 'cluster'],
    instanceLabels=['host'],
  )
  + 
  {
    grafana+: {
      panels+: {
        panel1+: 
          g.panel.timeSeries.withDescription("My new description for panel1")
      }
    }
  };
```

- Due to high decomposition level, not only dashboards but single panels can be imported ('cherry-picked) from the library to be used in other dashboards
- Format introduces mandatory arguments that each library should have: `filteringSelector`, `instanceLabels`, `groupLabels`, `uid`. Proper use of those parameters ensures library can be used to instantiate multiple copies of the observability package in the same enviroment without `ids` conflicts or timeSeries overlapping.

## Examples

### Monitoring-Mixin example

You can use lib to fill in [monitoring-mixin](https://monitoring.mixins.dev/) structure:

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
