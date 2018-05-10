{
  _images+:: {
    prometheus: 'prom/prometheus:v2.2.1',
    watch: 'weaveworks/watch:master-5b2a6e5',
    kubeStateMetrics: 'gcr.io/google_containers/kube-state-metrics:v1.2.0',
    grafana: 'grafana/grafana:5.0.4',
    gfdatasource: 'quay.io/weaveworks/gfdatasource:master-2bda599',
    alertmanager: 'prom/alertmanager:v0.14.0',
    nodeExporter: 'prom/node-exporter:v0.16.0-rc.3',
    nginx: 'nginx:1.13.9',
  },
}
