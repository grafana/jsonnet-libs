local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '2m',
    discoveryMetric: {
      prometheus: 'ClickHouseMetrics_TCPConnection',
    },
    signals: {
      tcpConnections: {
        name: 'TCP connections',
        nameShort: 'TCP',
        type: 'gauge',
        description: 'Current number of TCP connections to ClickHouse',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'ClickHouseMetrics_TCPConnection{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }} - TCP connection',
          },
        },
      },
      httpConnections: {
        name: 'HTTP connections',
        nameShort: 'HTTP',
        type: 'gauge',
        description: 'Current number of HTTP connections to ClickHouse',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'ClickHouseMetrics_HTTPConnection{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }} - HTTP connection',
          },
        },
      },
      mysqlConnections: {
        name: 'MySQL connections',
        nameShort: 'MySQL',
        type: 'gauge',
        description: 'Current number of MySQL connections to ClickHouse',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'ClickHouseMetrics_MySQLConnection{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }} - MySQL connection',
          },
        },
      },
      postgresqlConnections: {
        name: 'PostgreSQL connections',
        nameShort: 'PostgreSQL',
        type: 'gauge',
        description: 'Current number of PostgreSQL connections to ClickHouse',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'ClickHouseMetrics_PostgreSQLConnection{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }} - PostgreSQL connection',
          },
        },
      },
    },
  }
