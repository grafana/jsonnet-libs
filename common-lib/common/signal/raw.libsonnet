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
    valueMapping,
    legendCustomTemplate,
    rangeFunction,
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
      valueMapping,
      legendCustomTemplate,
      rangeFunction,
    )

    {
    },

}
