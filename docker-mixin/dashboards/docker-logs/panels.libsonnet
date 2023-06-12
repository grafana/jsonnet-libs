local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local custom_barchart_grafonnet = import '../../lib/custom-barchart-grafonnet/custom-barchart.libsonnet';

function(queries) {
  total_log_lines_panel: grafana.statPanel.new(
    'Total Log Lines',
    description='Total number of log lines including errors and warnings.',
    datasource='$loki_datasource',
    graphMode='none',
    reducerFunction='sum',
    unit='short',
  )
  .addThreshold(
    { color: 'rgb(192, 216, 255)', value: 0 }
  )
  .addTarget(
    grafana.loki.target(queries.total_log_lines)
  ),

  total_log_warnings_panel: grafana.statPanel.new(
    'Warnings',
    description='Total number of log lines of level: warning.',
    datasource='$loki_datasource',
    graphMode='none',
    reducerFunction='sum',
    unit='short',
  ).addThreshold(
    { color: 'rgb(255, 152, 48)', value: 0 }
  )
  .addTarget(
    grafana.loki.target(queries.total_log_warnings)
  ),

  total_log_errors_panel: grafana.statPanel.new(
    'Errors',
    description='Total number of log lines of level: error.',
    datasource='$loki_datasource',
    graphMode='none',
    reducerFunction='sum',
    unit='short',
  ).addThreshold(
    { color: 'rgb(242, 73, 92)', value: 0 }
  )
  .addTarget(
    grafana.loki.target(queries.total_log_errors)
  ),

  error_percentage_panel: grafana.statPanel.new(
    'Error Percentage',
    description='Percentage of log lines with level: Error out of total log lines.',
    datasource='$loki_datasource',
    graphMode='none',
    reducerFunction='lastNotNull',
    unit='percent',
  ).addThresholds([
    { color: 'rgb(255, 166, 176)', value: 0 },
    { color: 'rgb(255, 115, 131)', value: 25 },
    { color: 'rgb(196, 22, 42)', value: 50 },
  ])
  .addTarget(
    grafana.loki.target(queries.error_percentage)
  ),

  total_bytes_panel: grafana.statPanel.new(
    'Bytes Used',
    description='Total number of bytes for log lines including errors and warnings.',
    datasource='$loki_datasource',
    graphMode='none',
    reducerFunction='sum',
    unit='bytes',
  )
  .addThreshold(
    { color: 'rgb(184, 119, 217)', value: 0 }
  )
  .addTarget(
    grafana.loki.target(queries.total_bytes)
  ),

  historical_logs_errors_warnings_panel: custom_barchart_grafonnet.new(
    q1=queries.total_log_lines,
    q2=queries.total_log_warnings,
    q3=queries.total_log_errors,
  ),

  log_errors_panel: grafana.logPanel.new(
    'Errors',
    datasource='$loki_datasource',
  )
  .addTarget(
    grafana.loki.target(queries.error_log_lines)
  ),

  log_warnings_panel: grafana.logPanel.new(
    'Warnings',
    datasource='$loki_datasource',
  )
  .addTarget(
    grafana.loki.target(queries.warning_log_lines)
  ),

  log_full_panel: grafana.logPanel.new(
    'Full Log File',
    datasource='$loki_datasource',
  )
  .addTarget(
    grafana.loki.target(queries.log_full_lines)
  ),
}