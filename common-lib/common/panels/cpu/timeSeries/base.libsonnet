local g = import '../../../g.libsonnet';
local base = import '../../generic/timeSeries/base.libsonnet';

base {
  new(
    title,
    targets,
    description=''
  ):
    super.new(title, targets, description),
}
