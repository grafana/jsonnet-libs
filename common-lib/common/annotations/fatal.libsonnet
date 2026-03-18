local g = import '../g.libsonnet';
local annotation = g.dashboard.annotation;
local colors = import '../tokens/colors.libsonnet';
local base = import './base.libsonnet';

// Show fatal events as annotations
base {
  new(
    title,
    target,
  ):
    super.new(title, target)
    + annotation.withIconColor(colors.palette.critical)
    + annotation.withHide(true),
}
