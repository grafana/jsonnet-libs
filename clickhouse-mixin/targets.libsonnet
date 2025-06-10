local g = import './g.libsonnet';
local prometheusQuery = g.query.prometheus;
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils {
  labelsToPanelLegend(labels): std.join(' - ', ['{{%s}}' % [label] for label in labels]),
};

{
  new(this): {
    local vars = this.grafana.variables,
    local config = this.config,

    local selector = if config.enableMultiCluster then vars.clusterQuerySelector else vars.instanceQueriesSelector,

    ClickHouseMetrics_InterserverConnection:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'ClickHouseMetrics_InterserverConnection{%s}' % selector
      )
      + prometheusQuery.withLegendFormat('%s - Interserver Connections' % utils.labelsToPanelLegend(config.legendLabels)),

    ClickHouseAsyncMetrics_ReplicasMaxQueueSize:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'ClickHouseAsyncMetrics_ReplicasMaxQueueSize{%s}' % selector
      )
      + prometheusQuery.withLegendFormat('%s - Max Queue Size' % utils.labelsToPanelLegend(config.legendLabels)),

    ClickHouseProfileEvents_ReplicatedPartFetches:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(ClickHouseProfileEvents_ReplicatedPartFetches{%s}[$__rate_interval])' % selector
      )
      + g.panel.timeSeries.queryOptions.withInterval('30s')
      + prometheusQuery.withLegendFormat('%s - Part Fetches' % utils.labelsToPanelLegend(config.legendLabels)),

    ClickHouseProfileEvents_ReplicatedPartMerges:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(ClickHouseProfileEvents_ReplicatedPartMerges{%s}[$__rate_interval])' % selector
      )
      + g.panel.timeSeries.queryOptions.withInterval('30s')
      + prometheusQuery.withLegendFormat('%s - Part Merges' % utils.labelsToPanelLegend(config.legendLabels)),

    ClickHouseProfileEvents_ReplicatedPartMutations:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(ClickHouseProfileEvents_ReplicatedPartMutations{%s}[$__rate_interval])' % selector
      )
      + g.panel.timeSeries.queryOptions.withInterval('30s')
      + prometheusQuery.withLegendFormat('%s - Part Mutations' % utils.labelsToPanelLegend(config.legendLabels)),

    ClickHouseProfileEvents_ReplicatedPartChecks:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(ClickHouseProfileEvents_ReplicatedPartChecks{%s}[$__rate_interval])' % selector
      )
      + g.panel.timeSeries.queryOptions.withInterval('30s')
      + prometheusQuery.withLegendFormat('%s - Part Checks' % utils.labelsToPanelLegend(config.legendLabels)),

    ClickHouseMetrics_ReadonlyReplica:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'ClickHouseMetrics_ReadonlyReplica{%s}' % selector
      )
      + prometheusQuery.withLegendFormat('%s - Read Only' % utils.labelsToPanelLegend(config.legendLabels)),

    ClickHouseMetrics_ZooKeeperWatch:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'ClickHouseMetrics_ZooKeeperWatch{%s}' % selector
      )
      + prometheusQuery.withLegendFormat('%s - ZooKeeper watches' % utils.labelsToPanelLegend(config.legendLabels)),

    ClickHouseMetrics_ZooKeeperSession:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'ClickHouseMetrics_ZooKeeperSession{%s}' % selector
      )
      + prometheusQuery.withLegendFormat('%s - ZooKeeper sessions' % utils.labelsToPanelLegend(config.legendLabels)),

    ClickHouseMetrics_ZooKeeperRequest:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'ClickHouseMetrics_ZooKeeperRequest{%s}' % selector
      )
      + prometheusQuery.withLegendFormat('%s - ZooKeeper requests' % utils.labelsToPanelLegend(config.legendLabels)),

    ClickHouseProfileEvents_SelectQuery:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(ClickHouseProfileEvents_SelectQuery{%s}[$__rate_interval])' % selector
      )
      + g.panel.timeSeries.queryOptions.withInterval('30s')
      + prometheusQuery.withLegendFormat('%s - select query' % utils.labelsToPanelLegend(config.legendLabels)),

    ClickHouseProfileEvents_InsertQuery:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(ClickHouseProfileEvents_InsertQuery{%s}[$__rate_interval])' % selector
      )
      + g.panel.timeSeries.queryOptions.withInterval('30s')
      + prometheusQuery.withLegendFormat('%s - insert query' % utils.labelsToPanelLegend(config.legendLabels)),

    ClickHouseProfileEvents_AsyncInsertQuery:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(ClickHouseProfileEvents_AsyncInsertQuery{%s}[$__rate_interval])' % selector
      )
      + g.panel.timeSeries.queryOptions.withInterval('30s')
      + prometheusQuery.withLegendFormat('%s - async insert query' % utils.labelsToPanelLegend(config.legendLabels)),

    ClickHouseProfileEvents_FailedSelectQuery:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(ClickHouseProfileEvents_FailedSelectQuery{%s}[$__rate_interval])' % selector
      )
      + g.panel.timeSeries.queryOptions.withInterval('30s')
      + prometheusQuery.withLegendFormat('%s - Failed Select Query' % utils.labelsToPanelLegend(config.legendLabels)),

    ClickHouseProfileEvents_FailedInsertQuery:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(ClickHouseProfileEvents_FailedInsertQuery{%s}[$__rate_interval])' % selector
      )
      + g.panel.timeSeries.queryOptions.withInterval('30s')
      + prometheusQuery.withLegendFormat('%s - Failed Insert Query' % utils.labelsToPanelLegend(config.legendLabels)),

    ClickHouseProfileEvents_RejectedInserts:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(ClickHouseProfileEvents_RejectedInserts{%s}[$__rate_interval])' % selector
      )
      + g.panel.timeSeries.queryOptions.withInterval('30s')
      + prometheusQuery.withLegendFormat('%s - Rejected Inserts' % utils.labelsToPanelLegend(config.legendLabels)),

    ClickHouseMetrics_MemoryTracking:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '(ClickHouseMetrics_MemoryTracking{%s})' % selector
      )
      + prometheusQuery.withLegendFormat('%s - Memory Tracking' % utils.labelsToPanelLegend(config.legendLabels)),

    ClickHouseMetrics_MemoryTrackingPercent:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '(ClickHouseMetrics_MemoryTracking{%s} / ClickHouseAsyncMetrics_OSMemoryTotal{%s}) * 100' % [selector, selector]
      )
      + prometheusQuery.withLegendFormat('%s - Memory Tracking Percent' % utils.labelsToPanelLegend(config.legendLabels)),

    ClickHouseMetrics_TCPConnection:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'ClickHouseMetrics_TCPConnection{%s}' % selector
      )
      + prometheusQuery.withLegendFormat('%s - TCP connection' % utils.labelsToPanelLegend(config.legendLabels)),

    ClickHouseMetrics_HTTPConnection:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'ClickHouseMetrics_HTTPConnection{%s}' % selector
      )
      + prometheusQuery.withLegendFormat('%s - HTTP connection' % utils.labelsToPanelLegend(config.legendLabels)),

    ClickHouseMetrics_MySQLConnection:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'ClickHouseMetrics_MySQLConnection{%s}' % selector
      )
      + prometheusQuery.withLegendFormat('%s - MySQL connection' % utils.labelsToPanelLegend(config.legendLabels)),

    ClickHouseMetrics_PostgreSQLConnection:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'ClickHouseMetrics_PostgreSQLConnection{%s}' % selector
      )
      + prometheusQuery.withLegendFormat('%s - PostgreSQL connection' % utils.labelsToPanelLegend(config.legendLabels)),

    ClickHouseProfileEvents_NetworkReceiveBytes:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(ClickHouseProfileEvents_NetworkReceiveBytes{%s}[$__rate_interval])' % selector
      )
      + g.panel.timeSeries.queryOptions.withInterval('30s')
      + prometheusQuery.withLegendFormat('%s - network receive bytes' % utils.labelsToPanelLegend(config.legendLabels)),

    ClickHouseProfileEvents_NetworkSendBytes:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(ClickHouseProfileEvents_NetworkSendBytes{%s}[$__rate_interval])' % selector
      )
      + g.panel.timeSeries.queryOptions.withInterval('30s')
      + prometheusQuery.withLegendFormat('%s - network send bytes' % utils.labelsToPanelLegend(config.legendLabels)),

    ClickHouseProfileEvents_DiskReadElapsedMicroseconds:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(ClickHouseProfileEvents_DiskReadElapsedMicroseconds{%s}[$__rate_interval])' % selector
      )
      + g.panel.timeSeries.queryOptions.withInterval('30s')
      + prometheusQuery.withLegendFormat('%s - disk read elapsed' % utils.labelsToPanelLegend(config.legendLabels)),

    ClickHouseProfileEvents_DiskWriteElapsedMicroseconds:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(ClickHouseProfileEvents_DiskWriteElapsedMicroseconds{%s}[$__rate_interval])' % selector
      )
      + g.panel.timeSeries.queryOptions.withInterval('30s')
      + prometheusQuery.withLegendFormat('%s - disk write elapsed' % utils.labelsToPanelLegend(config.legendLabels)),

    ClickHouseProfileEvents_NetworkReceiveElapsedMicroseconds:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(ClickHouseProfileEvents_NetworkReceiveElapsedMicroseconds{%s}[$__rate_interval])' % selector
      )
      + g.panel.timeSeries.queryOptions.withInterval('30s')
      + prometheusQuery.withLegendFormat('%s - network receive elapsed' % utils.labelsToPanelLegend(config.legendLabels)),

    ClickHouseProfileEvents_NetworkSendElapsedMicroseconds:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(ClickHouseProfileEvents_NetworkSendElapsedMicroseconds{%s}[$__rate_interval])' % selector
      )
      + g.panel.timeSeries.queryOptions.withInterval('30s')
      + prometheusQuery.withLegendFormat('%s - network send elapsed' % utils.labelsToPanelLegend(config.legendLabels)),

    ClickHouseProfileEvents_ZooKeeperWaitMicroseconds:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(ClickHouseProfileEvents_ZooKeeperWaitMicroseconds{%s}[$__rate_interval])' % selector
      )
      + g.panel.timeSeries.queryOptions.withInterval('30s')
      + prometheusQuery.withLegendFormat('%s - ZooKeeper wait' % utils.labelsToPanelLegend(config.legendLabels)),

  },
}
