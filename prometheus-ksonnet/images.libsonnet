{
  _images+:: {
    prometheus: 'prom/prometheus:v2.12.0',
    grafana: 'grafana/grafana:6.2.5',
    watch: 'weaveworks/watch:master-5b2a6e5',
    kubeStateMetrics: 'gcr.io/google_containers/kube-state-metrics:v1.6.0',
    alertmanager: 'prom/alertmanager:v0.19.0',
    nodeExporter: 'prom/node-exporter:v0.18.1',
    nginx: 'nginx:1.15.1-alpine',
  },
}
