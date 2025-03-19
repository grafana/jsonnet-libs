local g = import '../g.libsonnet';
local utils = import '../utils.libsonnet';
local base = import './base.libsonnet';
local signalUtils = import './utils.libsonnet';

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
      local this = self,
      withQuantile(quantile=0.95):
        self
        {
          sourceMaps:
            [
              source
              {
                quantile: quantile,
              }
              for source in super.sourceMaps
            ],
        },
    },
}
