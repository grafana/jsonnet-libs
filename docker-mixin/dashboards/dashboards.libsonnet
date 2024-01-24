{
  grafanaDashboards: {
    'docker.json': (import 'docker-overview.json'),
  },
} +
(import 'docker-logs.libsonnet')
