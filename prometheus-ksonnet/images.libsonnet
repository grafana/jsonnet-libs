{
  _images+:: {
    prometheus: "prom/prometheus:v2.2.1",
    watch: "weaveworks/watch:master-5b2a6e5",
    kubeStateMetrics: "gcr.io/google_containers/kube-state-metrics:v1.2.0",
    grafana: "kausal/grafana:v4.6.2-plus-build-image-760716341",
    gfdatasource: "quay.io/weaveworks/gfdatasource:master-2bda599",
    alertmanager: "prom/alertmanager:v0.14.0",
    nodeExporter: "prom/node-exporter:v0.15.1",
    nginx: "nginx:1.13.9",
  },
}
