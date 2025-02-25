local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(signals, this):: {
    credit:
      signals.fiber.fcIfCurrRxBbCredit.withTopK().asTimeSeries('FC buffer-to-buffer credit')
      + signals.fiber.fcIfCurrTxBbCredit.withTopK().asPanelMixin()
      + commonlib.panels.network.timeSeries.base.stylize()
      + commonlib.panels.network.timeSeries.base.withNegateOutPackets()
      + g.panel.timeSeries.queryOptions.withInterval(this.config.minInterval)
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0),
    errors:
      signals.fiber.fcIfTxWaitCount.withTopK().asTimeSeries('Network FC errors')
      + g.panel.timeSeries.panelOptions.withDescription(
        |||
          -TxWaitCount: The number of times the FC-port waited due to lack of transmit credits.

          -FramesDiscard: The number of frames discarded by the FC-port.

          -TxWtAvgBBCreditTransitionToZero: increments if the credit available is zero for 100 ms.

          -BBCreditTransistionFromZero: increments if the transmit b2b credit is zero.

          -BBCreditTransistionToZero: increments if the receive b2b credit is zero.

          -InvalidTxWords: The number of invalid transmission words detected by the FC-Port.

          -InvalidCrcs: The number of invalid CRCs detected by the FC-Port.
        |||
      )
      + signals.fiber.fcIfFramesDiscard.withTopK().asPanelMixin()
      + signals.fiber.fcIfTxWtAvgBBCreditTransitionToZero.withTopK().asPanelMixin()
      + signals.fiber.fcHCIfBBCreditTransistionFromZero.withTopK().asPanelMixin()
      + signals.fiber.fcHCIfBBCreditTransistionToZero.withTopK().asPanelMixin()
      + signals.fiber.fcIfInvalidCrcs.withTopK().asPanelMixin()
      + signals.fiber.fcIfInvalidTxWords.withTopK().asPanelMixin()
      + commonlib.panels.network.timeSeries.errors.stylize()
      + commonlib.panels.network.timeSeries.errors.withNegateOutPackets()
      + g.panel.timeSeries.queryOptions.withInterval(this.config.minInterval),

  },
}
