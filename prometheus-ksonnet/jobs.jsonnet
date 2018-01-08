local wilkie = import "lib/wilkie.libsonnet";

// Various common, observability services
wilkie {
  _images+: import "images.jsonnet",
  _config+: {
    namespace: "default",
    slack_url: "",
    victorops_key: "",
  },
} +
(import "proxy.jsonnet") +
(import "prometheus.jsonnet") +
(import "grafana.jsonnet") +
(import "alertmanager.jsonnet") +
(import "kube-state-metrics.jsonnet") +
(import "node-exporter.jsonnet") +
(import "deploy.jsonnet")
