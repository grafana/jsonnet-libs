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
    aggFunction,
    aggKeepLabels,
    vars,
    datasource,
    valueMappings,
    legendCustomTemplate,
    sourceMaps,
  ):
    base.new(
      name,
      type,
      unit,
      description,
      expr,
      exprWrappers,
      aggLevel,
      aggFunction,
      aggKeepLabels,
      vars,
      datasource,
      valueMappings,
      legendCustomTemplate,
      rangeFunction=null,
      sourceMaps=sourceMaps,
    )
    {
    },

}
