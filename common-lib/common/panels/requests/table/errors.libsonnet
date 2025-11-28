local g = import '../../../g.libsonnet';
local errors = import '../stat/errors.libsonnet';
local base = import './base.libsonnet';
local table = g.panel.table;
local fieldOverride = table.fieldOverride;

base {
  local this = self,

  new(): error 'not supported',
  stylize(): error 'not supported',

  // when attached to table, this function applies style to row named 'name="Errors"'
  stylizeByName(name='Errors'):
    table.standardOptions.withOverridesMixin(
      fieldOverride.byName.new(name)
      + fieldOverride.byName.withProperty('custom.cellOptions', { type: 'color-text' })
      + fieldOverride.byName.withPropertiesFromOptions(errors.stylize(allLayers=false),)
    ),
}
