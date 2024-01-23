// # Libsonnet dashboards targetting the correct Grafana schema. Outdated dashboards can be found in old-dashboards/
(import 'kafka-lag-overview.libsonnet') +
(import 'zookeeper-overview.libsonnet') +
{
  grafanaDashboards+:: {
    'connect-overview.json': (import 'connect-overview.json'),
    'kafka-ksqldb-overview.json': (import 'kafka-ksqldb-overview.json'),
    'kafka-overview.json': (import 'kafka-overview.json'),
    'kafka-topics.json': (import 'kafka-topics.json'),
    'schema-registry-overview.json': (import 'schema-registry-overview.json'),
  },
}
