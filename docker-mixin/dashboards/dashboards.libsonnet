{
  grafanaDashboards: {
    'docker-overview.json': (import 'docker-overview.json'),
  },
} +
(import 'docker-logs.libsonnet')
