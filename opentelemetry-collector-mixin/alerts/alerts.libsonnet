{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'otelcol',
        rules: [
          {
            alert: 'OtelcolSendingQueueFull',
            expr: |||
              otelcol_exporter_queue_size >= otelcol_exporter_queue_capacity
            |||,
            'for': '30m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'The sending queue has filled up.',
              description: 'The sending queue is full for {{ $labels.instance }}. The collector might start dropping data',
            },
          },
        ],
      },
    ],
  },
}
