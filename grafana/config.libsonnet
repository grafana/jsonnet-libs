local k = import 'k.libsonnet';
{
  _config+:: {
    grafana+: {
      rootUrl: error 'Root URL required',
      provisioningDir: '/etc/grafana/provisioning',
      dashboardConfigMapCount: $._config.dashboard_config_maps,
      labels+: {
        dashboards: $._config.grafana_dashboard_labels,
        datasources: $._config.grafana_datasource_labels,
        notificationChannels: $._config.grafana_notification_channel_labels,
      },
      config+: {
        sections: {
          server: {
            http_port: 3000,
            router_logging: true,
            root_url: $._config.grafana.rootUrl,
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
    },
  },

  withConfig(config):: {
    _config+:: {
      grafana+: {
        config+: config,
      },
    },
  },

  local configMap = k.core.v1.configMap,

  grafana_config_map:
    configMap.new('grafana-config') +
    configMap.withData({ 'grafana.ini': std.manifestIni($.grafana_config) }),
}
