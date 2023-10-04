local grafana = import 'grafonnet/grafana.libsonnet';
local resource = import '../../lib/resource.libsonnet';
local kind = 'Target';

local host_matcher = 'job=~"$job", instance=~"$instance"';
local container_matcher = host_matcher + ', container=~"$container"';

local logql(q, docs) = resource.new(kind, std.md5(q))
  + resource.withDocs(docs)
  + resource.withSpec(grafana.loki.target(q))
  + resource.withAnnotation('polly.grafana.com/variables', ['job', 'instance', 'container']);

{
  total_log_lines: logql(
    'sum(count_over_time({' + container_matcher + '}[$__interval]))',
    'Total number of log lines for a container',
  ),
  total_log_warnings: logql(
    'sum(count_over_time({' + container_matcher + '} |= "Warning" [$__interval]))',
    'Total number of warning log lines for a container',
  ),
  total_log_errors: logql(
    'sum(count_over_time({' + container_matcher + '} |= "Error" [$__interval]))',
    'Total number of error log lines for a container',
  ),
  error_percentage: logql(
    'sum( count_over_time({' + container_matcher + '} |= "Error" [$__interval]) ) / sum( count_over_time({' + container_matcher + '} [$__interval]) )',
    'Percentage of log lines containing an error',
  ),
  total_bytes: logql(
    'sum(bytes_over_time({' + container_matcher + '} [$__interval]))',
    'Total number of bytes consumed by log lines',
  ),
  error_log_lines: logql(
    '{' + container_matcher + '} |= "Error"',
    'All error log lines',
  ),
  warning_log_lines: logql(
    '{' + container_matcher + '} |= "Warning"',
    'All warning log lines',
  ),
  log_full_lines: logql(
    '{' + container_matcher + '}',
    'All log lines',
  ),
}