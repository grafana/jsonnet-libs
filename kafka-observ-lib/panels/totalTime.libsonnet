local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(signals, config):: {

    _common::
      commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.panelOptions.withRepeat(config.instanceLabels[0])
      + g.panel.timeSeries.panelOptions.withRepeatDirection('v')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withStacking({ mode: 'normal' })
      + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(0)
      + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('none'),

    fetchConsumerTotalTimeBreakdown:
      g.panel.timeSeries.new('Fetch-consumer ($%s)' % config.instanceLabels[0])
      + g.panel.timeSeries.panelOptions.withDescription(
        |||
          Total time breakdown for fetch requests.
          quantile: %s

          - `Request queue`: Time   spent waiting in the request queue.
          - `Local time`: Time spent being processed by leader.
          - `Remote time`: Time spent waiting for follower response (only when 'require acks' is set).
          - `Response queue`: Time spent waiting in the response queue.
          - `Response time`: Time to send the response.

        ||| % config.totalTimeMsQuantile
      )
      + signals.totalTime.fetchQueueTime.asPanelMixin()
      + signals.totalTime.fetchLocalTime.asPanelMixin()
      + signals.totalTime.fetchRemoteTime.asPanelMixin()
      + signals.totalTime.fetchResponseQueue.asPanelMixin()
      + signals.totalTime.fetchResponseTime.asPanelMixin()
      + self._common,

    producerTotalTimeBreakdown:
      g.panel.timeSeries.new('Producer ($%s)' % config.instanceLabels[0])
      + g.panel.timeSeries.panelOptions.withDescription(
        |||
          Total time breakdown for producer requests.
          quantile: %s

          - `Request queue`: Time spent waiting in the request queue.
          - `Local time`: Time spent being processed by leader.
          - `Remote time`: Time spent waiting for follower response (only when 'require acks' is set).
          - `Response queue`: Time spent waiting in the response queue.
          - `Response time`: Time to send the response.

        ||| % config.totalTimeMsQuantile
      )
      + signals.totalTime.producerQueueTime.asPanelMixin()
      + signals.totalTime.producerLocalTime.asPanelMixin()
      + signals.totalTime.producerRemoteTime.asPanelMixin()
      + signals.totalTime.producerResponseQueue.asPanelMixin()
      + signals.totalTime.producerResponseTime.asPanelMixin()
      + self._common,

    fetchFollowerTotalTimeBreakdown:
      g.panel.timeSeries.new('Fetch-follower ($%s)' % config.instanceLabels[0])
      + g.panel.timeSeries.panelOptions.withDescription(
        |||
          Total time breakdown for fetch-follower requests.
          quantile: %s

          - `Request queue`: Time spent waiting in the request queue.
          - `Local time`: Time spent being processed by leader.
          - `Remote time`: Time spent waiting for follower response (only when 'require acks' is set).
          - `Response queue`: Time spent waiting in the response queue.
          - `Response time`: Time to send the response.

        ||| % config.totalTimeMsQuantile
      )
      + signals.totalTime.fetchFollowerQueueTime.asPanelMixin()
      + signals.totalTime.fetchFollowerLocalTime.asPanelMixin()
      + signals.totalTime.fetchFollowerRemoteTime.asPanelMixin()
      + signals.totalTime.fetchFollowerResponseQueue.asPanelMixin()
      + signals.totalTime.fetchFollowerResponseTime.asPanelMixin()
      + self._common,

  },
}
