local g = import './g.libsonnet';

{
  new(this): {
    local panels = this.grafana.panels,
    // Overview row with stat panels, aggregate metrics, and table
    overview: [
      g.panel.row.new('Overview')
      + g.panel.row.withCollapsed(false),
      // Stat panels - key metrics at a glance
      panels.indexesCountStat { gridPos+: { h: 4, w: 8 } },
      this.grafana.panels.totalRecordsStat { gridPos+: { h: 4, w: 8 } },
      this.grafana.panels.totalStorageStat { gridPos+: { h: 4, w: 8 } },
      // Aggregate operations time series
      this.grafana.panels.totalOperationsPerSec { gridPos+: { h: 8, w: 12 } },
      this.grafana.panels.totalReadWriteOperations { gridPos+: { h: 8, w: 12 } },
      // Indexes table - detailed view
      this.grafana.panels.indexesTable { gridPos+: { w: 24 } },
    ],

    // Write operations (upsert, delete)
    writeOperations: [
      g.panel.row.new('Write Operations'),
      this.grafana.panels.upsertTotal { gridPos+: { h: 7, w: 12 } },
      this.grafana.panels.upsertDuration { gridPos+: { h: 7, w: 12 } },
      // second row
      this.grafana.panels.deleteTotal { gridPos+: { h: 7, w: 12 } },
      this.grafana.panels.deleteDuration { gridPos+: { h: 7, w: 12 } },
    ],

    // Read operations (query, fetch)
    readOperations: [
      g.panel.row.new('Read Operations'),
      this.grafana.panels.queryTotal { gridPos+: { h: 7, w: 12 } },
      this.grafana.panels.queryDuration { gridPos+: { h: 7, w: 12 } },
      // second row
      this.grafana.panels.fetchTotal { gridPos+: { h: 7, w: 12 } },
      this.grafana.panels.fetchDuration { gridPos+: { h: 7, w: 12 } },
    ],

    // Resource usage
    resourceUsage: [
      g.panel.row.new('Resource Usage'),
      this.grafana.panels.writeUnitsTotal { gridPos+: { h: 7, w: 12 } },
      this.grafana.panels.readUnitsTotal { gridPos+: { h: 7, w: 12 } },
    ],
  },
}
