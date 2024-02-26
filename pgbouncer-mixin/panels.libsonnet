local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;
{
  new(this):
    {
      local t = this.grafana.targets,
      local stat = g.panel.stat,
      // create stat panel using commonlib
      clientsWaitingConnections:
        commonlib.panels.generic.stat.base.new(
          'Client waiting connections',
          targets=[t.clientsWaitingConnections],
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
          targets=[t.activeClientConnections],
          description='Current number of active client connections.'
        )
        + stat.options.withGraphMode('none'),
      activeServerConnections:
        commonlib.panels.generic.stat.info.new(
          'Active server connections',
          targets=[t.activeServerConnections],
          description='Current number of client connections that are linked to a server connection and able to process queries.'
        )
        + stat.options.withGraphMode('none'),
      maxDatabaseConnections:
        commonlib.panels.generic.stat.info.new(
          'Max database connections',
          targets=[t.maxDatabaseConnections],
          description='Maximum number of allowed connections for database.'
        )
        + stat.options.withGraphMode('none'),
      maxUserConnections:
        commonlib.panels.generic.stat.info.new(
          'Max user connections',
          targets=[t.maxUserConnections],
          description='Maximum number of server connections per user allowed.'
        )
        + stat.options.withGraphMode('none'),
      maxClientConnections:
        commonlib.panels.generic.stat.info.new(
          'Max client connections',
          targets=[t.maxClientConnections],
          description='Maximum number of client connections allowed.'
        )
        + stat.options.withGraphMode('none'),

      queriesPooled:
        commonlib.panels.generic.timeSeries.base.new(
          'Queries processed',
          targets=[t.queriesPooled],
          description=|||
            Rate of SQL queries pooled by PgBouncer.
          |||
        )
        + g.panel.timeSeries.standardOptions.withUnit('ops'),

      queryDuration:
        commonlib.panels.generic.timeSeries.base.new(
          'Queries average duration / $__interval',
          targets=[t.queryDuration],
          description=|||
            Average duration of queries being processed by PgBouncer.
          |||
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      networkTraffic:
        commonlib.panels.network.timeSeries.traffic.new(
          'Network traffic',
          targets=[t.networkTrafficRecieved, t.networkTrafficSent],
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
          targets=[t.transactionRate],
          description=|||
            Rate of SQL transactions pooled.
          |||
        )
        + g.panel.timeSeries.standardOptions.withUnit('ops'),

      transactionAverageDuration:
        commonlib.panels.generic.timeSeries.base.new(
          'SQL average transaction duration / $__interval',
          targets=[t.transactionAverageDuration],
          description=|||
            Average duration of SQL transactions pooled.
          |||
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      serverConnections:
        commonlib.panels.generic.timeSeries.base.new(
          'Server connections',
          targets=[t.serverIdleConnections, t.serverUsedConnections, t.serverLoginConnections, t.serverTestingConnections],
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
          targets=[t.granularActiveClientConnections],
          description=|||
            Current number of active client connections.
          |||
        )
        + g.panel.timeSeries.standardOptions.withUnit('conn'),

      clientsWaiting:
        commonlib.panels.generic.timeSeries.base.new(
          'Waiting clients',
          targets=[t.clientsWaiting],
          description=|||
            Current number of client connections waiting on a server connection.
          |||
        )
        + g.panel.timeSeries.standardOptions.withUnit('clients'),

      maxClientWaitTime:
        commonlib.panels.generic.timeSeries.base.new(
          'Max client wait time',
          targets=[t.maxClientWaitTime],
          description=|||
            Age of the oldest unserved client connection in seconds.
          |||
        )
        + g.panel.timeSeries.standardOptions.withUnit('s'),
    },
}
