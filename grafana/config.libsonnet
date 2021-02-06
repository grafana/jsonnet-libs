local k = import 'k.libsonnet';
{
  _config+:: {
    grafana+: {
      rootUrl: error 'Root URL required',
      provisioningDir: '/etc/grafana/provisioning',
      dashboardConfigMapCount: 1,
      labels+: {
        dashboards: [],
        datasources: [],
        notificationChannels: [],
      },
      grafana_ini+: {
        sections+: {
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

  withGrafanaIniConfig(config):: {
    _config+:: {
      grafana+: {
        sections+: {
          config+: config,
        },
      },
    },
  },

  withTheme(theme):: self.withGrafanaIniConfig({
    users+: {
      default_theme: theme,
    },
  }),

  withAnonymous():: self.withGrafanaIniConfig({
    'auth.anonymous': {
      enabled: true,
      org_role: 'Admin',
    },
  }),
}
