local g = import './g.libsonnet';
{
  new(this):
    {
      overview: [
        g.panel.row.new('Overview'),
        this.grafana.panels.containersCount
        + g.panel.timeSeries.gridPos.withW(24 / 6)
        + g.panel.timeSeries.gridPos.withH(4),
        this.grafana.panels.imagesCount
        + g.panel.timeSeries.gridPos.withW(24 / 6)
        + g.panel.timeSeries.gridPos.withH(4),
        this.grafana.panels.cpuTotal
        + g.panel.timeSeries.gridPos.withW(24 / 6)
        + g.panel.timeSeries.gridPos.withH(4),
        this.grafana.panels.memoryReserved
        + g.panel.timeSeries.gridPos.withW(24 / 6)
        + g.panel.timeSeries.gridPos.withH(4),
        this.grafana.panels.memoryUtilization
        + g.panel.timeSeries.gridPos.withW(24 / 6)
        + g.panel.timeSeries.gridPos.withH(4),

      ],
      compute: [
        g.panel.row.new('Compute'),
        this.grafana.panels.cpu
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(7),
        this.grafana.panels.memory
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(7),
      ],
      network: [
        g.panel.row.new('Network'),
        this.grafana.panels.network
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(7),
        this.grafana.panels.networkErrsAndDrops
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(7),
      ],
      disks: [
        g.panel.row.new('Storage'),
        this.grafana.panels.diskUsageBytes
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(7),
        this.grafana.panels.diskIO
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(7),

      ],
    },
}
