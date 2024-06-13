local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(this): {
    bucketCount:
      this.signals.blobstore.bucketCount.asStat()
      + commonlib.panels.generic.stat.base.stylize(),
    objectCountTotal:
      this.signals.blobstore.objectCountTotal.asStat()
      + commonlib.panels.generic.stat.base.stylize(),
    objectCountByBucket:
      g.panel.pieChart.new('Top 10 Buckets - Object Count')
      + g.panel.pieChart.options.withPieType('donut')
      + g.panel.pieChart.options.legend.withShowLegend(false)
      + this.signals.blobstore.objectCountTopK.common,
    totalBytesTotal:
      this.signals.blobstore.totalBytesTotal.asStat()
      + commonlib.panels.generic.stat.base.stylize(),
    totalBytesByBucket:
      g.panel.pieChart.new('Top 10 Buckets - Total Bytes')
      + g.panel.pieChart.options.withPieType('donut')
      + g.panel.pieChart.options.legend.withShowLegend(false)
      + this.signals.blobstore.totalBytesTopK.common,
    apiRequestCount:
      this.signals.blobstore.apiRequestCount.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.options.legend.withDisplayMode('table')
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),
    network:
      commonlib.panels.network.timeSeries.traffic.new('Network traffic', targets=[])
      + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets()
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
      + g.panel.timeSeries.options.legend.withDisplayMode('table')
      + g.panel.timeSeries.options.legend.withPlacement('bottom')
      + this.signals.blobstore.networkRx.asPanelMixin()
      + this.signals.blobstore.networkTx.asPanelMixin(),
  },
}
