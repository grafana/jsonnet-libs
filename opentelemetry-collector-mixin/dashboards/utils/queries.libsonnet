local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

local prometheusQuery = g.query.prometheus;
local variables = import './variables.libsonnet';
local cfg = import '../../config.libsonnet';

// Build dynamic label selectors and legend formats
local groupByLabels = std.join(', ', cfg._config.groupLabels + cfg._config.instanceLabels);
local legendFormat = commonlib.utils.labelsToPanelLegend(cfg._config.groupLabels + cfg._config.instanceLabels);

// Helper function to create queries with dynamic selectors
local buildQuery(queryTemplate, legendPrefix='', format='') =
  prometheusQuery.new(
    '$' + variables.datasources.prometheus.name,
    queryTemplate % {
      groupByLabels: groupByLabels,
      selector: variables.queriesSelector,
    }
  )
  + prometheusQuery.withIntervalFactor(2)
  + prometheusQuery.withLegendFormat(
    if legendPrefix != '' then legendPrefix + ' - ' + legendFormat
    else legendFormat
  )
  + (if format != '' then prometheusQuery.withFormat(format) else {})
  + (if format == 'table' then prometheusQuery.withInstant(true) else {});

{
  // Process metrics
  cpuUsage:
    buildQuery(|||
      sum by (%(groupByLabels)s) (
          rate(
              {
                  __name__=~"otelcol_process_cpu_seconds(_total)?",
                  %(selector)s
              }
          [$__rate_interval])
      )
    |||),

  memUsageRSS:
    [
      buildQuery(|||
        sum by (%(groupByLabels)s) (
          {__name__=~"otelcol_process_memory_rss(_bytes)?", %(selector)s}
        )
      |||, 'RSS'),
    ],

  memUsageHeapAlloc:
    [
      buildQuery(|||
        sum by (%(groupByLabels)s) (
          {__name__=~"otelcol_process_runtime_total_sys_memory_bytes(_total)?", %(selector)s}
        )
      |||, 'RSS'),
    ],

  // Fleet Overview queries
  runningCollectors:
    prometheusQuery.new(
      '$' + variables.datasources.prometheus.name,
      |||
        count({__name__=~"otelcol_process_uptime(_seconds_total)?", %(selector)s})
      ||| % {
        selector: variables.queriesSelector,
      }
    ),

  collectorUptime:
    buildQuery(|||
      {__name__=~"otelcol_process_uptime(_seconds_total)?", %(selector)s}
    |||, format='table'),

  // Receivers status queries
  acceptedMetricPoints:
    buildQuery(|||
      sum by(%(groupByLabels)s) (rate({__name__=~"otelcol_receiver_accepted_metric_points(_total)?", %(selector)s}[$__rate_interval]))
    |||),

  acceptedLogRecords:
    buildQuery(|||
      sum by(%(groupByLabels)s) (rate({__name__=~"otelcol_receiver_accepted_log_records(_total)?", %(selector)s}[$__rate_interval]))
    |||),

  acceptedSpans:
    buildQuery(|||
      sum by(%(groupByLabels)s) (rate({__name__=~"otelcol_receiver_accepted_spans(_total)?", %(selector)s}[$__rate_interval]))
    |||),

  incomingItems:
    buildQuery(|||
      sum by(%(groupByLabels)s) (rate({__name__=~"otelcol_processor_incoming_items(_total)?", %(selector)s}[$__rate_interval]))
    |||),

  refusedMetricPoints:
    buildQuery(|||
      sum by(%(groupByLabels)s) (rate({__name__=~"otelcol_receiver_refused_metric_points(_total)?", %(selector)s}[$__rate_interval]))
    |||),

  refusedLogRecords:
    buildQuery(|||
      sum by(%(groupByLabels)s) (rate({__name__=~"otelcol_receiver_refused_log_records(_total)?", %(selector)s}[$__rate_interval]))
    |||),

  refusedSpans:
    buildQuery(|||
      sum by(%(groupByLabels)s) (rate({__name__=~"otelcol_receiver_refused_spans(_total)?", %(selector)s}[$__rate_interval]))
    |||),

  outgoingItems:
    buildQuery(|||
      sum by(%(groupByLabels)s) (rate({__name__=~"otelcol_processor_outgoing_items(_total)?", %(selector)s}[$__rate_interval]))
    |||),

  // Processors status queries
  batchSendSize:
    buildQuery(|||
      sum by (%(groupByLabels)s, le) (increase({__name__=~"otelcol_processor_batch_batch_send_size_bucket", %(selector)s}[$__rate_interval]))
    |||),

  batchCardinality:
    buildQuery(|||
      sum by(%(groupByLabels)s) ({__name__=~"otelcol_processor_batch_metadata_cardinality(_total)?", %(selector)s})
    |||),

  queueSize:
    buildQuery(|||
      sum by(%(groupByLabels)s) ({__name__=~"otelcol_exporter_queue_size(_total)?", %(selector)s})
    |||, 'queue current size'),

  queueCapacity:
    buildQuery(|||
      sum by(%(groupByLabels)s) ({__name__=~"otelcol_exporter_queue_capacity(_total)?", %(selector)s})
    |||, 'queue capacity'),

  batchSizeSendTrigger:
    prometheusQuery.new(
      '$' + variables.datasources.prometheus.name,
      |||
        sum by(%(groupByLabels)s) (rate({__name__=~"otelcol_processor_batch_timeout_trigger_send(_total)?", %(selector)s}[$__rate_interval]))
      ||| % {
        groupByLabels: groupByLabels,
        selector: variables.queriesSelector,
      }
    ),

  batchTimeoutSendTrigger:
    buildQuery(|||
      sum by(%(groupByLabels)s) (rate({__name__=~"otelcol_processor_batch_timeout_trigger_send(_total)?", %(selector)s}[$__rate_interval]))
    |||),

  // Exporters status queries
  exportedMetrics:
    buildQuery(|||
      sum by(%(groupByLabels)s) (rate({__name__=~"otelcol_exporter_sent_metric_points(_total)?", %(selector)s}[$__rate_interval]))
    |||),

  exportedLogs:
    prometheusQuery.new(
      '$' + variables.datasources.prometheus.name,
      |||
        sum by(%(groupByLabels)s) (rate({__name__=~"otelcol_exporter_sent_log_records(_total)?", %(selector)s}[$__rate_interval]))
      ||| % {
        groupByLabels: groupByLabels,
        selector: variables.queriesSelector,
      }
    ),

  exportedSpans:
    buildQuery(|||
      sum by(%(groupByLabels)s) (rate({__name__=~"otelcol_exporter_sent_spans(_total)?", %(selector)s}[$__rate_interval]))
    |||),

  failedMetrics:
    buildQuery(|||
      sum by(%(groupByLabels)s) (rate({__name__=~"otelcol_exporter_send_failed_metric_points(_total)?", %(selector)s}[$__rate_interval]))
    |||),

  failedLogs:
    buildQuery(|||
      sum by(%(groupByLabels)s) (rate({__name__=~"otelcol_exporter_send_failed_log_records(_total)?", %(selector)s}[$__rate_interval]))
    |||),

  failedSpans:
    buildQuery(|||
      sum by(%(groupByLabels)s) (rate({__name__=~"otelcol_exporter_send_failed_spans(_total)?", %(selector)s}[$__rate_interval]))
    |||),

  enqueueFailedMetrics:
    buildQuery(|||
      sum by(%(groupByLabels)s) (rate({__name__=~"otelcol_exporter_enqueue_failed_metric_points(_total)?", %(selector)s}[$__rate_interval]))
    |||),

  enqueueFailedLogs:
    buildQuery(|||
      sum by(%(groupByLabels)s) (rate({__name__=~"otelcol_exporter_enqueue_failed_log_records(_total)?", %(selector)s}[$__rate_interval]))
    |||),

  enqueueFailedSpans:
    buildQuery(|||
      sum by(%(groupByLabels)s) (rate({__name__=~"otelcol_exporter_enqueue_failed_spans(_total)?", %(selector)s}[$__rate_interval]))
    |||),

  // Network traffic queries
  grpcInboundDurationP50:
    buildQuery(|||
      histogram_quantile(0.50, sum by (%(groupByLabels)s, le) (rate({__name__=~"rpc_server_duration_milliseconds_bucket", %(selector)s}[$__rate_interval])))
    |||, 'p50'),

  grpcInboundDurationP90:
    buildQuery(|||
      histogram_quantile(0.90, sum by (%(groupByLabels)s, le) (rate({__name__=~"rpc_server_duration_milliseconds_bucket", %(selector)s}[$__rate_interval])))
    |||, 'p90'),

  grpcInboundDurationP99:
    buildQuery(|||
      histogram_quantile(0.99, sum by (%(groupByLabels)s, le) (rate({__name__=~"rpc_server_duration_milliseconds_bucket", %(selector)s}[$__rate_interval])))
    |||, 'p99'),

  httpInboundDurationP50:
    buildQuery(|||
      histogram_quantile(0.50, sum by (%(groupByLabels)s, le) (rate({__name__=~"http_server_request_duration_seconds_bucket", %(selector)s}[$__rate_interval])))
    |||, 'p50'),

  httpInboundDurationP90:
    buildQuery(|||
      histogram_quantile(0.90, sum by (%(groupByLabels)s, le) (rate({__name__=~"http_server_request_duration_seconds_bucket", %(selector)s}[$__rate_interval])))
    |||, 'p90'),

  httpInboundDurationP99:
    buildQuery(|||
      histogram_quantile(0.99, sum by (%(groupByLabels)s, le) (rate({__name__=~"http_server_request_duration_seconds_bucket", %(selector)s}[$__rate_interval])))
    |||, 'p99'),

  grpcInboundSizeP50:
    buildQuery(|||
      histogram_quantile(0.50, sum by (%(groupByLabels)s, le) (rate({__name__=~"rpc_server_request_size_bytes_bucket", %(selector)s}[$__rate_interval])))
    |||, 'p50'),

  grpcInboundSizeP90:
    buildQuery(|||
      histogram_quantile(0.90, sum by (%(groupByLabels)s, le) (rate({__name__=~"rpc_server_request_size_bytes_bucket", %(selector)s}[$__rate_interval])))
    |||, 'p90'),

  grpcInboundSizeP99:
    buildQuery(|||
      histogram_quantile(0.99, sum by (%(groupByLabels)s, le) (rate({__name__=~"rpc_server_request_size_bytes_bucket", %(selector)s}[$__rate_interval])))
    |||, 'p99'),

  httpInboundSizeP50:
    buildQuery(|||
      histogram_quantile(0.50, sum by (%(groupByLabels)s, le) (rate({__name__=~"http_server_request_body_size_bytes_bucket", %(selector)s}[$__rate_interval])))
    |||, 'p50'),

  httpInboundSizeP90:
    buildQuery(|||
      histogram_quantile(0.90, sum by (%(groupByLabels)s, le) (rate({__name__=~"http_server_request_body_size_bytes_bucket", %(selector)s}[$__rate_interval])))
    |||, 'p90'),

  httpInboundSizeP99:
    buildQuery(|||
      histogram_quantile(0.99, sum by (%(groupByLabels)s, le) (rate({__name__=~"http_server_request_body_size_bytes_bucket", %(selector)s}[$__rate_interval])))
    |||, 'p99'),

  grpcOutboundDurationP50:
    buildQuery(|||
      histogram_quantile(0.50, sum by (%(groupByLabels)s, le) (rate({__name__=~"rpc_client_duration_milliseconds_bucket", %(selector)s}[$__rate_interval])))
    |||, 'p50'),

  grpcOutboundDurationP90:
    buildQuery(|||
      histogram_quantile(0.90, sum by (%(groupByLabels)s, le) (rate({__name__=~"rpc_client_duration_milliseconds_bucket", %(selector)s}[$__rate_interval])))
    |||, 'p90'),

  grpcOutboundDurationP99:
    buildQuery(|||
      histogram_quantile(0.99, sum by (%(groupByLabels)s, le) (rate({__name__=~"rpc_client_duration_milliseconds_bucket", %(selector)s}[$__rate_interval])))
    |||, 'p99'),

  httpOutboundDurationP50:
    buildQuery(|||
      histogram_quantile(0.50, sum by (%(groupByLabels)s, le) (rate({__name__=~"http_client_request_duration_seconds_bucket", %(selector)s}[$__rate_interval])))
    |||, 'p50'),

  httpOutboundDurationP90:
    buildQuery(|||
      histogram_quantile(0.90, sum by (%(groupByLabels)s, le) (rate({__name__=~"http_client_request_duration_seconds_bucket", %(selector)s}[$__rate_interval])))
    |||, 'p90'),

  httpOutboundDurationP99:
    buildQuery(|||
      histogram_quantile(0.99, sum by (%(groupByLabels)s, le) (rate({__name__=~"http_client_request_duration_seconds_bucket", %(selector)s}[$__rate_interval])))
    |||, 'p99'),

  grpcOutboundSizeP50:
    buildQuery(|||
      histogram_quantile(0.50, sum by (%(groupByLabels)s, le) (rate({__name__=~"rpc_client_request_size(_bytes_?)_bucket", %(selector)s}[$__rate_interval])))
    |||, 'p50'),

  grpcOutboundSizeP90:
    buildQuery(|||
      histogram_quantile(0.90, sum by (%(groupByLabels)s, le) (rate({__name__=~"rpc_client_request_size(_bytes_?)_bucket", %(selector)s}[$__rate_interval])))
    |||, 'p90'),

  grpcOutboundSizeP99:
    buildQuery(|||
      histogram_quantile(0.99, sum by (%(groupByLabels)s, le) (rate({__name__=~"rpc_client_request_size(_bytes_?)_bucket", %(selector)s}[$__rate_interval])))
    |||, 'p99'),

  httpOutboundSizeP50:
    buildQuery(|||
      histogram_quantile(0.50, sum by (%(groupByLabels)s, le) (rate({__name__=~"http_client_request_body_size_bytes_bucket", %(selector)s}[$__rate_interval])))
    |||, 'p50'),

  httpOutboundSizeP90:
    buildQuery(|||
      histogram_quantile(0.90, sum by (%(groupByLabels)s, le) (rate({__name__=~"http_client_request_body_size_bytes_bucket", %(selector)s}[$__rate_interval])))
    |||, 'p90'),

  httpOutboundSizeP99:
    buildQuery(|||
      histogram_quantile(0.99, sum by (%(groupByLabels)s, le) (rate({__name__=~"http_client_request_body_size_bytes_bucket", %(selector)s}[$__rate_interval])))
    |||, 'p99'),
}