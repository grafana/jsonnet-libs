{
  proxy: "weaveworks/socksproxy:latest",
  prometheus: "prom/prometheus:v1.7.1",
  watch: "weaveworks/watch:master-5b2a6e5",
  kubeStateMetrics: "gcr.io/google_containers/kube-state-metrics:v0.5.0",
  grafana: "grafana/grafana:4.3.2",
  gfdatasource: "quay.io/weaveworks/gfdatasource:master-2bda599",
  alertmanager: "prom/alertmanager:v0.7.1",
  nodeExporter: "prom/node-exporter:v0.14.0",
}
