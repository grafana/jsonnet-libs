local g = import '../g.libsonnet';
local annotation = g.dashboard.annotation;
local colors = import '../tokens/colors.libsonnet';
local base = import './base.libsonnet';

base {
  new(
    title,
    target,
  ):
    super.new(title, target)
    + annotation.withIconColor(colors.palette.info),
}
