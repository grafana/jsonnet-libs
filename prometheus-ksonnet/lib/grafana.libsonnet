{
  grafana_config:: {
    sections: {
      'auth.anonymous': {
        enabled: true,
        org_role: 'Admin',
      },
      server: {
        http_port: 80,
        root_url: $._config.grafana_root_url,
      },
      analytics: {
        reporting_enabled: false,
      },
      users: {
        default_theme: 'light',
      },
      explore+: {
        enabled: true,
      },
    },
  },

  local configMap = $.core.v1.configMap,

  grafana_config_map:
    configMap.new('grafana-config') +
    configMap.withData({ 'grafana.ini': std.manifestIni($.grafana_config) }),

  grafana_dashboard_provisioning_config_map:
    configMap.new('grafana-dashboard-provisioning') +
    configMap.withData({
      'dashboards.yml': $.util.manifestYaml({
        apiVersion: 1,
        providers: [{
          name: 'dashboards',
          orgId: 1,
          folder: '',
          type: 'file',
          disableDeletion: true,
          editable: false,
          options: {
            path: '/grafana/dashboards',
          },
        }],
      }),
    }),

  grafanaDatasources+:: {
    prometheus: $.grafana_datasource('prometheus',
                                     'http://prometheus.%(namespace)s.svc.%(cluster_dns_suffix)s%(prometheus_web_route_prefix)s' % $._config,
                                     default=true),
  },

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
      if $._config.dashboard_config_maps == 0
      then $.util.configVolumeMount('dashboards', '/grafana/dashboards')
      else
        std.foldr(
          function(m, acc) m + acc,
          [
            $.util.configVolumeMount('dashboards-%d' % shard, '/grafana/dashboards/%d' % shard)
            for shard in std.range(0, $._config.dashboard_config_maps - 1)
          ],
          {}
        )
    ) +
    $.util.podPriority('critical'),

  grafana_service:
    $.util.serviceFor($.grafana_deployment),
}
