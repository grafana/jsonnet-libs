local g = import '../../../g.libsonnet';
local timeSeries = import '../../all/timeSeries/main.libsonnet';

timeSeries {
  new(
    title,
    targets,
    description=''
  ):
    super.base.new(title, targets, description)
}
