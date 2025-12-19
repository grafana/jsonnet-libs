local g = import './g.libsonnet';

{
  new(this): {
    // Overview row with stat panels, aggregate metrics, and table
    overview: [
      g.panel.row.new('Overview')
      + g.panel.row.withCollapsed(false),
      // Stat panels - key metrics at a glance
      panels.indexesCountStat
      + g.panel.stat.gridPos.withW(8)
      + g.panel.stat.gridPos.withH(4),
      this.grafana.panels.totalRecordsStat
      + g.panel.stat.gridPos.withW(8)
      + g.panel.stat.gridPos.withH(4),
      this.grafana.panels.totalStorageStat
      + g.panel.stat.gridPos.withW(8)
      + g.panel.stat.gridPos.withH(4),
      // Aggregate operations time series
      this.grafana.panels.totalOperationsPerSec
      + g.panel.timeSeries.gridPos.withW(12)
      + g.panel.timeSeries.gridPos.withH(8),
      this.grafana.panels.totalReadWriteOperations
      + g.panel.timeSeries.gridPos.withW(12)
      + g.panel.timeSeries.gridPos.withH(8),
      // Indexes table - detailed view
      this.grafana.panels.indexesTable
      + g.panel.table.gridPos.withW(24),
    ],

    // Write operations (upsert, delete)
    writeOperations: [
      g.panel.row.new('Write Operations'),
      this.grafana.panels.upsertTotal
      + g.panel.timeSeries.gridPos.withW(12)
      + g.panel.timeSeries.gridPos.withH(7),
      this.grafana.panels.upsertDuration
      + g.panel.timeSeries.gridPos.withW(12)
      + g.panel.timeSeries.gridPos.withH(7),
      // second row
      this.grafana.panels.deleteTotal
      + g.panel.timeSeries.gridPos.withW(12)
      + g.panel.timeSeries.gridPos.withH(7),
      this.grafana.panels.deleteDuration
      + g.panel.timeSeries.gridPos.withW(12)
      + g.panel.timeSeries.gridPos.withH(7),
    ],

    // Read operations (query, fetch)
    readOperations: [
      g.panel.row.new('Read Operations'),
      this.grafana.panels.queryTotal
      + g.panel.timeSeries.gridPos.withW(12)
      + g.panel.timeSeries.gridPos.withH(7),
      this.grafana.panels.queryDuration
      + g.panel.timeSeries.gridPos.withW(12)
      + g.panel.timeSeries.gridPos.withH(7),
      // second row
      this.grafana.panels.fetchTotal
      + g.panel.timeSeries.gridPos.withW(12)
      + g.panel.timeSeries.gridPos.withH(7),
      this.grafana.panels.fetchDuration
      + g.panel.timeSeries.gridPos.withW(12)
      + g.panel.timeSeries.gridPos.withH(7),
    ],

    // Resource usage
    resourceUsage: [
      g.panel.row.new('Resource Usage'),
      this.grafana.panels.writeUnitsTotal
      + g.panel.timeSeries.gridPos.withW(12)
      + g.panel.timeSeries.gridPos.withH(7),
      this.grafana.panels.readUnitsTotal
      + g.panel.timeSeries.gridPos.withW(12)
      + g.panel.timeSeries.gridPos.withH(7),
    ],
  },
}

