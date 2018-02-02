{
  _config+:: {
    jobs: {
      cadvisor: "kubernetes-nodes",
      kube_state_metrics: "default/kube-state-metrics",
      node_exporter: "default/node-exporter",
    },
  },

  groups+: [
    {
      name: "k8s.rules",
      rules: [
        {
          record: "namespace:container_cpu_usage_seconds_total:sum_rate",
          expr: |||
            sum(rate(container_cpu_usage_seconds_total{job="%(cadvisor)s",image!=""}[5m])) by (namespace)
          ||| % $._config.jobs,
        },
        {
          record: "namespace:container_memory_usage_bytes:sum",
          expr: |||
            sum(container_memory_usage_bytes{job="%(cadvisor)s",image!=""}) by (namespace)
          ||| % $._config.jobs,
        },
        {
          record: "namespace_name:container_cpu_usage_seconds_total:sum_rate",
          expr: |||
            sum by (namespace, label_name) (
               sum(rate(container_cpu_usage_seconds_total{job="%(cadvisor)s",image!=""}[5m])) by (namespace, pod_name)
             * on (namespace, pod_name) group_left(label_name)
               label_replace(kube_pod_labels{job="%(kube_state_metrics)s"}, "pod_name", "$1", "pod", "(.*)")
            )
          ||| % $._config.jobs,
        },
        {
          record: "namespace_name:container_memory_usage_bytes:sum",
          expr: |||
            sum by (namespace, label_name) (
              sum(container_memory_usage_bytes{job="%(cadvisor)s",image!=""}) by (pod_name, namespace)
            * on (namespace, pod_name) group_left(label_name)
              label_replace(kube_pod_labels{job="%(kube_state_metrics)s"}, "pod_name", "$1", "pod", "(.*)")
            )
          ||| % $._config.jobs,
        },
        {
          record: "namespace_name:kube_pod_container_resource_requests_memory_bytes:sum",
          expr: |||
            sum by (namespace, label_name) (
              sum(kube_pod_container_resource_requests_memory_bytes{job="%(kube_state_metrics)s"}) by (namespace, pod)
            * on (namespace, pod) group_left(label_name)
              label_replace(kube_pod_labels{job="%(kube_state_metrics)s"}, "pod_name", "$1", "pod", "(.*)")
            )
          ||| % $._config.jobs,
        },
        {
          record: "namespace_name:kube_pod_container_resource_requests_cpu_cores:sum",
          expr: |||
            sum by (namespace, label_name) (
              sum(kube_pod_container_resource_requests_cpu_cores{job="%(kube_state_metrics)s"}) by (namespace, pod)
            * on (namespace, pod) group_left(label_name)
              label_replace(kube_pod_labels{job="%(kube_state_metrics)s"}, "pod_name", "$1", "pod", "(.*)")
            )
          ||| % $._config.jobs,
        },
      ],
    },
    {
      name: "node.rules",
      rules: [
        {
          // Number of nodes in the cluster
          record: ":kube_pod_info_node_count:",
          expr: "sum(min(kube_pod_info) by (node))"
        },
        {
          // This rule results in the tuples (node, namespace, instance) => 1;
          // it is used to calculate per-node metrics, given namespace & instance.
          record: "node_namespace_instance:kube_pod_info:",
          expr: |||
            max(label_replace(kube_pod_info{job="%(kube_state_metrics)s"}, "instance", "$1", "pod", "(.*)")) by (node, namespace, instance)
          ||| % $._config.jobs,
        },
        {
          // This rule gives the number of CPUs per node.
          record: "node:node_num_cpu:sum",
          expr: |||
            count by (node) (sum by (node, cpu) (
              node_cpu{job="%(node_exporter)s"}
            * on (namespace, instance) group_left(node)
              node_namespace_instance:kube_pod_info:
            ))
          ||| % $._config.jobs,
        },
        {
          // CPU utilisation is % CPU is not idle.
          record: ":node_cpu_utilisation:avg1m",
          expr: |||
            1 - avg(rate(node_cpu{job="%(node_exporter)s",mode="idle"}[1m]))
          ||| % $._config.jobs,
        },
        {
          // CPU utilisation is % CPU is not idle.
          record: "node:node_cpu_utilisation:avg1m",
          expr: |||
            1 - avg by (node) (
              rate(node_cpu{job="%(node_exporter)s",mode="idle"}[1m])
            * on (namespace, instance) group_left(node)
              node_namespace_instance:kube_pod_info:)
          ||| % $._config.jobs,
        },
        {
          // CPU saturation is 1min avg run queue length / number of CPUs.
          // Can go over 100%.  >100% is bad.
          record: ":node_cpu_saturation_load1:",
          expr: |||
            sum(node_load1{job="%(node_exporter)s"})
            /
            sum(node:node_num_cpu:sum)
          ||| % $._config.jobs,
        },
        {
          // CPU saturation is 1min avg run queue length / number of CPUs.
          // Can go over 100%.  >100% is bad.
          record: "node:node_cpu_saturation_load1:",
          expr: |||
            sum by (node) (
              node_load1{job="%(node_exporter)s"}
            * on (namespace, instance) group_left(node)
              node_namespace_instance:kube_pod_info:
            )
            /
            node:node_num_cpu:sum
          ||| % $._config.jobs,
        },
        {
          // Available memory per node
          record: "node:node_memory_bytes_available:sum",
          expr: |||
            sum by (node) (
              (node_memory_MemFree{job="%(node_exporter)s"} + node_memory_Cached{job="%(node_exporter)s"} + node_memory_Buffers{job="%(node_exporter)s"})
              * on (namespace, instance) group_left(node)
                node_namespace_instance:kube_pod_info:
            )
          ||| % $._config.jobs,
        },
        {
          // Total memory per node
          record: "node:node_memory_bytes_total:sum",
          expr: |||
            sum by (node) (
              node_memory_MemTotal{job="%(node_exporter)s"}
              * on (namespace, instance) group_left(node)
                node_namespace_instance:kube_pod_info:
            )
          |||
        },
        {
          // Memory utilisation per node, normalized by per-node memory
          record: "node:node_memory_utilisation:ratio",
          expr: |||
            (node:node_memory_bytes_total:sum - node:node_memory_bytes_available:sum)
            /
            scalar(sum(node:node_memory_bytes_total:sum))
          |||
        },
        {
          record: ":node_memory_swap_io_bytes:sum_rate",
          expr: |||
            1e3 * sum(
              (rate(node_vmstat_pgpgin{job="%(node_exporter)s"}[1m])
             + rate(node_vmstat_pgpgout{job="%(node_exporter)s"}[1m]))
            )
          ||| % $._config.jobs,
        },
        {
          record: "node:node_memory_utilisation:",
          expr: |||
            1 - (node:node_memory_bytes_available:sum / node:node_memory_bytes_total:sum)
          ||| % $._config.jobs,
        },
        {
          record: "node:node_memory_swap_io_bytes:sum_rate",
          expr: |||
            1e3 * sum by (node) (
              (rate(node_vmstat_pgpgin{job="%(node_exporter)s"}[1m])
             + rate(node_vmstat_pgpgout{job="%(node_exporter)s"}[1m]))
             * on (namespace, instance) group_left(node)
               node_namespace_instance:kube_pod_info:
            )
          ||| % $._config.jobs,
        },
        {
          record: ":node_disk_utilisation:avg_irate",
          expr: |||
            avg(irate(node_disk_io_time_ms{job="%(node_exporter)s",device=~"(sd|xvd).+"}[1m]) / 1e3)
          ||| % $._config.jobs,
        },
        {
          record: "node:node_disk_utilisation:avg_irate",
          expr: |||
            avg by (node) (
              irate(node_disk_io_time_ms{job="%(node_exporter)s",device=~"(sd|xvd).+"}[1m]) / 1e3
            * on (namespace, instance) group_left(node)
              node_namespace_instance:kube_pod_info:
            )
          ||| % $._config.jobs,
        },
        {
          record: ":node_disk_saturation:avg_irate",
          expr: |||
            avg(irate(node_disk_io_time_weighted{job="%(node_exporter)s",device=~"(sd|xvd).+"}[1m]) / 1e3)
          ||| % $._config.jobs,
        },
        {
          record: "node:node_disk_saturation:avg_irate",
          expr: |||
            avg by (node) (
              irate(node_disk_io_time_weighted{job="%(node_exporter)sr",device=~"(sd|xvd).+"}[1m]) / 1e3
            * on (namespace, instance) group_left(node)
              node_namespace_instance:kube_pod_info:
            )
          ||| % $._config.jobs,
        },
        {
          record: ":node_net_utilisation:sum_irate",
          expr: |||
            sum(irate(node_network_receive_bytes{job="%(node_exporter)s",device="eth0"}[1m])) +
            sum(irate(node_network_transmit_bytes{job="%(node_exporter)s",device="eth0"}[1m]))
          ||| % $._config.jobs,
        },
        {
          record: "node:node_net_utilisation:sum_irate",
          expr: |||
            sum by (node) (
              (irate(node_network_receive_bytes{job="%(node_exporter)s",device="eth0"}[1m]) +
              irate(node_network_transmit_bytes{job="%(node_exporter)s",device="eth0"}[1m]))
            * on (namespace, instance) group_left(node)
              node_namespace_instance:kube_pod_info:
            )
          ||| % $._config.jobs,
        },
        {
          record: ":node_net_saturation:sum_irate",
          expr: |||
            sum(irate(node_network_receive_drop{job="%(node_exporter)s",device="eth0"}[1m])) +
            sum(irate(node_network_transmit_drop{job="%(node_exporter)s",device="eth0"}[1m]))
          ||| % $._config.jobs,
        },
        {
          record: "node:node_net_saturation:sum_irate",
          expr: |||
            sum by (node) (
              (irate(node_network_receive_drop{job="%(node_exporter)s",device="eth0"}[1m]) +
              irate(node_network_transmit_drop{job="%(node_exporter)s",device="eth0"}[1m]))
            * on (namespace, instance) group_left(node)
              node_namespace_instance:kube_pod_info:
            )
          ||| % $._config.jobs,
        },
      ],
    },
  ],
}
