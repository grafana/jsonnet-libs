local host_matcher = 'job=~"$job", instance=~"$instance"';
local container_matcher = host_matcher + ', container=~"$container"';

{
  total_log_lines: 'sum(count_over_time({' + container_matcher + '}[$__interval]))',
  total_log_warnings: 'sum(count_over_time({' + container_matcher + '} |= "Warning" [$__interval]))',
  total_log_errors: 'sum(count_over_time({' + container_matcher + '} |= "Error" [$__interval]))',
  error_percentage: 'sum( count_over_time({' + container_matcher + '} |= "Error" [$__interval]) ) / sum( count_over_time({' + container_matcher + '} [$__interval]) )',
  total_bytes: 'sum(bytes_over_time({' + container_matcher + '} [$__interval]))',
  error_log_lines: '{' + container_matcher + '} |= "Error"',
  warning_log_lines: '{' + container_matcher + '} |= "Warning"',
  log_full_lines: '{' + container_matcher + '}',
}

