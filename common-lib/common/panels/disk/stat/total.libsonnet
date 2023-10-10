local g = import '../../../g.libsonnet';
local generic = import '../../generic/stat/main.libsonnet';
local base = import './base.libsonnet';
local stat = g.panel.stat;

base {
  new(
    title,
    targets,
    description=''
  ):
    super.new(title=title, targets=targets, description=description)
    + generic.info.stylize()
    + stat.standardOptions.withUnit('bytes'),
}
