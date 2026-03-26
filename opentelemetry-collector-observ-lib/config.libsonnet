{
  local this = self,
  filteringSelector: 'service_name!=""',
  alertsFilteringSelector: 'service_name=~".+", service_instance_id=~".+"',
  groupLabels: ['service_name'],
  instanceLabels: ['service_instance_id'],
  uid: 'otelcol',
  dashboardNamePrefix: '',
  dashboardTags: ['opentelemetry', 'collector'],
  metricsSource: 'otelcol',
  signals+:
    {
      receiver: (import './signals/receiver.libsonnet')(this),
      processor: (import './signals/processor.libsonnet')(this),
      exporter: (import './signals/exporter.libsonnet')(this),
    },
  alerts: {
    queueSaturation: {
      warn: '0.8',
    },
  },
}
