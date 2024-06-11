// Outdated dashboards can be found in old-dashboards/
{
  grafanaDashboards+:: {
    'connect-overview.json': (import 'connect-overview.json'),
    'kafka-ksqldb-overview.json': (import 'kafka-ksqldb-overview.json'),
    'kafka-lag-overview.json': (import 'kafka-lag-overview.json'),
    'kafka-overview.json': (import 'kafka-overview.json'),
    'kafka-topics.json': (import 'kafka-topics.json'),
    'schema-registry-overview.json': (import 'schema-registry-overview.json'),
    'zookeeper-overview.json': (import 'zookeeper-overview.json'),
  },
}
