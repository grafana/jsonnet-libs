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
    local common_config = {
      image:: image,
    } + import './common_config.libsonnet',
    local singleton_ksm = common_config + import './singleton.libsonnet',
    local sharded_ksm = common_config {
      replicas:: replicas,
      name:: name,
      namespace:: namespace,
    } + import './sharded.libsonnet',

    deployment: if sharded then {} else singleton_ksm.deployment,
    [if sharded then 'statefulset']: sharded_ksm.statefulset,
    [if sharded then 'configmaps']: sharded_ksm.configmaps,

    rbac: common_config.rbac,
  },

  scrape_config: (import './scrape_config.libsonnet'),
}
