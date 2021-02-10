local k = import 'k.libsonnet';
{
  _config+:: {
    rootUrl: error 'Root URL required',
    provisioningDir: '/etc/grafana/provisioning',
    labels+: {
      dashboards: {},
      datasources: {},
      notificationChannels: {},
    },
    grafana_ini+: {
      sections+: {
        server: {
          http_port: 3000,
          router_logging: true,
          root_url: $._config.rootUrl,
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

  withGrafanaIniConfig(config):: {
    _config+:: {
      grafana_ini+: {
        config+: config,
      },
    },
  },

  withTheme(theme):: self.withGrafanaIniConfig({
    sections+: {
      users+: {
        default_theme: theme,
      },
    },
  }),

  withAnonymous():: self.withGrafanaIniConfig({
    sections+: {
      'auth.anonymous': {
        enabled: true,
        org_role: 'Admin',
      },
    },
  }),
}
