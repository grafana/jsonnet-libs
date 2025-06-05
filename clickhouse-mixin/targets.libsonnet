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

    ClickHouseMetrics_InterserverConnection:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'ClickHouseMetrics_InterserverConnection{%(testNameSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(config.groupLabels + config.instanceLabels)),

    ClickHouseAsyncMetrics_ReplicasMaxQueueSize:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'ClickHouseAsyncMetrics_ReplicasMaxQueueSize{%(testNameSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(config.groupLabels + config.instanceLabels)),

    ClickHouseProfileEvents_ReplicatedPartFetches:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(ClickHouseProfileEvents_ReplicatedPartFetches{%(testNameSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(config.groupLabels + config.instanceLabels)),

    ClickHouseProfileEvents_ReplicatedPartMerges:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(ClickHouseProfileEvents_ReplicatedPartMerges{%(testNameSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(config.groupLabels + config.instanceLabels)),

    ClickHouseProfileEvents_ReplicatedPartMutations:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(ClickHouseProfileEvents_ReplicatedPartMutations{%(testNameSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(config.groupLabels + config.instanceLabels)),

    ClickHouseProfileEvents_ReplicatedPartChecks:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(ClickHouseProfileEvents_ReplicatedPartChecks{%(testNameSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(config.groupLabels + config.instanceLabels)),

    ClickHouseMetrics_ReadonlyReplica:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'ClickHouseMetrics_ReadonlyReplica{%(testNameSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(config.groupLabels + config.instanceLabels)),

    ClickHouseMetrics_ZooKeeperWatch:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'ClickHouseMetrics_ZooKeeperWatch{%(testNameSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(config.groupLabels + config.instanceLabels)),

    ClickHouseMetrics_ZooKeeperSession:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'ClickHouseMetrics_ZooKeeperSession{%(testNameSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(config.groupLabels + config.instanceLabels)),

    ClickHouseMetrics_ZooKeeperRequest:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'ClickHouseMetrics_ZooKeeperRequest{%(testNameSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(config.groupLabels + config.instanceLabels)),

    ClickHouseProfileEvents_SelectQuery:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(ClickHouseProfileEvents_SelectQuery{%(testNameSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(config.groupLabels + config.instanceLabels)),

    ClickHouseProfileEvents_InsertQuery:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(ClickHouseProfileEvents_InsertQuery{%(testNameSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(config.groupLabels + config.instanceLabels)),

    ClickHouseProfileEvents_AsyncInsertQuery:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(ClickHouseProfileEvents_AsyncInsertQuery{%(testNameSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(config.groupLabels + config.instanceLabels)),

    ClickHouseProfileEvents_FailedSelectQuery:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(ClickHouseProfileEvents_FailedSelectQuery{%(testNameSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(config.groupLabels + config.instanceLabels)),

    ClickHouseProfileEvents_FailedInsertQuery:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(ClickHouseProfileEvents_FailedInsertQuery{%(testNameSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(config.groupLabels + config.instanceLabels)),

    ClickHouseProfileEvents_RejectedInserts:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(ClickHouseProfileEvents_RejectedInserts{%(testNameSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(config.groupLabels + config.instanceLabels)),

    ClickHouseMetrics_MemoryTracking:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '(ClickHouseMetrics_MemoryTracking{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(config.groupLabels + config.instanceLabels)),

    ClickHouseMetrics_TCPConnection:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'ClickHouseMetrics_TCPConnection{%(testNameSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(config.groupLabels + config.instanceLabels)),

    ClickHouseMetrics_HTTPConnection:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'ClickHouseMetrics_HTTPConnection{%(testNameSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(config.groupLabels + config.instanceLabels)),

    ClickHouseMetrics_MySQLConnection:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'ClickHouseMetrics_MySQLConnection{%(testNameSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(config.groupLabels + config.instanceLabels)),

    ClickHouseMetrics_PostgreSQLConnection:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'ClickHouseMetrics_PostgreSQLConnection{%(testNameSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(config.groupLabels + config.instanceLabels)),

    ClickHouseProfileEvents_NetworkReceiveBytes:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(ClickHouseProfileEvents_NetworkReceiveBytes{%(testNameSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(config.groupLabels + config.instanceLabels)),

    ClickHouseProfileEvents_NetworkSendBytes:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(ClickHouseProfileEvents_NetworkSendBytes{%(testNameSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(config.groupLabels + config.instanceLabels)),

    ClickHouseProfileEvents_DiskReadElapsedMicroseconds:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(ClickHouseProfileEvents_DiskReadElapsedMicroseconds{%(testNameSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(config.groupLabels + config.instanceLabels)),

    ClickHouseProfileEvents_DiskWriteElapsedMicroseconds:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(ClickHouseProfileEvents_DiskWriteElapsedMicroseconds{%(testNameSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(config.groupLabels + config.instanceLabels)),

    ClickHouseProfileEvents_NetworkReceiveElapsedMicroseconds:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(ClickHouseProfileEvents_NetworkReceiveElapsedMicroseconds{%(testNameSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(config.groupLabels + config.instanceLabels)),

    ClickHouseProfileEvents_NetworkSendElapsedMicroseconds:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(ClickHouseProfileEvents_NetworkSendElapsedMicroseconds{%(testNameSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(config.groupLabels + config.instanceLabels)),

    ClickHouseProfileEvents_ZooKeeperWaitMicroseconds:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(ClickHouseProfileEvents_ZooKeeperWaitMicroseconds{%(testNameSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(config.groupLabels + config.instanceLabels)),

  },
}
