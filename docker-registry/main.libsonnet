local k = import 'github.com/grafana/jsonnet-libs/ksonnet-util/kausal.libsonnet';
local k_util = import 'github.com/grafana/jsonnet-libs/ksonnet-util/util.libsonnet';

{
  new(
    name='registry',
    image='registry:2',
    disk_size='5Gi',
    port=5000,
  ): {
    local this = self,

    port:: port,

    local container = k.core.v1.container,
    container::
      container.new(
        'registry',
        image
      )
      + container.withPorts([
        k.core.v1.containerPort.new('http', port),
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
      k_util.serviceFor(this.statefulset)
      + k.core.v1.service.spec.withPorts([
        // Explicitly override ports to prevent exposing debug endpoint
        k.core.v1.servicePort.newNamed('http', port, port),
      ]),
  },

  withMetrics(port=5001): {
    local container = k.core.v1.container,
    container+:
      container.withPortsMixin([
        k.core.v1.containerPort.new('http-metrics', port),
      ])
      + container.withEnvMixin([
        k.core.v1.envVar.new('REGISTRY_HTTP_DEBUG_ADDR', 'localhost:%d' % port),
        k.core.v1.envVar.new('REGISTRY_HTTP_DEBUG_PROMETHEUS_ENABLED', 'true'),
        k.core.v1.envVar.new('REGISTRY_HTTP_DEBUG_PROMETHEUS_PATH', '/metrics'),
      ]),
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

  withIngress(host, tlsSecretName, allowlist=[]):: {
    local this = self,
    local ingress = k.networking.v1.ingress,
    local rule = k.networking.v1.ingressRule,
    local path = k.networking.v1beta1.httpIngressPath,
    ingress:
      ingress.new(self.service.metadata.name)
      + (
        if std.length(allowlist) != 0
        then ingress.metadata.withAnnotationsMixin({
          'nginx.ingress.kubernetes.io/whitelist-source-range': std.join(',', allowlist),
        })
        else {}
      )
      + ingress.spec.withTls({
        hosts: [host],
        secretName: tlsSecretName,
      })
      + ingress.spec.withRules(
        rule.withHost(host)
        + rule.http.withPaths([
          path.withPath('/')
          + path.backend.withServiceName(this.service.metadata.name)
          + path.backend.withServicePort(this.port),
        ])
      ),
  },
}
