local g = import '../../../g.libsonnet';
local rate = import '../stat/rate.libsonnet';
local base = import './base.libsonnet';
local table = g.panel.table;
local fieldOverride = table.fieldOverride;

base {
  local this = self,

  new(): error 'not supported',
  stylize(): error 'not supported',

  // when attached to table, this function applies style to row named 'name="Rate"'
  stylizeByName(name='Rate'):
    table.standardOptions.withOverridesMixin(
      fieldOverride.byName.new(name)
      + fieldOverride.byName.withProperty('custom.cellOptions', { type: 'color-text' })
      + fieldOverride.byName.withPropertiesFromOptions(rate.stylize(allLayers=false),)
    ),
}
