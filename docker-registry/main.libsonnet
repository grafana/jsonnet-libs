local k = import 'github.com/grafana/jsonnet-libs/ksonnet-util/kausal.libsonnet';
local k_util = import 'github.com/grafana/jsonnet-libs/ksonnet-util/util.libsonnet';

{
  new(
    name='registry',
    image='registry:2',
    disk_size='5Gi'
  ): {
    local this = self,

    local container = k.core.v1.container,
    container::
      container.new(
        'registry',
        image
      )
      + container.withPorts([
        k.core.v1.containerPort.new('http-metrics', 5000),
      ])
    ,

    local pvc = k.core.v1.persistentVolumeClaim,
    pvc::
      pvc.new('data')
      + pvc.spec.withAccessModes(['ReadWriteOnce'])
      + pvc.spec.resources.withRequests({ storage: disk_size }),


    local statefulset = k.apps.v1.statefulSet,
    statefulset:
      statefulset.new(
        name,
        replicas=1,
        containers=[this.container],
        volumeClaims=[this.pvc]
      )
      + statefulset.spec.withServiceName(name)
      + k_util.pvcVolumeMount(this.pvc.metadata.name, '/var/lib/registry')
    ,

    service:
      k_util.serviceFor(this.statefulset),
  },

  withProxy(secretRef, url='https://registry-1.docker.io'): {
    //proxy:
    //  remoteurl: https://registry-1.docker.io
    //  username: [username]
    //  password: [password]
    local container = k.core.v1.container,
    container+:
      container.withEnvMixin([
        k.core.v1.envVar.new('REGISTRY_PROXY_REMOTEURL', url),
        k.core.v1.envVar.fromSecretRef('REGISTRY_PROXY_USERNAME', secretRef, 'username'),
        k.core.v1.envVar.fromSecretRef('REGISTRY_PROXY_PASSWORD', secretRef, 'password'),
      ]),
  },
}
