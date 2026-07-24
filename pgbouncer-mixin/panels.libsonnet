local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(this):
    {
      local signals = this.signals,
      local stat = g.panel.stat,
      local alertList = g.panel.alertList,

      // Single-signal stat panels: signal.asStat() + generic stat stylize() reproduces
      // the legacy commonlib.panels.generic.stat.<flavor>.new(...) styling, with title,
      // unit and description sourced from the signal spec.
      clientsWaitingConnections:
        signals.connections.pools_client_waiting_connections.withExprWrappersMixin(['sum(', ')']).withLegendFormat('').asStat()
        + commonlib.panels.generic.stat.base.stylize()
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
        signals.connections.pools_client_active_connections.withExprWrappersMixin(['sum(', ')']).withLegendFormat('').asStat()
        + commonlib.panels.generic.stat.info.stylize()
        + stat.options.withGraphMode('none'),
      activeServerConnections:
        signals.connections.pools_server_active_connections.withExprWrappersMixin(['sum(', ')']).withLegendFormat('').asStat()
        + commonlib.panels.generic.stat.info.stylize()
        + stat.options.withGraphMode('none'),
      maxDatabaseConnections:
        signals.connections.databases_max_connections.withExprWrappersMixin(['sum(', ')']).withLegendFormat('').asStat()
        + commonlib.panels.generic.stat.info.stylize()
        + stat.options.withGraphMode('none'),
      maxUserConnections:
        signals.config.config_max_user_connections.withExprWrappersMixin(['sum(', ')']).withLegendFormat('').asStat()
        + commonlib.panels.generic.stat.info.stylize()
        + stat.options.withGraphMode('none'),
      maxClientConnections:
        signals.config.config_max_client_connections.withExprWrappersMixin(['sum(', ')']).withLegendFormat('').asStat()
        + commonlib.panels.generic.stat.info.stylize()
        + stat.options.withGraphMode('none'),

      // Single-signal timeSeries panels: signal.asTimeSeries() + generic timeSeries stylize().
      queriesPooled:
        signals.stats.stats_queries_pooled_total.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      queryDuration:
        signals.stats.stats_query_avg_duration.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      // Multi-signal network traffic panel keeps target-based construction.
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
        signals.stats.stats_sql_transactions_pooled_total.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      transactionAverageDuration:
        signals.stats.stats_transaction_avg_duration.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      // Multi-signal server connection states panel keeps target-based construction.
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

      // Shares the "Active client connections" signal with the stat panel above; the
      // granular timeSeries view supplies its own unit.
      granularActiveClientConnections:
        signals.connections.pools_client_active_connections.withUnit('conn').asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      // Shares the "Client waiting connections" signal; the timeSeries view uses a
      // different title ('Waiting clients') and unit ('clients').
      clientsWaiting:
        signals.connections.pools_client_waiting_connections.withName('Waiting clients').withUnit('clients').asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      maxClientWaitTime:
        signals.connections.pools_client_maxwait_seconds.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      alertsPanel:
        alertList.new('PgBouncer alerts')
        + alertList.options.UnifiedAlertListOptions.withAlertInstanceLabelFilter(this.grafana.variables.queriesGroupSelectorAdvanced),

      topDatabaseActiveConnection:
        signals.cluster.top_database_active_connection.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),
      topDatabaseQueryPooled:
        signals.cluster.top_database_query_processed.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),
      topDatabaseQueryDuration:
        signals.cluster.top_database_query_duration.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),
      // Multi-signal top-database network panel keeps target-based construction.
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
