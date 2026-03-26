local common = import './signals/common.libsonnet';

{
  new(this): {
    local alertConfig = this.config { filteringSelector: this.config.alertsFilteringSelector },

    groups: [
      {
        name: this.config.uid + '-rules',
        rules:
          [
            {
              alert: 'ExporterQueueSaturated',
              expr: 'sum(otelcol_exporter_queue_size{%(filteringSelector)s}) by (data_type,service_instance_id,exporter) / sum(otelcol_exporter_queue_capacity{%(filteringSelector)s}) by (data_type,service_instance_id,exporter) > %(threshold)s' % alertConfig {
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
              expr: 'sum(rate(otelcol_exporter_enqueue_failed_%(metric_id)s_total{%(filteringSelector)s}[5m])) by (exporter,service_instance_id) > 0' % (signal + alertConfig),
              'for': '5m',
              keep_firing_for: '5m',
              labels: {
                collector_distro_name: 'opentelemetry-collector',
                severity: 'critical',
              },
              annotations: {
                summary: 'Failed to enqueue %(plural)s for export.' % signal,
                description: 'Collector {{ $labels.service_instance_id }} failed to enqueue %(plural)s for the {{ $labels.exporter }}' % signal,
              },
            }
            for signal in common.signalTypes
          ],
      },
    ],
  },
}
