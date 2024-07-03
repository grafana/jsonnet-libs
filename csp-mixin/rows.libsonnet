local g = import './g.libsonnet';
{
  new(this):
    {
      overview: [
        g.panel.row.new('Overview'),
        this.grafana.panels.bucketCount
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(4),
        this.grafana.panels.objectCountTotal
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(4),
        this.grafana.panels.totalBytesTotal
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(4),
        this.grafana.panels.totalNetworkThroughput
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(7),
        this.grafana.panels.objectCountByBucket
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(7),
        this.grafana.panels.totalBytesByBucket
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(7),
      ],
      api: std.prune(
        [
          g.panel.row.new('API'),
        ] +
        [
          if this.config.enableAvailability then
            this.grafana.panels.availabilityTs
            + g.panel.timeSeries.gridPos.withW(24)
            + g.panel.timeSeries.gridPos.withH(6),
        ]
        +
        [
          this.grafana.panels.apiRequestCount
          + g.panel.timeSeries.gridPos.withW(12)
          + g.panel.timeSeries.gridPos.withH(12),
          this.grafana.panels.apiErrorRate
          + g.panel.timeSeries.gridPos.withW(12)
          + g.panel.timeSeries.gridPos.withH(12),
        ]
      ),
      network: [
        g.panel.row.new('Network'),
        this.grafana.panels.network
        + g.panel.timeSeries.gridPos.withW(24)
        + g.panel.timeSeries.gridPos.withH(12),
      ],
    },
}
