local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(this): {
    // Azure Queue Storage
    _tableCommon(valueName)::
      g.panel.table.queryOptions.withTransformations([
        g.panel.table.queryOptions.transformation.withId('filterFieldsByName')
        + g.panel.table.queryOptions.transformation.withOptions({
          include: {
            pattern: 'resourceName.*|Value.*',
          },
        }),
        g.panel.table.queryOptions.transformation.withId('joinByField')
        + g.panel.table.queryOptions.transformation.withOptions({
          byField: 'resourceName',
          mode: 'outer',
        }),
      ])
      + g.panel.table.standardOptions.withOverrides([
        {
          matcher: {
            id: 'byName',
            options: 'resourceName',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Storage account',
            },
            // TODO: The link "works" but does not refresh the dashboard upon following the link. Surely this is solvable?
            // {
            //   id: 'links',
            //   value: [
            //     {
            //       title: 'Filter to bucket',
            //       url: '/d/%(uid)s/%(uid)s?${datasource:queryparam}&var-%(bucketLabel)s=${__data.fields.%(bucketLabel)s}' % {
            //         uid: this.config.uid + '-blobstorage',
            //         bucketLabel: this.config.blobStorage.bucketLabel,
            //       },
            //     },
            //   ],
            // },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Value',
          },
          properties: [
            {
              id: 'displayName',
              value: valueName,
            },
          ],
        },
      ]),

    availabilityTs:
      this.signals.azurequeuestore.availability.asTimeSeries()
      + g.panel.timeSeries.options.legend.withDisplayMode('table')
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),
    availabilityStat:
      this.signals.azurequeuestore.availability.asStat(),
    queueCount:
      this.signals.azurequeuestore.queueCount.asStat()
      + g.panel.stat.standardOptions.color.withMode('fixed')
      + g.panel.stat.standardOptions.color.withFixedColor('purple'),
    messageCountTotal:
      this.signals.azurequeuestore.messageCountTotal.asStat()
      + g.panel.stat.standardOptions.color.withMode('fixed')
      + g.panel.stat.standardOptions.color.withFixedColor('purple'),
    messageCountByQueue:
      this.signals.azurequeuestore.messageCountTopK.common
      + g.panel.table.standardOptions.withUnit('locale')
      + commonlib.panels.generic.table.base.new(
        'Top 5 Queues - Message Count',
        [
          this.signals.azurequeuestore.messageCountTopK.asTarget()
          + g.query.prometheus.withFormat('table')
          + g.query.prometheus.withInstant(true),
        ],
        'Number of messages stored.'
      )
      + self._tableCommon('Message Count'),
    messageCountTs:
      this.signals.azurequeuestore.messageCount.asTimeSeries(),
    totalBytesTotal:
      this.signals.azurequeuestore.totalBytesTotal.asStat()
      + g.panel.stat.standardOptions.color.withMode('fixed')
      + g.panel.stat.standardOptions.color.withFixedColor('purple'),
    totalBytesByBucket:
      this.signals.azurequeuestore.totalBytesTopK.common
      + g.panel.table.standardOptions.withUnit('bytes')
      + commonlib.panels.generic.table.base.new(
        'Top 5 Queues - Total Bytes',
        [
          this.signals.azurequeuestore.totalBytesTopK.asTarget()
          + g.query.prometheus.withFormat('table')
          + g.query.prometheus.withInstant(true),
        ],
        'Total bytes stored'
      ) + self._tableCommon('Total Bytes'),
    totalNetworkThroughput:
      this.signals.azurequeuestore.networkThroughputTopK.common
      + g.panel.table.standardOptions.withUnit('bytes')
      + commonlib.panels.generic.table.base.new(
        'Top 5 Queues - Network Throughput',
        [
          this.signals.azurequeuestore.networkThroughputTopK.asTarget()
          + g.query.prometheus.withFormat('table')
          + g.query.prometheus.withInstant(true),
          this.signals.azurequeuestore.networkRxTopK.asTarget()
          + g.query.prometheus.withFormat('table')
          + g.query.prometheus.withInstant(true),
          this.signals.azurequeuestore.networkTxTopK.asTarget()
          + g.query.prometheus.withFormat('table')
          + g.query.prometheus.withInstant(true),
        ],
        'Total network throughput in bits for the selected timerange'
      ) + self._tableCommon('Total Throughput')
      + g.panel.table.fieldConfig.defaults.custom.withMinWidth(100)
      + g.panel.table.standardOptions.withOverridesMixin([
        {
          matcher: {
            id: 'byName',
            options: 'Value #Network bits throughput',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Total',
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Value #Network bits received',
          },
          properties: [
            {
              id: 'displayName',
              value: 'rx',
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Value #Network bits transmitted',
          },
          properties: [
            {
              id: 'displayName',
              value: 'tx',
            },
          ],
        },
      ]),
    apiRequestCount:
      this.signals.azurequeuestore.apiRequestByTypeCount.asTimeSeries()
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),
    apiErrorRate:
      this.signals.azurequeuestore.apiRequestErrorRate.asTimeSeries(),
    network:
      commonlib.panels.network.timeSeries.traffic.new('Network traffic', targets=[])
      + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets()
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
      + this.signals.azurequeuestore.networkRx.asPanelMixin()
      + this.signals.azurequeuestore.networkTx.asPanelMixin(),
  },
}
