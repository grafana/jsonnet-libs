{
  local replicas = self._config.alertmanager_cluster_self.replicas,
  local isGlobal = self._config.alertmanager_cluster_self.global,
  local isGossiping = replicas > 1 || isGlobal,
  local peers = if isGossiping then
    [
      'alertmanager-%d.alertmanager-gossip.%s.svc.%s:%s' % [i, $._config.namespace, $._config.cluster_dns_suffix, $._config.alertmanager_gossip_port]
      for i in std.range(0, replicas - 1)
    ]
  else [],

  build_slack_receiver(name, slack_channel)::
    {
      name: name,
      slack_configs: [{
        api_url: $._config.slack_url,
        channel: slack_channel,
        send_resolved: true,
        title: '{{ template "__alert_title" . }}',
        text: '{{ template "__alert_text" . }}',
        actions: [
          {
            type: 'button',
            text: 'Runbook :green_book:',
            url: '{{ (index .Alerts 0).Annotations.runbook_url }}',
          },
          {
            type: 'button',
            text: 'Source :information_source:',
            url: '{{ (index .Alerts 0).GeneratorURL }}',
          },
          {
            type: 'button',
            text: 'Silence :no_bell:',
            url: '{{ template "__alert_silence_link" . }}',
          },
        ],
      }],
    },

  alertmanager_config:: {
    templates: [
      '/etc/alertmanager/*.tmpl',
      '/etc/alertmanager/config/templates.tmpl',
    ],
    route: {
      group_by: ['alertname'],
      receiver: 'slack',
    },

    receivers: [
      $.build_slack_receiver('slack', $._config.slack_channel),
    ],
  },

  local configMap = $.core.v1.configMap,

  // Do not create configmap in clusters without any alertmanagers.
  alertmanager_config_map: if replicas > 0 then
    configMap.new('alertmanager-config') +
    configMap.withData({
      'alertmanager.yml': $.util.manifestYaml($.alertmanager_config),
      'templates.tmpl': (importstr 'files/alertmanager_config.tmpl'),
    })
  else {},

  local container = $.core.v1.container,
  local volumeMount = $.core.v1.volumeMount,

  alertmanager_container::
    container.new('alertmanager', $._images.alertmanager) +
    container.withPorts(
      [$.core.v1.containerPort.new('http-metrics', $._config.alertmanager_port)] +
      if isGossiping then
        [
          $.core.v1.containerPort.newUDP('gossip-udp', $._config.alertmanager_gossip_port),
          $.core.v1.containerPort.new('gossip-tcp', $._config.alertmanager_gossip_port),
        ]
      else
        []
    ) +
    container.withArgs(
      [
        '--log.level=info',
        '--config.file=/etc/alertmanager/config/alertmanager.yml',
        '--web.listen-address=:%s' % $._config.alertmanager_port,
        '--web.external-url=%s%s' % [$._config.alertmanager_external_hostname, $._config.alertmanager_path],
        '--storage.path=/alertmanager',
      ] +
      if isGossiping then
        ['--cluster.listen-address=[$(POD_IP)]:%s' % $._config.alertmanager_gossip_port] +
        ['--cluster.peer=%s' % peer for peer in peers]
      else
        []
    ) +
    container.withEnvMixin([
      container.envType.fromFieldPath('POD_IP', 'status.podIP'),
    ]) +
    container.withVolumeMountsMixin(
      volumeMount.new('alertmanager-data', '/alertmanager')
    ) +
    container.mixin.resources.withRequests({
      cpu: '10m',
      memory: '40Mi',
    }),

  alertmanager_watch_container::
    container.new('watch', $._images.watch) +
    container.withArgs([
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
      'http://localhost:%s%s-/reload' % [$._config.alertmanager_port, $._config.alertmanager_path],
    ]) +
    container.mixin.resources.withRequests({
      cpu: '10m',
      memory: '20Mi',
    }),

  local pvc = $.core.v1.persistentVolumeClaim,

  alertmanager_pvc::
    pvc.new() +
    pvc.mixin.metadata.withName('alertmanager-data') +
    pvc.mixin.spec.withAccessModes('ReadWriteOnce') +
    pvc.mixin.spec.resources.withRequests({ storage: '5Gi' }),

  local statefulset = $.apps.v1.statefulSet,

  // Do not create statefulset in clusters without any alertmanagers.
  alertmanager_statefulset: if replicas > 0 then
    statefulset.new('alertmanager', replicas, [
      $.alertmanager_container,
      $.alertmanager_watch_container,
    ], self.alertmanager_pvc) +
    statefulset.mixin.spec.withServiceName('alertmanager-gossip') +
    statefulset.mixin.spec.template.metadata.withAnnotations({ 'prometheus.io.path': '%smetrics' % $._config.alertmanager_path }) +
    $.util.configVolumeMount('alertmanager-config', '/etc/alertmanager/config') +
    $.util.podPriority('critical')
  else {},

  local service = $.core.v1.service,
  local servicePort = service.mixin.spec.portsType,

  // Do not create service in clusters without any alertmanagers.
  alertmanager_service:
    if replicas == 1 then
      {
        web:
          $.util.serviceFor($.alertmanager_statefulset) +
          service.mixin.spec.withPortsMixin([
            servicePort.newNamed(
              name='http',
              port=80,
              targetPort=$._config.alertmanager_port,
            ),
          ]) +
          service.spec.withSessionAffinity('ClientIP'),
      }
    else if replicas > 0 then
      {
        web:
          $.util.serviceFor($.alertmanager_statefulset) +
          service.mixin.spec.withPorts([
            servicePort.newNamed(
              name='http',
              port=80,
              targetPort=$._config.alertmanager_port,
            ),
          ]) +
          service.spec.withSessionAffinity('ClientIP'),
        gossip:
          $.util.serviceFor($.alertmanager_statefulset) +
          service.metadata.withName('alertmanager-gossip') +
          service.spec.withClusterIp('None'),
      }
    else {},
}
