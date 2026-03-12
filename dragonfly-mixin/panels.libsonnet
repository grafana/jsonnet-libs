local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;
{
  new(this):
    {
      local t = this.grafana.targets,
      local stat = g.panel.stat,
      local alertList = g.panel.alertList,

      uptime:
        commonlib.panels.generic.stat.info.new(
          'Uptime',
          targets=[t.uptime],
          description='Dragonfly server uptime in seconds.'
        )
        + stat.options.withGraphMode('none')
        + stat.standardOptions.withUnit('s'),

      connectedClients:
        commonlib.panels.generic.stat.info.new(
          'Connected clients',
          targets=[t.connectedClients],
          description='Number of client connections.'
        )
        + stat.options.withGraphMode('none')
        + stat.standardOptions.withUnit('short'),

      memoryUtilization:
        commonlib.panels.generic.stat.base.new(
          'Memory utilization',
          targets=[t.memoryUtilization],
          description='Memory used as percentage of max configured.'
        )
        + stat.options.withGraphMode('none')
        + stat.standardOptions.color.withMode('thresholds')
        + stat.standardOptions.withUnit('percent')
        + stat.standardOptions.thresholds.withSteps([
          stat.thresholdStep.withColor('super-light-green')
          + stat.thresholdStep.withValue(0),
          stat.thresholdStep.withColor('super-light-orange')
          + stat.thresholdStep.withValue(80),
          stat.thresholdStep.withColor('super-light-red')
          + stat.thresholdStep.withValue(95),
        ]),

      commandsRate:
        commonlib.panels.generic.timeSeries.base.new(
          'Commands rate',
          targets=[t.commandsRate],
          description='Rate of commands processed per second.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ops'),

      replyRate:
        commonlib.panels.generic.timeSeries.base.new(
          'Reply rate',
          targets=[t.replyRate],
          description='Rate of replies sent per second.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ops'),

      replyLatency:
        commonlib.panels.generic.timeSeries.base.new(
          'Average reply latency',
          targets=[t.replyLatency],
          description='Average reply latency in seconds.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('s'),

      commandsDuration:
        commonlib.panels.generic.timeSeries.base.new(
          'Average command duration',
          targets=[t.commandsDuration],
          description='Average command execution duration.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('s'),

      memory:
        commonlib.panels.generic.timeSeries.base.new(
          'Memory usage',
          targets=[t.memoryUsedBytes, t.memoryMaxBytes, t.memoryRssBytes],
          description='Memory used, max, and RSS in bytes.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      keyspaceHitsMisses:
        commonlib.panels.generic.timeSeries.base.new(
          'Keyspace hits and misses',
          targets=[t.keyspaceHitsRate, t.keyspaceMissesRate],
          description='Rate of keyspace hits and misses.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ops')
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      keyspaceHitRate:
        commonlib.panels.generic.timeSeries.base.new(
          'Keyspace hit rate',
          targets=[t.keyspaceHitRate],
          description='Percentage of keyspace lookups that were hits.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      dbKeys:
        commonlib.panels.generic.timeSeries.base.new(
          'Database keys',
          targets=[t.dbKeys, t.dbKeysExpiring],
          description='Number of keys and expiring keys per database.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('short')
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      evictedExpiredKeys:
        commonlib.panels.generic.timeSeries.base.new(
          'Evicted and expired keys rate',
          targets=[t.evictedKeysRate, t.expiredKeysRate],
          description='Rate of keys evicted and expired.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ops')
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      networkTraffic:
        commonlib.panels.network.timeSeries.traffic.new(
          'Network traffic',
          targets=[t.networkTraffic, t.networkTrafficSent],
          description='Network bytes received and sent per second.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('Bps')
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      pipelineQueueLength:
        commonlib.panels.generic.timeSeries.base.new(
          'Pipeline queue length',
          targets=[t.pipelineQueueLength],
          description='Current pipeline queue length.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('short'),

      connectedClientsTimeSeries:
        commonlib.panels.generic.timeSeries.base.new(
          'Connected clients',
          targets=[t.connectedClients],
          description='Number of connected clients over time.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('short'),

      alertsPanel:
        alertList.new('Dragonfly alerts')
        + alertList.options.UnifiedAlertListOptions.withAlertInstanceLabelFilter(this.grafana.variables.queriesGroupSelectorAdvanced),
    },
}
