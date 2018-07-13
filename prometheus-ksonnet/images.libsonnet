{
  _images+:: {
    prometheus: 'prom/prometheus:v2.3.1',
    watch: 'weaveworks/watch:master-5b2a6e5',
    kubeStateMetrics: 'gcr.io/google_containers/kube-state-metrics:v1.3.1',
    grafana: 'grafana/grafana:5.2.1',
    gfdatasource: 'quay.io/weaveworks/gfdatasource:master-2bda599',
    alertmanager: 'prom/alertmanager:v0.15.0',
    nodeExporter: 'prom/node-exporter:v0.15.2',
    nginx: 'nginx:1.15.1-alpine',
  },
}
