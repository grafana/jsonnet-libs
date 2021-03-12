{
  // Grafana Labs' battle tested scrape config for scraping kubernetes pods.
  //
  // Scraping happens on following characteristics:
  //   - on named Pod ports that end on '-metrics'
  //   - Pod has a 'name' label
  //   - Pod status is not Succeeded/Failed
  //
  // You can specify the following annotations (on pods):
  //   prometheus.io.scrape: false - don't scrape this pod
  //   prometheus.io.scheme: https - use https for scraping
  //   prometheus.io.path - scrape this path
  //   prometheus.io.port - scrape this port
  //   prometheus.io.param-<parameter> - send ?parameter=value with the scrape
  kubernetesPodsScrapeConfig:: {
    job_name: 'kubernetes-pods',
    kubernetes_sd_configs: [{
      role: 'pod',
    }],

    relabel_configs: [

      // Drop any endpoint who's pod port name does not end with metrics
      {
        source_labels: ['__meta_kubernetes_pod_container_port_name'],
        action: 'keep',
        regex: '.*-metrics',
      },

      // Drop pods without a name label
      {
        source_labels: ['__meta_kubernetes_pod_label_name'],
        action: 'drop',
        regex: '',
      },

      // Drop pods with phase Succeeded or Failed
      {
        source_labels: ['__meta_kubernetes_pod_phase'],
        action: 'drop',
        regex: 'Succeeded|Failed',
      },

      // Drop anything annotated with prometheus.io.scrape=false
      {
        source_labels: ['__meta_kubernetes_pod_annotation_prometheus_io_scrape'],
        action: 'drop',
        regex: 'false',
      },

      // Allow pods to override the scrape scheme with prometheus.io.scheme=https
      {
        source_labels: ['__meta_kubernetes_pod_annotation_prometheus_io_scheme'],
        action: 'replace',
        target_label: '__scheme__',
        regex: '(https?)',
        replacement: '$1',
      },

      // Allow service to override the scrape path with prometheus.io.path=/other_metrics_path
      {
        source_labels: ['__meta_kubernetes_pod_annotation_prometheus_io_path'],
        action: 'replace',
        target_label: '__metrics_path__',
        regex: '(.+)',
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

      {
        regex: '__meta_kubernetes_pod_annotation_prometheus_io_param_(.+)',
        action: 'labelmap',
        replacement: '__param_$1',
      },

      // Map all K8s labels/annotations starting with
      // 'prometheus.io/label-' to Prometheus labels.
      {
        regex: '__meta_kubernetes_pod_label_prometheus_io_label_(.+)',
        action: 'labelmap',
      },
      {
        regex: '__meta_kubernetes_pod_annotation_prometheus_io_label_(.+)',
        action: 'labelmap',
      },

      // Rename jobs to be <namespace>/<name, from pod name label>
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
}
