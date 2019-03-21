{
  prometheus_config:: {
    global: {
      scrape_interval: '15s',
    },

    rule_files: [
      'alerts.rules',
      'recording.rules',
    ],

    alerting: {
      alertmanagers: [{
        kubernetes_sd_configs: [{
          role: 'pod',
        }],
        path_prefix: $._config.alertmanager_path,
        tls_config: {
          ca_file: '/var/run/secrets/kubernetes.io/serviceaccount/ca.crt',
        },
        bearer_token_file: '/var/run/secrets/kubernetes.io/serviceaccount/token',
        relabel_configs: [{
          source_labels: ['__meta_kubernetes_pod_label_name'],
          regex: 'alertmanager',
          action: 'keep',
        }, {
          source_labels: ['__meta_kubernetes_namespace'],
          regex: $._config.namespace,
          action: 'keep',
        }, {
          source_labels: ['__meta_kubernetes_pod_container_port_number'],
          regex: null,
          action: 'drop',
        }],
      }],
    },

    scrape_configs: [
      {
        job_name: 'kubernetes-pods',
        kubernetes_sd_configs: [{
          role: 'pod',
        }],

        tls_config: {
          ca_file: '/var/run/secrets/kubernetes.io/serviceaccount/ca.crt',
          insecure_skip_verify: $._config.prometheus_insecure_skip_verify,
        },
        bearer_token_file: '/var/run/secrets/kubernetes.io/serviceaccount/token',

        // You can specify the following annotations (on pods):
        //   prometheus.io.scrape: false - don't scrape this pod
        //   prometheus.io.scheme: https - use https for scraping
        //   prometheus.io.port - scrape this port
        //   prometheus.io.path - scrape this path
        //   prometheus.io.param-<parameter> - send ?parameter=value with the scrape
        relabel_configs: [

          // Drop anything annotated with prometheus.io.scrape=false
          {
            source_labels: ['__meta_kubernetes_pod_annotation_prometheus_io_scrape'],
            action: 'drop',
            regex: 'false',
          },

          // Drop any endpoint who's pod port name does not end with metrics
          {
            source_labels: ['__meta_kubernetes_pod_container_port_name'],
            action: 'keep',
            regex: '.*-metrics',
          },

          // Allow pods to override the scrape scheme with prometheus.io.scheme=https
          {
            source_labels: ['__meta_kubernetes_pod_annotation_prometheus_io_scheme'],
            action: 'replace',
            target_label: '__scheme__',
            regex: '^(https?)$',
            replacement: '$1',
          },

          // Allow service to override the scrape path with prometheus.io.path=/other_metrics_path
          {
            source_labels: ['__meta_kubernetes_pod_annotation_prometheus_io_path'],
            action: 'replace',
            target_label: '__metrics_path__',
            regex: '^(.+)$',
            replacement: '$1',
          },

          // Allow services to override the scrape port with prometheus.io.port=1234
          {
            source_labels: ['__address__', '__meta_kubernetes_pod_annotation_prometheus_io_port'],
            action: 'replace',
            target_label: '__address__',
            regex: '(.+?)(\\:\\d+)?;(\\d+)',
            replacement: '$1:$3',
          },

          // Drop pods without a name label
          {
            source_labels: ['__meta_kubernetes_pod_label_name'],
            action: 'drop',
            regex: '^$',
          },

          // Rename jobs to be <namespace>/<name, from pod name label>
          {
            source_labels: ['__meta_kubernetes_namespace', '__meta_kubernetes_pod_label_name'],
            action: 'replace',
            separator: '/',
            target_label: 'job',
            replacement: '$1',
          },

          // But also include the namespace as a separate label, for routing alerts
          {
            source_labels: ['__meta_kubernetes_namespace'],
            action: 'replace',
            target_label: 'namespace',
          },

          // Rename instances to be the pod name
          {
            source_labels: ['__meta_kubernetes_pod_name'],
            action: 'replace',
            target_label: 'instance',
          },

          {
            regex: '__meta_kubernetes_pod_annotation_prometheus_io_param_(.+)',
            action: 'labelmap',
            replacement: '__param_$1',
          },

          // Drop pods with phase Succeeded or Failed
          {
            source_labels: ['__meta_kubernetes_pod_phase'],
            action: 'drop',
            regex: '^(Succeeded|Failed)$',
          },
        ],
      },

      // A separate scrape config for kube-state-metrics which doesn't add a namespace
      // label, instead taking the namespace label from the exported timeseries.  This
      // prevents the exported namespace label being renamed to exported_namespace, and
      // allows us to route alerts based on namespace.
      {
        job_name: '%s/kube-state-metrics' % $._config.namespace,
        kubernetes_sd_configs: [{
          role: 'pod',
          namespaces: {
            names: [$._config.namespace],
          },
        }],

        tls_config: {
          ca_file: '/var/run/secrets/kubernetes.io/serviceaccount/ca.crt',
          insecure_skip_verify: $._config.prometheus_insecure_skip_verify,
        },
        bearer_token_file: '/var/run/secrets/kubernetes.io/serviceaccount/token',

        relabel_configs: [

          // Drop anything who's service is not kube-state-metrics
          // Rename jobs to be <namespace>/<name, from pod name label>
          {
            source_labels: ['__meta_kubernetes_pod_label_name'],
            regex: 'kube-state-metrics',
            action: 'keep',
          },

          // Rename instances to be the pod name.
          // As the scrape two ports of KSM, include the port name in the instance
          // name.  Otherwise alerts about scrape failures and timeouts won't work.
          {
            source_labels: ['__meta_kubernetes_pod_name', '__meta_kubernetes_pod_container_port_name'],
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

        tls_config: {
          ca_file: '/var/run/secrets/kubernetes.io/serviceaccount/ca.crt',
          insecure_skip_verify: $._config.prometheus_insecure_skip_verify,
        },
        bearer_token_file: '/var/run/secrets/kubernetes.io/serviceaccount/token',

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
            replacement: 'kubernetes.default.svc:443',
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

  // Extension points for adding alerts, recording rules and prometheus config.
  prometheus_alerts:: {
    groups+: [
      {
        name: 'prometheus-extra',
        rules: [
          {
            alert: 'PromScrapeFailed',
            expr: |||
              up != 1
            |||,
            'for': '15m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Prometheus failed to scrape a target {{ $labels.job }} / {{ $labels.instance }}',
            },
          },
          {
            alert: 'PromScrapeFlapping',
            expr: |||
              avg_over_time(up[5m]) < 1
            |||,
            'for': '15m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Prometheus target flapping {{ $labels.job }} / {{ $labels.instance }}',
            },
          },
          {
            alert: 'PromScrapeTooLong',
            expr: |||
              scrape_duration_seconds > 60
            |||,
            'for': '15m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: '{{ $labels.job }} / {{ $labels.instance }} is taking too long to scrape ({{ printf "%.1f" $value }}s)',
            },
          },
        ],
      },
    ],
  },

  prometheus_rules:: {
    groups+: [
      {
        // Add mapping from namespace, pod -> node with node name as pod, as
        // we use the node name as the node-exporter instance label.
        name: 'instance_override',
        rules: [
          {
            record: 'node_namespace_pod:kube_pod_info:',
            expr: |||
              max by(node, namespace, instance) (label_replace(kube_pod_info{job="default/kube-state-metrics"}, "instance", "$1", "node", "(.*)"))
            |||,
          },
        ],
      },
    ],
  },

  // We changes to using camelCase, but here we try and make it backwards compatible.
  prometheusAlerts+:: $.prometheus_alerts,
  prometheusRules+:: $.prometheus_rules,
}
