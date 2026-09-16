local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(this):
    {
      local signals = this.signals,

      clientsWaitingConnections:
        signals.connections.pools_client_waiting_connections_total.asStat()
        + commonlib.panels.generic.stat.base.stylize()
        + g.panel.stat.options.withGraphMode('none')
        + g.panel.stat.standardOptions.color.withMode('thresholds')
        + g.panel.stat.standardOptions.thresholds.withSteps([
          g.panel.stat.thresholdStep.withColor('super-light-green')
          + g.panel.stat.thresholdStep.withValue(0),
          g.panel.stat.thresholdStep.withColor('super-light-orange')
          + g.panel.stat.thresholdStep.withValue(10),
          g.panel.stat.thresholdStep.withColor('super-light-red')
          + g.panel.stat.thresholdStep.withValue(20),
        ]),
      activeClientConnections:
        signals.connections.pools_client_active_connections_total.asStat()
        + commonlib.panels.generic.stat.info.stylize(),
      activeServerConnections:
        signals.connections.pools_server_active_connections.asStat()
        + commonlib.panels.generic.stat.info.stylize(),
      maxDatabaseConnections:
        signals.connections.databases_max_connections.asStat()
        + commonlib.panels.generic.stat.info.stylize(),
      maxUserConnections:
        signals.config.config_max_user_connections.asStat()
        + commonlib.panels.generic.stat.info.stylize(),
      maxClientConnections:
        signals.config.config_max_client_connections.asStat()
        + commonlib.panels.generic.stat.info.stylize(),

      queriesPooled:
        signals.stats.stats_queries_pooled_total.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      queryDuration:
        signals.stats.stats_query_avg_duration.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      transactionRate:
        signals.stats.stats_sql_transactions_pooled_total.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      transactionAverageDuration:
        signals.stats.stats_transaction_avg_duration.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      granularActiveClientConnections:
        signals.connections.pools_client_active_connections.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      clientsWaiting:
        signals.connections.pools_client_waiting_connections.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      maxClientWaitTime:
        signals.connections.pools_client_maxwait_seconds.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

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

      // Cluster overview panels.
      topDatabaseActiveConnection:
        signals.cluster.top_database_active_connection.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),
      topDatabaseQueryPooled:
        signals.cluster.top_database_query_processed.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),
      topDatabaseQueryDuration:
        signals.cluster.top_database_query_duration.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),
      topDatabaseNetworkTraffic:
        commonlib.panels.network.timeSeries.traffic.new(
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

      alertsPanel:
        g.panel.alertList.new('PgBouncer alerts')
        + g.panel.alertList.options.UnifiedAlertListOptions.withAlertInstanceLabelFilter(
          this.grafana.variables.queriesGroupSelectorAdvanced
        ),
    },
}
