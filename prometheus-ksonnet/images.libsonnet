{
  _images+:: {
    prometheus: 'prom/prometheus:v2.22.0',
    grafana: 'grafana/grafana:7.2.2',
    watch: 'weaveworks/watch:master-5fc29a9',
    kubeStateMetrics: 'gcr.io/google_containers/kube-state-metrics:v1.6.0',
    alertmanager: 'prom/alertmanager:v0.21.0',
    nodeExporter: 'prom/node-exporter:v0.18.1',
    nginx: 'nginx:1.15.1-alpine',
  },
}
