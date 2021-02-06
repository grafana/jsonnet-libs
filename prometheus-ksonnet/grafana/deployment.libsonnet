local grafana = import 'grafana/grafana.libsonnet';

{
  grafana_deployment+: grafana.withStatelessness(),
  _config+:: {
    // Grafana config options.
    grafana_root_url: '',
    grafana_provisioning_dir: '/etc/grafana/provisioning',

    // Optionally shard dashboards into multiple config maps.
    // Set to the number of desired config maps.  0 to disable.
    dashboard_config_maps: 0,

    // Optionally add labels to grafana config maps.
    grafana_dashboard_labels: {},
    grafana_datasource_labels: {},
    grafana_notification_channel_labels: {},
  },

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
