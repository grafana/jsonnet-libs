local kausal = import 'ksonnet-util/kausal.libsonnet';

(import 'config.libsonnet')
+ (import 'images.libsonnet')
+ {
  local this = self,
  local _config = self._config,
  local k = kausal { _config+:: _config },

  alertmanager_config:: {
    templates: [
      '/etc/alertmanager/*.tmpl',
      '/etc/alertmanager/config/templates.tmpl',
    ],
  },

  local configMap = k.core.v1.configMap,

  alertmanager_config_map:
    configMap.new('alertmanager-config') +
    configMap.withData({
      'alertmanager.yml': k.util.manifestYaml(this.alertmanager_config),
      'templates.tmpl': (importstr 'files/alertmanager_config.tmpl'),
    }),

  local container = k.core.v1.container,
  local volumeMount = k.core.v1.volumeMount,

  alertmanager_container::
    container.new('alertmanager', self._images.alertmanager)
    + container.withPorts([
      k.core.v1.containerPort.new('http-metrics', _config.alertmanager_port),
    ])
    + container.withArgs([
      '--log.level=info',
      '--config.file=/etc/alertmanager/config/alertmanager.yml',
      '--web.listen-address=:%s' % _config.alertmanager_port,
      '--web.external-url=%s%s' % [_config.alertmanager_external_hostname, _config.alertmanager_path],
      '--storage.path=/alertmanager',
    ])
    + container.withEnvMixin([
      container.envType.fromFieldPath('POD_IP', 'status.podIP'),
    ])
    + container.withVolumeMountsMixin(
      volumeMount.new('alertmanager-data', '/alertmanager')
    )
    + container.mixin.resources.withRequests({
      cpu: '10m',
      memory: '40Mi',
    }),

  isGossiping():: {
    alertmanager_container+:
      container.withPortsMixin(
        [
          k.core.v1.containerPort.newUDP('gossip-udp', _config.alertmanager_gossip_port),
          k.core.v1.containerPort.new('gossip-tcp', _config.alertmanager_gossip_port),
        ]
      )
      + container.withArgsMixin(
        ['--cluster.listen-address=[$(POD_IP)]:%s' % _config.alertmanager_gossip_port]
        + ['--cluster.peer=%s' % peer for peer in _config.alertmanager_peers]
      ),
  },

  alertmanager_watch_container::
    container.new('watch', self._images.watch)
    + container.withArgs([
      '-v',
      '-t',
      '-p=/etc/alertmanager/config',
      'curl',
      '-X',
      'POST',
      '--fail',
      '-o',
      '-',
      '-sS',
      'http://localhost:%s%s-/reload' % [
        _config.alertmanager_port,
        _config.alertmanager_path,
      ],
    ]) +
    container.mixin.resources.withRequests({
      cpu: '10m',
      memory: '20Mi',
    }),

  local pvc = k.core.v1.persistentVolumeClaim,

  alertmanager_pvc::
    pvc.new('alertmanager-data')
    + pvc.mixin.spec.withAccessModes('ReadWriteOnce')
    + pvc.mixin.spec.resources.withRequests({ storage: '5Gi' }),

  local statefulset = k.apps.v1.statefulSet,

  alertmanager_statefulset:
    statefulset.new(
      'alertmanager',
      _config.alertmanager_replicas,
      [
        self.alertmanager_container,
        self.alertmanager_watch_container,
      ],
      self.alertmanager_pvc
    )
    + statefulset.mixin.spec.withServiceName('alertmanager')
    + statefulset.mixin.spec.template.metadata.withAnnotations({
      'prometheus.io.path': '%smetrics' % _config.alertmanager_path,
    })
    + statefulset.mixin.spec.template.spec.securityContext.withFsGroup(2000)
    + statefulset.mixin.spec.template.spec.securityContext.withRunAsUser(1000)
    + statefulset.mixin.spec.template.spec.securityContext.withRunAsNonRoot(true)
    + k.util.configVolumeMount('alertmanager-config', '/etc/alertmanager/config')
    + k.util.podPriority('critical')
  ,

  local service = k.core.v1.service,
  local servicePort = service.mixin.spec.portsType,

  alertmanager_service:
    k.util.serviceFor(self.alertmanager_statefulset)
    + service.mixin.spec.withPortsMixin([
      servicePort.newNamed(
        name='http',
        port=80,
        targetPort=_config.alertmanager_port,
      ),
    ]) +
    service.mixin.spec.withSessionAffinity('ClientIP'),
}
