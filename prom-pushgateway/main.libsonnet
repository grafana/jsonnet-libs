local k = import 'ksonnet-util/kausal.libsonnet';

{
  new(
    namespace,
    cluster_name='cluster',
    cluster_dns_tld='local',
    port=9091,
    path='/pushgateway/',
    disk_size='1Gi',
    run_as_uid=65534,
    run_as_gid=65534,
    image='prom/pushgateway:v1.4.1',
  ):: {
    external_hostname::
      'http://'
      + std.join('.', [
        self.service.metadata.name,
        namespace,
        'svc',
        cluster_name,
        cluster_dns_tld,
      ]),

    path:: path,

    local pvc = k.core.v1.persistentVolumeClaim,
    pvc::
      pvc.new('prom-pushgateway')
      + pvc.spec.withAccessModes(['ReadWriteOnce'])
      + pvc.spec.resources.withRequests({ storage: disk_size }),

    local container = k.core.v1.container,
    local containerPort = k.core.v1.containerPort,
    local volumeMount = k.core.v1.volumeMount,
    container::
      container.new('prom-pushgateway', image)
      + container.withPorts(containerPort.new('http-metrics', port))
      + container.withArgsMixin([
        '--persistence.file=/pushgateway/persist.db',
        '--web.listen-address=:%s' % port,
        '--web.external-url=%s%s' % [self.external_hostname, self.path],
      ])
      + container.withVolumeMounts([
        volumeMount.new(self.pvc.metadata.name, '/pushgateway'),
      ]),

    local statefulSet = k.apps.v1.statefulSet,
    statefulset:
      statefulSet.new('prom-pushgateway', 1, [self.container], [self.pvc])
      + statefulSet.spec.withServiceName(self.service.metadata.name)
      + statefulSet.spec.template.spec.securityContext.withRunAsUser(run_as_uid)
      + statefulSet.spec.template.spec.securityContext.withRunAsGroup(run_as_gid)
      + statefulSet.spec.template.spec.securityContext.withFsGroup(run_as_uid)
      + statefulSet.spec.template.metadata.withAnnotationsMixin({
        'prometheus.io.path': '%smetrics' % self.path,
        'prometheus.io.scrape': 'false',
      }),

    service:
      k.util.serviceFor(self.statefulset),
  },
}
