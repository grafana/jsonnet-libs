{
  _images+:: {
    prometheus: 'prom/prometheus:v2.9.2',
    grafana: 'grafana/grafana:6.0.2',
    watch: 'weaveworks/watch:master-5b2a6e5',
    kubeStateMetrics: 'gcr.io/google_containers/kube-state-metrics:v1.4.0',
    gfdatasource: 'quay.io/weaveworks/gfdatasource:master-2bda599',
    alertmanager: 'prom/alertmanager:v0.16.2',
    nodeExporter: 'prom/node-exporter:v0.16.0',
    nginx: 'nginx:1.15.1-alpine',
  },
}
