local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(this):
    {
      local signals = this.signals,
      local stat = g.panel.stat,
      local alertList = g.panel.alertList,

      // create stat panel using commonlib
      clientsWaitingConnections:
        commonlib.panels.generic.stat.base.new(
          'Client waiting connections',
          targets=[
            signals.connections.pools_client_waiting_connections.withExprWrappersMixin(['sum(', ')']).withLegendFormat('').asTarget(),
          ],
          description='Current number of client connections waiting on a server connection.'
        )
        + stat.options.withGraphMode('none')
        + stat.standardOptions.color.withMode('thresholds')
        + stat.standardOptions.thresholds.withSteps([
          stat.thresholdStep.withColor('super-light-green')
          + stat.thresholdStep.withValue(0),
          stat.thresholdStep.withColor('super-light-orange')
          + stat.thresholdStep.withValue(10),
          stat.thresholdStep.withColor('super-light-red')
          + stat.thresholdStep.withValue(20),
        ]),
      activeClientConnections:
        commonlib.panels.generic.stat.info.new(
          'Active client connections',
          targets=[
            signals.connections.pools_client_active_connections.withExprWrappersMixin(['sum(', ')']).withLegendFormat('').asTarget(),
          ],
          description='Current number of active client connections.'
        )
        + stat.options.withGraphMode('none'),
      activeServerConnections:
        commonlib.panels.generic.stat.info.new(
          'Active server connections',
          targets=[
            signals.connections.pools_server_active_connections.withExprWrappersMixin(['sum(', ')']).withLegendFormat('').asTarget(),
          ],
          description='Current number of client connections that are linked to a server connection and able to process queries.'
        )
        + stat.options.withGraphMode('none'),
      maxDatabaseConnections:
        commonlib.panels.generic.stat.info.new(
          'Max database connections',
          targets=[
            signals.connections.databases_max_connections.withExprWrappersMixin(['sum(', ')']).withLegendFormat('').asTarget(),
          ],
          description='Maximum number of allowed connections for database.'
        )
        + stat.options.withGraphMode('none'),
      maxUserConnections:
        commonlib.panels.generic.stat.info.new(
          'Max user connections',
          targets=[
            signals.config.config_max_user_connections.withExprWrappersMixin(['sum(', ')']).withLegendFormat('').asTarget(),
          ],
          description='Maximum number of server connections per user allowed.'
        )
        + stat.options.withGraphMode('none'),
      maxClientConnections:
        commonlib.panels.generic.stat.info.new(
          'Max client connections',
          targets=[
            signals.config.config_max_client_connections.withExprWrappersMixin(['sum(', ')']).withLegendFormat('').asTarget(),
          ],
          description='Maximum number of client connections allowed.'
        )
        + stat.options.withGraphMode('none'),

      queriesPooled:
        commonlib.panels.generic.timeSeries.base.new(
          'Queries processed',
          targets=[signals.stats.stats_queries_pooled_total.asTarget()],
          description=|||
            Rate of SQL queries pooled by PgBouncer.
          |||
        )
        + g.panel.timeSeries.standardOptions.withUnit('ops'),

      queryDuration:
        commonlib.panels.generic.timeSeries.base.new(
          'Queries average duration / $__interval',
          targets=[signals.stats.stats_query_avg_duration.asTarget()],
          description=|||
            Average duration of queries being processed by PgBouncer.
          |||
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      networkTraffic:
        commonlib.panels.network.timeSeries.traffic.new(
          'Network traffic',
          targets=[
            signals.stats.stats_received_bytes_total.asTarget(),
            signals.stats.stats_sent_bytes_total.asTarget(),
          ],
          description=|||
            Volume in bytes of network traffic received by PgBouncer.
          |||
        )
        + g.panel.timeSeries.standardOptions.withUnit('Bps')
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      transactionRate:
        commonlib.panels.generic.timeSeries.base.new(
          'SQL transaction rate',
          targets=[signals.stats.stats_sql_transactions_pooled_total.asTarget()],
          description=|||
            Rate of SQL transactions pooled.
          |||
        )
        + g.panel.timeSeries.standardOptions.withUnit('ops'),

      transactionAverageDuration:
        commonlib.panels.generic.timeSeries.base.new(
          'SQL average transaction duration / $__interval',
          targets=[signals.stats.stats_transaction_avg_duration.asTarget()],
          description=|||
            Average duration of SQL transactions pooled.
          |||
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      serverConnections:
        commonlib.panels.generic.timeSeries.base.new(
          'Server connections',
          targets=[
            signals.connections.pools_server_idle_connections.asTarget(),
            signals.connections.pools_server_used_connections.asTarget(),
            signals.connections.pools_server_login_connections.asTarget(),
            signals.connections.pools_server_testing_connections.asTarget(),
          ],
          description=|||
            Number of various server connection states.
          |||
        )
        + g.panel.timeSeries.standardOptions.withUnit('conn')
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      granularActiveClientConnections:
        commonlib.panels.generic.timeSeries.base.new(
          'Active client connections',
          targets=[signals.connections.pools_client_active_connections.asTarget()],
          description=|||
            Current number of active client connections.
          |||
        )
        + g.panel.timeSeries.standardOptions.withUnit('conn'),

      clientsWaiting:
        commonlib.panels.generic.timeSeries.base.new(
          'Waiting clients',
          targets=[signals.connections.pools_client_waiting_connections.asTarget()],
          description=|||
            Current number of client connections waiting on a server connection.
          |||
        )
        + g.panel.timeSeries.standardOptions.withUnit('clients'),

      maxClientWaitTime:
        commonlib.panels.generic.timeSeries.base.new(
          'Max client wait time',
          targets=[signals.connections.pools_client_maxwait_seconds.asTarget()],
          description=|||
            Age of the oldest unserved client connection in seconds.
          |||
        )
        + g.panel.timeSeries.standardOptions.withUnit('s'),

      alertsPanel:
        alertList.new('PgBouncer alerts')
        + alertList.options.UnifiedAlertListOptions.withAlertInstanceLabelFilter(this.grafana.variables.queriesGroupSelectorAdvanced),

      topDatabaseActiveConnection:
        commonlib.panels.generic.timeSeries.base.new(
          'Top databases by active connections',
          targets=[signals.cluster.top_database_active_connection.asTarget()],
          description=|||
            Top databases by current number of active client connections.
          |||
        )
        + g.panel.timeSeries.standardOptions.withUnit('conn'),
      topDatabaseQueryPooled:
        commonlib.panels.generic.timeSeries.base.new(
          'Top databases by queries processed',
          targets=[signals.cluster.top_database_query_processed.asTarget()],
          description=|||
            Top databases by rate of SQL queries pooled by PgBouncer.
          |||
        )
        + g.panel.timeSeries.standardOptions.withUnit('ops'),
      topDatabaseQueryDuration:
        commonlib.panels.generic.timeSeries.base.new(
          'Top databases by average query duration',
          targets=[signals.cluster.top_database_query_duration.asTarget()],
          description=|||
            Top databases by average duration of queries being processed by PgBouncer.
          |||
        )
        + g.panel.timeSeries.standardOptions.withUnit('s'),
      topDatabaseNetworkTraffic:
        commonlib.panels.generic.timeSeries.base.new(
          'Top databases by network traffic',
          targets=[
            signals.cluster.top_database_network_received.asTarget(),
            signals.cluster.top_database_network_sent.asTarget(),
          ],
          description=|||
            Top databases by volume of network traffic.
          |||
        )
        + g.panel.timeSeries.standardOptions.withUnit('Bps')
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right'),
    },
}
