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
    aggKeepLabels,
    vars,
    datasource,
    valueMappings,
    legendCustomTemplate,
    rangeFunction,
    sourceMaps,
  ):
    base.new(
      name,
      type,
      unit,
      description,
      aggLevel,
      aggFunction,
      aggKeepLabels,
      vars,
      datasource,
      valueMappings,
      legendCustomTemplate,
      rangeFunction,
      sourceMaps=sourceMaps,
    )

    {
    },

}
