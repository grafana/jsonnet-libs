local g = import './g.libsonnet';
{
  new(this):
    {
      overview: [
        g.panel.row.new('Overview'),
        this.grafana.panels.bucketCount
        + g.panel.timeSeries.gridPos.withW(24 / 5)
        + g.panel.timeSeries.gridPos.withH(4),
        this.grafana.panels.objectCountTotal
        + g.panel.timeSeries.gridPos.withW(24 / 5)
        + g.panel.timeSeries.gridPos.withH(4),
        this.grafana.panels.objectCountByBucket
        + g.panel.timeSeries.gridPos.withW(24 / 5)
        + g.panel.timeSeries.gridPos.withH(4),
        this.grafana.panels.totalBytesTotal
        + g.panel.timeSeries.gridPos.withW(24 / 5)
        + g.panel.timeSeries.gridPos.withH(4),
        this.grafana.panels.totalBytesByBucket
        + g.panel.timeSeries.gridPos.withW(24 / 5)
        + g.panel.timeSeries.gridPos.withH(4),
      ],
      api: [
        g.panel.row.new('API'),
        this.grafana.panels.apiRequestCount
        + g.panel.timeSeries.gridPos.withW(24)
        + g.panel.timeSeries.gridPos.withH(12),
      ],
      network: [
        g.panel.row.new('Network'),
        this.grafana.panels.network
        + g.panel.timeSeries.gridPos.withW(24)
        + g.panel.timeSeries.gridPos.withH(12),
      ],
    },
}
