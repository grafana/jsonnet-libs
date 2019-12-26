(import 'ksonnet-util/kausal.libsonnet') +
(import 'images.libsonnet') +
(import 'lib/alertmanager.libsonnet') +
(import 'lib/grafana.libsonnet') +
(import 'lib/grafana-configmaps.libsonnet') +
(import 'lib/kube-state-metrics.libsonnet') +
(import 'lib/nginx.libsonnet') +
(import 'lib/node-exporter.libsonnet') +
(import 'lib/prometheus.libsonnet') +
(import 'lib/prometheus-config.libsonnet') +
(import 'kubernetes-mixin/mixin.libsonnet') +
(import 'prometheus-mixin/mixin.libsonnet') +
(import 'alertmanager-mixin/mixin.libsonnet') +
(import 'node-mixin/mixin.libsonnet') +
(import 'lib/config.libsonnet') +
{
  // Mark obsolete node-related dashboards from the k8s mixin as
  // hidden.
  // Once we can use the current version of the k8s mixin, those
  // overrides can be removed.
  // (Note: In jsonnet, you cannot easily remove a field from
  // a tuple. Marking it as hidden is a hack suggested by
  // @sparkprime himself. See https://github.com/google/jsonnet/issues/312
  // for details.)
  grafanaDashboards+:: {
    'k8s-cluster-rsrc-use.json':: super['k8s-cluster-rsrc-use.json'],
    'k8s-node-rsrc-use.json':: super['k8s-node-rsrc-use.json'],
    'k8s-multicluster-rsrc-use.json':: super['k8s-multicluster-rsrc-use.json'],
  },
}
