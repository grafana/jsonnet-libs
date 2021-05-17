local cortex =
  (import 'github.com/grafana/cortex-jsonnet/cortex-mixin/config.libsonnet')
  + (import 'github.com/grafana/cortex-jsonnet/cortex-mixin/dashboards.libsonnet');


cortex + {
  //overrides to go here
  grafanaDashboards:
    (import 'github.com/grafana/cortex-jsonnet/cortex-mixin/dashboards/reads.libsonnet') +
    (import 'github.com/grafana/cortex-jsonnet/cortex-mixin/dashboards/writes.libsonnet') +
    (if std.member($._config.storage_engine, 'blocks')
     then
       (import 'github.com/grafana/cortex-jsonnet/cortex-mixin/dashboards/compactor.libsonnet') +
       (import 'github.com/grafana/cortex-jsonnet/cortex-mixin/dashboards/compactor-resources.libsonnet') +
       (import 'github.com/grafana/cortex-jsonnet/cortex-mixin/dashboards/object-store.libsonnet')
     else {}) +
  { _config:: $._config },
}
