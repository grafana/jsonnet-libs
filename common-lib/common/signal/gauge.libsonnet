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
    aggLevel,
    aggFunction,
    vars,
    datasource,
    legendCustomTemplate,
    sourceMaps,
  ):
    base.new(
      name,
      type,
      unit,
      description,
      aggLevel,
      aggFunction,
      vars,
      datasource,
      legendCustomTemplate,
      sourceMaps=sourceMaps,
    )
    {
    },

}
