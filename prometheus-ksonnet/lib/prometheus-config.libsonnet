local prometheus = import 'prometheus/prometheus.libsonnet';
local scrape_configs = import 'prometheus/scrape_configs.libsonnet';

{
  prometheus_config:: {
    global: {
      scrape_interval: '15s',
    },

    rule_files: [
      'alerts/alerts.rules',
      'recording/recording.rules',
    ],

    alerting: {
      alertmanagers: prometheus.withAlertmanagers(
        $._config.alertmanagers,
        $._config.cluster_name
      ).prometheus_config.alerting.alertmanagers,
    },

    scrape_configs: [
      scrape_configs.kubernetesPodsScrapeConfig,  // Grafana Labs' battle tested scrape config for scraping kubernetes pods.

      // A separate scrape config for kube-state-metrics which doesn't
      // add namespace, container, and pod labels, instead taking
      // those labels from the exported timeseries. This prevents them
      // being renamed to exported_namespace etc.  and allows us to
      // route alerts based on namespace and join KSM metrics with
      // cAdvisor metrics.
      {
        job_name: '%s/kube-state-metrics' % $._config.namespace,
        kubernetes_sd_configs: [{
          role: 'pod',
          namespaces: {
            names: [$._config.namespace],
          },
        }],

        relabel_configs: [

          // Drop anything who's service is not kube-state-metrics
          // Rename jobs to be <namespace>/<name, from pod name label>
          {
            source_labels: ['__meta_kubernetes_pod_label_name'],
            regex: 'kube-state-metrics',
            action: 'keep',
          },

          // Rename instances to the concatenation of pod:container:port.
          // In the specific case of KSM, we could leave out the container
          // name and still have a unique instance label, but we leave it
          // in here for consistency with the normal pod scraping.
          {
            source_labels: [
              '__meta_kubernetes_pod_name',
              '__meta_kubernetes_pod_container_name',
              '__meta_kubernetes_pod_container_port_name',
            ],
            action: 'replace',
            separator: ':',
            target_label: 'instance',
          },
        ],
      },

      // A separate scrape config for node-exporter which maps the nodename onto the
      // instance label.
      {
        job_name: '%s/node-exporter' % $._config.namespace,
        kubernetes_sd_configs: [{
          role: 'pod',
          namespaces: {
            names: [$._config.namespace],
          },
        }],

        relabel_configs: [
          // Drop anything who's name is not node-exporter.
          {
            source_labels: ['__meta_kubernetes_pod_label_name'],
            regex: 'node-exporter',
            action: 'keep',
          },

          // Rename instances to be the node name.
          {
            source_labels: ['__meta_kubernetes_pod_node_name'],
            action: 'replace',
            target_label: 'instance',
          },

          // But also include the namespace as a separate label, for routing alerts
          {
            source_labels: ['__meta_kubernetes_namespace'],
            action: 'replace',
            target_label: 'namespace',
          },
        ],
      },

      // A separate scrape config for kube-dns, which does not adhere to the pod
      // conventions required by the generic scrape config.
      {
        job_name: 'kube-system/kube-dns',
        kubernetes_sd_configs: [{
          role: 'pod',
          namespaces: {
            names: ['kube-system'],
          },
        }],

        relabel_configs: [

          // Scrape only kube-dns.
          {
            source_labels: ['__meta_kubernetes_pod_label_k8s_app'],
            action: 'keep',
            regex: 'kube-dns',
          },

          // Scrape the ports named "metrics".
          {
            source_labels: ['__meta_kubernetes_pod_container_port_name'],
            action: 'keep',
            regex: 'metrics',
          },

          // Include the namespace, container, pod as separate labels,
          // for routing alerts and joining with cAdvisor metrics.
          {
            source_labels: ['__meta_kubernetes_namespace'],
            action: 'replace',
            target_label: 'namespace',
          },
          {
            source_labels: ['__meta_kubernetes_pod_name'],
            action: 'replace',
            target_label: 'pod',  // Not 'pod_name', which disappeared in K8s 1.16.
          },
          {
            source_labels: ['__meta_kubernetes_pod_container_name'],
            action: 'replace',
            target_label: 'container',  // Not 'container_name', which disappeared in K8s 1.16.
          },

          // Rename instances to the concatenation of pod:container:port.
          // All three components are needed to guarantee a unique instance label.
          {
            source_labels: [
              '__meta_kubernetes_pod_name',
              '__meta_kubernetes_pod_container_name',
              '__meta_kubernetes_pod_container_port_name',
            ],
            action: 'replace',
            separator: ':',
            target_label: 'instance',
          },
        ],
      },

      // This scrape config gather all kubelet metrics.
      {
        job_name: 'kube-system/kubelet',
        kubernetes_sd_configs: [{
          role: 'node',
        }],

        // Couldn't get prometheus to validate the kublet cert for scraping, so don't bother for now
        tls_config: {
          ca_file: '/var/run/secrets/kubernetes.io/serviceaccount/ca.crt',
          insecure_skip_verify: $._config.prometheus_insecure_skip_verify,
        },
        bearer_token_file: '/var/run/secrets/kubernetes.io/serviceaccount/token',

        relabel_configs: [
          {
            target_label: '__address__',
            replacement: $._config.prometheus_api_server_address,
          },
          {
            target_label: '__scheme__',
            replacement: 'https',
          },
          {
            source_labels: ['__meta_kubernetes_node_name'],
            regex: '(.+)',
            target_label: '__metrics_path__',
            replacement: '/api/v1/nodes/${1}/proxy/metrics',
          },
        ],
      },

      // As of k8s 1.7.3, cAdvisor metrics are available via kubelet using the /metrics/cadvisor path
      {
        job_name: 'kube-system/cadvisor',
        kubernetes_sd_configs: [{
          role: 'node',
        }],
        scheme: 'https',

        bearer_token_file: '/var/run/secrets/kubernetes.io/serviceaccount/token',
        tls_config: {
          ca_file: '/var/run/secrets/kubernetes.io/serviceaccount/ca.crt',
          insecure_skip_verify: $._config.prometheus_insecure_skip_verify,
        },

        relabel_configs: [
          {
            target_label: '__address__',
            replacement: $._config.prometheus_api_server_address,
          },
          {
            source_labels: ['__meta_kubernetes_node_name'],
            regex: '(.+)',
            target_label: '__metrics_path__',
            replacement: '/api/v1/nodes/${1}/proxy/metrics/cadvisor',
          },
        ],

        metric_relabel_configs: [
          // Drop container_* metrics with no image.
          {
            source_labels: ['__name__', 'image'],
            regex: 'container_([a-z_]+);',
            action: 'drop',
          },

          // Drop a bunch of metrics which are disabled but still sent, see
          // https://github.com/google/cadvisor/issues/1925.
          {
            source_labels: ['__name__'],
            regex: 'container_(network_tcp_usage_total|network_udp_usage_total|tasks_state|cpu_load_average_10s)',
            action: 'drop',
          },
        ],
      },

      // If running on GKE, you cannot scrape API server pods, and must instead
      // scrape the API server service endpoints.  On AKS this doesn't work.
      {
        job_name: 'default/kubernetes',
        kubernetes_sd_configs: [{
          role:
            if $._config.scrape_api_server_endpoints
            then 'endpoints'
            else 'service',
        }],
        scheme: 'https',

        bearer_token_file: '/var/run/secrets/kubernetes.io/serviceaccount/token',
        tls_config: {
          ca_file: '/var/run/secrets/kubernetes.io/serviceaccount/ca.crt',
          insecure_skip_verify: $._config.prometheus_insecure_skip_verify,
        },

        relabel_configs: [{
          source_labels: ['__meta_kubernetes_service_label_component'],
          regex: 'apiserver',
          action: 'keep',
        }],

        // Drop some high cardinality metrics.
        metric_relabel_configs: [
          {
            source_labels: ['__name__'],
            regex: 'apiserver_admission_controller_admission_latencies_seconds_.*',
            action: 'drop',
          },
          {
            source_labels: ['__name__'],
            regex: 'apiserver_admission_step_admission_latencies_seconds_.*',
            action: 'drop',
          },
        ],
      },
    ],
  },
}
