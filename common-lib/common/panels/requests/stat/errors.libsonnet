local g = import '../../../g.libsonnet';
local tokens = import '../../../tokens/main.libsonnet';
local generic = import '../../generic/stat/main.libsonnet';
local base = import './base.libsonnet';
local stat = g.panel.stat;

base {
  new(title='Errors', targets, description='Rate of errors.'):
    super.new(title, targets, description)
    + self.stylize(),

  stylize(allLayers=true):
    (if allLayers then super.stylize() else {})
    + stat.standardOptions.color.withMode(tokens.base.colors.mode.monochrome)
    + stat.standardOptions.color.withFixedColor(tokens.base.colors.palette.errors)
    + stat.standardOptions.withNoValue('No errors')
    + stat.options.withGraphMode('none')
    // use default color if there are no errors
    + stat.standardOptions.withMappingsMixin([
      stat.standardOptions.mapping.SpecialValueMap.withType()
      + stat.standardOptions.mapping.SpecialValueMap.options.withMatch('null')
      + stat.standardOptions.mapping.SpecialValueMap.options.result.withIndex(0)
      + stat.standardOptions.mapping.SpecialValueMap.options.result.withColor(tokens.base.colors.palette.default),
      stat.standardOptions.mapping.ValueMap.withType()
      + stat.standardOptions.mapping.ValueMap.withOptions(
        {
          '0': {
            color: tokens.base.colors.palette.default,
            index: 1,
          },
        }
      ),
    ]),
}
