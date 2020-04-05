{
  _config+:: {
    // Cluster and environment specific overrides.
    cluster_dns_tld: 'local',
    cluster_dns_suffix: 'cluster.' + self.cluster_dns_tld,
    cluster_name: error 'must specify cluster name',
    namespace: error 'must specify namespace',

    // Overrides for the nginx frontend for all these services.
    admin_services: std.prune([
      {
        title: 'Grafana',
        path: 'grafana',
        url: 'http://grafana.%(namespace)s.svc.%(cluster_dns_suffix)s/' % $._config,
        allowWebsockets: true,
      },
      {
        title: 'Prometheus',
        path: 'prometheus',
        url: 'http://prometheus.%(namespace)s.svc.%(cluster_dns_suffix)s/prometheus/' % $._config,
      },
      if $._config.alertmanager_cluster_self.replicas > 0 then {
        title: 'Alertmanager' + if $._config.alertmanager_cluster_self.global then ' (global)' else ' (local)',
        path: 'alertmanager',
        url: 'http://alertmanager.%(namespace)s.svc.%(cluster_dns_suffix)s/alertmanager/' % $._config,
      },
    ]),

    // Prometheus config options - DEPRECATED, for backwards compatibility.
    apiServerAddress: 'kubernetes.default.svc.%(cluster_dns_suffix)s:443' % self,
    insecureSkipVerify: false,

    // Prometheus config options.
    prometheus_api_server_address: self.apiServerAddress,
    scrape_api_server_endpoints: true,
    prometheus_insecure_skip_verify: self.insecureSkipVerify,
    prometheus_external_hostname: 'http://prometheus.%(namespace)s.svc.%(cluster_dns_suffix)s' % self,
    prometheus_path: '/prometheus/',
    prometheus_port: 80,
    prometheus_web_route_prefix: $._config.prometheus_path,

    // Alertmanager config options.
    alertmanager_external_hostname: 'http://alertmanager.%(namespace)s.svc.%(cluster_dns_suffix)s' % self,
    alertmanager_path: '/alertmanager/',
    alertmanager_port: 80,
    alertmanager_gossip_port: 9094,
    // Description of how many alertmanager replicas to run where. All
    // clusters with `'global': true` are participating in one global
    // alertmanager über-cluster, which requires all those clusters to
    // have inter-cluster network connectivity. Configure 2–3 clusters
    // with 2–3 replicas each to limit global gossiping. Clusters that
    // should not or cannot participate in the alertmanager
    // über-cluster must be set to `'global': false`. That's usually
    // the case for clusters without inter-cluster network
    // connectivity. The alertmanager instances in those clusters only
    // gossip with others in the same clusters (or not at all if
    // `'replicas': 0`). Prometheus servers in those cluster only talk
    // to the local alertmanager instances. In all other clusters, the
    // Prometheus servers talk to all clustered alertmanager replicas
    // globally.
    alertmanager_clusters: {
      // Example for a cluster with global alertmanager instances:
      //   'us-east5': { global: true, replicas: 2 },
      // Example for cluster with isolated local alertmanager instance:
      //   'eu-west7': { global: false, replicas: 1 },
      // This is the default for all clusters not mentioned, i.e. let
      // Prometheus servers talk to global alertmanagers, don't have
      // own alertmanagers in this cluster:
      //   'us-west3': { global: true, replicas: 0 },
    },
    // Shortcut to alertmanager_clusters entry for this cluster.
    alertmanager_cluster_self:
      if self.cluster_name in self.alertmanager_clusters then
        self.alertmanager_clusters[self.cluster_name]
      else
        { global: true, replicas: 0 },

    slack_url: 'http://slack',
    slack_channel: 'general',

    // Node exporter options.
    node_exporter_mount_root: true,

    // Kubernetes mixin overrides.
    cadvisorSelector: 'job="kube-system/cadvisor"',
    kubeletSelector: 'job="kube-system/kubelet"',
    kubeStateMetricsSelector: 'job="%s/kube-state-metrics"' % $._config.namespace,
    nodeExporterSelector: 'job="%s/node-exporter"' % $._config.namespace,  // Also used by node-mixin.
    notKubeDnsSelector: 'job!="kube-system/kube-dns"',
    kubeSchedulerSelector: 'job="kube-system/kube-scheduler"',
    kubeControllerManagerSelector: 'job="kube-system/kube-controller-manager"',
    kubeApiserverSelector: 'job="kube-system/kube-apiserver"',
    podLabel: 'instance',
    grafanaPrefix: '/grafana',  // Also used by node-mixin.

    // Prometheus mixin overrides.
    prometheusSelector: 'job="default/prometheus"',
    alertmanagerSelector: 'job="default/alertmanager"',

    // Node mixin overrides.
    nodeCriticalSeverity: 'warning',  // Do not page if nodes run out of disk space.

    // oauth2-proxy
    oauth_enabled: false,
  },
}
