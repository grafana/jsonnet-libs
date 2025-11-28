{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'otelcol',
        rules: [
          {
            alert: 'ReceiverDroppedSpans',
            expr: |||
              rate(otelcol_receiver_refused_spans_total[5m]) > 0
            |||,
            'for': '2m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Receiver is dropping spans.',
              description: 'The {{ $labels.receiver }} receiver is dropping spans at a rate of {{ humanize $value }} per second.',
              runbook_url: 'https://opentelemetry.io/docs/collector/internal-telemetry/#receive-failures',
            },
          },
          {
            alert: 'ReceiverDroppedMetrics',
            expr: |||
              rate(otelcol_receiver_refused_metric_points_total[5m]) > 0
            |||,
            'for': '2m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Receiver is dropping metrics.',
              description: 'The {{ $labels.receiver }} receiver is dropping metrics at a rate of {{ humanize $value }} per second.',
              runbook_url: 'https://opentelemetry.io/docs/collector/internal-telemetry/#receive-failures',
            },
          },
          {
            alert: 'ReceiverDroppedLogs',
            expr: |||
              rate(otelcol_receiver_refused_log_records_total[5m]) > 0
            |||,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Receiver is dropping logs.',
              description: 'The {{ $labels.receiver }} is dropping logs at a rate of {{ humanize $value }} per second.',
              runbook_url: 'https://opentelemetry.io/docs/collector/internal-telemetry/#receive-failures',
            },
          },
          {
            alert: 'ExporterDroppedSpans',
            expr: |||
              rate(otelcol_exporter_send_failed_spans_total[5m]) > 0
            |||,
            'for': '2m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Exporter is dropping spans.',
              description: 'The {{ $labels.exporter }} exporter is dropping spans at a rate of {{ humanize $value }} per second.',
              runbook_url: 'https://opentelemetry.io/docs/collector/internal-telemetry/#send-failures',
            },
          },
          {
            alert: 'ExporterDroppedMetrics',
            expr: |||
              rate(otelcol_exporter_send_failed_metric_points_total[5m]) > 0
            |||,
            'for': '2m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Exporter is dropping metrics.',
              description: 'The {{ $labels.exporter }} exporter is dropping metrics at a rate of {{ humanize $value }} per second.',
              runbook_url: 'https://opentelemetry.io/docs/collector/internal-telemetry/#send-failures',
            },
          },
          {
            alert: 'ExporterDroppedLogs',
            expr: |||
              rate(otelcol_exporter_send_failed_log_records_total[5m]) > 0
            |||,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Exporter is dropping logs.',
              description: 'The {{ $labels.exporter }} is dropping logs at a rate of {{ humanize $value }} per second.',
              runbook_url: 'https://opentelemetry.io/docs/collector/internal-telemetry/#send-failures',
            },
          },
          {
            alert: 'ExporterQueueSize',
            expr: |||
              otelcol_exporter_queue_size > otelcol_exporter_queue_capacity * 0.8
            |||,
            'for': '1m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Exporter queue is filling up.',
              description: 'The {{ $labels.exporter }} queue has reached a size of {{ $value }}.',
              runbook_url: 'https://opentelemetry.io/docs/collector/internal-telemetry/#queue-length',
            },
          },
          {
            alert: 'SendQueueFailedSpans',
            expr: |||
              rate(otelcol_exporter_enqueue_failed_spans_total[5m]) > 0
            |||,
            'for': '1m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Exporter send queue failed to accept spans.',
              description: 'The {{ $labels.exporter }} sending queue failed to accept {{ $value }} spans.',
              runbook_url: 'https://opentelemetry.io/docs/collector/internal-telemetry/#queue-length',
            },
          },
          {
            alert: 'SendQueueFailedMetricPoints',
            expr: |||
              rate(otelcol_exporter_enqueue_failed_metric_points_total[5m]) > 0
            |||,
            'for': '1m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Exporter send queue failed to accept metric points.',
              description: 'The {{ $labels.exporter }} sending queue failed to accept {{ $value }} metric points.',
              runbook_url: 'https://opentelemetry.io/docs/collector/internal-telemetry/#queue-length',
            },
          },
          {
            alert: 'SendQueueFailedLogRecords',
            expr: |||
              rate(otelcol_exporter_enqueue_failed_log_records_total[5m]) > 0
            |||,
            'for': '1m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Exporter send queue failed to accept log records.',
              description: 'The {{ $labels.exporter }} sending queue failed to accept {{ $value }} log records.',
              runbook_url: 'https://opentelemetry.io/docs/collector/internal-telemetry/#queue-length',
            },
          },
        ],
      },
    ],
  },
}
