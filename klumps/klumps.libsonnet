local g = import "grafana.libsonnet";

{
  _config:: {
    grafanaPrefix: "",
  },

  "k8s-resources-cluster.json":
    local tableStyles = {
      namespace: {
        alias: "Namespace",
        link: "%s/dashboard/file/k8s-resources-namespace.json?var-datasource=$datasource&var-namespace=$__cell" % $._config.grafanaPrefix,
      }
    };

    g.dashboard("K8s / Compute Resources / Cluster")
     .addRow(
      (g.row("Headlines") +
      {
        height: "100px",
        showTitle: false,
      })
       .addPanel(
        g.panel("CPU Requests Commitment") +
        g.statPanel("sum(kube_pod_container_resource_requests_cpu_cores) / sum(node:node_num_cpu:sum)")
       )
       .addPanel(
        g.panel("CPU Limits Commitment") +
        g.statPanel("sum(kube_pod_container_resource_limits_cpu_cores) / sum(node:node_num_cpu:sum)")
       )
       .addPanel(
        g.panel("Memory Requests Commitment") +
        g.statPanel("sum(kube_pod_container_resource_requests_memory_bytes) / sum(node_memory_MemTotal)")
       )
       .addPanel(
        g.panel("Memory Limits Commitment") +
        g.statPanel("sum(kube_pod_container_resource_limits_memory_bytes) / sum(node_memory_MemTotal)")
       )
     )
     .addRow(
      g.row("CPU")
       .addPanel(
        g.panel("CPU Usage") +
        g.queryPanel('sum(irate(container_cpu_usage_seconds_total[1m])) by (namespace)', "{{namespace}}") +
        g.stack
       )
     )
     .addRow(
      g.row("CPU Requests")
       .addPanel(
        g.panel("Requests by Namespace") +
        g.tablePanel('sum(kube_pod_container_resource_requests_cpu_cores) by (namespace)',
          "CPUs", tableStyles)
       )
       .addPanel(
        g.panel("Limits by Namespace") +
        g.tablePanel('sum(kube_pod_container_resource_limits_cpu_cores) by (namespace)',
          "CPUs", tableStyles)
       )
       .addPanel(
         g.panel("Usage by Namespace") +
         g.tablePanel('sum(rate(container_cpu_usage_seconds_total[5m])) by (namespace)',
          "CPU Usage", tableStyles)
       )
     )
     .addRow(
      g.row("Memory")
       .addPanel(
        g.panel("Memory Usage") +
        g.queryPanel('sum(container_memory_usage_bytes) by (namespace)', "{{namespace}}") +
        g.stack +
        { yaxes: g.yaxes("decbytes") },
       )
     )
     .addRow(
      g.row("Memory Requests")
       .addPanel(
        g.panel("Requests by Namespace") +
        g.tablePanel('sum(kube_pod_container_resource_requests_memory_bytes) by (namespace)',
          "Memory", tableStyles) +
        { _styles+: { Value+: { unit: "decbytes" } } }
       )
       .addPanel(
        g.panel("Limits by Namespace") +
        g.tablePanel('sum(kube_pod_container_resource_limits_memory_bytes) by (namespace)',
          "Memory", tableStyles) +
        { _styles+: { Value+: { unit: "decbytes" } } }
       )
       .addPanel(
         g.panel("Usage by Namespace") +
         g.tablePanel('sum(container_memory_usage_bytes) by (namespace)',
          "Memory Usage", tableStyles) +
        { _styles+: { Value+: { unit: "decbytes" } } }
       )
     ),

  "k8s-resources-namespace.json":
    local tableStyles = {
      pod: {
        alias: "Pod",
        link: "%s/dashboard/file/k8s-resources-pod.json?var-datasource=$datasource&var-namespace=$namespace&var-pod=$__cell" % $._config.grafanaPrefix,
      }
    };

    g.dashboard("K8s / Compute Resources / Namespace")
     .addTemplate("namespace", "kube_pod_info", "namespace")
     .addRow(
      g.row("CPU Usage")
       .addPanel(
        g.panel("CPU Usage") +
        g.queryPanel('sum(irate(container_cpu_usage_seconds_total{namespace="$namespace"}[1m])) by (pod_name)', "{{pod_name}}") +
        g.stack,
       )
     )
     .addRow(
      g.row("CPU")
       .addPanel(
        g.panel("Requests by Pod") +
        g.tablePanel('sum(kube_pod_container_resource_requests_cpu_cores{namespace="$namespace"}) by (pod)', "CPUs", tableStyles)
       )
       .addPanel(
        g.panel("Limits by Pod") +
        g.tablePanel('sum(kube_pod_container_resource_limits_cpu_cores{namespace="$namespace"}) by (pod)', "CPUs", tableStyles)
       )
       .addPanel(
         g.panel("Usage by Pod") +
         g.tablePanel('sum(rate(container_cpu_usage_seconds_total{namespace="$namespace"}[5m])) by (pod_name)', "CPU Usage", tableStyles)
       )
     )
     .addRow(
      g.row("Memory Usage")
       .addPanel(
        g.panel("Memory Usage") +
        g.queryPanel('sum(container_memory_usage_bytes{namespace="$namespace"}) by (pod_name)', "{{pod_name}}") +
        g.stack,
       )
     )
     .addRow(
      g.row("Memory")
       .addPanel(
        g.panel("Requests by Pod") +
        g.tablePanel('sum(kube_pod_container_resource_requests_memory_bytes{namespace="$namespace"}) by (pod)', "Memory", tableStyles) +
        { _styles+: { Value+: { unit: "decbytes" } } }
       )
       .addPanel(
        g.panel("Limits by Pod") +
        g.tablePanel('sum(kube_pod_container_resource_limits_memory_bytes{namespace="$namespace"}) by (pod)', "Memory", tableStyles) +
        { _styles+: { Value+: { unit: "decbytes" } } }
       )
       .addPanel(
         g.panel("Usage by Pod") +
         g.tablePanel('sum(container_memory_usage_bytes{namespace="$namespace"}) by (pod_name)', "Memory Usage", tableStyles) +
         { _styles+: { Value+: { unit: "decbytes" } } }
       )
     ),

  "k8s-resources-pod.json":
    g.dashboard("K8s / Compute Resources / Pod")
     .addTemplate("namespace", "kube_pod_info", "namespace")
     .addTemplate("pod", 'kube_pod_info{namespace="$namespace"}', "pod")
     .addRow(
      g.row("CPU Usage")
       .addPanel(
        g.panel("CPU Usage") +
        g.queryPanel('sum(irate(container_cpu_usage_seconds_total{namespace="$namespace",pod_name="$pod"}[1m])) by (container_name)', "{{container_name}}") +
        g.stack,
       )
     )
     .addRow(
      g.row("CPU")
       .addPanel(
        g.panel("Requests by Container") +
        g.tablePanel('sum(kube_pod_container_resource_requests_cpu_cores{namespace="$namespace", pod="$pod"}) by (container)', "CPUs", {container: "Container"})
       )
       .addPanel(
        g.panel("Limits by Container") +
        g.tablePanel('sum(kube_pod_container_resource_limits_cpu_cores{namespace="$namespace", pod="$pod"}) by (container)', "CPUs", {container: "Container"})
       )
       .addPanel(
         g.panel("Usage by Namespace") +
         g.tablePanel('sum(rate(container_cpu_usage_seconds_total{namespace="$namespace", pod_name="$pod"}[5m])) by (container_name)', "CPU Usage", {container_name: "Container"})
       )
     )
     .addRow(
      g.row("Memory Usage")
       .addPanel(
        g.panel("Memory Usage") +
        g.queryPanel('sum(container_memory_usage_bytes{namespace="$namespace", pod_name="$pod"}) by (container_name)', "{{container_name}}") +
        g.stack,
       )
     )
     .addRow(
      g.row("Memory")
       .addPanel(
        g.panel("Requests by Container") +
        g.tablePanel('sum(kube_pod_container_resource_requests_memory_bytes{namespace="$namespace", pod="$pod"}) by (container)', "Memory", {container: "Container"}) +
        { _styles+: { Value+: { unit: "decbytes" } } }
       )
       .addPanel(
        g.panel("Limits by Container") +
        g.tablePanel('sum(kube_pod_container_resource_limits_memory_bytes{namespace="$namespace", pod="$pod"}) by (container)', "Memory", {container: "Container"}) +
        { _styles+: { Value+: { unit: "decbytes" } } }
       )
       .addPanel(
         g.panel("Usage by Container") +
         g.tablePanel('sum(container_memory_usage_bytes{namespace="$namespace", pod_name="$pod"}) by (container_name)', "Memory Usage", {container_name: "Container"}) +
         { _styles+: { Value+: { unit: "decbytes" } } }
       )
     ),

  "k8s-services.json":
    g.dashboard("K8s Service Resources")
     .addTemplate("namespace", "kube_service_info", "namespace")
     .addRow(
      g.row("Resources (by service)")
       .addPanel(
        g.panel("CPU") +
        g.queryPanel("namespace_name:container_cpu_usage_seconds_total:sum_rate{namespace=\"$namespace\"}", "{{namespace}}/{{label_name}}") +
        g.stack,
       )
       .addPanel(
        g.panel("Memory") +
        g.queryPanel("namespace_name:container_memory_usage_bytes:sum{namespace=\"$namespace\"}", "{{namespace}}/{{label_name}}") +
        g.stack +
        { yaxes: g.yaxes("bytes") },
       ),
    ),

  "k8s-cluster-rsrc-use.json":
    g.dashboard("K8s / USE Method / Cluster")
     .addRow(
      g.row("CPU")
       .addPanel(
        g.panel("CPU Utilisation") +
        g.queryPanel(':node_cpu_utilisation:avg1m', "Utilisation") +
        { yaxes: g.yaxes("percentunit") },
       )
       .addPanel(
        g.panel("CPU Saturation") +
        g.queryPanel(':node_cpu_saturation_load1:', "Saturation") +
        { yaxes: g.yaxes("percentunit") },
       )
     )
     .addRow(
      g.row("Memory")
       .addPanel(
        g.panel("Memory Utilisation") +
        g.queryPanel(':node_memory_utilisation:', "Utilisation") +
        { yaxes: g.yaxes("percentunit") },
       )
       .addPanel(
        g.panel("Memory Saturation") +
        g.queryPanel(':node_memory_swap_io_bytes:sum_rate', "Swap IO") +
        { yaxes: g.yaxes("Bps") },
       )
     )
     .addRow(
      g.row("Disk")
       .addPanel(
        g.panel("Disk IO Utilisation") +
        g.queryPanel(':node_disk_utilisation:avg_irate', "Utilisation") +
        { yaxes: g.yaxes("percentunit") },
       )
       .addPanel(
        g.panel("Disk IO Saturation") +
        g.queryPanel(':node_disk_saturation:avg_irate', "Saturation") +
        { yaxes: g.yaxes("percentunit") },
       )
     )
     .addRow(
      g.row("Network")
       .addPanel(
        g.panel("Net Utilisation") +
        g.queryPanel(':node_net_utilisation:sum_irate', "Utilisation") +
        { yaxes: g.yaxes("Bps") },
       )
       .addPanel(
        g.panel("Net Saturation") +
        g.queryPanel(':node_net_saturation:sum_irate', "Saturation") +
        { yaxes: g.yaxes("Bps") },
       )
     )
     .addRow(
      g.row("Memory")
       .addPanel(
        g.panel("Disk Capacity") +
        g.queryPanel('1 - sum(max by (device, node) (node_filesystem_free{fstype=~"ext[24]"})) / sum(max by (device, node) (node_filesystem_size{fstype=~"ext[24]"}))', "Disk") +
        { yaxes: g.yaxes("percentunit") },
       ),
     ),

  "k8s-node-rsrc-use.json":
    g.dashboard("K8s / USE Method / Node")
     .addTemplate("node", "kube_node_info", "node")
     .addRow(
      g.row("CPU")
       .addPanel(
        g.panel("CPU Utilisation") +
        g.queryPanel('node:node_cpu_utilisation:avg1m{node="$node"}', "Utilisation") +
        { yaxes: g.yaxes("percentunit") },
       )
       .addPanel(
        g.panel("CPU Saturation") +
        g.queryPanel('node:node_cpu_saturation_load1:{node="$node"}', "Saturation") +
        { yaxes: g.yaxes("percentunit") },
       )
     )
     .addRow(
      g.row("Memory")
       .addPanel(
        g.panel("Memory Utilisation") +
        g.queryPanel('node:node_memory_utilisation:{node="$node"}', "Memory") +
        { yaxes: g.yaxes("percentunit") },
       )
       .addPanel(
        g.panel("Memory Saturation") +
        g.queryPanel('node:node_memory_swap_io_bytes:sum_rate{node="$node"}', "Swap IO") +
        { yaxes: g.yaxes("Bps") },
       )
     )
     .addRow(
      g.row("Disk")
       .addPanel(
        g.panel("Disk IO Utilisation") +
        g.queryPanel('node:node_disk_utilisation:avg_irate{node="$node"}', "Utilisation") +
        { yaxes: g.yaxes("percentunit") },
       )
       .addPanel(
        g.panel("Disk IO Saturation") +
        g.queryPanel('node:node_disk_saturation:avg_irate{node="$node"}', "Saturation") +
        { yaxes: g.yaxes("percentunit") },
       )
     )
     .addRow(
      g.row("Net")
       .addPanel(
        g.panel("Net Utilisation") +
        g.queryPanel('node:node_net_utilisation:sum_irate{node="$node"}', "Utilisation") +
        { yaxes: g.yaxes("Bps") },
       )
       .addPanel(
        g.panel("Net Saturation") +
        g.queryPanel('node:node_net_saturation:sum_irate{node="$node"}', "Saturation") +
        { yaxes: g.yaxes("Bps") },
       )
     )
     .addRow(
      g.row("Disk")
       .addPanel(
        g.panel("Disk Utilisation") +
        g.queryPanel('1 - sum(max by (device, node) (node_filesystem_free{fstype=~"ext[24]"})) / sum(max by (device, node) (node_filesystem_size{fstype=~"ext[24]"}))', "Disk") +
        { yaxes: g.yaxes("percentunit") },
       ),
    ),
}
