local g = import './g.libsonnet';

{
  new(this):
    {
      // ---
      // Overview Dashboard Rows
      // ---

      // Main overview row
      apacheAirflowOverview:
        g.panel.row.new('Apache Airflow overview')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          this.grafana.panels.dagFileParsingErrorsPanel { gridPos+: { w: 8 } },
          this.grafana.panels.slaIssuesPanel { gridPos+: { w: 8 } },
          this.grafana.panels.taskFailuresPanel { gridPos+: { w: 8 } },
          this.grafana.panels.dagSuccessDurationPanel { gridPos+: { w: 12 } },
          this.grafana.panels.dagFailedDurationPanel { gridPos+: { w: 12 } },
          this.grafana.panels.taskDurationPanel { gridPos+: { w: 8 } },
          this.grafana.panels.taskCountSummaryPanel { gridPos+: { w: 8 } },
          this.grafana.panels.taskCountsPanel { gridPos+: { w: 8 } },
        ]),

      // Scheduler details row
      apacheAirflowSchedulerDetails:
        g.panel.row.new('Scheduler details')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          this.grafana.panels.dagScheduleDelayPanel { gridPos+: { w: 12 } },
          this.grafana.panels.schedulerTasksPanel { gridPos+: { w: 12 } },
          this.grafana.panels.executorTasksPanel { gridPos+: { w: 12 } },
          this.grafana.panels.poolTaskSlotsPanel { gridPos+: { w: 12 } },
        ]),

      // ---
      // Logs Dashboard Rows
      // ---

      apacheAirflowLogs:
        g.panel.row.new('Apache Airflow logs')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          this.grafana.panels.taskLogsPanel { gridPos+: { w: 24 } },
          this.grafana.panels.schedulerLogsPanel { gridPos+: { w: 24 } },
        ]),
    },
}
