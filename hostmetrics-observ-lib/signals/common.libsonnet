{
  // Suffixes that Prometheus-compatible OTLP ingestion adds when suffixes are enabled:
  // unit suffixes (By -> _bytes, s -> _seconds, 1 -> _ratio, Hz -> _hertz) and _total for monotonic sums.
  // Metrics with an annotation-only unit, such as {process}, and non-monotonic sums get no suffix.
  suffixes: {
    system_cpu_frequency: '_hertz',
    system_cpu_time: '_seconds_total',
    system_cpu_utilization: '_ratio',
    system_disk_io: '_bytes_total',
    system_disk_io_time: '_seconds_total',
    system_disk_merged: '_total',
    system_disk_operation_time: '_seconds_total',
    system_disk_operations: '_total',
    system_disk_weighted_io_time: '_seconds_total',
    system_filesystem_usage: '_bytes',
    system_filesystem_utilization: '_ratio',
    system_linux_memory_available: '_bytes',
    system_linux_memory_dirty: '_bytes',
    system_memory_limit: '_bytes',
    system_memory_linux_shared: '_bytes',
    system_memory_usage: '_bytes',
    system_memory_utilization: '_ratio',
    system_network_dropped: '_total',
    system_network_errors: '_total',
    system_network_io: '_bytes_total',
    system_network_packets: '_total',
    system_paging_faults: '_total',
    system_paging_operations: '_total',
    system_paging_usage: '_bytes',
    system_processes_created: '_total',
    system_uptime: '_seconds',
  },

  // Adds suffixes to every metric in expr. Matching on the opening brace keeps
  // system_disk_io from also matching system_disk_io_time.
  withSuffixes(expr)::
    std.foldl(
      function(e, metric) std.strReplace(e, metric + '{', metric + self.suffixes[metric] + '{'),
      std.objectFields(self.suffixes),
      expr
    ),

  // Returns the 'otel' and 'otel_with_suffixes' sources for an expression written with plain names.
  // Any extra source options, such as legendCustomTemplate, apply to both.
  sources(expr, extra={}):: {
    otel: { expr: expr } + extra,
    otel_with_suffixes: { expr: $.withSuffixes(expr) } + extra,
  },

  discoveryMetric: {
    otel: 'system_uptime',
    otel_with_suffixes: 'system_uptime_seconds',
  },
}
