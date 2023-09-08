local g = import '../../../g.libsonnet';
local base = import '../../all/stat/info.libsonnet';
local stat = g.panel.stat;
local fieldOverride = g.panel.stat.fieldOverride;
local custom = stat.fieldConfig.defaults.custom;
local defaults = stat.fieldConfig.defaults;
local options = stat.options;
base + {
  new(
    title='Memory total',
    targets,
    description=''
  ):
    super.new(title=title, targets=targets, description=description)
     + stat.standardOptions.withUnit("bytes")
}
