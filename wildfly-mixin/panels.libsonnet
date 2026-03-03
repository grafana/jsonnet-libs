local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this)::
    {
      local signals = this.signals,

      requestsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Requests',
          targets=[signals.overviewServer.requestsRate.asTarget() { interval: '2m', intervalFactor: 2 }],
          description='Requests rate over time'
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps'),

      requestErrorsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Request errors',
          targets=[signals.overviewServer.requestErrorsRate.asTarget() { interval: '2m', intervalFactor: 2 }],
          description='Rate of requests that result in 500 over time'
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          { color: 'green', value: null },
          { color: 'red', value: 80 },
        ])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      networkReceivedThroughputPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Network received throughput',
          targets=[signals.overviewServer.networkReceivedThroughput.asTarget() { interval: '2m', intervalFactor: 2 }],
          description='Throughput rate of data received over time'
        )
        + g.panel.timeSeries.standardOptions.withUnit('binBps')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      networkSentThroughputPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Network sent throughput',
          targets=[signals.overviewServer.networkSentThroughput.asTarget() { interval: '2m', intervalFactor: 2 }],
          description='Throughput rate of data sent over time'
        )
        + g.panel.timeSeries.standardOptions.withUnit('binBps')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          { color: 'green', value: null },
          { color: 'red', value: 80 },
        ])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      sessionsActivePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Active sessions',
          targets=[signals.overviewDeployment.activeSessions.asTarget() { intervalFactor: 2 }],
          description='Number of active sessions to deployment over time'
        )
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          { color: 'green', value: null },
          { color: 'red', value: 80 },
        ])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      sessionsExpiredPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Expired sessions',
          targets=[signals.overviewDeployment.expiredSessions.asTarget() { interval: '2m', intervalFactor: 2 }],
          description='Number of sessions that have expired for a deployment over time'
        )
        + g.panel.timeSeries.standardOptions.withDecimals(0)
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          { color: 'green', value: null },
          { color: 'red', value: 80 },
        ])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      sessionsRejectedPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Rejected sessions',
          targets=[signals.overviewDeployment.rejectedSessions.asTarget() { interval: '2m', intervalFactor: 2 }],
          description='Number of sessions that have been rejected from a deployment over time'
        )
        + g.panel.timeSeries.standardOptions.withDecimals(0)
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          { color: 'green', value: null },
          { color: 'red', value: 80 },
        ])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      connectionsActivePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Active connections',
          targets=[signals.datasource.connectionsActive.asTarget() { intervalFactor: 2 }],
          description='Active connections to the datasource over time'
        )
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          { color: 'green', value: null },
          { color: 'red', value: 80 },
        ])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      connectionsIdlePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Idle connections',
          targets=[signals.datasource.connectionsIdle.asTarget() { intervalFactor: 2 }],
          description='Idle connections to the datasource over time'
        )
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          { color: 'green', value: null },
          { color: 'red', value: 80 },
        ])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      transactionsCreatedPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Created transactions',
          targets=[signals.datasourceTransaction.transactionsCreated.asTarget() { interval: '2m', intervalFactor: 2 }],
          description='Number of transactions that were created over time'
        )
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          { color: 'green', value: null },
          { color: 'red', value: 80 },
        ])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      transactionsInFlightPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'In-flight transactions',
          targets=[signals.datasourceTransaction.transactionsInFlight.asTarget() { intervalFactor: 2 }],
          description='Number of transactions that are in-flight over time'
        )
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          { color: 'green', value: null },
          { color: 'red', value: 80 },
        ])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      transactionsAbortedPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Aborted transactions',
          targets=[signals.datasourceTransaction.transactionsAborted.asTarget() { interval: '2m', intervalFactor: 2 }],
          description='Number of transactions that have been aborted over time'
        )
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          { color: 'green', value: null },
          { color: 'red', value: 80 },
        ])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),
    },
}
