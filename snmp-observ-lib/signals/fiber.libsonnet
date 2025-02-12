local commonlib = import 'common-lib/common/main.libsonnet';
local xtd = import 'github.com/jsonnet-libs/xtd/main.libsonnet';
function(this, level='interface')
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels + ['ifName'],
    aggLevel: 'instance',
    aggFunction: 'sum',
    rangeFunction: 'irate',
    aggKeepLabels: ['ifAlias', 'ifDescr'],
    enableLokiLogs: this.enableLokiLogs,
    discoveryMetric: {
      cisco: 'fcIfTxWaitCount',
    },
    varAdHocEnabled: true,
    varAdHocLabels: self.aggKeepLabels,
    signals:
      {
        fcIfCurrRxBbCredit: {
          name: 'FC receive credits',
          nameShort: 'credit receive',
          description: |||
            The current value of receive buffer-to-buffer credits for this port.
          |||,
          optional: true,
          type: 'gauge',
          unit: 'short',
          sources: {
            generic:
              {
                expr: 'fcIfCurrRxBbCredit{%(queriesSelector)s}',
              },
          },
        },

        fcIfCurrTxBbCredit: {
          name: 'FC transmit credits',
          nameShort: 'credit transmit',
          description: |||
            The current value of transmit buffer-to-buffer credits for this port.
          |||,
          type: 'gauge',
          optional: true,
          unit: 'short',
          sources: {
            generic:
              {
                expr: 'fcIfCurrTxBbCredit{%(queriesSelector)s}',
              },
          },
        },

        fcIfTxWaitCount: {
          name: 'FC wait due to lack of transmit credits.',
          nameShort: 'fcIfTxWaitCount',
          description: |||
            The number of times the FC-port waited due to lack of transmit credits.
          |||,
          type: 'counter',
          optional: true,
          unit: 'pps',
          sources: {
            generic:
              {
                expr: 'fcIfTxWaitCount{%(queriesSelector)s}',
              },
          },
        },
        fcIfFramesDiscard: {
          name: 'Frames discarded',
          nameShort: 'fcIfFramesDiscard',
          description: |||
            The number of frames discarded by the FC-port.
          |||,
          type: 'counter',
          optional: true,
          unit: 'pps',
          sources: {
            generic:
              {
                expr: 'fcIfFramesDiscard{%(queriesSelector)s}',
              },
          },
        },
        fcIfTxWtAvgBBCreditTransitionToZero: {
          name: 'Zero credit available',
          nameShort: 'fcIfTxWtAvgBBCreditTransitionToZero',
          description: |||
            fcIfTxWtAvgBBCreditTransitionToZero increments if the credit
            available is zero for 100 ms.
          |||,
          type: 'counter',
          optional: true,
          unit: 'pps',
          sources: {
            generic:
              {
                expr: 'fcIfTxWtAvgBBCreditTransitionToZero{%(queriesSelector)s}',
              },
          },
        },
        fcHCIfBBCreditTransistionFromZero: {
          name: 'Zero credit available (transmit)',
          nameShort: 'fcHCIfBBCreditTransistionFromZero',
          description: |||
            fcHCIfBBCreditTransistionFromZero increments if the transmit b2b
            credit is zero.
          |||,
          type: 'counter',
          optional: true,
          unit: 'pps',
          sources: {
            generic:
              {
                expr: 'fcHCIfBBCreditTransistionFromZero{%(queriesSelector)s}',
              },
          },
        },
        fcHCIfBBCreditTransistionToZero: {
          name: 'Zero credit available (receive)',
          nameShort: 'fcHCIfBBCreditTransistionToZero',
          description: |||
            fcHCIfBBCreditTransistionToZero increments if the receive b2b
            credit is zero.
          |||,
          type: 'counter',
          optional: true,
          unit: 'pps',
          sources: {
            generic:
              {
                expr: 'fcHCIfBBCreditTransistionToZero{%(queriesSelector)s}',
              },
          },
        },

        fcIfInvalidCrcs: {
          name: 'FC invalid CRCc detected',
          nameShort: 'fcIfInvalidCrcs',
          description: |||
            The number of invalid CRCs detected by the FC-Port.
          |||,
          optional: true,
          type: 'counter',
          unit: 'pps',
          sources: {
            generic:
              {
                expr: 'fcIfInvalidCrcs{%(queriesSelector)s}',
              },
          },
        },

        fcIfInvalidTxWords: {
          name: 'FC invalid TX words',
          nameShort: 'fcIfInvalidTxWords',
          description: |||
            The number of invalid transmission words detected by the FC-Port.
          |||,
          type: 'counter',
          optional: true,
          unit: 'pps',
          sources: {
            generic:
              {
                expr: 'fcIfInvalidTxWords{%(queriesSelector)s}',
              },
          },
        },
      },
  }
