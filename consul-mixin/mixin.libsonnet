{
  _config+:: {
    consul_replicas: 3,
  },
} +
(import 'dashboards.libsonnet') +
(import 'alerts.libsonnet')
