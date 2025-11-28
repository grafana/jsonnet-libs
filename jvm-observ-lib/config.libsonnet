{
  local this = self,
  filteringSelector: '',  // set to apply static filters to all queries and alerts, i.e. job="bar"
  groupLabels: ['job'],
  instanceLabels: ['instance'],
  uid: 'jvm',
  dashboardNamePrefix: '',
  dashboardTags: ['java', 'jvm'],
  // generate only popular by default. See others options in README.
  metricsSource: ['java_micrometer', 'prometheus', 'otel_old_with_suffixes', 'otel_with_suffixes', 'jmx_exporter'],
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
