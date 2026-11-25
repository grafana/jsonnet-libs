local g = import '../../../g.libsonnet';
local table = g.panel.table;
local percentageUnit = import '../timeSeries/percentage_unit.libsonnet';
local fieldOverride = g.panel.timeSeries.fieldOverride;
local base = import './base.libsonnet';
// This panel can be used to display gauge table columns with ratio values from 0 to 1 (percentunit).
// Examples: error ratio, cache hit ratio etc.
base {
  new(): error 'not supported',
  stylize(): error 'not supported',

  // when attached to table, this function applies style to row named 'name'
  stylizeByName(name):
    table.standardOptions.withOverridesMixin(
      fieldOverride.byName.new(name)
      + fieldOverride.byName.withProperty('custom.cellOptions', { type: 'gauge', mode: 'basic' })
      + fieldOverride.byName.withPropertiesFromOptions(percentageUnit.stylize(allLayers=false)),
    ),
}
