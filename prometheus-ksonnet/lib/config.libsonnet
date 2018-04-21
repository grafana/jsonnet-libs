{
  _config+:: {
    // Cluster specific overrides.
    cluster_dns_suffix: 'cluster.local',

    // Overrides for the nginx frontend for all these services.
    admin_services: [
      { title: 'Grafana', path: 'grafana', url: 'http://grafana.%(namespace)s.svc.%(cluster_dns_suffix)s/' % $._config },
      { title: 'Prometheus', path: 'prometheus', url: 'http://prometheus.%(namespace)s.svc.%(cluster_dns_suffix)s/prometheus/' % $._config },
      { title: 'Alertmanager', path: 'alertmanager', url: 'http://alertmanager.%(namespace)s.svc.%(cluster_dns_suffix)s/alertmanager/' % $._config },
    ],

    // Prometheus config options - DEPRECATED, for backwards compatibility.
    apiServerAddress: 'kubernetes.default.svc.%(cluster_dns_suffix)s:443' % self,
    insecureSkipVerify: false,

    // Prometheus config options.
    prometheus_api_server_address: self.apiServerAddress,
    prometheus_insecure_skip_verify: self.insecureSkipVerify,
    prometheus_external_hostname: 'http://prometheus.%(namespace)s.svc.%(cluster_dns_suffix)s' % self,
    prometheus_path: '/prometheus/',
    prometheus_port: 80,
    prometheus_web_route_prefix: $._config.prometheus_path,

    // Alertmanager config options.
    alertmanager_external_hostname: 'http://alertmanager.%(namespace)s.svc.%(cluster_dns_suffix)s' % self,
    alertmanager_path: '/alertmanager/',
    alertmanager_port: 80,

    slack_url: 'http://slack',
    slack_channel: 'general',

    // Grafana config options.
    grafana_root_url: 'http://nginx.%(namespace)s.svc.%(cluster_dns_suffix)s/grafana' % self,

    // Node exporter options.
    node_exporter_mount_root: true,
  },
}
