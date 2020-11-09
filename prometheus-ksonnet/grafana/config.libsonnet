{
  _config+:: {
    admin_services+:: [
      {
        key: 'grafana_light',
        title: 'Grafana (Light)',
        path: 'grafana',
        params: '/?search=open&theme=light',
        url: 'http://grafana.%(namespace)s.svc.%(cluster_dns_suffix)s/' % $._config,
        allowWebsockets: true,
      },
      {
        key: 'grafana_dark',
        title: 'Grafana (Dark)',
        path: 'grafana',
        params: '/?search=open&theme=dark',
        url: 'http://grafana.%(namespace)s.svc.%(cluster_dns_suffix)s/' % $._config,
        allowWebsockets: true,
      },
    ],
  },

  grafana_config:: {
    sections: {
      'auth.anonymous': {
        enabled: true,
        org_role: 'Admin',
      },
      server: {
        http_port: 3000,
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
}
