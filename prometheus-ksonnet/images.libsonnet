{
  _images+:: {
    prometheus: "prom/prometheus:v2.0.0",
    watch: "weaveworks/watch:master-5b2a6e5",
    kubeStateMetrics: "gcr.io/google_containers/kube-state-metrics:v0.5.0",
    grafana: "kausal/grafana:v4.6.2-plus-build-image-c3b097cfc",
    gfdatasource: "quay.io/weaveworks/gfdatasource:master-2bda599",
    alertmanager: "prom/alertmanager:v0.7.1",
    nodeExporter: "prom/node-exporter:v0.15.1",
  },
}
