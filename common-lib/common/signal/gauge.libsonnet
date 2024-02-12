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
    aggLevel,
    vars,
    datasource,
    valueMapping,
  ):
    base.new(
      name,
      type,
      unit,
      description,
      expr,
      aggLevel,
      vars,
      datasource,
      valueMapping
    )
    {
    },

}
