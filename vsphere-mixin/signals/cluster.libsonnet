// Cluster signals shown on the vSphere clusters dashboard.
local selectors = import './selectors.libsonnet';

function(this)
  local s = selectors(this);
  local clusterLegend = '{{vcenter_cluster_name}}';
  local clusterSumBy = 'sum by (job, vcenter_datacenter_name, vcenter_cluster_name)';
  local swd = 'sum without(object, direction)';
  // 3-way label_join over the VM inventory path (resource pool / virtual app / neither).
  local vmJoin3(metric) =
    'label_join(' + metric + '{' + s.clusterNoVAppQueriesSelector + '}, "vm_path", "/", "vcenter_resource_pool_inventory_path","vcenter_vm_name") or '
    + 'label_join(' + metric + '{' + s.clusterNoRPoolQueriesSelector + '}, "vm_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name") or '
    + 'label_join(' + metric + '{' + s.clusterNoRPoolOrVAppQueriesSelector + '}, "vm_path", "/", "vcenter_vm_name")';
  local raw(name, expr, unit, description, legend='') = {
    name: name,
    type: 'raw',
    unit: unit,
    description: description,
    sources: {
      prometheus: {
        expr: expr,
        legendCustomTemplate: legend,
      },
    },
  };
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: [],
    datasource: 'prometheus_datasource',
    aggLevel: 'none',
    aggFunction: 'avg',
    signals: {
      clusterVMsOnCount: raw(
        'VMs on',
        'vcenter_cluster_vm_count{power_state="on", ' + s.clusterQueriesSelector + '}',
        'none',
        'VMs powered on within the cluster.'
      ),
      clusterVMsOffCount: raw(
        'VMs off',
        'vcenter_cluster_vm_count{power_state="off", ' + s.clusterQueriesSelector + '}',
        'none',
        'VMs powered off within the cluster.'
      ),
      clusterVMsSuspendedCount: raw(
        'VMs suspended',
        'vcenter_cluster_vm_count{power_state="suspended", ' + s.clusterQueriesSelector + '}',
        'none',
        'VMs suspended within the cluster.'
      ),
      clusterHostsActiveCount: raw(
        'Active ESXi hosts',
        'vcenter_cluster_host_count{effective="true", ' + s.clusterQueriesSelector + '}',
        'none',
        'Active ESXi hosts within the cluster.'
      ),
      clusterHostsInactiveCount: raw(
        'Inactive ESXi hosts',
        'vcenter_cluster_host_count{effective="false", ' + s.clusterQueriesSelector + '}',
        'none',
        'Inactive ESXi hosts within the cluster.'
      ),
      clusterResourcePoolsCount: raw(
        'Resource pools',
        'count(vcenter_resource_pool_cpu_shares{' + s.clusterQueriesSelector + '})',
        'none',
        'Resource pools within the cluster.'
      ),
      clusterCPUEffective: raw(
        'Cluster CPU effective',
        'vcenter_cluster_cpu_effective{' + s.clusterQueriesSelector + '}',
        'rotmhz',
        'The effective CPU capacity of the cluster.',
        clusterLegend
      ),
      clusterCPULimit: raw(
        'Cluster CPU limit',
        'vcenter_cluster_cpu_limit{' + s.clusterQueriesSelector + '}',
        'rotmhz',
        'The available CPU capacity of the cluster.',
        clusterLegend
      ),
      clusterCPUUtilization: raw(
        'Cluster CPU utilization',
        '(100 * ' + clusterSumBy + ' (vcenter_host_cpu_usage_MHz{' + s.clusterQueriesSelector + '}) / clamp_min(vcenter_cluster_cpu_limit{' + s.clusterQueriesSelector + '}, 1))',
        'percent',
        'The CPU utilization percentage of the cluster.',
        clusterLegend
      ),
      clusterMemoryEffective: raw(
        'Cluster memory effective',
        'vcenter_cluster_memory_effective_bytes{' + s.queriesSelector + '}',
        'bytes',
        'The effective memory capacity of the cluster.',
        clusterLegend
      ),
      clusterMemoryLimit: raw(
        'Cluster memory limit',
        'vcenter_cluster_memory_limit_bytes{' + s.queriesSelector + '}',
        'bytes',
        'The available memory capacity of the cluster.',
        clusterLegend
      ),
      clusterMemoryUtilization: raw(
        'Cluster memory utilization',
        ' 104857600 * ' + clusterSumBy + ' (vcenter_host_memory_usage_mebibytes{' + s.clusterQueriesSelector + '}) / clamp_min(vcenter_cluster_memory_limit_bytes{' + s.clusterQueriesSelector + '}, 1)',
        'percent',
        'The memory utilization percentage of the cluster.',
        clusterLegend
      ),
      clusterHostCPUUsage: raw(
        'CPU usage',
        'vcenter_host_cpu_usage_MHz{' + s.clusterQueriesSelector + '}',
        'rotmhz',
        'CPU usage of ESXi hosts in the cluster.'
      ),
      clusterHostCPUUtilization: raw(
        'CPU utilization',
        'vcenter_host_cpu_utilization_percent{' + s.clusterQueriesSelector + '}',
        'percent',
        'CPU utilization of ESXi hosts in the cluster.'
      ),
      clusterHostMemoryUsage: raw(
        'Memory usage',
        'vcenter_host_memory_usage_mebibytes{' + s.clusterQueriesSelector + '}',
        'mbytes',
        'Memory usage of ESXi hosts in the cluster.'
      ),
      clusterHostMemoryUtilization: raw(
        'Memory utilization',
        'vcenter_host_memory_utilization_percent{' + s.clusterQueriesSelector + '}',
        'percent',
        'Memory utilization of ESXi hosts in the cluster.'
      ),
      clusterHostDiskThroughput: raw(
        'Disk throughput',
        swd + ' (vcenter_host_disk_throughput{object="",' + s.clusterQueriesSelector + '})',
        'KiBs',
        'Disk throughput of ESXi hosts in the cluster.'
      ),
      clusterHostDiskLatency: raw(
        'Disk delay',
        swd + ' (vcenter_host_disk_latency_avg_milliseconds{' + s.clusterQueriesSelector + '})',
        'ms',
        'Disk latency of ESXi hosts in the cluster.'
      ),
      clusterHostNetworkThroughput: raw(
        'Net throughput',
        swd + ' (vcenter_host_network_usage{object="",' + s.clusterQueriesSelector + '})',
        'KiBs',
        'Network throughput of ESXi hosts in the cluster.'
      ),
      clusterHostPacketErrorRate: raw(
        'Packet errors',
        swd + ' (vcenter_host_network_packet_error_rate{object="",' + s.clusterQueriesSelector + '}) / clamp_min(' + swd + ' (vcenter_host_network_packet_rate{object="",' + s.clusterQueriesSelector + '}), 1)',
        'percent',
        'Packet error rate of ESXi hosts in the cluster.'
      ),
      clusterVMCPUUsage: raw('CPU usage', vmJoin3('vcenter_vm_cpu_usage_MHz'), 'rotmhz', 'CPU usage of VMs in the cluster.'),
      clusterVMCPUUtilization: raw('CPU utilization', vmJoin3('vcenter_vm_cpu_utilization_percent'), 'percent', 'CPU utilization of VMs in the cluster.'),
      clusterVMMemoryUsage: raw('Memory usage', vmJoin3('vcenter_vm_memory_usage_mebibytes'), 'mbytes', 'Memory usage of VMs in the cluster.'),
      clusterVMMemoryUtilization: raw('Memory utilization', vmJoin3('vcenter_vm_memory_utilization_percent'), 'percent', 'Memory utilization of VMs in the cluster.'),
      clusterVMDiskUsage: raw('Disk usage', vmJoin3('vcenter_vm_disk_usage_bytes'), 'bytes', 'Disk usage of VMs in the cluster.'),
      clusterVMDiskUtilization: raw('Disk utilization', vmJoin3('vcenter_vm_disk_utilization_percent'), 'percent', 'Disk utilization of VMs in the cluster.'),
      clusterVMNetworkThroughput: raw(
        'Net throughput',
        'label_join(' + swd + ' (vcenter_vm_network_usage{object="",' + s.clusterNoVAppQueriesSelector + '}), "vm_path", "/", "vcenter_resource_pool_inventory_path","vcenter_vm_name") or '
        + 'label_join(' + swd + ' (vcenter_vm_network_usage{object="",' + s.clusterNoRPoolQueriesSelector + '}), "vm_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name") or '
        + 'label_join(' + swd + ' (vcenter_vm_network_usage{object="",' + s.clusterNoRPoolOrVAppQueriesSelector + '}), "vm_path", "/", "vcenter_vm_name")',
        'KiBs',
        'Network throughput of VMs in the cluster.'
      ),
      clusterVMPacketDropRate: raw(
        'Packet drops',
        'label_join(' + swd + ' (vcenter_vm_network_packet_drop_rate{object="",' + s.clusterNoVAppQueriesSelector + '}) / clamp_min(' + swd + ' (vcenter_vm_network_packet_rate{object="",' + s.clusterNoVAppQueriesSelector + '}), 1), "vm_path", "/", "vcenter_resource_pool_inventory_path", "vcenter_vm_name") or '
        + 'label_join(' + swd + ' (vcenter_vm_network_packet_drop_rate{object="",' + s.clusterNoRPoolQueriesSelector + '}) / clamp_min(' + swd + ' (vcenter_vm_network_packet_rate{object="",' + s.clusterNoRPoolQueriesSelector + '}), 1), "vm_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name") or '
        + 'label_join(' + swd + ' (vcenter_vm_network_packet_drop_rate{object="",' + s.clusterNoRPoolOrVAppQueriesSelector + '}) / clamp_min(' + swd + ' (vcenter_vm_network_packet_rate{object="",' + s.clusterNoRPoolOrVAppQueriesSelector + '}), 1), "vm_path", "/", "vcenter_vm_name")',
        'percent',
        'Packet drop rate of VMs in the cluster.'
      ),
    },
  }
