local k = import 'ksonnet-util/kausal.libsonnet';
local deployment = k.apps.v1.deployment;
local statefulset = k.apps.v1.statefulSet;
local service = k.core.v1.service;
local servicePort = service.mixin.spec.portsType;
local container = k.core.v1.container;
{
  grafana_container::
    container.new('grafana', $._images.grafana) +
    container.withPorts($.core.v1.containerPort.new('grafana-metrics', 3000)) +
    container.withEnvMap({
      GF_PATHS_CONFIG: '/etc/grafana-config/grafana.ini',
      GF_INSTALL_PLUGINS: std.join(',', $.grafana_plugins),
    }) +
    k.util.resourcesRequests('10m', '40Mi'),

  // this object may be either a k8s deployment resource or a statefulset depending on user selection
  grafana_deployment:
    deployment.new('grafana', 1, [$.grafana_container])
    + $.configmap_mounts
    + k.util.podPriority('critical'),

  grafana_service:
    k.util.serviceFor($.grafana_deployment) +
    service.mixin.spec.withPortsMixin([
      servicePort.newNamed(
        name='http',
        port=80,
        targetPort=3000,
      ),
    ]),

  withStatelessness():: {
    kind: 'Deployment',
    spec+: {
      minReadySeconds: 10,
      revisionHistoryLimit: 10,
    },
    updateStrategy:: {},
  },
}
