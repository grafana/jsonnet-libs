local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(this): {
    local vars = this.grafana.variables,
    local config = this.config,
    // define signals
    local s = commonlib.signals.init(
      datasource='${datasource}',
      groupLabels=this.config.groupLabels,
      instanceLabels=this.config.instanceLabels,
      filteringSelector=[this.config.filteringSelector],
      aggLevel='group',  // group metrics by 'instance', 'group', or 'none'
    ),

    //prepare Grafana templated variables aligned with queriesSelector generated:
    variables: s.getVariablesMultiChoice(),

    logsErrors:
      s.addSignal(
        name='Errors in logs',
        type='raw',
        description='Errors in logs.',
        expr='{%(queriesSelector)s, level=~"error|Error"} |= "searchstring"',
      ),
    info: s.addSignal(
      name='Info version metric',
      type='info',
      infoLabel='version',
      description='Version of the system',
      expr='metric_info{%(queriesSelector)s}',
    ),
    uptime1: s.addSignal(
      name='Uptime Annotation signals',
      type='raw',
      description='Signal for annotation',
      expr='uptime{%(queriesSelector)s}*1000 > $__from < $__to',
    ),
    metric1: s.addSignal(
      name='Sample gauge metric',
      type='gauge',
      unit='bytes',
      description='',
      expr='gauge{%(queriesSelector)s}',
    ),
    metric2: s.addSignal(
      name='Sample counter metric',
      type='counter',
      unit='requests',
      description='',
      expr='counter_total{%(queriesSelector)s}',
    ),
    metric3: s.addSignal(
      name='Sample histogram metric',
      type='histogram',
      unit='',
      description='',
      expr='counter_bucket_seconds{%(queriesSelector)s}',
    ),
    metric4: s.addSignal(
      name='Sample raw metric',
      type='raw',
      unit='',
      description='',
      expr=
      |||
        %(aggFunction)s by %(agg) (counter_bucket_seconds{%(queriesSelector)s})
      |||,
    ),

  },
}
