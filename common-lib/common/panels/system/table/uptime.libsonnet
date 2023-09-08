local g = import '../../../g.libsonnet';
local style = import '../stat/uptime.libsonnet';
local table = g.panel.table;
local fieldOverride = table.fieldOverride;

{
  local this = self,

  stylize(): style.stylize(), 

  // when attached to table, this function applies style to row named 'name="Uptime"'
  stylizeByName(name='Uptime'):
    table.standardOptions.withOverrides(
      fieldOverride.byName.new(name)
        + fieldOverride.byName.withProperty('custom.cellOptions',{type:'color-text'})
        + fieldOverride.byName.withPropertiesFromOptions(this.stylize())
  )
}
