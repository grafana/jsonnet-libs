local g = import '../../../g.libsonnet';
local styleBase = import '../stat/uptime.libsonnet';
local base = import './base.libsonnet';
local table = g.panel.table;
local fieldOverride = table.fieldOverride;

base {
  local this = self,

  stylize(): styleBase.stylize(),

  // when attached to table, this function applies style to row named 'name="Uptime"'
  stylizeByName(name='Uptime'):
    table.standardOptions.withOverrides(
      fieldOverride.byName.new(name)
      + fieldOverride.byName.withProperty('custom.cellOptions', { type: 'color-text' })
      + fieldOverride.byName.withPropertiesFromOptions(this.stylize())
    ),
}
