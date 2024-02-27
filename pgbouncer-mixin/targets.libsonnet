local g = import './g.libsonnet';
local prometheusQuery = g.query.prometheus;
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils {
  labelsToPanelLegend(labels): std.join(' - ', ['{{%s}}' % [label] for label in labels]),
};
local lokiQuery = g.query.loki;

{
  new(this): {
    local vars = this.grafana.variables,
    local config = this.config,

    clientsWaitingConnections:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum(pgbouncer_pools_client_waiting_connections{%(queriesSelector)s})' % vars
      ),
    activeClientConnections:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum(pgbouncer_pools_client_active_connections{%(queriesSelector)s})' % vars
      ),
    activeServerConnections:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum(pgbouncer_pools_server_active_connections{%(queriesSelector)s})' % vars
      ),
    maxDatabaseConnections:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum(pgbouncer_databases_max_connections{%(queriesSelector)s})' % vars
      ),
    maxUserConnections:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum(pgbouncer_config_max_user_connections{%(instanceQueriesSelector)s})' % vars
      ),
    maxClientConnections:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum(pgbouncer_config_max_client_connections{%(instanceQueriesSelector)s})' % vars
      ),
    queriesPooled:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(pgbouncer_stats_queries_pooled_total{%(queriesSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(this.config.legendLabels)),
    queryDuration:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '1000 * increase(pgbouncer_stats_queries_duration_seconds_total{%(queriesSelector)s}[$__interval:]) / clamp_min(increase(pgbouncer_stats_queries_pooled_total{%(queriesSelector)s}[$__interval:]), 1)' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(this.config.legendLabels)),

    networkTrafficRecieved:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(pgbouncer_stats_received_bytes_total{%(queriesSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('%s - received' % utils.labelsToPanelLegend(this.config.legendLabels)),

    networkTrafficSent:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(pgbouncer_stats_sent_bytes_total{%(queriesSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('%s - sent' % utils.labelsToPanelLegend(this.config.legendLabels)),

    transactionRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(pgbouncer_stats_sql_transactions_pooled_total{%(queriesSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(this.config.legendLabels)),

    transactionAverageDuration:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '1000 * increase(pgbouncer_stats_server_in_transaction_seconds_total{%(queriesSelector)s}[$__interval:]) / clamp_min(increase(pgbouncer_stats_sql_transactions_pooled_total{%(queriesSelector)s}[$__interval:]), 1)' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(this.config.legendLabels)),

    serverIdleConnections:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'pgbouncer_pools_server_idle_connections{%(queriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s - idle' % utils.labelsToPanelLegend(this.config.legendLabels)),

    serverUsedConnections:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'pgbouncer_pools_server_used_connections{%(queriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s - used' % utils.labelsToPanelLegend(this.config.legendLabels)),

    serverTestingConnections:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'pgbouncer_pools_server_testing_connections{%(queriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s - testing' % utils.labelsToPanelLegend(this.config.legendLabels)),

    serverLoginConnections:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'pgbouncer_pools_server_login_connections{%(queriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s - login' % utils.labelsToPanelLegend(this.config.legendLabels)),

    granularActiveClientConnections:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'pgbouncer_pools_client_active_connections{%(queriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(this.config.legendLabels)),

    clientsWaiting:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'pgbouncer_pools_client_waiting_connections{%(queriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(this.config.legendLabels)),

    maxClientWaitTime:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'pgbouncer_pools_client_maxwait_seconds{%(queriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(this.config.legendLabels)),

    topDatabaseActiveConnection:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(database, instance, pgbouncer_cluster)(5, pgbouncer_pools_client_active_connections{%(clusterQuerySelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(this.config.clusterLegendLabel)),
    topDatabaseQueryProcessed:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(database, instance, pgbouncer_cluster)(5, rate(pgbouncer_stats_queries_pooled_total{%(clusterQuerySelector)s}[$__rate_interval]))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(this.config.clusterLegendLabel)),
    topDatabaseQueryDuration:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(database, instance, pgbouncer_cluster)(5, 1000 * increase(pgbouncer_stats_queries_duration_seconds_total{%(clusterQuerySelector)s}[$__interval:]) / clamp_min(increase(pgbouncer_stats_queries_pooled_total{%(clusterQuerySelector)s}[$__interval:]), 1))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(this.config.clusterLegendLabel)),
    topDatabaseNetworkTrafficReceived:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(database, instance, pgbouncer_cluster)(5, rate(pgbouncer_stats_received_bytes_total{%(clusterQuerySelector)s}[$__rate_interval]))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - received' % utils.labelsToPanelLegend(this.config.clusterLegendLabel)),
    topDatabaseNetworkTrafficSent:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(database, instance, pgbouncer_cluster)(5, rate(pgbouncer_stats_sent_bytes_total{%(clusterQuerySelector)s}[$__rate_interval]))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - sent' % utils.labelsToPanelLegend(this.config.clusterLegendLabel)),
  },
}
