local g = import '../g.libsonnet';
local utils = import '../utils.libsonnet';
local base = import './base.libsonnet';
local signalUtils = import './utils.libsonnet';
local lokiQuery = g.query.loki;
base {
  new(
    name,
    type,
    unit,
    nameShort,
    description,
    aggLevel,
    aggFunction,
    vars,
    datasource,
    sourceMaps,
  ):
    base.new(
      name,
      type,
      unit,
      nameShort,
      description,
      aggLevel,
      aggFunction,
      vars,
      datasource,
      sourceMaps=sourceMaps,
    )
    {
      common(type)::
        // override panel-wide --mixed-- datasource
        lokiQuery.withDatasource('${%s}' % datasource)
        + g.panel.logs.panelOptions.withDescription(description),


      //Return as grafana panel target(query+legend)
      asTarget(name=name):
        lokiQuery.new(
          '${%s}' % datasource,
          self.asPanelExpression(),
        )
        + lokiQuery.withRefId(name),

      asGauge()::
        error 'asGauge() is not supported for log metrics.',
      asStat()::
        error 'asStat() is not supported for log metrics.',
      asTimeSeries()::
        error 'asTimeSeries() is not supported for log metrics.',
      asTableTarget():
        error 'asTableTarget() is not supported for log metrics.',
      asTableColumn():
        error 'asTableColumn() is not supported for log metrics.',
      asTable():
        error 'asTable() is not supported for log metrics.',
      asOverride():
        error 'asOverride() is not supported for log metrics.',
      asStatusHistory():
        error 'asStatusHistory() is not supported for log metrics.',
      withOffset():
        error 'withOffset() is not supported for log metrics.',
      withTopK():
        error 'withTopK() is not supported for log metrics.',
    },

}
