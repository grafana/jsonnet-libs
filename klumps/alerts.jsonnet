{
  jobs+:: {
    kube_dns: "kube-system/kube-dns",
    kube_state_metrics: "default/kube-state-metrics",
  },

  groups+: [
    {
      name: "kubernetes",
      rules: [
        {
          expr: |||
            rate(kube_pod_container_status_restarts[15m]) > 0
          |||,
          labels: {
            severity: "critical",
          },
          annotations: {
            message: "{{ $labels.namespace }}/{{ $labels.pod }} ({{ $labels.container }}) is restarting {{ printf \"%.2f\" $value }} / second",
          },
          "for": "1h",
          alert: "KubePodCrashLooping",
        },
        {
          expr: |||
            kube_pod_status_ready{condition="true"} != 1
          |||,
          labels: {
            severity: "critical",
          },
          annotations: {
            message: "{{ $labels.namespace }}/{{ $labels.pod }} is not ready.",
          },
          "for": "1h",
          alert: "KubePodNotReady",
        },
        {
          expr: |||
            kube_deployment_status_observed_generation != kube_deployment_metadata_generation
          |||,
          labels: {
            severity: "critical",
          },
          annotations: {
            message: "Deployment {{ $labels.namespace }}/{{ labels.deployment }} generation mismatch",
          },
          "for": "15m",
          alert: "KubeDeploymentGenerationMismatch",
        },
        {
          expr: |||
            kube_deployment_spec_replicas != kube_deployment_status_replicas_available
          |||,
          labels: {
            severity: "critical",
          },
          annotations: {
            message: "Deployment {{ $labels.namespace }}/{{ $labels.deployment }} replica mismatch",
          },
          "for": "15m",
          alert: "KubeDeploymentReplicasMismatch",
        },
        {
          expr: |||
            max(kube_node_status_ready{condition="false"} == 1) BY (node)
          |||,
          labels: {
            severity: "warning",
          },
          annotations: {
            message: "{{ $labels.node }} has been unready for more than an hour",
          },
          "for": "1h",
          alert: "KubeNodeNotReady",
        },
        {
          expr: |||
            sum(namespace_name:kube_pod_container_resource_requests_cpu_cores:sum)
              /
            sum(node:node_num_cpu:sum)
              >
            (count(node:node_num_cpu:sum)-1) / count(node:node_num_cpu:sum)
          |||,
          labels: {
            severity: "warning",
          },
          annotations: {
            message: "Overcommited CPU resource requests, cannot tolerate node failure.",
          },
          "for": "5m",
          alert: "KubeCPUOvercommit",
        },
        {
          expr: |||
            sum(namespace_name:kube_pod_container_resource_requests_memory_bytes:sum)
              /
            sum(node_memory_MemTotal)
              >
            (count(node:node_num_cpu:sum)-1) / count(node:node_num_cpu:sum)
          |||,
          labels: {
            severity: "warning",
          },
          annotations: {
            message: "Overcommited Memory resource requests, cannot tolerate node failure.",
          },
          "for": "5m",
          alert: "KubeMemOvercommit",
        },
        {
          alert: "KubeVersionMismatch",
          expr: |||
            count(count(kubernetes_build_info{job!~"%s"}) by (gitVersion)) > 1
          ||| % $.jobs.kube_dns,
          "for": "1h",
          labels: {
            severity: "warning",
          },
          annotations: {
            message: "There are {{ $value }} different versions of Kubernetes components running.",
          },
        },
        {
          alert: "KubeClientErrors",
          expr: |||
           sum(rate(rest_client_requests_total{code!~"2.."}[5m])) by (instance, job) * 100 / sum(rate(rest_client_requests_total[5m])) by (instance, job) > 1
          |||,
          "for": "15m",
          labels: {
            severity: "warning",
          },
          annotations: {
            message: "Kubernetes API server client '{{ $labels.job }}/{{ $labels.instance }}' is experiencing {{ printf \"%0.0f\" $value }}% errors.'",
          },
        },
        {
          alert: "KubeClientErrors",
          expr: |||
           sum(rate(ksm_scrape_error_total{job="%s"}[5m])) by (instance, job) > 0.1
          ||| % $.jobs.kube_state_metrics,
          "for": "15m",
          labels: {
            severity: "warning",
          },
          annotations: {
            message: "Kubernetes API server client '{{ $labels.job }}/{{ $labels.instance }}' is experiencing {{ printf \"%0.0f\" $value }} errors / sec.'",
          },
        },
      ],
    },
  ],
}
