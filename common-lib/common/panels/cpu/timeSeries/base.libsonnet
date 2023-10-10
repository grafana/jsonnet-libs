local g = import '../../../g.libsonnet';
local base = import '../../all/timeSeries/base.libsonnet';

base {
  new(
    title,
    targets,
    description=''
  ):
    super.new(title, targets, description),
}
