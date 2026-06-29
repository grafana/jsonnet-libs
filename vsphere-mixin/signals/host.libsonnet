// ESXi host signals shown on the vSphere hosts dashboard.
local selectors = import './selectors.libsonnet';

function(this)
  local s = selectors(this);
  local hostLegend = '{{vcenter_host_name}}';
  local hostSumBy = 'sum by (job, vcenter_datacenter_name, vcenter_cluster_name, vcenter_host_name)';
  local swd = 'sum without(object, direction)';
  // 3-way label_join over the VM inventory path, host-scoped selectors.
  local vmJoin3(metric) =
    'label_join(' + metric + '{' + s.hostNoVAppQueriesSelector + '}, "vm_path", "/", "vcenter_resource_pool_inventory_path","vcenter_vm_name") or '
    + 'label_join(' + metric + '{' + s.hostNoRPoolQueriesSelector + '}, "vm_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name") or '
    + 'label_join(' + metric + '{' + s.hostNoRPoolOrVAppQueriesSelector + '}, "vm_path", "/", "vcenter_vm_name")';
  // 2-way label_join over disk path (with/without cluster).
  local diskJoin(metric, direction) =
    'label_join(' + metric + '{direction="' + direction + '", object!="", ' + s.hostNoClusterQueriesSelector + '}, "disk_path", "/", "vcenter_host_name","object") or '
    + 'label_join(' + metric + '{direction="' + direction + '", object!="", ' + s.hostWithClusterQueriesSelector + '}, "disk_path", "/", "vcenter_cluster_name","vcenter_host_name","object")';
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
      hostCPUUsage: raw('CPU usage', 'vcenter_host_cpu_usage_MHz{' + s.hostQueriesSelector + '}', 'rotmhz', 'The amount of CPU used by the ESXi host.', hostLegend),
      hostCPUUtilization: raw('CPU utilization', 'vcenter_host_cpu_utilization_percent{' + s.hostQueriesSelector + '}', 'percent', 'The CPU utilization percentage of the ESXi host.', hostLegend),
      hostMemoryUsage: raw('Memory usage', 'vcenter_host_memory_usage_mebibytes{' + s.hostQueriesSelector + '}', 'mbytes', 'The amount of memory used by the ESXi host.', hostLegend),
      hostMemoryUtilization: raw('Memory utilization', 'vcenter_host_memory_utilization_percent{' + s.hostQueriesSelector + '}', 'percent', 'The memory utilization percentage of the ESXi host.', hostLegend),
      hostModifiedMemoryBallooned: raw(
        'Modified memory ballooned',
        hostSumBy + ' (vcenter_vm_memory_ballooned_mebibytes{' + s.hostQueriesSelector + '}) != 0',
        'mbytes',
        'The amount of memory ballooned on the ESXi host.',
        hostLegend + ' - ballooned'
      ),
      hostModifiedMemorySwapped: raw(
        'Modified memory swapped',
        hostSumBy + ' (vcenter_vm_memory_swapped_mebibytes{' + s.hostQueriesSelector + '}) != 0',
        'mbytes',
        'The amount of memory swapped on the ESXi host.',
        hostLegend + ' - swapped'
      ),
      hostNetworkTransmittedThroughputRate: raw(
        'Network throughput transmitted',
        'vcenter_host_network_throughput{direction="transmitted", object="", ' + s.hostQueriesSelector + '}',
        'KiBs',
        'Data transmitted over the network of the ESXi host.',
        hostLegend + ' - transmitted'
      ),
      hostNetworkReceivedThroughputRate: raw(
        'Network throughput received',
        'vcenter_host_network_throughput{direction="received", object="", ' + s.hostQueriesSelector + '}',
        'KiBs',
        'Data received over the network of the ESXi host.',
        hostLegend + ' - received'
      ),
      hostPacketReceivedErrorRate: raw(
        'Packet errors received',
        'vcenter_host_network_packet_error_rate{direction="received", object="", ' + s.hostQueriesSelector + '} / clamp_min(vcenter_host_network_packet_rate{direction="received", object="", ' + s.hostQueriesSelector + '}, 1) != 0',
        'percent',
        'Received packet error rate of the ESXi host.',
        hostLegend + ' - received'
      ),
      hostPacketTransmittedErrorRate: raw(
        'Packet errors transmitted',
        'vcenter_host_network_packet_error_rate{direction="transmitted", object="", ' + s.hostQueriesSelector + '} / clamp_min(vcenter_host_network_packet_rate{direction="transmitted", object="", ' + s.hostQueriesSelector + '}, 1) != 0',
        'percent',
        'Transmitted packet error rate of the ESXi host.',
        hostLegend + ' - transmitted'
      ),
      hostVMCPUUsage: raw('CPU usage', vmJoin3('vcenter_vm_cpu_usage_MHz'), 'rotmhz', 'CPU usage of VMs on the ESXi host.'),
      hostVMCPUUtilization: raw('CPU utilization', vmJoin3('vcenter_vm_cpu_utilization_percent'), 'percent', 'CPU utilization of VMs on the ESXi host.'),
      hostVMMemoryUsage: raw('Memory usage', vmJoin3('vcenter_vm_memory_usage_mebibytes'), 'mbytes', 'Memory usage of VMs on the ESXi host.'),
      hostVMMemoryUtilization: raw('Memory utilization', vmJoin3('vcenter_vm_memory_utilization_percent'), 'percent', 'Memory utilization of VMs on the ESXi host.'),
      hostVMDiskUsage: raw('Disk usage', vmJoin3('vcenter_vm_disk_usage_bytes'), 'bytes', 'Disk usage of VMs on the ESXi host.'),
      hostVMDiskUtilization: raw('Disk utilization', vmJoin3('vcenter_vm_disk_utilization_percent'), 'percent', 'Disk utilization of VMs on the ESXi host.'),
      hostVMNetworkThroughput: raw(
        'Net throughput',
        'label_join(' + swd + ' (vcenter_vm_network_usage{object!="", ' + s.hostNoVAppQueriesSelector + '}), "vm_path", "/", "vcenter_resource_pool_inventory_path","vcenter_vm_name") or '
        + 'label_join(' + swd + ' (vcenter_vm_network_usage{object!="", ' + s.hostNoRPoolQueriesSelector + '}), "vm_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name") or '
        + 'label_join(' + swd + ' (vcenter_vm_network_usage{object!="", ' + s.hostNoRPoolOrVAppQueriesSelector + '}), "vm_path", "/", "vcenter_vm_name")',
        'KiBs',
        'Network throughput of VMs on the ESXi host.'
      ),
      hostVMPacketDropRate: raw(
        'Packet drops',
        'label_join(' + swd + ' (vcenter_vm_network_packet_drop_rate{object!="", ' + s.hostNoVAppQueriesSelector + '}) / clamp_min(' + swd + ' (vcenter_vm_network_packet_rate{object!="", ' + s.hostNoVAppQueriesSelector + '}), 1), "vm_path", "/", "vcenter_resource_pool_inventory_path","vcenter_vm_name") or '
        + 'label_join(' + swd + ' (vcenter_vm_network_packet_drop_rate{object!="", ' + s.hostNoRPoolQueriesSelector + '}) / clamp_min(' + swd + ' (vcenter_vm_network_packet_rate{object!="", ' + s.hostNoRPoolQueriesSelector + '}), 1), "vm_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name") or '
        + 'label_join(' + swd + ' (vcenter_vm_network_packet_drop_rate{object!="", ' + s.hostNoRPoolOrVAppQueriesSelector + '}) / clamp_min(' + swd + ' (vcenter_vm_network_packet_rate{object!="", ' + s.hostNoRPoolOrVAppQueriesSelector + '}), 1), "vm_path", "/", "vcenter_vm_name")',
        'percent',
        'Packet drop rate of VMs on the ESXi host.'
      ),
      hostDiskReadThroughput: raw('Throughput (R)', diskJoin('vcenter_host_disk_throughput', 'read'), 'KiBs', 'Read throughput of disks on the ESXi host.'),
      hostDiskReadLatency: raw('Delay (R)', diskJoin('vcenter_host_disk_latency_avg_milliseconds', 'read'), 'ms', 'Read latency of disks on the ESXi host.'),
      hostDiskWriteThroughput: raw('Throughput (W)', diskJoin('vcenter_host_disk_throughput', 'write'), 'KiBs', 'Write throughput of disks on the ESXi host.'),
      hostDiskWriteLatency: raw('Delay (W)', diskJoin('vcenter_host_disk_latency_avg_milliseconds', 'write'), 'ms', 'Write latency of disks on the ESXi host.'),
    },
  }
