(import 'ksonnet-util/kausal.libsonnet') +
(import 'images.libsonnet') +
(import 'lib/alertmanager.libsonnet') +
(import 'lib/grafana.libsonnet') +
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
  // Delete obsolete node-related dashboards from the k8s mixin.
  // Once we can use the current version of the k8s mixin, those
  // overrides can be removed.
  grafanaDashboards+:: {
    'k8s-cluster-rsrc-use.json': null,
    'k8s-node-rsrc-use.json': null,
    'k8s-multicluster-rsrc-use.json': null,
  },
}
