local g = import '../../../g.libsonnet';
local duration = import '../stat/duration.libsonnet';
local base = import './base.libsonnet';
local table = g.panel.table;
local fieldOverride = table.fieldOverride;

base {
  local this = self,

  new(): error 'not supported',
  stylize(): error 'not supported',

  // when attached to table, this function applies style to row named 'name="Duration"'
  stylizeByName(name='Duration'):
    table.standardOptions.withOverridesMixin(
      fieldOverride.byName.new(name)
      + fieldOverride.byName.withProperty('custom.cellOptions', { type: 'color-text' })
      + fieldOverride.byName.withPropertiesFromOptions(duration.stylize(allLayers=false),)
    ),
}
