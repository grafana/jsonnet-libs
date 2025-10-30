local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this)::
    {
      local signals = this.signals,

      requestsPanel:
        g.panel.timeSeries.new('Requests')
        + g.panel.timeSeries.panelOptions.withDescription('Requests rate over time')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.requests.requestsRate.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('reqps'),

      requestErrorsPanel:
        g.panel.timeSeries.new('Request errors')
        + g.panel.timeSeries.panelOptions.withDescription('Rate of requests that result in 500 over time')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.requests.requestErrorsRate.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          { color: 'green', value: null },
          { color: 'red', value: 80 },
        ])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      networkReceivedThroughputPanel:
        g.panel.timeSeries.new('Network received throughput')
        + g.panel.timeSeries.panelOptions.withDescription('Throughput rate of data received over time')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.network.networkReceivedThroughput.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('binBps')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      networkSentThroughputPanel:
        g.panel.timeSeries.new('Network sent throughput')
        + g.panel.timeSeries.panelOptions.withDescription('Throughput rate of data sent over time')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.network.networkSentThroughput.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('binBps')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          { color: 'green', value: null },
          { color: 'red', value: 80 },
        ])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      connectionsActivePanel:
        g.panel.timeSeries.new('Active connections')
        + g.panel.timeSeries.panelOptions.withDescription('Connections to the datasource over time')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.connections.connectionsActive.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          { color: 'green', value: null },
          { color: 'red', value: 80 },
        ])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      connectionsIdlePanel:
        g.panel.timeSeries.new('Idle connections')
        + g.panel.timeSeries.panelOptions.withDescription('Connections to the datasource over time')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.connections.connectionsIdle.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          { color: 'green', value: null },
          { color: 'red', value: 80 },
        ])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      transactionsCreatedPanel:
        g.panel.timeSeries.new('Created transactions')
        + g.panel.timeSeries.panelOptions.withDescription('Number of transactions that were created over time')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.transactions.transactionsCreated.asTarget()
          + g.query.prometheus.withInterval('1m')
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          { color: 'green', value: null },
          { color: 'red', value: 80 },
        ])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      transactionsInFlightPanel:
        g.panel.timeSeries.new('In-flight transactions')
        + g.panel.timeSeries.panelOptions.withDescription('Number of transactions that are in-flight over time')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.transactions.transactionsInFlight.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          { color: 'green', value: null },
          { color: 'red', value: 80 },
        ])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      transactionsAbortedPanel:
        g.panel.timeSeries.new('Aborted transactions')
        + g.panel.timeSeries.panelOptions.withDescription('Number of transactions that have been aborted over time')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.transactions.transactionsAborted.asTarget()
          + g.query.prometheus.withInterval('1m')
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          { color: 'green', value: null },
          { color: 'red', value: 80 },
        ])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      sessionsActivePanel:
        g.panel.timeSeries.new('Active sessions')
        + g.panel.timeSeries.panelOptions.withDescription('Number of active sessions to deployment over time')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.sessions.activeSessions.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          { color: 'green', value: null },
          { color: 'red', value: 80 },
        ])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      sessionsExpiredPanel:
        g.panel.timeSeries.new('Expired sessions')
        + g.panel.timeSeries.panelOptions.withDescription('Number of sessions that have expired for a deployment over time')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.sessions.expiredSessions.asTarget()
          + g.query.prometheus.withInterval('1m')
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withDecimals(0)
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          { color: 'green', value: null },
          { color: 'red', value: 80 },
        ])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      sessionsRejectedPanel:
        g.panel.timeSeries.new('Rejected sessions')
        + g.panel.timeSeries.panelOptions.withDescription('Number of sessions that have been rejected from a deployment over time')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.sessions.rejectedSessions.asTarget()
          + g.query.prometheus.withInterval('1m')
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withDecimals(0)
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          { color: 'green', value: null },
          { color: 'red', value: 80 },
        ])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),
    },
}
