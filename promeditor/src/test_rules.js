export default [
    {
        "name": "node",
        "file": "/etc/prometheus/rules/node.rules.yml",
        "rules": [
            {
                "rule": 'record: node_namespace_instance:kube_pod_info:\nexpr: max(label_replace(kube_pod_info, "instance", "$1", "pod", "(.*)")) by (node, namespace, instance)\n'
            },
            {
                "rule": 'record: node:node_num_cpu:sum\nexpr: count by (node) (sum by (node, cpu) (\nnode_cpu{job="default/node-exporter"}\n * on (namespace, instance) group_left(node)\n node_namespace_instance:kube_pod_info:\n))\n'
            },
            {
                "rule": 'record: :node_cpu_saturation_load1:\nexpr: sum(node_load1{job="default/node-exporter"}) / sum(node:node_num_cpu:sum)\n'
            }
        ]
    }
]