local g = import './g.libsonnet';
{
  new(this):
    {
      'jvm-dashboard.json':
        g.dashboard.new(this.config.dashboardNamePrefix + 'JVM overview')
        + g.dashboard.withVariables(this.signals.memory.getVariablesMultiChoice())
        + g.dashboard.withTags(this.config.dashboardTags)
        + g.dashboard.withUid(this.config.uid + '-jvm-dashboard')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.overview,
                this.process.grafana.rows.process,
                this.grafana.rows.memory,
              ]
              + (if this.config.metricsSource != 'jmx_exporter' then [this.grafana.rows.gc] else [])
              + [this.grafana.rows.threads]
              + (if this.config.metricsSource != 'jmx_exporter' then [this.grafana.rows.buffers] else [])
              + (
                if this.config.metricsSource == 'java_micrometer' || this.config.metricsSource == 'otel' then
                  [
                    this.grafana.rows.hikari,
                  ]
                else []
              )
              + (
                if this.config.metricsSource == 'java_micrometer' then
                  [
                    this.grafana.rows.logback,
                  ]
                else []
              )

            )
          ),
          setPanelIDs=false
        ),
    },
}
