(import 'config.libsonnet')
+ (import 'mixins.libsonnet')
+ (import 'dashboards.libsonnet')
+ (import 'datasources.libsonnet')
+ (import 'plugins.libsonnet')
+ (import 'instance.libsonnet')
+ (import 'notifications.libsonnet')
+ {
  withTheme(theme):: {
    grafana_config+:: {
      users+: {
        default_theme: theme,
      },
    },
  },
  withAnonymous():: {
    grafana_config+:: {
      sections: {
        'auth.anonymous': {
          enabled: true,
          org_role: 'Admin',
        },
      },
    },
  },

  grafana_config+:: {
    server: {
      http_port: 3000,
      router_logging: true,
      root_url: $._config.grafana_root_url,
    },
    analytics: {
      reporting_enabled: false,
    },
    explore+: {
      enabled: true,
    },
  },
}
