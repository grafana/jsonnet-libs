local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

local prometheusQuery = g.query.prometheus;
local variables = import './variables.libsonnet';

{
  // Existing queries (modified to work with instance variable)
  cpuUsage:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        sum by (job, cluster, namespace, instance) (
            rate(
                {
                    __name__=~"otelcol_process_cpu_seconds(_total)?",
                    job=~"$job",
                    cluster=~"$cluster",
                    namespace=~"$namespace",
                    instance=~"$instance"
                }
            [$__rate_interval])
        )
      |||
    )
    + prometheusQuery.withIntervalFactor(2)
    + prometheusQuery.withLegendFormat(|||
      {{cluster}} - {{namespace}} - {{instance}}
    |||),

  memUsageRSS:
    [
      prometheusQuery.new(
        '$' + variables.datasourceVariable.name,
        |||
          sum by (job, cluster, namespace, instance) (
            {__name__=~"otelcol_process_memory_rss(_bytes)?", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}
          )
        |||
      )
      + prometheusQuery.withIntervalFactor(2)
      + prometheusQuery.withLegendFormat(|||
        RSS - {{cluster}} - {{namespace}} - {{instance}}
      |||),
    ],

  memUsageHeapAlloc:
    [
      prometheusQuery.new(
        '$' + variables.datasourceVariable.name,
        |||
          sum by (job, cluster, namespace, instance) (
            {__name__=~"otelcol_process_runtime_total_sys_memory_bytes(_total)?", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}
          )
        |||
      )
      + prometheusQuery.withIntervalFactor(2)
      + prometheusQuery.withLegendFormat(|||
        RSS - {{cluster}} - {{namespace}} - {{instance}}
      |||),
    ],

  // Fleet Overview queries
  runningCollectors:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        count({__name__=~"otelcol_process_uptime(_seconds_total)?", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"})
      |||
    ),

  collectorUptime:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        {__name__=~"otelcol_process_uptime(_seconds_total)?", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}
      |||
    )
    + prometheusQuery.withFormat('table')
    + prometheusQuery.withInstant(true),

  // Receivers status queries
  acceptedMetricPoints:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        sum by(job, cluster, namespace, instance) (rate({__name__=~"otelcol_receiver_accepted_metric_points(_total)?", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval]))
      |||
    )
    + prometheusQuery.withLegendFormat('{{cluster}} - {{namespace}} - {{instance}}'),

  acceptedLogRecords:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        sum by(job, cluster, namespace, instance) (rate({__name__=~"otelcol_receiver_accepted_log_records(_total)?", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval]))
      |||
    )
    + prometheusQuery.withLegendFormat('{{cluster}} - {{namespace}} - {{instance}}'),

  acceptedSpans:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        sum by(job, cluster, namespace, instance) (rate({__name__=~"otelcol_receiver_accepted_spans(_total)?", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval]))
      |||
    )
    + prometheusQuery.withLegendFormat('{{cluster}} - {{namespace}} - {{instance}}'),

  incomingItems:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        sum by(job, cluster, namespace, instance) (rate({__name__=~"otelcol_processor_incoming_items(_total)?", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval]))
      |||
    )
    + prometheusQuery.withLegendFormat('{{cluster}} - {{namespace}} - {{instance}}'),

  refusedMetricPoints:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        sum by(job, cluster, namespace, instance) (rate({__name__=~"otelcol_receiver_refused_metric_points(_total)?", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval]))
      |||
    )
    + prometheusQuery.withLegendFormat('{{cluster}} - {{namespace}} - {{instance}}'),

  refusedLogRecords:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        sum by(job, cluster, namespace, instance) (rate({__name__=~"otelcol_receiver_refused_log_records(_total)?", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval]))
      |||
    )
    + prometheusQuery.withLegendFormat('{{cluster}} - {{namespace}} - {{instance}}'),

  refusedSpans:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        sum by(job, cluster, namespace, instance) (rate({__name__=~"otelcol_receiver_refused_spans(_total)?", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval]))
      |||
    )
    + prometheusQuery.withLegendFormat('{{cluster}} - {{namespace}} - {{instance}}'),

  outgoingItems:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        sum by(job, cluster, namespace, instance) (rate({__name__=~"otelcol_processor_outgoing_items(_total)?", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval]))
      |||
    )
    + prometheusQuery.withLegendFormat('{{cluster}} - {{namespace}} - {{instance}}'),

  // Processors status queries
  batchSendSize:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        sum by (job, cluster, namespace, instance, le) (increase({__name__=~"otelcol_processor_batch_batch_send_size_bucket", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval]))
      |||
    )
    + prometheusQuery.withLegendFormat('{{cluster}} - {{namespace}} - {{instance}} - {{le}}'),

  batchCardinality:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        sum by(job, cluster, namespace, instance) ({__name__=~"otelcol_processor_batch_metadata_cardinality(_total)?", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"})
      |||
    )
    + prometheusQuery.withLegendFormat('{{cluster}} - {{namespace}} - {{instance}}'),

  queueSize:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        sum by(job, cluster, namespace, instance) ({__name__=~"otelcol_exporter_queue_size(_total)?", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"})
      |||
    )
    + prometheusQuery.withLegendFormat('{{cluster}} - {{namespace}} - {{instance}} queue current size'),

  queueCapacity:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        sum by(job, cluster, namespace, instance) ({__name__=~"otelcol_exporter_queue_capacity(_total)?", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"})
      |||
    )
    + prometheusQuery.withLegendFormat('{{cluster}} - {{namespace}} - {{instance}} queue capacity'),

  batchSizeSendTrigger:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        sum by(job, cluster, namespace, instance) (rate({__name__=~"otelcol_processor_batch_timeout_trigger_send(_total)?", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval]))
      |||
    ),

  batchTimeoutSendTrigger:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        sum by(job, cluster, namespace, instance) (rate({__name__=~"otelcol_processor_batch_timeout_trigger_send(_total)?", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval]))
      |||
    )
    + prometheusQuery.withLegendFormat('{{cluster}} - {{namespace}} - {{instance}}'),

  // Exporters status queries
  exportedMetrics:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        sum by(job, cluster, namespace, instance) (rate({__name__=~"otelcol_exporter_sent_metric_points(_total)?", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval]))
      |||
    )
    + prometheusQuery.withLegendFormat('{{cluster}} - {{namespace}} - {{instance}}'),

  exportedLogs:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        sum by(job, cluster, namespace, instance) (rate({__name__=~"otelcol_exporter_sent_log_records(_total)?", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval]))
      |||
    ),

  exportedSpans:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        sum by(job, cluster, namespace, instance) (rate({__name__=~"otelcol_exporter_sent_spans(_total)?", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval]))
      |||
    )
    + prometheusQuery.withLegendFormat('{{cluster}} - {{namespace}} - {{instance}}'),

  failedMetrics:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        sum by(job, cluster, namespace, instance) (rate({__name__=~"otelcol_exporter_send_failed_metric_points(_total)?", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval]))
      |||
    )
    + prometheusQuery.withLegendFormat('{{cluster}} - {{namespace}} - {{instance}}'),

  failedLogs:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        sum by(job, cluster, namespace, instance) (rate({__name__=~"otelcol_exporter_send_failed_log_records(_total)?", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval]))
      |||
    )
    + prometheusQuery.withLegendFormat('{{cluster}} - {{namespace}} - {{instance}}'),

  failedSpans:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        sum by(job, cluster, namespace, instance) (rate({__name__=~"otelcol_exporter_send_failed_spans(_total)?", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval]))
      |||
    )
    + prometheusQuery.withLegendFormat('{{cluster}} - {{namespace}} - {{instance}}'),

  enqueueFailedMetrics:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        sum by(job, cluster, namespace, instance) (rate({__name__=~"otelcol_exporter_enqueue_failed_metric_points(_total)?", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval]))
      |||
    )
    + prometheusQuery.withLegendFormat('{{cluster}} - {{namespace}} - {{instance}}'),

  enqueueFailedLogs:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        sum by(job, cluster, namespace, instance) (rate({__name__=~"otelcol_exporter_enqueue_failed_log_records(_total)?", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval]))
      |||
    )
    + prometheusQuery.withLegendFormat('{{cluster}} - {{namespace}} - {{instance}}'),

  enqueueFailedSpans:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        sum by(job, cluster, namespace, instance) (rate({__name__=~"otelcol_exporter_enqueue_failed_spans(_total)?", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval]))
      |||
    )
    + prometheusQuery.withLegendFormat('{{cluster}} - {{namespace}} - {{instance}}'),

  // Network traffic queries
  grpcInboundDurationP50:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        histogram_quantile(0.50, sum by (job, cluster, namespace, instance, le) (rate({__name__=~"rpc_server_duration_milliseconds_bucket", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval])))
      |||
    )
    + prometheusQuery.withLegendFormat('p50 - {{cluster}} - {{namespace}} - {{instance}}'),

  grpcInboundDurationP90:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        histogram_quantile(0.90, sum by (job, cluster, namespace, instance, le) (rate({__name__=~"rpc_server_duration_milliseconds_bucket", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval])))
      |||
    )
    + prometheusQuery.withLegendFormat('p90 - {{cluster}} - {{namespace}} - {{instance}}'),

  grpcInboundDurationP99:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        histogram_quantile(0.99, sum by (job, cluster, namespace, instance, le) (rate({__name__=~"rpc_server_duration_milliseconds_bucket", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval])))
      |||
    )
    + prometheusQuery.withLegendFormat('p99 - {{cluster}} - {{namespace}} - {{instance}}'),

  httpInboundDurationP50:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        histogram_quantile(0.50, sum by (job, cluster, namespace, instance, le) (rate({__name__=~"http_server_request_duration_seconds_bucket", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval])))
      |||
    )
    + prometheusQuery.withLegendFormat('p50 - {{cluster}} - {{namespace}} - {{instance}}'),

  httpInboundDurationP90:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        histogram_quantile(0.90, sum by (job, cluster, namespace, instance, le) (rate({__name__=~"http_server_request_duration_seconds_bucket", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval])))
      |||
    )
    + prometheusQuery.withLegendFormat('p90 - {{cluster}} - {{namespace}} - {{instance}}'),

  httpInboundDurationP99:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        histogram_quantile(0.99, sum by (job, cluster, namespace, instance, le) (rate({__name__=~"http_server_request_duration_seconds_bucket", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval])))
      |||
    )
    + prometheusQuery.withLegendFormat('p99 - {{cluster}} - {{namespace}} - {{instance}}'),

  grpcInboundSizeP50:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        histogram_quantile(0.50, sum by (job, cluster, namespace, instance, le) (rate({__name__=~"rpc_server_request_size_bytes_bucket", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval])))
      |||
    )
    + prometheusQuery.withLegendFormat('p50 - {{cluster}} - {{namespace}} - {{instance}}'),

  grpcInboundSizeP90:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        histogram_quantile(0.90, sum by (job, cluster, namespace, instance, le) (rate({__name__=~"rpc_server_request_size_bytes_bucket", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval])))
      |||
    )
    + prometheusQuery.withLegendFormat('p90 - {{cluster}} - {{namespace}} - {{instance}}'),

  grpcInboundSizeP99:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        histogram_quantile(0.99, sum by (job, cluster, namespace, instance, le) (rate({__name__=~"rpc_server_request_size_bytes_bucket", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval])))
      |||
    )
    + prometheusQuery.withLegendFormat('p99 - {{cluster}} - {{namespace}} - {{instance}}'),

  httpInboundSizeP50:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        histogram_quantile(0.50, sum by (job, cluster, namespace, instance, le) (rate({__name__=~"http_server_request_body_size_bytes_bucket", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval])))
      |||
    )
    + prometheusQuery.withLegendFormat('p50 - {{cluster}} - {{namespace}} - {{instance}}'),

  httpInboundSizeP90:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        histogram_quantile(0.90, sum by (job, cluster, namespace, instance, le) (rate({__name__=~"http_server_request_body_size_bytes_bucket", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval])))
      |||
    )
    + prometheusQuery.withLegendFormat('p90 - {{cluster}} - {{namespace}} - {{instance}}'),

  httpInboundSizeP99:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        histogram_quantile(0.99, sum by (job, cluster, namespace, instance, le) (rate({__name__=~"http_server_request_body_size_bytes_bucket", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval])))
      |||
    )
    + prometheusQuery.withLegendFormat('p99 - {{cluster}} - {{namespace}} - {{instance}}'),

  grpcOutboundDurationP50:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        histogram_quantile(0.50, sum by (job, cluster, namespace, instance, le) (rate({__name__=~"rpc_client_duration_milliseconds_bucket", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval])))
      |||
    )
    + prometheusQuery.withLegendFormat('p50 - {{cluster}} - {{namespace}} - {{instance}}'),

  grpcOutboundDurationP90:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        histogram_quantile(0.90, sum by (job, cluster, namespace, instance, le) (rate({__name__=~"rpc_client_duration_milliseconds_bucket", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval])))
      |||
    )
    + prometheusQuery.withLegendFormat('p90 - {{cluster}} - {{namespace}} - {{instance}}'),

  grpcOutboundDurationP99:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        histogram_quantile(0.99, sum by (job, cluster, namespace, instance, le) (rate({__name__=~"rpc_client_duration_milliseconds_bucket", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval])))
      |||
    )
    + prometheusQuery.withLegendFormat('p99 - {{cluster}} - {{namespace}} - {{instance}}'),

  httpOutboundDurationP50:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        histogram_quantile(0.50, sum by (job, cluster, namespace, instance, le) (rate({__name__=~"http_client_request_duration_seconds_bucket", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval])))
      |||
    )
    + prometheusQuery.withLegendFormat('p50 - {{cluster}} - {{namespace}} - {{instance}}'),

  httpOutboundDurationP90:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        histogram_quantile(0.90, sum by (job, cluster, namespace, instance, le) (rate({__name__=~"http_client_request_duration_seconds_bucket", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval])))
      |||
    )
    + prometheusQuery.withLegendFormat('p90 - {{cluster}} - {{namespace}} - {{instance}}'),

  httpOutboundDurationP99:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        histogram_quantile(0.99, sum by (job, cluster, namespace, instance, le) (rate({__name__=~"http_client_request_duration_seconds_bucket", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval])))
      |||
    )
    + prometheusQuery.withLegendFormat('p99 - {{cluster}} - {{namespace}} - {{instance}}'),

  grpcOutboundSizeP50:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        histogram_quantile(0.50, sum by (job, cluster, namespace, instance, le) (rate({__name__=~"rpc_client_request_size(_bytes_?)_bucket", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval])))
      |||
    )
    + prometheusQuery.withLegendFormat('p50 - {{cluster}} - {{namespace}} - {{instance}}'),

  grpcOutboundSizeP90:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        histogram_quantile(0.90, sum by (job, cluster, namespace, instance, le) (rate({__name__=~"rpc_client_request_size(_bytes_?)_bucket", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval])))
      |||
    )
    + prometheusQuery.withLegendFormat('p90 - {{cluster}} - {{namespace}} - {{instance}}'),

  grpcOutboundSizeP99:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        histogram_quantile(0.99, sum by (job, cluster, namespace, instance, le) (rate({__name__=~"rpc_client_request_size(_bytes_?)_bucket", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval])))
      |||
    )
    + prometheusQuery.withLegendFormat('p99 - {{cluster}} - {{namespace}} - {{instance}}'),

  httpOutboundSizeP50:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        histogram_quantile(0.50, sum by (job, cluster, namespace, instance, le) (rate({__name__=~"http_client_request_body_size_bytes_bucket", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval])))
      |||
    )
    + prometheusQuery.withLegendFormat('p50 - {{cluster}} - {{namespace}} - {{instance}}'),

  httpOutboundSizeP90:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        histogram_quantile(0.90, sum by (job, cluster, namespace, instance, le) (rate({__name__=~"http_client_request_body_size_bytes_bucket", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval])))
      |||
    )
    + prometheusQuery.withLegendFormat('p90 - {{cluster}} - {{namespace}} - {{instance}}'),

  httpOutboundSizeP99:
    prometheusQuery.new(
      '$' + variables.datasourceVariable.name,
      |||
        histogram_quantile(0.99, sum by (job, cluster, namespace, instance, le) (rate({__name__=~"http_client_request_body_size_bytes_bucket", job=~"$job", cluster=~"$cluster", namespace=~"$namespace", instance=~"$instance"}[$__rate_interval])))
      |||
    )
    + prometheusQuery.withLegendFormat('p99 - {{cluster}} - {{namespace}} - {{instance}}'),
}
