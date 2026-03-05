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

    uptime:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'dragonfly_uptime_in_seconds{%(queriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(this.config.legendLabels)),

    connectedClients:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'dragonfly_connected_clients{%(queriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(this.config.legendLabels)),

    memoryUsedBytes:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'dragonfly_memory_used_bytes{%(queriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s - used' % utils.labelsToPanelLegend(this.config.legendLabels)),

    memoryMaxBytes:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'dragonfly_memory_max_bytes{%(queriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s - max' % utils.labelsToPanelLegend(this.config.legendLabels)),

    memoryRssBytes:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'dragonfly_used_memory_rss_bytes{%(queriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s - RSS' % utils.labelsToPanelLegend(this.config.legendLabels)),

    memoryUtilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '100 * dragonfly_memory_used_bytes{%(queriesSelector)s} / clamp_min(dragonfly_memory_max_bytes{%(queriesSelector)s}, 1)' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(this.config.legendLabels)),

    commandsRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(dragonfly_commands_total{%(queriesSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(this.config.legendLabels)),

    replyRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(dragonfly_reply_total{%(queriesSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(this.config.legendLabels)),

    replyLatency:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(dragonfly_reply_duration_seconds{%(queriesSelector)s}[$__rate_interval]) / clamp_min(rate(dragonfly_reply_total{%(queriesSelector)s}[$__rate_interval]), 0.001)' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(this.config.legendLabels)),

    keyspaceHitsRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(dragonfly_keyspace_hits_total{%(queriesSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('%s - hits' % utils.labelsToPanelLegend(this.config.legendLabels)),

    keyspaceMissesRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(dragonfly_keyspace_misses_total{%(queriesSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('%s - misses' % utils.labelsToPanelLegend(this.config.legendLabels)),

    keyspaceHitRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '100 * rate(dragonfly_keyspace_hits_total{%(queriesSelector)s}[$__rate_interval]) / clamp_min(rate(dragonfly_keyspace_hits_total{%(queriesSelector)s}[$__rate_interval]) + rate(dragonfly_keyspace_misses_total{%(queriesSelector)s}[$__rate_interval]), 0.001)' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(this.config.legendLabels)),

    dbKeys:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'dragonfly_db_keys{%(queriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(this.config.legendLabelsWithJob)),

    dbKeysExpiring:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'dragonfly_db_keys_expiring{%(queriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s - expiring' % utils.labelsToPanelLegend(this.config.legendLabelsWithJob)),

    evictedKeysRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(dragonfly_evicted_keys_total{%(queriesSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(this.config.legendLabels)),

    expiredKeysRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(dragonfly_expired_keys_total{%(queriesSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(this.config.legendLabels)),

    networkInputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(dragonfly_net_input_bytes_total{%(queriesSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('%s - in' % utils.labelsToPanelLegend(this.config.legendLabels)),

    networkOutputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(dragonfly_net_output_bytes_total{%(queriesSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('%s - out' % utils.labelsToPanelLegend(this.config.legendLabels)),

    networkTraffic:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(dragonfly_net_input_bytes_total{%(queriesSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('%s - received' % utils.labelsToPanelLegend(this.config.legendLabels)),
    networkTrafficSent:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(dragonfly_net_output_bytes_total{%(queriesSelector)s}[$__rate_interval])' % vars
      )
      + prometheusQuery.withLegendFormat('%s - sent' % utils.labelsToPanelLegend(this.config.legendLabels)),

    pipelineQueueLength:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'dragonfly_pipeline_queue_length{%(queriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(this.config.legendLabels)),

    commandsDuration:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum without (cmd) (rate(dragonfly_commands_duration_seconds{%(queriesSelector)s}[$__rate_interval])) / clamp_min(sum without (cmd) (rate(dragonfly_commands_total{%(queriesSelector)s}[$__rate_interval])), 0.001)' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(this.config.legendLabels)),

    alertsPanel:
      g.panel.alertList.new('Dragonfly alerts')
      + g.panel.alertList.options.UnifiedAlertListOptions.withAlertInstanceLabelFilter(this.grafana.variables.queriesGroupSelectorAdvanced),
  },
}
