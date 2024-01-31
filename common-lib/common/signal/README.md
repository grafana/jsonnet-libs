# Signal

This part of the lib allows to define signals (i.e. metrics, logs). 

This shifts focus of dashboard building from panels to actual signals we want to observe.

Workflow to generate dashboards would be as follows:
- Define key indicators(signals) your want to observe.
- Use built-in functions to render each signal as a panel (i.e. signal.asTimeSeries())
- If you want to combine multiple signals inside a single panel, render signal not as [Grafana panel](https://grafana.github.io/grafonnet/API/panel/index.html), but as a [Target](https://grafana.github.io/grafonnet/API/panel/timeSeries/index.html#fn-queryoptionswithtargets), which is attachable to existing panel
- Bonus: use stylize() functions from commonlib/panels to apply common styles to signals.

## Example




```
local g = import 'g.libsonnet';

# define signals
local s = commonlib.signals.init(
    datasource='${datasource}',
    instanceLabels=['instance','device'],
    groupLabels=['job'],
    filteringSelector=['job=integrations/test'],
    aggLevel='instance',
),
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
+ g.dashboard.withVariables(<somevars>)
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