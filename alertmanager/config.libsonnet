{
  _config+:: {
    // Cluster and environment specific overrides.
    cluster_dns_tld: 'local',
    cluster_dns_suffix: 'cluster.' + self.cluster_dns_tld,
    cluster_name: error 'must specify cluster name',
    namespace: error 'must specify namespace',

    // Alertmanager config options.
    alertmanager_external_hostname: 'http://alertmanager.%(namespace)s.svc.%(cluster_dns_suffix)s' % self,
    alertmanager_path: '/alertmanager/',
    alertmanager_port: 9093,
    alertmanager_gossip_port: 9094,

    slack_url: 'http://slack',
    slack_channel: 'general',

    alertmanager_replicas: 1,
    alertmanager_peers: [],
  },
}
