local g = import './g.libsonnet';
{
  new(this):
  {
    overview: [
      g.panel.row.new('Overview'),
      this.grafana.panels.objectCountTotal
      + g.panel.timeSeries.gridPos.withW(24/2)
      + g.panel.timeSeries.gridPos.withH(4),
      this.grafana.panels.totalBytesTotal
      + g.panel.timeSeries.gridPos.withW(24/2)
      + g.panel.timeSeries.gridPos.withH(4),
    ]
  }
}