{
  local this = self,
  filteringSelector: 'job!=""',
  groupLabels: ['job'],
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
}
