{
  _config+:: {
    admin_services+:: [
      {
        title: 'Grafana (Light)',
        path: 'grafana',
        params: '/?search=open&theme=light',
        url: 'http://grafana.%(namespace)s.svc.%(cluster_dns_suffix)s/' % $._config,
        allowWebsockets: true,
      },
      {
        title: 'Grafana (Dark)',
        path: 'grafana',
        params: '/?search=open&theme=dark',
        url: 'http://grafana.%(namespace)s.svc.%(cluster_dns_suffix)s/' % $._config,
        allowWebsockets: true,
      },
    ],
  },
}
