local grafana = import 'grafonnet/grafana.libsonnet';

local loki(q) = {
  target: grafana.loki.target(q.query),
  docs: q.docs,
};

function(queries) {
  total_log_lines: loki(queries.total_log_lines),
  total_log_warnings: loki(queries.total_log_warnings),
  total_log_errors: loki(queries.total_log_errors),
  error_percentage: loki(queries.error_percentage),
  total_bytes: loki(queries.total_bytes),
  error_log_lines: loki(queries.error_log_lines),
  warning_log_lines: loki(queries.warning_log_lines),
  log_full_lines: loki(queries.log_full_lines),
}

