local alertmanager_images = import 'alertmanager/images.libsonnet';
local prometheus_images = import 'prometheus/images.libsonnet';

{
  _images+::
    prometheus_images +
    alertmanager_images +
    {
      watch: 'weaveworks/watch:master-5fc29a9',
      kubeStateMetrics: 'gcr.io/google_containers/kube-state-metrics:v1.9.5',
      nodeExporter: 'prom/node-exporter:v0.18.1',
      nginx: 'nginx:1.15.1-alpine',
    },
}
