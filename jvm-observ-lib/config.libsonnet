{
  local this = self,
  filteringSelector: 'job!=""',
  groupLabels: ['job'],
  instanceLabels: ['instance'],
  uid: 'jvm',
  dashboardNamePrefix: '',
  dashboardTags: ['java', 'jvm'],
  metricsSource: ['java_micrometer', 'prometheus', 'prometheus_old', 'otel', 'jmx_exporter'],
  signals+:
    {
      memory: (import './signals/memory.libsonnet')(this),
      gc: (import './signals/gc.libsonnet')(this),
      threads: (import './signals/threads.libsonnet')(this),
      buffers: (import './signals/buffers.libsonnet')(this),
      classes: (import './signals/classes.libsonnet')(this),
      logback: (import './signals/logback.libsonnet')(this),
      hikari: (import './signals/hikari.libsonnet')(this),
    },
  alertHeapWarning: 80,  // %
}
