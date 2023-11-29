# Hello world observ lib

This lib can be used as a starter template of modular observ lib. Modular observ libs are highly reusable observability package containing grafana dashboards and prometheus alerts/rules. They can be used in as a replacement or in conjuction to monitoring-mixins format.


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
   links: {},
 },

 prometheus: {
  alerts: {},
  rules: {},
 },
}

```

## Pros of using modular observabilty format

- Uses [jsonnet](https://jsonnet.org/learning/tutorial.html), jsonnet-bundler, and [grafonnet](https://github.com/grafana/grafonnet)
- Highly customizable and flexible:

Any object like `panel`, `target` (query) can be easily referenced by key and then overriden before output of the lib is provided by using jsonnet [patching](https://tanka.dev/tutorial/environments#patching) technique:

```jsonnet
local helloworldlib = import './main.libsonnet';

local helloworld =
  helloworldlib.new() + 
  {
    grafana+: {
      panels+: {
        panel1+: 
          g.panel.timeSeries.withDescription("My new description for panel1")
      }
    }
  };
```

- Due to high decomposition level, not only dashboards but single panels can be imported ('cherry-picked') from the library to be used in other dashboards
- Format introduces mandatory arguments that each library should have: `filteringSelector`, `instanceLabels`, `groupLabels`, `uid`. Proper use of those parameters ensures library can be used to instantiate multiple copies of the observability package in the same enviroment without `ids` conflicts or timeSeries overlapping.

## Examples

### Example 1: Monitoring-Mixin example

You can use lib to fill in [monitoring-mixin](https://monitoring.mixins.dev/) structure:

```jsonnet
// mixin.libsonnet file

local helloworldlib = import 'helloworld-observ-lib/main.libsonnet';

local helloworld =
  helloworldlib.new();

// populate monitoring-mixin:
{
  grafanaDashboards+:: helloworld.grafana.dashboards,
  prometheusAlerts+:: helloworld.prometheus.alerts,
  prometheusRules+:: helloworld.prometheus.recordingRules,
}
```

### Example 2: Monitoring-mixin example with custom config


Any modular library should include as mandator configuration paramaters:
- `filteringSelector` - Static selector to apply to ALL dashboard variables of type query, panel queries, alerts and recording rules.
- `groupLabels` - one or more labels that can be used to identify 'group' of instances. In simple cases, can be 'job' or 'cluster'.
- `instanceLabels` - one or more labels that can be used to identify single entity of instances. In simple cases, can be 'instance' or 'pod'.
- `uid` - UID to prefix all dashboards original uids
- `dashboardNamePrefix` - Use as prefix for all Dashboards and (optional) rule groups

By changing those you can install same mixin two or more times into same Grafana/Prometheus, or import them into other mixins, without any potential problem of conflicting dashboard ids or intersecting PromQL queries:

First:

```
local helloworldlib = import './main.libsonnet';

local helloworld =
  helloworldlib.new()
  + helloworldlib.withConfigMixin(
    {
      filteringSelector: 'job=~"integrations/first"',
      uid: 'firsthelloworld',
      groupLabels: ['environment', 'cluster', 'job'],
      instanceLabels: ['instance'],
    }
  );

// populate monitoring-mixin:
{
  grafanaDashboards+:: helloworld.grafana.dashboards,
  prometheusAlerts+:: helloworld.prometheus.alerts,
  prometheusRules+:: helloworld.prometheus.recordingRules,
}
```

Second:

```
local helloworldlib = import './main.libsonnet';

local helloworld =
  helloworldlib.new()
  + helloworldlib.withConfigMixin(
    {
      filteringSelector: 'job=~"integrations/second"',
      uid: 'secondhelloworld',
      groupLabels: ['environment', 'cluster', 'job'],
      instanceLabels: ['instance'],
    }
  );

// populate monitoring-mixin:
{
  grafanaDashboards+:: helloworld.grafana.dashboards,
  prometheusAlerts+:: helloworld.prometheus.alerts,
  prometheusRules+:: helloworld.prometheus.recordingRules,
}
```


### Example 3: Changing specific panel before rendering dashboards

We can point to any object (i.e grafana.panels.panel1) and modify it by using [jsonnnet mixins](https://jsonnet.org/learning/tutorial.html).

For example, let's modify panel's default draw style to bars by mutating it with [grafonnet](https://grafana.github.io/grafonnet/API/panel/timeSeries/index.html#fn-fieldconfigdefaultscustomwithdrawstyle):

```
local g = import './g.libsonnet';
local helloworldlib = import 'helloworld-observ-lib/main.libsonnet';

local helloworld =
  helloworldlib.new()
  + {
    grafana+: {
      panels+: {
        networkSockstatAll+:
          + g.panel.timeSeries.fieldConfig.defaults.custom.withDrawStyle('bars')
      }
    }
  };

// populate monitoring-mixin:
{
  grafanaDashboards+:: helloworld.grafana.dashboards,
  prometheusAlerts+:: helloworld.prometheus.alerts,
  prometheusRules+:: helloworld.prometheus.recordingRules,
}

```

### Example 4: Optional logs collection

Grafana Loki datasource is used to populate logs dashboard and also for quering annotations.

To opt-out, you can set `enableLokiLogs: false` in config:

```
local helloworldlib = import 'helloworld-observ-lib/main.libsonnet';

local helloworld =
  helloworldlib.new()
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

## Recommended dev environment

To speed up developing observability libs as-code, we recommend to work in the following dev enviroment:

- Setup Vscode with [Jsonnet Language Server](https://marketplace.visualstudio.com/items?itemName=Grafana.vscode-jsonnet)
- Setup format on save in vscode to lint jsonnet automatically.
- use [grizzly](https://github.com/grafana/grizzly):
  - `export GRAFANA_URL=http://localhost:3000`
  - `grr apply -t "Dashboard/*" mixin.libsonnet` or `grr watch -t "Dashboard/*" . mixin.libsonnet`
