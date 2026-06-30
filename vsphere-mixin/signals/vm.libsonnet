// Virtual machine signals shown on the vSphere virtual machines dashboard.
local selectors = import './selectors.libsonnet';

function(this)
  local s = selectors(this);
  local vmLegend = '{{vcenter_resource_pool_inventory_path}}{{vcenter_virtual_app_inventory_path}}/{{vcenter_vm_name}}';
  local vmSel = s.virtualMachinesQueriesSelector;
  // 3-way label_join over disk path (resource pool / virtual app / neither), VM-scoped.
  local diskJoin(metric, direction) =
    'label_join(' + metric + '{direction="' + direction + '", object!="", ' + s.virtualMachinesNoVAppQueriesSelector + '}, "disk_path", "/", "vcenter_resource_pool_inventory_path","vcenter_vm_name","object") or '
    + 'label_join(' + metric + '{direction="' + direction + '", object!="", ' + s.virtualMachinesNoRPoolQueriesSelector + '}, "disk_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name","object") or '
    + 'label_join(' + metric + '{direction="' + direction + '", object!="", ' + s.virtualMachinesNoRPoolOrVAppQueriesSelector + '}, "disk_path", "/", "vcenter_vm_name","object")';
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
      vmCPUUsage: raw('CPU usage', 'vcenter_vm_cpu_usage_MHz{' + vmSel + '}', 'rotmhz', 'The amount of CPU used by the VMs.', vmLegend),
      vmCPUUtilization: raw('CPU utilization', 'vcenter_vm_cpu_utilization_percent{' + vmSel + '}', 'percent', 'The CPU utilization percentage of VMs.', vmLegend),
      vmMemoryUsage: raw('Memory usage', 'vcenter_vm_memory_usage_mebibytes{' + vmSel + '}', 'mbytes', 'The amount of memory used by the VMs.', vmLegend),
      vmMemoryUtilization: raw('Memory utilization', 'vcenter_vm_memory_utilization_percent{' + vmSel + '}', 'percent', 'The memory utilization percentage of the VMs.', vmLegend),
      vmDiskUsage: raw('Disk usage', 'vcenter_vm_disk_usage_bytes{disk_state="used", ' + vmSel + '}', 'bytes', 'The amount of disk space used by the VMs.', vmLegend),
      vmDiskUtilization: raw('Disk utilization', 'vcenter_vm_disk_utilization_percent{' + vmSel + '}', 'percent', 'The disk utilization percentage of VMs.', vmLegend),
      vmModifiedMemoryBallooned: raw(
        'Modified memory ballooned',
        'vcenter_vm_memory_ballooned_mebibytes{' + vmSel + '} != 0',
        'mbytes',
        'The amount of memory ballooned on the VMs.',
        vmLegend + ' - ballooned'
      ),
      vmModifiedMemorySwapped: raw(
        'Modified memory swapped',
        'vcenter_vm_memory_swapped_mebibytes{' + vmSel + '} != 0',
        'mbytes',
        'The amount of memory swapped on the VMs.',
        vmLegend + ' - swapped'
      ),
      vmNetworkReceivedThroughputRate: raw(
        'Network throughput received',
        'vcenter_vm_network_throughput_bytes_per_sec{direction="received", object="", ' + vmSel + '}',
        'KiBs',
        'Data received over the network of the VMs.',
        vmLegend + ' - received'
      ),
      vmNetworkTransmittedThroughputRate: raw(
        'Network throughput transmitted',
        'vcenter_vm_network_throughput_bytes_per_sec{direction="transmitted", object="", ' + vmSel + '}',
        'KiBs',
        'Data transmitted over the network of the VMs.',
        vmLegend + ' - transmitted'
      ),
      vmPacketReceivedDropRate: raw(
        'Packet drops received',
        'vcenter_vm_network_packet_drop_rate{direction="received", object="", ' + vmSel + '} / clamp_min(vcenter_vm_network_packet_rate{direction="received", object="", ' + vmSel + '}, 1) != 0',
        'percent',
        'Received packet drop rate of the VMs.',
        vmLegend + ' - received'
      ),
      vmPacketTransmittedDropRate: raw(
        'Packet drops transmitted',
        'vcenter_vm_network_packet_drop_rate{direction="transmitted", object="", ' + vmSel + '} / clamp_min(vcenter_vm_network_packet_rate{direction="transmitted", object="", ' + vmSel + '}, 1) != 0',
        'percent',
        'Transmitted packet drop rate of the VMs.',
        vmLegend + ' - transmitted'
      ),
      vmDiskReadThroughput: raw('Throughput (R)', diskJoin('vcenter_vm_disk_throughput', 'read'), 'KiBs', 'Read throughput of disks on the VMs.'),
      vmDiskReadLatency: raw('Delay (R)', diskJoin('vcenter_vm_disk_latency_avg_milliseconds', 'read'), 'ms', 'Read latency of disks on the VMs.'),
      vmDiskWriteThroughput: raw('Throughput (W)', diskJoin('vcenter_vm_disk_throughput', 'write'), 'KiBs', 'Write throughput of disks on the VMs.'),
      vmDiskWriteLatency: raw('Delay (W)', diskJoin('vcenter_vm_disk_latency_avg_milliseconds', 'write'), 'ms', 'Write latency of disks on the VMs.'),
    },
  }
