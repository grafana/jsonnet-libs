# Golang observ lib

This lib can be used to generate dashboards, panels, and targets for Golang runtime.
## Import

```sh
jb init
jb install https://github.com/grafana/jsonnet-libs/golang-observ-lib
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
local golanglib = import './main.libsonnet';

local golang =
  golanglib.new() + 
  {
    grafana+: {
      panels+: {
        goroutines+: 
          g.panel.timeSeries.withDescription("My new description for goroutines")
      }
    }
  };
```

- Due to high decomposition level, not only dashboards but single panels can be imported ('cherry-picked') from the library to be used in other dashboards
- Format introduces mandatory arguments that each library should have: `filteringSelector`, `instanceLabels`, `groupLabels`, `uid`. Proper use of those parameters ensures library can be used to instantiate multiple copies of the observability package in the same enviroment without `ids` conflicts or timeSeries overlapping.
