{
  _config:: {
    cadvisorJob: "kubernetes-nodes",
  },

  groups: [
    {
      name: "k8s.rules",
      rules: [
        {
          record: "namespace:container_cpu_usage_seconds_total:sum_rate",
          expr: "sum(rate(container_cpu_usage_seconds_total{job=\"%s\",image!=\"\"}[5m])) by (namespace)" % $._config.cadvisorJob,
        },
        {
          record: "namespace:container_memory_usage_bytes:sum",
          expr: "sum(container_memory_usage_bytes{job=\"%s\",image!=\"\"}) by (namespace)" % $._config.cadvisorJob,
        },
        {
          record: "namespace_name:container_cpu_usage_seconds_total:sum_rate",
          expr: |||
            sum by (namespace, label_name) (
               sum(rate(container_cpu_usage_seconds_total{image!=""}[5m])) by (namespace, pod_name)
             * on (namespace, pod_name) group_left(label_name)
               label_replace(kube_pod_labels, "pod_name", "$1", "pod", "(.*)")
            )
          |||,
        },
        {
          record: "namespace_name:container_memory_usage_bytes:sum",
          expr: |||
            sum by (namespace, label_name) (
              sum(container_memory_usage_bytes{image!=""}) by (pod_name, namespace)
            * on (namespace, pod_name) group_left(label_name)
              label_replace(kube_pod_labels, "pod_name", "$1", "pod", "(.*)")
            )
          |||,
        },
        {
          record: "namespace_name:kube_pod_container_resource_requests_memory_bytes:sum",
          expr: |||
            sum by (namespace, label_name) (
              sum(kube_pod_container_resource_requests_memory_bytes{job="default/kube-state-metrics"}) by (namespace, pod)
            * on (namespace, pod)
              group_left(label_name) kube_pod_labels{job="default/kube-state-metrics"}
            )
          |||,
        },
        {
          record: "namespace_name:kube_pod_container_resource_requests_cpu_cores:sum",
          expr: |||
            sum by (namespace, label_name) (
              sum(kube_pod_container_resource_requests_cpu_cores{job="default/kube-state-metrics"}) by (namespace, pod)
            * on (namespace, pod)
              group_left(label_name) kube_pod_labels{job="default/kube-state-metrics"}
            )
          |||,
        },
      ],
    },
    {
      name: "node.rules",
      rules: [
        {
          // This rule results in the tuples (node, namespace, instance) => 1;
          // it is used to calculate per-node metrics, given namespace & instance.
          record: "node_namespace_instance:kube_pod_info:",
          expr: |||
            max(label_replace(kube_pod_info, "instance", "$1", "pod", "(.*)")) by (node, namespace, instance)
          |||,
        },
        {
          // This rule gives the number of CPUs per node.
          record: "node:node_num_cpu:sum",
          expr: |||
            count by (node) (sum by (node, cpu) (
              node_cpu{job="default/node-exporter"}
            * on (namespace, instance) group_left(node)
              node_namespace_instance:kube_pod_info:
            ))
          |||,
        },
        {
          // CPU utilisation is % CPU is not idle.
          record: ":node_cpu_utilisation:avg1m",
          expr: |||
            1 - avg(rate(node_cpu{job="default/node-exporter",mode="idle"}[1m]))
          |||
        },
        {
          // CPU utilisation is % CPU is not idle.
          record: "node:node_cpu_utilisation:avg1m",
          expr: |||
            1 - avg by (node) (
              rate(node_cpu{job="default/node-exporter",mode="idle"}[1m])
            * on (namespace, instance) group_left(node)
              node_namespace_instance:kube_pod_info:)
          |||
        },
        {
          // CPU saturation is 1min avg run queue length / number of CPUs.
          // Can go over 100%.  >100% is bad.
          record: ":node_cpu_saturation_load1:",
          expr: |||
            sum(node_load1{job="default/node-exporter"})
            /
            sum(node:node_num_cpu:sum)
          |||
        },
        {
          // CPU saturation is 1min avg run queue length / number of CPUs.
          // Can go over 100%.  >100% is bad.
          record: "node:node_cpu_saturation_load1:",
          expr: |||
            sum by (node) (
              node_load1{job="default/node-exporter"}
            * on (namespace, instance) group_left(node)
              node_namespace_instance:kube_pod_info:
            )
            /
            node:node_num_cpu:sum
          |||
        },
        {
          record: ":node_memory_utilisation:",
          expr: |||
            1 -
            sum(node_memory_MemFree{job="default/node-exporter"} + node_memory_Cached{job="default/node-exporter"} + node_memory_Buffers{job="default/node-exporter"})
            /
            sum(node_memory_MemTotal{job="default/node-exporter"})
          |||
        },
        {
          record: ":node_memory_swap_io_bytes:sum_rate",
          expr: |||
            1e3 * sum(
              (rate(node_vmstat_pgpgin{job="default/node-exporter"}[1m])
             + rate(node_vmstat_pgpgout{job="default/node-exporter"}[1m]))
            )
          |||
        },
        {
          record: "node:node_memory_utilisation:",
          expr: |||
            1 -
            sum by (node) (
              (node_memory_MemFree{job="default/node-exporter"} + node_memory_Cached{job="default/node-exporter"} + node_memory_Buffers{job="default/node-exporter"})
            * on (namespace, instance) group_left(node)
              node_namespace_instance:kube_pod_info:
            )
            /
            sum by (node) (
              node_memory_MemTotal{job="default/node-exporter"}
            * on (namespace, instance) group_left(node)
              node_namespace_instance:kube_pod_info:
            )
          |||
        },
        {
          record: "node:node_memory_swap_io_bytes:sum_rate",
          expr: |||
            1e3 * sum by (node) (
              (rate(node_vmstat_pgpgin{job="default/node-exporter"}[1m])
             + rate(node_vmstat_pgpgout{job="default/node-exporter"}[1m]))
             * on (namespace, instance) group_left(node)
               node_namespace_instance:kube_pod_info:
            )
          |||
        },
        {
          record: ":node_disk_utilisation:avg_irate",
          expr: |||
            avg(irate(node_disk_io_time_ms{job="default/node-exporter",device=~"(sd|xvd).+"}[1m]) / 1e3)
          |||
        },
        {
          record: "node:node_disk_utilisation:avg_irate",
          expr: |||
            avg by (node) (
              irate(node_disk_io_time_ms{job="default/node-exporter",device=~"(sd|xvd).+"}[1m]) / 1e3
            * on (namespace, instance) group_left(node)
              node_namespace_instance:kube_pod_info:
            )
          |||
        },
        {
          record: ":node_disk_saturation:avg_irate",
          expr: |||
            avg(irate(node_disk_io_time_weighted{job="default/node-exporter",device=~"(sd|xvd).+"}[1m]) / 1e3)
          |||
        },
        {
          record: "node:node_disk_saturation:avg_irate",
          expr: |||
            avg by (node) (
              irate(node_disk_io_time_weighted{job="default/node-exporter",device=~"(sd|xvd).+"}[1m]) / 1e3
            * on (namespace, instance) group_left(node)
              node_namespace_instance:kube_pod_info:
            )
          |||
        },
        {
          record: ":node_net_utilisation:sum_irate",
          expr: |||
            sum(irate(node_network_receive_bytes{job="default/node-exporter",device="eth0"}[1m])) +
            sum(irate(node_network_transmit_bytes{job="default/node-exporter",device="eth0"}[1m]))
          |||
        },
        {
          record: "node:node_net_utilisation:sum_irate",
          expr: |||
            sum by (node) (
              (irate(node_network_receive_bytes{job="default/node-exporter",device="eth0"}[1m]) +
              irate(node_network_transmit_bytes{job="default/node-exporter",device="eth0"}[1m]))
            * on (namespace, instance) group_left(node)
              node_namespace_instance:kube_pod_info:
            )
          |||
        },
        {
          record: ":node_net_saturation:sum_irate",
          expr: |||
            sum(irate(node_network_receive_drop{job="default/node-exporter",device="eth0"}[1m])) +
            sum(irate(node_network_transmit_drop{job="default/node-exporter",device="eth0"}[1m]))
          |||
        },
        {
          record: "node:node_net_saturation:sum_irate",
          expr: |||
            sum by (node) (
              (irate(node_network_receive_drop{job="default/node-exporter",device="eth0"}[1m]) +
              irate(node_network_transmit_drop{job="default/node-exporter",device="eth0"}[1m]))
            * on (namespace, instance) group_left(node)
              node_namespace_instance:kube_pod_info:
            )
          |||
        },
      ],
    },
  ],
}
