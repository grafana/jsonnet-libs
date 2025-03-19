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

    logsErrors: s.addSignal(
      name='Errors in logs',
      type='raw',
      description='Errors in logs.',
      sourceMaps=[
        {
          expr: '{%(queriesSelector)s, level=~"error|Error"} |= "searchstring"',
          aggKeepLabels: [],
          legendCustomTemplate: null,
          rangeFunction: null,
        },
      ],
    ),
    info: s.addSignal(
      name='Info version metric',
      type='info',
      infoLabel='version',
      description='Version of the system',
      sourceMaps=[
        {
          expr: 'metric_info{%(queriesSelector)s}',
          aggKeepLabels: [],
          legendCustomTemplate: null,
          rangeFunction: null,
        },
      ],
    ),
    uptime1: s.addSignal(
      name='Uptime Annotation signals',
      type='raw',
      description='Signal for annotation',
      sourceMaps=[
        {
          expr: 'uptime{%(queriesSelector)s}*1000 > $__from < $__to',
          aggKeepLabels: [],
          legendCustomTemplate: null,
          rangeFunction: null,
        },
      ],
    ),
    metric1: s.addSignal(
      name='Sample gauge metric',
      type='gauge',
      unit='bytes',
      description='Some description.',
      sourceMaps=[
        {
          expr: 'gauge{%(queriesSelector)s}',
          aggKeepLabels: [],
          legendCustomTemplate: null,
          rangeFunction: null,
        },
      ],
    ),
    metric2: s.addSignal(
      name='Sample counter metric',
      type='counter',
      unit='requests',
      description='Some description.',
      sourceMaps=[
        {
          expr: 'counter_total{%(queriesSelector)s}',
          aggKeepLabels: [],
          legendCustomTemplate: null,
          rangeFunction: 'rate',
        },
      ],
    ),
    metric3: s.addSignal(
      name='Sample histogram metric',
      type='histogram',
      unit='',
      description='Some description.',
      sourceMaps=[
        {
          expr: 'counter_bucket_seconds{%(queriesSelector)s}',
          aggKeepLabels: [],
          legendCustomTemplate: null,
          rangeFunction: 'rate',
        },
      ],
    ),
    metric4: s.addSignal(
      name='Sample raw metric',
      type='raw',
      unit='',
      description='Some description.',
      sourceMaps=[
        {
          expr: |||
            %(aggFunction)s by %(agg) (counter_bucket_seconds{%(queriesSelector)s})
          |||,
          aggKeepLabels: [],
          legendCustomTemplate: null,
          rangeFunction: null,
        },
      ],
    ),

  },
}
