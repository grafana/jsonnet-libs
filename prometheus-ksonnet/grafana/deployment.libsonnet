{
  grafanaDatasources+:: {
    'prometheus.yml': $.grafana_datasource('prometheus',
                                           'http://prometheus.%(namespace)s.svc.%(cluster_dns_suffix)s%(prometheus_web_route_prefix)s' % $._config,
                                           default=true),
  },

  _config+:: {
    // Grafana config options.
    grafana_root_url: 'http://nginx.%(namespace)s.svc.%(cluster_dns_suffix)s/grafana' % self,
    grafana_provisioning_dir: '/etc/grafana/provisioning',

    // Optionally shard dashboards into multiple config maps.
    // Set to the number of desired config maps.  0 to disable.
    dashboard_config_maps: 0,

    // Optionally add labels to grafana config maps.
    grafana_dashboard_labels: {},
    grafana_datasource_labels: {},
    grafana_notification_channel_labels: {},
  },

  grafana_plugins+:: [],

  local container = $.core.v1.container,

  grafana_container::
    container.new('grafana', $._images.grafana) +
    container.withPorts($.core.v1.containerPort.new('grafana', 80)) +
    container.withEnvMap({
      GF_PATHS_CONFIG: '/etc/grafana-config/grafana.ini',
      GF_INSTALL_PLUGINS: std.join(',', $.grafana_plugins),
    }) +
    $.util.resourcesRequests('10m', '40Mi'),

  local deployment = $.apps.v1.deployment,

  grafana_deployment:
    deployment.new('grafana', 1, [$.grafana_container]) +
    deployment.mixin.spec.template.spec.securityContext.withRunAsUser(0) +
    $.util.configVolumeMount('grafana-config', '/etc/grafana-config') +
    $.util.configVolumeMount('grafana-dashboard-provisioning', '%(grafana_provisioning_dir)s/dashboards' % $._config) +
    $.util.configVolumeMount('grafana-datasources', '%(grafana_provisioning_dir)s/datasources' % $._config) +
    $.util.configVolumeMount('grafana-notification-channels', '%(grafana_provisioning_dir)s/notifiers' % $._config) +
    (
      // If we're not doing dashboard config map sharding, mount the dashboard
      // config map.
      if $._config.dashboard_config_maps == 0
      then $.util.configVolumeMount('dashboards', '/grafana/dashboards')
      else {}
    ) + (
      // If we are doing dashboard config map sharding here, mount _all_
      // the shards.
      if $._config.dashboard_config_maps > 0
      then
        std.foldr(
          function(m, acc) m + acc,
          [
            $.util.configVolumeMount('dashboards-%d' % shard, '/grafana/dashboards/%d' % shard)
            for shard in std.range(0, $._config.dashboard_config_maps - 1)
          ],
          {}
        )
      else {}
    ) + (
      // Add config map mounts for each folder for dashboards.
      std.foldr(
        function(m, acc) m + acc,
        [
          $.util.configVolumeMount('dashboards-%s' % std.asciiLower(folder), '/grafana/dashboard-folders/%s' % std.asciiLower(folder))
          for folder in std.objectFields($.dashboardsByFolder)
        ],
        {}
      )
    ) +
    $.util.podPriority('critical'),

  grafana_service:
    $.util.serviceFor($.grafana_deployment),
}
