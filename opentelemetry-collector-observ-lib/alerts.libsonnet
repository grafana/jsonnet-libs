local common = import './signals/common.libsonnet';

{
  new(this): {
    local alertConfig = this.config { filteringSelector: this.config.alertsFilteringSelector },
    local instanceLabels = std.join(',', this.config.instanceLabels),
    local instanceLabel = this.config.instanceLabels[-1],

    groups: [
      {
        name: this.config.uid + '-rules',
        rules:
          [
            {
              alert: 'ExporterQueueSaturated',
              expr: 'sum(otelcol_exporter_queue_size{%(filteringSelector)s}) by (data_type,%(instanceLabels)s,exporter) / sum(otelcol_exporter_queue_capacity{%(filteringSelector)s}) by (data_type,%(instanceLabels)s,exporter) > %(threshold)s' % alertConfig {
                instanceLabels: instanceLabels,
                threshold: alertConfig.alerts.queueSaturation.warn,
              },
              'for': '5m',
              keep_firing_for: '5m',
              labels: {
                collector_distro_name: 'opentelemetry-collector',
                severity: 'warning',
              },
              annotations: {
                summary: 'Exporter queue is reaching limit.',
                description: 'The {{ $labels.data_type }} queue of the {{ $labels.exporter }} exporter is almost full ({{ $value }}). It will start dropping data once full',
              },
            },
          ]
          + [
            {
              alert: '%(capitalized)sFailedToSend' % signal,
              expr: 'sum(rate(otelcol_exporter_enqueue_failed_%(metric_id)s_total{%(filteringSelector)s}[5m])) by (exporter,%(instanceLabels)s) > 0' % (signal + alertConfig { instanceLabels: instanceLabels }),
              'for': '5m',
              keep_firing_for: '5m',
              labels: {
                collector_distro_name: 'opentelemetry-collector',
                severity: 'critical',
              },
              annotations: {
                summary: 'Failed to enqueue %(plural)s for export.' % signal,
                description: 'Collector {{ $labels.%(instanceLabel)s }} failed to enqueue %(plural)s for the {{ $labels.exporter }}' % (signal { instanceLabel: instanceLabel }),
              },
            }
            for signal in common.signalTypes
          ],
      },
    ],
  },
}
