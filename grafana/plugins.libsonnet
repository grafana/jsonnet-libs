{
  // Mixins can now specify extra plugins..
  grafana_plugins+:: std.foldr(
    function(mixinName, acc)
      local mixin = $.mixins[mixinName];
      if std.objectHas(mixin, 'grafanaPlugins')
      then mixin.grafanaPlugins + acc
      else acc,
    std.objectFields($.mixins),
    [],
  ),
}
