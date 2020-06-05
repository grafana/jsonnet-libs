local k = import 'ksonnet-util/kausal.libsonnet';

{
  _config:: {
    etherpad: {
      name: error 'must provide name for etherpad',
      plugins: [
        'ep_headings2',
        'ep_markdown',
      ],
      replicas: 1,
    },
  },

  _images+:: {
    etherpad: 'etherpad/etherpad:1.8.4',
  },

  local plugins = [
    'npm install %s' % plugin
    for plugin in $._config.etherpad.plugins
  ],

  local container = k.core.v1.container,
  local containerPort = k.core.v1.containerPort,
  container::
    container.new('etherpad-%s' % $._config.etherpad.name, self._images.etherpad)
    + container.withCommand([
      'sh',
      '-c',
      '%s && node node_modules/ep_etherpad-lite/node/server.js' % std.join(' && ', plugins),
    ])
    + k.util.resourcesLimits('150m', '30Mi')
    + container.withPorts(containerPort.new('http', 9001))
    + container.mixin.livenessProbe.httpGet.withPath('/')
    + container.mixin.livenessProbe.httpGet.withPort(9001)
    + container.mixin.livenessProbe.httpGet.withScheme('HTTP')
    + container.mixin.livenessProbe
      .withPeriodSeconds(10)
      .withSuccessThreshold(1)
      .withFailureThreshold(10)
      .withInitialDelaySeconds(30)
      .withTimeoutSeconds(1)
    + container.mixin.readinessProbe.httpGet.withPath('/')
    + container.mixin.readinessProbe.httpGet.withPort(9001)
    + container.mixin.readinessProbe.httpGet.withScheme('HTTP')
    + container.mixin.readinessProbe
      .withPeriodSeconds(10)
      .withSuccessThreshold(1)
      .withFailureThreshold(10)
      .withInitialDelaySeconds(30)
      .withTimeoutSeconds(1)
  ,

  local deployment = k.apps.v1.deployment,
  deployment:
    deployment.new('etherpad-%s' % $._config.etherpad.name, $._config.etherpad.replicas, [$.container]),

  service:
    k.util.serviceFor($.deployment),
}
