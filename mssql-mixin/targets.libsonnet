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
    local selectorVar = if config.enableMultiCluster then vars.multiclusterSelector else vars.queriesSelector,
    local databaseSelector = '%s, db=~"$db"' % selectorVar,

    mssql_connections:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'mssql_connections{%s}' % selectorVar,
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(config.legendLabels)),

    batch_requests:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(mssql_batch_requests_total{%s}[$__rate_interval])' % selectorVar,
      )
      + g.panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(config.legendLabels)),

    severe_errors:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(mssql_kill_connection_errors_total{%s}[$__rate_interval:])' % selectorVar,
      )
      + g.panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(config.legendLabels)),

    deadlocks:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(mssql_deadlocks_total{%s}[$__rate_interval])' % selectorVar,
      )
      + g.panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(config.legendLabels)),

    os_memory_usage:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'mssql_os_memory{%s}' % selectorVar,
      )
      + prometheusQuery.withLegendFormat('%s - {{ state }}' % utils.labelsToPanelLegend(config.legendLabels)),

    memory_manager_total:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'mssql_server_total_memory_bytes{%s}' % selectorVar,
      )
      + prometheusQuery.withLegendFormat('%s - total' % utils.labelsToPanelLegend(config.legendLabels)),

    memory_manager_target:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'mssql_server_target_memory_bytes{%s}' % selectorVar,
      )
      + prometheusQuery.withLegendFormat('%s - target' % utils.labelsToPanelLegend(config.legendLabels)),

    committed_memory_utilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '100 * mssql_server_total_memory_bytes{%s} / clamp_min(mssql_available_commit_memory_bytes{%s}, 1)' % [selectorVar, selectorVar],
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(config.legendLabels)),

    database_write_stall_duration:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(mssql_io_stall_seconds_total{%s, operation="write"}[$__rate_interval:])' % databaseSelector,
      )
      + g.panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('%s - {{db}}' % utils.labelsToPanelLegend(config.legendLabels)),

    database_read_stall_duration:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(mssql_io_stall_seconds_total{%s, operation="read"}[$__rate_interval:])' % databaseSelector,
      )
      + g.panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('%s - {{db}}' % utils.labelsToPanelLegend(config.legendLabels)),

    transaction_log_expansions:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(mssql_log_growths_total{%s}[$__rate_interval:])' % databaseSelector,
      )
      + g.panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('%s - {{db}}' % utils.labelsToPanelLegend(config.legendLabels)),

    page_file_memory:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'mssql_os_page_file{%s}' % selectorVar,
      )
      + prometheusQuery.withLegendFormat('%s - {{ state}}' % utils.labelsToPanelLegend(config.legendLabels)),

    buffer_cache_hit_percentage:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'mssql_buffer_cache_hit_ratio{%s}' % selectorVar,
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(config.legendLabels)),

    page_checkpoints:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'mssql_checkpoint_pages_sec{%s}' % selectorVar,
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(config.legendLabels)),

    page_faults:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(mssql_page_fault_count_total{%s}[$__rate_interval:])' % selectorVar,
      )
      + g.panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(config.legendLabels)),

  },
}
