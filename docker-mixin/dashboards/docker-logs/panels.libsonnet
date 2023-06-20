local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local custom_barchart_grafonnet = import '../../lib/custom-barchart-grafonnet/custom-barchart.libsonnet';

function(targets) {
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
  .addTarget(targets.total_log_lines.target),

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
  .addTarget(targets.total_log_warnings.target),

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
  .addTarget(targets.total_log_errors.target),

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
  .addTarget(targets.error_percentage.target),

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
  .addTarget(targets.total_bytes.target),

  historical_logs_errors_warnings_panel: custom_barchart_grafonnet.new(
    q1=targets.total_log_lines.target.expr,
    q2=targets.total_log_warnings.target.expr,
    q3=targets.total_log_errors.target.expr,
  ),

  log_errors_panel: grafana.logPanel.new(
    'Errors',
    datasource='$loki_datasource',
  )
  .addTarget(targets.error_log_lines.target),

  log_warnings_panel: grafana.logPanel.new(
    'Warnings',
    datasource='$loki_datasource',
  )
  .addTarget(targets.warning_log_lines.target),

  log_full_panel: grafana.logPanel.new(
    'Full Log File',
    datasource='$loki_datasource',
  )
  .addTarget(targets.log_full_lines.target),
}