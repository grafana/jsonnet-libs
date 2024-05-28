local g = import '../g.libsonnet';
local utils = import '../utils.libsonnet';
local base = import './base.libsonnet';
local signalUtils = import './utils.libsonnet';
base {
  new(
    name,
    type,
    unit,
    description,
    expr,
    exprWrappers,
    aggLevel,
    vars,
    datasource,
    valueMapping,
    legendCustomTemplate,
  ):
    base.new(
      name,
      type,
      unit,
      description,
      expr,
      exprWrappers,
      aggLevel,
      vars,
      datasource,
      valueMapping,
      legendCustomTemplate,
      rangeFunction=null,
    )
    {
    },

}
