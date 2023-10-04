local grafana = (import 'grafonnet/grafana.libsonnet');
local resource = import '../../lib/resource.libsonnet';
local kind = 'Dashboard';

function(config, variables, panels) {

  dockerLogsDashboardSpec:: grafana.dashboard.new(
        'Docker Logs',
        time_from='%s' % config.dashboardPeriod,
        editable=false,
        tags=(config.dashboardTags),
        timezone='%s' % config.dashboardTimezone,
        refresh='%s' % config.dashboardRefresh,
        uid='integration-docker-logs'
      )

      .addTemplates([
        variables.prometheus.spec,
        variables.loki.spec,
        variables.job.spec,
        variables.instance.spec,
        variables.container.spec,
      ])

      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Docker Dashboards',
        includeVars=true,
        keepTime=true,
        tags=(config.dashboardTags),
      ))

      // Overview Row
      .addPanel(grafana.row.new(title='Overview'), gridPos={ x: 0, y: 2, w: 0, h: 0 })
      // Total Log Lines
      .addPanel(panels.total_log_lines.spec, gridPos={ x: 0, y: 2, w: 4, h: 4 })
      // Warnings
      .addPanel(panels.total_log_warnings.spec, gridPos={ x: 4, y: 2, w: 4, h: 4 })
      // Errors
      .addPanel(panels.total_log_errors.spec, gridPos={ x: 8, y: 2, w: 4, h: 4 })
      // Error Percentage
      .addPanel(panels.error_percentage.spec, gridPos={ x: 12, y: 2, w: 4, h: 4 })
      // Bytes Used
      .addPanel(panels.total_bytes.spec, gridPos={ x: 16, y: 2, w: 4, h: 4 })
      // Historical Logs / Warnings / Errors
      .addPanel(panels.historical_logs_errors_warnings.spec, gridPos={ x: 0, y: 6, w: 24, h: 6 })

      // Errors Row
      .addPanel(
        grafana.row.new(title='Errors', collapse=true)
        // Errors
        .addPanel(panels.log_errors.spec, gridPos={ x: 0, y: 12, w: 24, h: 8 }),
        gridPos={ x: 0, y: 12, w: 0, h: 0 }
      )

      // Warnings Row
      .addPanel(
        grafana.row.new(title='Warnings', collapse=true)
        // Warnings
        .addPanel(panels.log_warnings.spec, gridPos={ x: 0, y: 20, w: 24, h: 8 }),
        gridPos={ x: 0, y: 20, w: 0, h: 0 }
      )

      // Complete Log File
      .addPanel(
        grafana.row.new(title='Complete Log File', collapse=true)
        // Full Log File
        .addPanel(panels.log_full.spec, gridPos={ x: 0, y: 28, w: 24, h: 8 }),
        gridPos={ x: 0, y: 28, w: 0, h: 0 }
      ),

  'docker-logs': resource.new(kind, 'docker-logs')
    + resource.withDocs('Dashboard showing logs for Docker containers')
    + resource.withSpec(self.dockerLogsDashboardSpec),
}