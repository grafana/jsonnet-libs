{
  local podAntiAffinity = $.apps.v1beta1.deployment.mixin.spec.template.spec.affinity.podAntiAffinity,

  etcd_cluster(name, size=3, version='3.3.13', env=[]):: {
    apiVersion: 'etcd.database.coreos.com/v1beta2',
    kind: 'EtcdCluster',
    metadata: {
      name: name,
      annotations: {
        'etcd.database.coreos.com/scope': 'clusterwide',
      },
    },
    spec: {
      size: size,
      version: version,
      pod:
        podAntiAffinity.withRequiredDuringSchedulingIgnoredDuringExecution([
          podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecutionType.new() +
          podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecutionType.mixin.labelSelector.withMatchLabels({ etcd_cluster: name }) +
          podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecutionType.withTopologyKey('kubernetes.io/hostname'),
        ]).spec.template.spec
        {
          labels: { name: name },
          annotations: {
            'prometheus.io/scrape': 'true',
            'prometheus.io/port': '2379',
          },
          etcdEnv: env,
        },
    },
  },
}
