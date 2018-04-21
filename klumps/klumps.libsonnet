local g = import 'lib/grafana.libsonnet';

{
  _config:: {
    grafanaPrefix: '',
  },

  'k8s-resources-cluster.json':
    local tableStyles = {
      namespace: {
        alias: 'Namespace',
        link: '%s/dashboard/file/k8s-resources-namespace.json?var-datasource=$datasource&var-namespace=$__cell' % $._config.grafanaPrefix,
      },
    };

    g.dashboard('K8s / Compute Resources / Cluster')
    .addRow(
      (g.row('Headlines') +
       {
         height: '100px',
         showTitle: false,
       })
      .addPanel(
        g.panel('CPU Requests Commitment') +
        g.statPanel('sum(kube_pod_container_resource_requests_cpu_cores) / sum(node:node_num_cpu:sum)')
      )
      .addPanel(
        g.panel('CPU Limits Commitment') +
        g.statPanel('sum(kube_pod_container_resource_limits_cpu_cores) / sum(node:node_num_cpu:sum)')
      )
      .addPanel(
        g.panel('Memory Requests Commitment') +
        g.statPanel('sum(kube_pod_container_resource_requests_memory_bytes) / sum(node_memory_MemTotal)')
      )
      .addPanel(
        g.panel('Memory Limits Commitment') +
        g.statPanel('sum(kube_pod_container_resource_limits_memory_bytes) / sum(node_memory_MemTotal)')
      )
    )
    .addRow(
      g.row('CPU')
      .addPanel(
        g.panel('CPU Usage') +
        g.queryPanel('sum(irate(container_cpu_usage_seconds_total[1m])) by (namespace)', '{{namespace}}') +
        g.stack
      )
    )
    .addRow(
      g.row('CPU Quota')
      .addPanel(
        g.panel('CPU Quota') +
        g.tablePanel([
          'sum(rate(container_cpu_usage_seconds_total[5m])) by (namespace)',
          'sum(kube_pod_container_resource_requests_cpu_cores) by (namespace)',
          'sum(rate(container_cpu_usage_seconds_total[5m])) by (namespace) / sum(kube_pod_container_resource_requests_cpu_cores) by (namespace)',
          'sum(kube_pod_container_resource_limits_cpu_cores) by (namespace)',
          'sum(rate(container_cpu_usage_seconds_total[5m])) by (namespace) / sum(kube_pod_container_resource_limits_cpu_cores) by (namespace)',
        ], tableStyles {
          'Value #A': { alias: 'CPU Usage' },
          'Value #B': { alias: 'CPU Requests' },
          'Value #C': { alias: 'CPU Requests %', unit: 'percentunit' },
          'Value #D': { alias: 'CPU Limits' },
          'Value #E': { alias: 'CPU Limits %', unit: 'percentunit' },
        })
      )
    )
    .addRow(
      g.row('Memory')
      .addPanel(
        g.panel('Memory Usage (w/o cache)') +
        // Not using container_memory_usage_bytes here because that includes page cache
        g.queryPanel('sum(container_memory_rss) by (namespace)', '{{namespace}}') +
        g.stack +
        { yaxes: g.yaxes('decbytes') },
      )
    )
    .addRow(
      g.row('Memory Requests')
      .addPanel(
        g.panel('Requests by Namespace') +
        g.tablePanel([
          // Not using container_memory_usage_bytes here because that includes page cache
          'sum(container_memory_rss) by (namespace)',
          'sum(kube_pod_container_resource_requests_memory_bytes) by (namespace)',
          'sum(container_memory_rss) by (namespace) / sum(kube_pod_container_resource_requests_memory_bytes) by (namespace)',
          'sum(kube_pod_container_resource_limits_memory_bytes) by (namespace)',
          'sum(container_memory_rss) by (namespace) / sum(kube_pod_container_resource_limits_memory_bytes) by (namespace)',
        ], tableStyles {
          'Value #A': { alias: 'Memory Usage', unit: 'decbytes' },
          'Value #B': { alias: 'Memory Requests', unit: 'decbytes' },
          'Value #C': { alias: 'Memory Requests %', unit: 'percentunit' },
          'Value #D': { alias: 'Memory Limits', unit: 'decbytes' },
          'Value #E': { alias: 'Memory Limits %', unit: 'percentunit' },
        })
      )
    ),

  'k8s-resources-namespace.json':
    local tableStyles = {
      pod: {
        alias: 'Pod',
        link: '%s/dashboard/file/k8s-resources-pod.json?var-datasource=$datasource&var-namespace=$namespace&var-pod=$__cell' % $._config.grafanaPrefix,
      },
    };

    g.dashboard('K8s / Compute Resources / Namespace')
    .addTemplate('namespace', 'kube_pod_info', 'namespace')
    .addRow(
      g.row('CPU Usage')
      .addPanel(
        g.panel('CPU Usage') +
        g.queryPanel('sum(irate(container_cpu_usage_seconds_total{namespace="$namespace"}[1m])) by (pod_name)', '{{pod_name}}') +
        g.stack,
      )
    )
    .addRow(
      g.row('CPU Quota')
      .addPanel(
        g.panel('CPU Quota') +
        g.tablePanel([
          'sum(label_replace(rate(container_cpu_usage_seconds_total{namespace="$namespace"}[5m]), "pod", "$1", "pod_name", "(.*)")) by (pod)',
          'sum(kube_pod_container_resource_requests_cpu_cores{namespace="$namespace"}) by (pod)',
          'sum(label_replace(rate(container_cpu_usage_seconds_total{namespace="$namespace"}[5m]), "pod", "$1", "pod_name", "(.*)")) by (pod) / sum(kube_pod_container_resource_requests_cpu_cores{namespace="$namespace"}) by (pod)',
          'sum(kube_pod_container_resource_limits_cpu_cores{namespace="$namespace"}) by (pod)',
          'sum(label_replace(rate(container_cpu_usage_seconds_total{namespace="$namespace"}[5m]), "pod", "$1", "pod_name", "(.*)")) by (pod) / sum(kube_pod_container_resource_limits_cpu_cores{namespace="$namespace"}) by (pod)',
        ], tableStyles {
          'Value #A': { alias: 'CPU Usage' },
          'Value #B': { alias: 'CPU Requests' },
          'Value #C': { alias: 'CPU Requests %', unit: 'percentunit' },
          'Value #D': { alias: 'CPU Limits' },
          'Value #E': { alias: 'CPU Limits %', unit: 'percentunit' },
        })
      )
    )
    .addRow(
      g.row('Memory Usage')
      .addPanel(
        g.panel('Memory Usage') +
        g.queryPanel('sum(container_memory_usage_bytes{namespace="$namespace"}) by (pod_name)', '{{pod_name}}') +
        g.stack,
      )
    )
    .addRow(
      g.row('Memory Quota')
      .addPanel(
        g.panel('Memory Quota') +
        g.tablePanel([
          'sum(label_replace(container_memory_usage_bytes{namespace="$namespace"}, "pod", "$1", "pod_name", "(.*)")) by (pod)',
          'sum(kube_pod_container_resource_requests_memory_bytes{namespace="$namespace"}) by (pod)',
          'sum(label_replace(container_memory_usage_bytes{namespace="$namespace"}, "pod", "$1", "pod_name", "(.*)")) by (pod) / sum(kube_pod_container_resource_requests_memory_bytes{namespace="$namespace"}) by (pod)',
          'sum(kube_pod_container_resource_limits_memory_bytes{namespace="$namespace"}) by (pod)',
          'sum(label_replace(container_memory_usage_bytes{namespace="$namespace"}, "pod", "$1", "pod_name", "(.*)")) by (pod) / sum(kube_pod_container_resource_limits_memory_bytes{namespace="$namespace"}) by (pod)',
        ], tableStyles {
          'Value #A': { alias: 'Memory Usage', unit: 'decbytes' },
          'Value #B': { alias: 'Memory Requests', unit: 'decbytes' },
          'Value #C': { alias: 'Memory Requests %', unit: 'percentunit' },
          'Value #D': { alias: 'Memory Limits', unit: 'decbytes' },
          'Value #E': { alias: 'Memory Limits %', unit: 'percentunit' },
        })
      )
    ),

  'k8s-resources-pod.json':
    local tableStyles = {
      container: {
        alias: 'Container',
      },
    };

    g.dashboard('K8s / Compute Resources / Pod')
    .addTemplate('namespace', 'kube_pod_info', 'namespace')
    .addTemplate('pod', 'kube_pod_info{namespace="$namespace"}', 'pod')
    .addRow(
      g.row('CPU Usage')
      .addPanel(
        g.panel('CPU Usage') +
        g.queryPanel('sum(irate(container_cpu_usage_seconds_total{namespace="$namespace",pod_name="$pod"}[1m])) by (container_name)', '{{container_name}}') +
        g.stack,
      )
    )
    .addRow(
      g.row('CPU Quota')
      .addPanel(
        g.panel('CPU Quota') +
        g.tablePanel([
          'sum(label_replace(rate(container_cpu_usage_seconds_total{namespace="$namespace", pod_name="$pod"}[5m]), "container", "$1", "container_name", "(.*)")) by (container)',
          'sum(kube_pod_container_resource_requests_cpu_cores{namespace="$namespace", pod="$pod"}) by (container)',
          'sum(label_replace(rate(container_cpu_usage_seconds_total{namespace="$namespace", pod_name="$pod"}[5m]), "container", "$1", "container_name", "(.*)")) by (container) / sum(kube_pod_container_resource_requests_cpu_cores{namespace="$namespace", pod="$pod"}) by (container)',
          'sum(kube_pod_container_resource_limits_cpu_cores{namespace="$namespace", pod="$pod"}) by (container)',
          'sum(label_replace(rate(container_cpu_usage_seconds_total{namespace="$namespace", pod_name="$pod"}[5m]), "container", "$1", "container_name", "(.*)")) by (container) / sum(kube_pod_container_resource_limits_cpu_cores{namespace="$namespace", pod="$pod"}) by (container)',
        ], tableStyles {
          'Value #A': { alias: 'CPU Usage' },
          'Value #B': { alias: 'CPU Requests' },
          'Value #C': { alias: 'CPU Requests %', unit: 'percentunit' },
          'Value #D': { alias: 'CPU Limits' },
          'Value #E': { alias: 'CPU Limits %', unit: 'percentunit' },
        })
      )
    )
    .addRow(
      g.row('Memory Usage')
      .addPanel(
        g.panel('Memory Usage') +
        g.queryPanel('sum(container_memory_usage_bytes{namespace="$namespace", pod_name="$pod"}) by (container_name)', '{{container_name}}') +
        g.stack,
      )
    )
    .addRow(
      g.row('Memory Quota')
      .addPanel(
        g.panel('Memory Quota') +
        g.tablePanel([
          'sum(label_replace(container_memory_usage_bytes{namespace="$namespace", pod_name="$pod"}, "container", "$1", "container_name", "(.*)")) by (container)',
          'sum(kube_pod_container_resource_requests_memory_bytes{namespace="$namespace", pod="$pod"}) by (container)',
          'sum(label_replace(container_memory_usage_bytes{namespace="$namespace", pod_name="$pod"}, "container", "$1", "container_name", "(.*)")) by (container) / sum(kube_pod_container_resource_requests_memory_bytes{namespace="$namespace", pod="$pod"}) by (container)',
          'sum(kube_pod_container_resource_limits_memory_bytes{namespace="$namespace", pod="$pod"}) by (container)',
          'sum(label_replace(container_memory_usage_bytes{namespace="$namespace", pod_name="$pod"}, "container", "$1", "container_name", "(.*)")) by (container) / sum(kube_pod_container_resource_limits_memory_bytes{namespace="$namespace", pod="$pod"}) by (container)',
        ], tableStyles {
          'Value #A': { alias: 'Memory Usage', unit: 'decbytes' },
          'Value #B': { alias: 'Memory Requests', unit: 'decbytes' },
          'Value #C': { alias: 'Memory Requests %', unit: 'percentunit' },
          'Value #D': { alias: 'Memory Limits', unit: 'decbytes' },
          'Value #E': { alias: 'Memory Limits %', unit: 'percentunit' },
        })
      )
    ),

  'k8s-services.json':
    g.dashboard('K8s Service Resources')
    .addTemplate('namespace', 'kube_service_info', 'namespace')
    .addRow(
      g.row('Resources (by service)')
      .addPanel(
        g.panel('CPU') +
        g.queryPanel('namespace_name:container_cpu_usage_seconds_total:sum_rate{namespace="$namespace"}', '{{namespace}}/{{label_name}}') +
        g.stack,
      )
      .addPanel(
        g.panel('Memory') +
        g.queryPanel('namespace_name:container_memory_usage_bytes:sum{namespace="$namespace"}', '{{namespace}}/{{label_name}}') +
        g.stack +
        { yaxes: g.yaxes('bytes') },
      ),
    ),

  'k8s-cluster-rsrc-use.json':
    local legendLink = '%s/dashboard/file/k8s-node-rsrc-use.json' % $._config.grafanaPrefix;

    g.dashboard('K8s / USE Method / Cluster')
    .addRow(
      g.row('CPU')
      .addPanel(
        g.panel('CPU Utilisation') +
        g.queryPanel('node:node_cpu_utilisation:avg1m * node:node_num_cpu:sum / scalar(sum(node:node_num_cpu:sum))', '{{node}}', legendLink) +
        g.stack +
        { yaxes: g.yaxes({ format: 'percentunit', max: 1 }) },
      )
      .addPanel(
        g.panel('CPU Saturation (Load1)') +
        g.queryPanel('node:node_cpu_saturation_load1: / scalar(sum(min(kube_pod_info) by (node)))', '{{node}}', legendLink) +
        g.stack +
        { yaxes: g.yaxes({ format: 'percentunit', max: 1 }) },
      )
    )
    .addRow(
      g.row('Memory')
      .addPanel(
        g.panel('Memory Utilisation') +
        g.queryPanel('node:node_memory_utilisation:ratio', '{{node}}', legendLink) +
        g.stack +
        { yaxes: g.yaxes({ format: 'percentunit', max: 1 }) },
      )
      .addPanel(
        g.panel('Memory Saturation (Swap I/O)') +
        g.queryPanel('node:node_memory_swap_io_bytes:sum_rate', '{{node}}', legendLink) +
        g.stack +
        { yaxes: g.yaxes('Bps') },
      )
    )
    .addRow(
      g.row('Disk')
      .addPanel(
        g.panel('Disk IO Utilisation') +
        // Full utilisation would be all disks on each node spending an average of
        // 1 sec per second doing I/O, normalize by node count for stacked charts
        g.queryPanel('node:node_disk_utilisation:avg_irate / scalar(:kube_pod_info_node_count:)', '{{node}}', legendLink) +
        g.stack +
        { yaxes: g.yaxes({ format: 'percentunit', max: 1 }) },
      )
      .addPanel(
        g.panel('Disk IO Saturation') +
        g.queryPanel('node:node_disk_saturation:avg_irate / scalar(:kube_pod_info_node_count:)', '{{node}}', legendLink) +
        g.stack +
        { yaxes: g.yaxes({ format: 'percentunit', max: 1 }) },
      )
    )
    .addRow(
      g.row('Network')
      .addPanel(
        g.panel('Net Utilisation (Transmitted)') +
        g.queryPanel('node:node_net_utilisation:sum_irate', '{{node}}', legendLink) +
        g.stack +
        { yaxes: g.yaxes('Bps') },
      )
      .addPanel(
        g.panel('Net Saturation (Dropped)') +
        g.queryPanel('node:node_net_saturation:sum_irate', '{{node}}', legendLink) +
        g.stack +
        { yaxes: g.yaxes('Bps') },
      )
    )
    .addRow(
      g.row('Storage')
      .addPanel(
        g.panel('Disk Capacity') +
        g.queryPanel('sum(max(node_filesystem_size{fstype=~"ext[24]"} - node_filesystem_free{fstype=~"ext[24]"}) by (device,instance,namespace)) by (instance,namespace) / scalar(sum(max(node_filesystem_size{fstype=~"ext[24]"}) by (device,instance,namespace))) * on (namespace, instance) group_left(node) node_namespace_instance:kube_pod_info:', '{{node}}', legendLink) +
        g.stack +
        { yaxes: g.yaxes({ format: 'percentunit', max: 1 }) },
      ),
    ),

  'k8s-node-rsrc-use.json':
    g.dashboard('K8s / USE Method / Node')
    .addTemplate('node', 'kube_node_info', 'node')
    .addRow(
      g.row('CPU')
      .addPanel(
        g.panel('CPU Utilisation') +
        g.queryPanel('node:node_cpu_utilisation:avg1m{node="$node"}', 'Utilisation') +
        { yaxes: g.yaxes('percentunit') },
      )
      .addPanel(
        g.panel('CPU Saturation (Load1)') +
        g.queryPanel('node:node_cpu_saturation_load1:{node="$node"}', 'Saturation') +
        { yaxes: g.yaxes('percentunit') },
      )
    )
    .addRow(
      g.row('Memory')
      .addPanel(
        g.panel('Memory Utilisation') +
        g.queryPanel('node:node_memory_utilisation:{node="$node"}', 'Memory') +
        { yaxes: g.yaxes('percentunit') },
      )
      .addPanel(
        g.panel('Memory Saturation (Swap I/O)') +
        g.queryPanel('node:node_memory_swap_io_bytes:sum_rate{node="$node"}', 'Swap IO') +
        { yaxes: g.yaxes('Bps') },
      )
    )
    .addRow(
      g.row('Disk')
      .addPanel(
        g.panel('Disk IO Utilisation') +
        g.queryPanel('node:node_disk_utilisation:avg_irate{node="$node"}', 'Utilisation') +
        { yaxes: g.yaxes('percentunit') },
      )
      .addPanel(
        g.panel('Disk IO Saturation') +
        g.queryPanel('node:node_disk_saturation:avg_irate{node="$node"}', 'Saturation') +
        { yaxes: g.yaxes('percentunit') },
      )
    )
    .addRow(
      g.row('Net')
      .addPanel(
        g.panel('Net Utilisation (Transmitted)') +
        g.queryPanel('node:node_net_utilisation:sum_irate{node="$node"}', 'Utilisation') +
        { yaxes: g.yaxes('Bps') },
      )
      .addPanel(
        g.panel('Net Saturation (Dropped)') +
        g.queryPanel('node:node_net_saturation:sum_irate{node="$node"}', 'Saturation') +
        { yaxes: g.yaxes('Bps') },
      )
    )
    .addRow(
      g.row('Disk')
      .addPanel(
        g.panel('Disk Utilisation') +
        g.queryPanel('1 - sum(max by (device, node) (node_filesystem_free{fstype=~"ext[24]"})) / sum(max by (device, node) (node_filesystem_size{fstype=~"ext[24]"}))', 'Disk') +
        { yaxes: g.yaxes('percentunit') },
      ),
    ),
}
