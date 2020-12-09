{
  _config+:: {
    name:: 'prometheus',

    // Cluster and environment specific overrides.
    cluster_dns_tld: 'local',
    cluster_dns_suffix: 'cluster.' + self.cluster_dns_tld,
    namespace: error 'must specify namespace',

    // Prometheus config basics
    prometheus_requests_cpu: '250m',
    prometheus_requests_memory: '1536Mi',
    prometheus_limits_cpu: '500m',
    prometheus_limits_memory: '2Gi',

    // Prometheus config options.
    prometheus_external_hostname: 'http://prometheus.%(namespace)s.svc.%(cluster_dns_suffix)s' % self,
    prometheus_path: '/prometheus/',
    prometheus_port: 9090,
    prometheus_web_route_prefix: self.prometheus_path,
    prometheus_config_dir: '/etc/prometheus',
    prometheus_config_file: self.prometheus_config_dir + '/prometheus.yml',

    alertmanagers: [],
    scrape_configs: [],
  },

  prometheus_config:: {
    global: {
      scrape_interval: '15s',
    },

    rule_files: [
      'alerts/alerts.rules',
      'recording/recording.rules',
    ],

    alerting: {
      alertmanagers: $._config.alertmanagers,
    },

    scrape_configs: $._config.scrape_configs,
  },
}
