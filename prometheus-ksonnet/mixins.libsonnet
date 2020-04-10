{
  // Add you mixins here.
  mixins+:: {
    kubernetes:
      (import 'kubernetes-mixin/mixin.libsonnet') {
        grafanaDashboardFolder: 'Kubernetes',
        grafanaDashboardShards: 8,

        _config+:: {
          cadvisorSelector: 'job="kube-system/cadvisor"',
          kubeletSelector: 'job="kube-system/kubelet"',
          kubeStateMetricsSelector: 'job="%s/kube-state-metrics"' % $._config.namespace,
          nodeExporterSelector: 'job="%s/node-exporter"' % $._config.namespace,  // Also used by node-mixin.
          notKubeDnsSelector: 'job!="kube-system/kube-dns"',
          kubeSchedulerSelector: 'job="kube-system/kube-scheduler"',
          kubeControllerManagerSelector: 'job="kube-system/kube-controller-manager"',
          kubeApiserverSelector: 'job="kube-system/kube-apiserver"',
          podLabel: 'instance',
        },
      },

    prometheus:
      (import 'prometheus-mixin/mixin.libsonnet') {
        grafanaDashboardFolder: 'Prometheus',

        _config+:: {
          prometheusSelector: 'job="default/prometheus"',
        },
      },

    alertmanager:
      (import 'alertmanager-mixin/mixin.libsonnet') {
        grafanaDashboardFolder: 'Alertmanager',

        _config+:: {
          alertmanagerSelector: 'job="default/alertmanager"',
        },
      },

    node_exporter:
      (import 'node-mixin/mixin.libsonnet') {
        grafanaDashboardFolder: 'node_exporter',

        _config+:: {
          nodeExporterSelector: 'job="%s/node-exporter"' % $._config.namespace,  // Also used by node-mixin.

          // Do not page if nodes run out of disk space.
          nodeCriticalSeverity: 'warning',
          grafanaPrefix: '/grafana',
        },
      },
  },
}
