# Signal

Status: experimental.

This part of the lib allows to define signals (i.e. metrics, logs). 

This shifts focus of dashboard building from panels to actual signals we want to observe.

Workflow to generate dashboards would be as follows:

- Define key indicators(signals) your want to observe.
- Use built-in functions to render each signal as a panel (i.e. `signal.asTimeSeries()`, `signal.asStat()`, `signal.asGauge()`, `signal.asStatusHistory()`, `signal.asTable(format='table|timeseries'))`, `signal.asTableColumn()`)
- If you want to combine multiple signals inside a single panel, render signal not as [Grafana panel](https://grafana.github.io/grafonnet/API/panel/index.html), but as a [Target](https://grafana.github.io/grafonnet/API/panel/timeSeries/index.html#fn-queryoptionswithtargets), which is attachable to existing panel. (`signal.asTarget()`)
- If you need to put multiple signals inside single panel use `signal.asPanelMixin()` function. It would add `Target` And overrides relevant to it (units, value mappings...)
- If you need to put multiple columns inside single table use `signal.asTableColumn(format='table|timeseries')` function. It would add `Target` And overrides relevant to it (units, value mappings...).
- Variables required for signals are also generated and can be attached to any dashboard
- Bonus: use stylize() functions from commonlib/panels to apply common styles to signals.

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

Signal's level:

|Name|Description|Possible values|Example value|Default value|
|-----|---|---|---|---|
|name|Signal's name. Used to populate panel's legends and titles. |*|CPU usage|-|
|type|Signal's type. Depending on the type, some opinionated autotransformations would happen with queries, units. |gauge,counter,histogram,info,raw|gauge|-|
|unit| Signal's units. |*|bytes|``|
|description| Signal's description. Used to populate panel's description. |*|CPU usage time in percent.|``|
|expr| Signal's BASE expression in simplest form. Simplified jsonnet templating is supported (see below). Depending on signal's type(not `raw`) could autotransform to different form. |*|network_bytes_received_total{%(queriesSelector)s}|-|
|exprWrappers| Signal's additional wrapper functions that could be added as an array, [<left_part>, <right_part>]. Functions would be applied AFTER any autotransformation takes place.  |*|`['topk(10,',')']`|[]|
|aggLevel| Metrics aggregation level. |none, instance, group|`group`|`none`|
|aggFunction| A function used to aggregate metrics. |avg,min,max,sum...|`sum`|`avg`|
|aggKeepLabels| Extra labels to keep when aggregating with by() clause.  |`['pool','level']`|`[]`|
|infoLabel| Only applicable to `info` metrics. Points to label name used to extract info. |*|-|-|
|valueMapping| Define signal's valueMapping in the same way defined in Grafana Dashboard Schema. |*|-|-|
|legendCustomTemplate| A custom legend template could be defined with this to override automatic legend's generation|*|`null`|`{{instance}}`|
|rangeFunction| Rate function to use for counter metrics.|rate,irate,delta,idelta,increase|`rate`|`increase`|

## Expressions templating

The following is supported in expressions and legends:

- `%(queriesSelector)s` - expands to filteringSelector matchers and matchers based on instanceLabels, and groupLabels
- `%(filteringSelector)s` - expands to filteringSelector matchers
- `%(groupLabels)s` - expands to groupLabels list
- `%(instanceLabels)s` - expands to instanceLabels list
- `%(agg)s` - expands to list of labels according to `aggLevel` and `aggKeepLabels` choosen
- `%(aggLegend)s` - expands to list of labels in legend format (i.e. `{{<label1>}}/{{label2}}`) according to `aggLevel` and `aggKeepLabels` choosen
- `%(aggFunction)s` - expands to aggregation function
- `%(interval)s` - expands to `interval` value
- `%(alertsInterval)s` - expands to `interval` value

## Example 1

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
        type='counter',
        unit='bytes',
        description='Bytes in through interface',
        expr='node_network_receive_bytes_total{%(queriesSelector)s}',
    ),
    bytesOut: s.addSignal(
        name='Bytes out',
        type='counter',
        unit='bytes',
        description='Bytes out through interface',
        expr='node_network_transmit_bytes_total{%(queriesSelector)s}',
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


## Example 2

Define signals in json/jsonnet and unmarshall to signals:

```jsonnet
//config.libsonnet

local jsonSignals =
  {
    aggLevel: 'group',
    groupLabels: ['job'],
    instanceLabels: ['instance'],
    filteringSelector: 'job="integrations/agent"',
    signals: {
      abc: {
        name: 'ABC',
        type: 'gauge',
        description: 'ABC',
        unit: 's',
        expr: 'abc{%(queriesSelector)s}',
      },
      bar: {
        name: 'BAR',
        type: 'counter',
        description: 'BAR',
        unit: 'ns',
        expr: 'bar{%(queriesSelector)s}',
      },
      foo_info: {
        name: 'foo info',
        type: 'info',
        description: 'foo',
        unit: 'short',
        infoLabel: 'version',
        expr: 'foo_info{%(queriesSelector)s}',
      },
      status: {
        name: 'Status',
        type: 'gauge',
        description: 'status',
        unit: 'short',
        expr: 'status{%(queriesSelector)s}',
        valueMapping: {
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
          },
        },
      },
    },
  };

local signals = signal.unmarshallJson(jsonSignals);

```


## Running tests

See test files
```
cd common-lib
jsonnet -J vendor common/signal/test_histogram.libsonnet 
```