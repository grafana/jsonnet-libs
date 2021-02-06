{
  _config+:: {
    grafana+: {
      // configure Grafana Lib based upon legacy configs below
      rootUrl: $._config.grafana_root_url,
      provisioningDir: $._config.grafana_provisioning_dir,
      dashboardConfigMapCount: $._config.dashboard_config_maps,

      grafana_ini+: {
        sections+: {
          'auth.anonymous': {
            enabled: true,
            org_role: 'Admin',
          },
          explore+: {
            enabled: true,
          },
        },

      } + $.grafana_config,
    },
    // LEGACY CONFIGS:
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

  // legacy grafana_ini extension point
  grafana_config+:: {},
}
