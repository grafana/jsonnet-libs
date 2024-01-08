local kausal = import 'github.com/grafana/jsonnet-libs/ksonnet-util/kausal.libsonnet';

{
  new(
    namespace,
    name='kube-state-metrics',
    image='registry.k8s.io/kube-state-metrics/kube-state-metrics:v2.1.0',
    sharded=false,
    replicas=3,
  ):: {
    local k = kausal {
      _config+: {
        namespace: namespace,
      },
    },
    local shared_config = {
      image:: image,
    } + import './shared_config.libsonnet',
    local singleton_ksm = shared_config + import './singleton.libsonnet',
    local sharded_ksm = shared_config {
      replicas:: replicas,
      name:: name,
      namespace:: namespace,
    } + import './sharded.libsonnet',

    deployment: if sharded then {} else singleton_ksm.deployment,
    statefulset: if sharded then sharded_ksm.statefulset else {},
    configmaps: if sharded then sharded_ksm.configmaps else {},

    rbac: shared_config.rbac,
  },

  scrape_config: (import './scrape_config.libsonnet'),
}
