# Signal

Status: experimental.

This part of the lib allows to define signals (i.e. metrics, logs). 

This shifts focus of dashboard building from panels to actual signals we want to observe.

Workflow to generate dashboards would be as follows:

- Define key indicators(signals) your want to observe.
- Use built-in functions to render each signal as a panel (i.e. `signal.asTimeSeries()`, `signal.asStat()`, `signal.asGauge()`, `signal.asStatusHistory()`, `signal.asTable(format='table|time_series'))`, `signal.asTableColumn()`).
- If you need to put multiple signals inside a single panel use `signal.asPanelMixin()` function. It would add [Target](https://grafana.github.io/grafonnet/API/panel/timeSeries/index.html#fn-queryoptionswithtargets) and overrides relevant to it (units, value mappings...)
- If you need to put multiple columns inside single table use `signal.asTableColumn(format='table|time_series')` function. It would add `Target` And overrides relevant to it (units, value mappings...).
- Variables required for signals are also generated and can be attached to any dashboard.
- Bonus: use stylize() functions from commonlib/panels to apply common styles to signals.

## Functions

### Modify functions

These functions modify one of the signal's property and then  return signal back. Can be used as part of the builder pattern.

- withTopK(limit=25) - wrap signal expression into topk().
- withExprWrappersMixin(wrapper=[]) - wrap signal expression into additional function on top of existing wrappers.
- withOffset(offset) - add offset modifier to the expression.
- withFilteringSelectorMixin(mixin) - add additional selector to filteringSelector used.

### Render functions

These functions return signals view as one of the Grafana panels, its part, or as alerts.

- Panel functions
  - asTimeSeries() - renders TimeSeries panel with signals expression as the the first target and panel override.
  - asStat() - renders Stat panel with signals expression as the the first target and panel override.
  - asGauge() - renders Gauge panel with signals expression as the the first target and panel override.
  - asStatusHistory() - renders StatusHistory panel with signals expression as the the first target and panel override.
  - asTable(format=table|time_series) - renders Table panel with signals expression as the the first target and panel override.
- Parts of panels
  - asPanelMixin() - add signals expression as the the target and panel override to the existing panel of any type, except a table.
  - asTableColumn(format=table|time_series) - add signals expression as the the target and panel override to the existing panel created with .asTable() function.
  - asTarget() - add signals expression as the the target to the existing panel.
  - asTableTarget() - add signals expression as the the target to the existing panel, with format=table.
  - asOverride() - add panel override to the existing panel.
  - asPanelExpression() - add signals expression to the panels target.
- Prometheus rules (alerts)
  - asRuleExpression() - add signals expression without any Grafana dynamic variables inside. Can be used for Prometheus alerts and rules.

## Autotransformations

### Expressions
When one of built-in functions are used (asTimeSeries, asPanelsMixin, asTarget...) signals' base expressions are converted automatically based on the type:

- counter: is wrapped into `<rangeFunction>(<base>[<interval>])`
- gauge: no transformation
- histogram: wrapped into `histogram_quantile(0.95, <aggFunction>(rate(<base>[<interval>])) by (le,<agg>))`
- info: no transformation
- raw: no transformation. You can write your own complex expression and make sure is kept as is.

Also, regardless of type (with the exception of `raw`), additional wrapper can be added when aggLevel `group` or `instance` is selected:

`<aggFunction> by (<agg>) (<base>)`

## Configuration options

Init level:

|Name|Description|Possible values|Example value|Default value|
|-----|---|---|---|---|
|datasource| Prometheus Datasource name. |*|`custom_datasource`|`datasource`|
|datasourceLabel| Prometheus Datasource label. |*|`Custom data source`|`Data source`|
|filteringSelector|Used to filter metric scopes. Added to all dashboards'(as part of `queriesSelector`) and alerts' queries. |*|`[job="blablablah]"`,|`['job!=""']`|
|groupLabels| List of labels used to identify group of instance or whole service. |*|`[job]`|`[job]`|
|instanceLabels| List of labels used to identify single entity or specific service instance. |*|`[instance]`|`['instance']`|
|interval| The interval used in `counters` and `histogram` auto transformations. |1m,5m.1h..., $__rate_interval, $__interval...|`5m`,|`$__rate_interval`|
|alertsInterval| The interval used in  `counters` and `histogram` auto transformations in alerts. Grafana's $__rate_interval or similar are not supported. |1m,5m.1h...|`5m`,|`5m`|
|aggLevel| Metrics aggregation level. |none, instance, group|`group`|`none`|
|aggKeepLabels| Extra labels to keep when aggregating with by() clause. |`['pool','level']`|`[]`|
|aggFunction| A function used to aggregate metrics. |avg,min,max,sum...|`sum`|`avg`|
|varMetric| A Metric used for variables discovery. |*|`up`|`node_uname_info`|
|legendCustomTemplate| A custom legend template could be defined with this to override automatic legend's generation|*|`null`|`{{instance}}`|
|rangeFunction| Rate function to use for counter metrics.|rate,irate,delta,idelta,increase|`rate`|`increase`|
|varAdHocEnabled| Attach ad hoc labels to variables generated. |`true`,`false`|`false`|`false`|
|varAdHocLabels| Limit ad hoc to the specific labels |*|`["environment"]`|`[]`|
|enableLokiLogs| Add additional loki datasource to variables generation |`true`,`false`|`true`|`false`|

Signal's level:

|Name|Description|Possible values|Example value|Default value|
|-----|---|---|---|---|
|name|Signal's name. Used to populate panel's titles. |*|CPU utilization|-|
|nameShort|Signal's short name. Used to populate panel's legends and column names. |*|CPU|-|
|type|Signal's type. Depending on the type, some opinionated autotransformations would happen with queries, units. |gauge,counter,histogram,info,raw|gauge|-|
|optional| Set this signal optional.| true,false | false | false|
|unit| Signal's units. |*|bytes|``|
|description| Signal's description. Used to populate panel's description. |*|CPU usage time in percent.|``|
|sourceMaps[].expr| Signal's BASE expression in simplest form. Simplified jsonnet templating is supported (see below). Depending on signal's type(not `raw`) could autotransform to different form. |*|network_bytes_received_total{%(queriesSelector)s}|-|
|sourceMaps[].exprWrappers| Signal's additional wrapper functions that could be added as an array, [<left_part>, <right_part>]. Functions would be applied AFTER any autotransformation takes place.  |*|`['topk(10,',')']`|[]|
|aggLevel| Metrics aggregation level. |none, instance, group|`group`|`none`|
|aggFunction| A function used to aggregate metrics. |avg,min,max,sum...|`sum`|`avg`|
|sourceMaps[].aggKeepLabels| Extra labels to keep when aggregating with by() clause.  |`['pool','level']`|`[]`|
|sourceMaps[].infoLabel| Only applicable to `info` metrics. Points to label name used to extract info. |*|-|-|
|sourceMaps[].valueMappings| Define signal's valueMappings in the same way defined in Grafana Dashboard Schema. |*|-|-|
|sourceMaps[].legendCustomTemplate| A custom legend template could be defined with this to override automatic legend's generation|*|`null`|`{{topic}}`|
|sourceMaps[].rangeFunction| Rate function to use for counter metrics.|rate,irate,delta,idelta,increase|`rate`|`increase`|

## Expressions templating

The following is supported in expressions and legends:

- `%(queriesSelector)s` - expands to filteringSelector matchers and matchers based on instanceLabels, and groupLabels
- `%(filteringSelector)s` - expands to filteringSelector matchers
- `%(groupLabels)s` - expands to groupLabels list
- `%(instanceLabels)s` - expands to instanceLabels list
- `%(agg)s` - expands to list of labels according to `aggLevel` and `aggKeepLabels` choosen
- `%(aggLegend)s` - expands to label in legend format (i.e. `{{<label1>}}`) according to `aggLevel` and `aggKeepLabels` choosen
- `%(aggFunction)s` - expands to aggregation function
- `%(interval)s` - expands to `interval` value
- `%(alertsInterval)s` - expands to `interval` value

## Making signals optional

When defining signals from multiple sources, you can make some of the signals optional. In this case, rendering will not throw a validation error that signal is missing for the specific source, while internal 'stub' type will be used and empty panel will be rendered instead.

## Example 1: From JSON

Define signals in json/jsonnet and unmarshall to signals. You can define multiple signals' sources:

```jsonnet
//config.libsonnet

local jsonSignals =
  {
    aggLevel: 'group',
    groupLabels: ['job'],
    instanceLabels: ['instance'],
    filteringSelector: 'job="integrations/agent"',
    discoveryMetric: {
      prometheus: 'up',
      opentelemetry: 'target_info',
    },
    signals: {
      abc: {
        name: 'ABC metric',
        nameShort: 'ABC',
        type: 'gauge',
        description: 'ABC',
        unit: 's',
        sources: {
          "prometheus": {
            expr: 'abc_total{%(queriesSelector)s}',
          },
          "opentelemetry": {
            expr: 'otel_metric{%(queriesSelector)s}',
          }
        },
      },
      bar: {
        name: 'BAR',
        type: 'counter',
        description: 'BAR',
        unit: 'ns',
        sources: {
          "prometheus": {
            expr: 'bar_total{%(queriesSelector)s}',
          },
          "opentelemetry": {
            expr: 'otel_bar{%(queriesSelector)s}',
          }
        },
        
      },
      foo_info: {
        name: 'foo info',
        type: 'info',
        description: 'foo',
        unit: 'short',
        optional: true, // set optional:true, if not all sources are available.
        sources: {
          "prometheus": {
            expr: 'foo_info{%(queriesSelector)s}',
            infoLabel: 'version',
          },
        },
        
      },
      status: {
        name: 'Status',
        type: 'gauge',
        description: 'status',
        unit: 'short',
        optional: true,
        sources: {
          "prometheus": {
            expr: 'status{%(queriesSelector)s}',
            valueMappings: 
              [
                {
                  type: 'value',
                  options: {
                    '1': {
                      text: 'Up',
                      color: 'light-green',
                      index: 1,
                    },
                    '0': {
                      text: 'Down',
                      color: 'light-red',
                      index: 0,
                    },
                  }
                },
              ],
          },
        },
        
      },
    },
  };

local signals = signal.unmarshallJsonMulti(jsonSignals,type=['prometheus']);

```

## Example 2: Generate 'combined' dashboard/alerts

Same as example 1, but you can actually merge multiple sources together in one query by using 'or':

```jsonnet
local jsonSignals = <see example1>;
local signals = signal.unmarshallJsonMulti(jsonSignals,type=['prometheus','opentelemetry]);
```

This would make your dashboards and alerts universal, suitable for multiple sources.


## Example 3: low-level

Rarely used, but it is also possible to skip JSON unmarshalling: 

```
local g = import 'g.libsonnet';

# define signals
    local s = commonlib.signals.init(
        datasource='datasource',
        instanceLabels=['instance','device'],
        groupLabels=['job'],
        filteringSelector=['job=integrations/test'],
        aggLevel='instance',
    ),
    
    //prepare Grafana templated variables aligned with queriesSelector generated:
    variables: s.getVariablesMultiChoice(),

    bytesIn: s.addSignal(
        name='Bytes in',
        nameShort='In',
        type='counter',
        unit='bytes',
        description='Bytes in through interface',
        sourceMaps=[
          {
            expr: 'node_network_receive_bytes_total{%(queriesSelector)s}',
            rangeFunction: null,
            aggKeepLabels: [],
            legendCustomTemplate: null,
            infoLabel: null,
          },
        ],
    ),
    bytesOut: s.addSignal(
        name='Bytes out',
        nameShort='Out',
        type='counter',
        unit='bytes',
        description='Bytes out through interface',
        sourceMaps=[
          {
            expr: 'node_network_transmit_bytes_total{%(queriesSelector)s}',
            rangeFunction: null,
            aggKeepLabels: [],
            legendCustomTemplate: null,
            infoLabel: null,
          },
        ],
        
    ),
};



#generate dashboard
g.dashboard.new('Device')
+ g.dashboard.withVariables(signals.variables)
+ g.dashboard.withPanels(
    [
    g.panel.row.new('Graph'),
    signals.bytesIn.asTimeSeries()
    + g.panel.timeSeries.queryOptions.withTargetsMixin(
        signals.bytesOut.asTarget()
    )
    + { gridPos: { h: 10, w: 8 } }
    + commonlib.panels.network.timeSeries.traffic.stylize()
    + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets(),
    ]
)
```

## Running tests

See test files
```
cd common-lib
jsonnet -J vendor common/signal/test_histogram.libsonnet 
```
