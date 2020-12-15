local alertmanager = import 'alertmanager/alertmanager.libsonnet';

alertmanager {
  local replicas = self._config.alertmanager_cluster_self.replicas,
  local isGlobal = self._config.alertmanager_cluster_self.global,
  local isGossiping = replicas > 1 || isGlobal,
  local peers = if isGlobal
  then
    [
      'alertmanager-%d.alertmanager.%s.svc.%s.%s:%s' % [i, $._config.namespace, cluster, $._config.cluster_dns_tld, $._config.alertmanager_gossip_port]
      for cluster in std.objectFields($._config.alertmanager_clusters)
      if $._config.alertmanager_clusters[cluster].global
      for i in std.range(0, $._config.alertmanager_clusters[cluster].replicas - 1)
    ]
  else if isGossiping then
    [
      'alertmanager-%d.alertmanager.%s.svc.%s.%s:%s' % [i, $._config.namespace, $._config.cluster_name, $._config.cluster_dns_tld, $._config.alertmanager_gossip_port]
      for i in std.range(0, replicas - 1)
    ]
  else [],

  _config+:: {
    alertmanager_peers: peers,
    alertmanager_replicas: replicas,
  },

  alertmanager_container+:: (
    if isGossiping
    then self.isGossiping().alertmanager_container
    else {}
  ),
}
