{
  _images+:: {
    prometheus: 'prom/prometheus:v2.20.0',
    grafana: 'grafana/grafana:7.0.4',
    // Replace 'beorn7' with 'weaveworks' in the following line once this
    // image has been pushed to hub.docker.io.
    watch: 'beorn7/watch:master-f2017cf-1',
    kubeStateMetrics: 'gcr.io/google_containers/kube-state-metrics:v1.6.0',
    alertmanager: 'prom/alertmanager:v0.21.0',
    nodeExporter: 'prom/node-exporter:v0.18.1',
    nginx: 'nginx:1.15.1-alpine',
  },
}
