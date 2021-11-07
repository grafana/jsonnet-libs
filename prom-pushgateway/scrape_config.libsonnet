// A separate scrape config for prom-pushgateway with `honor_labels=true`.
// https://github.com/prometheus/pushgateway/blob/b944c4c8267ee365ee1758ddf37a790dcd0f7ea6/README.md#about-the-job-and-instance-labels

function(namespace) {
  job_name: '%s/prom-pushgateway' % namespace,
  kubernetes_sd_configs: [{
    role: 'pod',
    namespaces: {
      names: [namespace],
    },
  }],

  honor_labels: true,
  relabel_configs: [

    // Keep only prom-pushgateway service.
    {
      source_labels: ['__meta_kubernetes_pod_label_name'],
      action: 'keep',
      regex: 'prom-pushgateway',
    },

    // Drop pods with phase Succeeded or Failed.
    {
      source_labels: ['__meta_kubernetes_pod_phase'],
      action: 'drop',
      regex: 'Succeeded|Failed',
    },

    // Allow service to override the scrape path with 'prometheus.io.path=/other_metrics_path'.
    {
      source_labels: ['__meta_kubernetes_pod_annotation_prometheus_io_path'],
      action: 'replace',
      target_label: '__metrics_path__',
      regex: '(.+)',
      replacement: '$1',
    },

    // Map all K8s labels/annotations starting with
    // 'prometheus.io/param-' to URL params for Prometheus scraping.
    {
      regex: '__meta_kubernetes_pod_annotation_prometheus_io_param_(.+)',
      action: 'labelmap',
      replacement: '__param_$1',
    },

    // Rename jobs to be <namespace>/<name, from pod name label>.
    {
      source_labels: ['__meta_kubernetes_namespace', '__meta_kubernetes_pod_label_name'],
      action: 'replace',
      separator: '/',
      target_label: 'job',
      replacement: '$1',
    },

    // But also include the namespace, container, pod as separate labels,
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

    // Rename instances to the concatenation of 'pod:container:port',
    // all three components are needed to guarantee a unique instance label.
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
}
