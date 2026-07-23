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
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: [],
    datasource: 'prometheus_datasource',
    aggLevel: 'none',
    aggFunction: 'avg',
    signals: {
      hostCPUUsage: {
        name: 'CPU usage',
        description: 'The amount of CPU used by the ESXi host.',
        type: 'raw',
        unit: 'rotmhz',
        sources: {
          prometheus: {
            expr: 'vcenter_host_cpu_usage_MHz{' + s.hostQueriesSelector + '}',
            legendCustomTemplate: hostLegend,
          },
        },
      },
      hostCPUUtilization: {
        name: 'CPU utilization',
        description: 'The CPU utilization percentage of the ESXi host.',
        type: 'raw',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'vcenter_host_cpu_utilization_percent{' + s.hostQueriesSelector + '}',
            legendCustomTemplate: hostLegend,
          },
        },
      },
      hostMemoryUsage: {
        name: 'Memory usage',
        description: 'The amount of memory used by the ESXi host.',
        type: 'raw',
        unit: 'mbytes',
        sources: {
          prometheus: {
            expr: 'vcenter_host_memory_usage_mebibytes{' + s.hostQueriesSelector + '}',
            legendCustomTemplate: hostLegend,
          },
        },
      },
      hostMemoryUtilization: {
        name: 'Memory utilization',
        description: 'The memory utilization percentage of the ESXi host.',
        type: 'raw',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'vcenter_host_memory_utilization_percent{' + s.hostQueriesSelector + '}',
            legendCustomTemplate: hostLegend,
          },
        },
      },
      hostModifiedMemoryBallooned: {
        name: 'Modified memory ballooned',
        description: 'The amount of memory ballooned on the ESXi host.',
        type: 'raw',
        unit: 'mbytes',
        sources: {
          prometheus: {
            expr: hostSumBy + ' (vcenter_vm_memory_ballooned_mebibytes{' + s.hostQueriesSelector + '}) != 0',
            legendCustomTemplate: hostLegend + ' - ballooned',
          },
        },
      },
      hostModifiedMemorySwapped: {
        name: 'Modified memory swapped',
        description: 'The amount of memory swapped on the ESXi host.',
        type: 'raw',
        unit: 'mbytes',
        sources: {
          prometheus: {
            expr: hostSumBy + ' (vcenter_vm_memory_swapped_mebibytes{' + s.hostQueriesSelector + '}) != 0',
            legendCustomTemplate: hostLegend + ' - swapped',
          },
        },
      },
      hostNetworkTransmittedThroughputRate: {
        name: 'Network throughput transmitted',
        description: 'Data transmitted over the network of the ESXi host.',
        type: 'raw',
        unit: 'KiBs',
        sources: {
          prometheus: {
            expr: 'vcenter_host_network_throughput{direction="transmitted", object="", ' + s.hostQueriesSelector + '}',
            legendCustomTemplate: hostLegend + ' - transmitted',
          },
        },
      },
      hostNetworkReceivedThroughputRate: {
        name: 'Network throughput received',
        description: 'Data received over the network of the ESXi host.',
        type: 'raw',
        unit: 'KiBs',
        sources: {
          prometheus: {
            expr: 'vcenter_host_network_throughput{direction="received", object="", ' + s.hostQueriesSelector + '}',
            legendCustomTemplate: hostLegend + ' - received',
          },
        },
      },
      hostPacketReceivedErrorRate: {
        name: 'Packet errors received',
        description: 'Received packet error rate of the ESXi host.',
        type: 'raw',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'vcenter_host_network_packet_error_rate{direction="received", object="", ' + s.hostQueriesSelector + '} / clamp_min(vcenter_host_network_packet_rate{direction="received", object="", ' + s.hostQueriesSelector + '}, 1) != 0',
            legendCustomTemplate: hostLegend + ' - received',
          },
        },
      },
      hostPacketTransmittedErrorRate: {
        name: 'Packet errors transmitted',
        description: 'Transmitted packet error rate of the ESXi host.',
        type: 'raw',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'vcenter_host_network_packet_error_rate{direction="transmitted", object="", ' + s.hostQueriesSelector + '} / clamp_min(vcenter_host_network_packet_rate{direction="transmitted", object="", ' + s.hostQueriesSelector + '}, 1) != 0',
            legendCustomTemplate: hostLegend + ' - transmitted',
          },
        },
      },
      hostVMCPUUsage: {
        name: 'CPU usage',
        description: 'CPU usage of VMs on the ESXi host.',
        type: 'raw',
        unit: 'rotmhz',
        sources: {
          prometheus: {
            expr: vmJoin3('vcenter_vm_cpu_usage_MHz'),
            legendCustomTemplate: '',
          },
        },
      },
      hostVMCPUUtilization: {
        name: 'CPU utilization',
        description: 'CPU utilization of VMs on the ESXi host.',
        type: 'raw',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: vmJoin3('vcenter_vm_cpu_utilization_percent'),
            legendCustomTemplate: '',
          },
        },
      },
      hostVMMemoryUsage: {
        name: 'Memory usage',
        description: 'Memory usage of VMs on the ESXi host.',
        type: 'raw',
        unit: 'mbytes',
        sources: {
          prometheus: {
            expr: vmJoin3('vcenter_vm_memory_usage_mebibytes'),
            legendCustomTemplate: '',
          },
        },
      },
      hostVMMemoryUtilization: {
        name: 'Memory utilization',
        description: 'Memory utilization of VMs on the ESXi host.',
        type: 'raw',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: vmJoin3('vcenter_vm_memory_utilization_percent'),
            legendCustomTemplate: '',
          },
        },
      },
      hostVMDiskUsage: {
        name: 'Disk usage',
        description: 'Disk usage of VMs on the ESXi host.',
        type: 'raw',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: vmJoin3('vcenter_vm_disk_usage_bytes'),
            legendCustomTemplate: '',
          },
        },
      },
      hostVMDiskUtilization: {
        name: 'Disk utilization',
        description: 'Disk utilization of VMs on the ESXi host.',
        type: 'raw',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: vmJoin3('vcenter_vm_disk_utilization_percent'),
            legendCustomTemplate: '',
          },
        },
      },
      hostVMNetworkThroughput: {
        name: 'Net throughput',
        description: 'Network throughput of VMs on the ESXi host.',
        type: 'raw',
        unit: 'KiBs',
        sources: {
          prometheus: {
            expr: 'label_join(' + swd + ' (vcenter_vm_network_usage{object!="", ' + s.hostNoVAppQueriesSelector + '}), "vm_path", "/", "vcenter_resource_pool_inventory_path","vcenter_vm_name") or '
                  + 'label_join(' + swd + ' (vcenter_vm_network_usage{object!="", ' + s.hostNoRPoolQueriesSelector + '}), "vm_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name") or '
                  + 'label_join(' + swd + ' (vcenter_vm_network_usage{object!="", ' + s.hostNoRPoolOrVAppQueriesSelector + '}), "vm_path", "/", "vcenter_vm_name")',
            legendCustomTemplate: '',
          },
        },
      },
      hostVMPacketDropRate: {
        name: 'Packet drops',
        description: 'Packet drop rate of VMs on the ESXi host.',
        type: 'raw',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'label_join(' + swd + ' (vcenter_vm_network_packet_drop_rate{object!="", ' + s.hostNoVAppQueriesSelector + '}) / clamp_min(' + swd + ' (vcenter_vm_network_packet_rate{object!="", ' + s.hostNoVAppQueriesSelector + '}), 1), "vm_path", "/", "vcenter_resource_pool_inventory_path","vcenter_vm_name") or '
                  + 'label_join(' + swd + ' (vcenter_vm_network_packet_drop_rate{object!="", ' + s.hostNoRPoolQueriesSelector + '}) / clamp_min(' + swd + ' (vcenter_vm_network_packet_rate{object!="", ' + s.hostNoRPoolQueriesSelector + '}), 1), "vm_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name") or '
                  + 'label_join(' + swd + ' (vcenter_vm_network_packet_drop_rate{object!="", ' + s.hostNoRPoolOrVAppQueriesSelector + '}) / clamp_min(' + swd + ' (vcenter_vm_network_packet_rate{object!="", ' + s.hostNoRPoolOrVAppQueriesSelector + '}), 1), "vm_path", "/", "vcenter_vm_name")',
            legendCustomTemplate: '',
          },
        },
      },
      hostDiskReadThroughput: {
        name: 'Throughput (R)',
        description: 'Read throughput of disks on the ESXi host.',
        type: 'raw',
        unit: 'KiBs',
        sources: {
          prometheus: {
            expr: diskJoin('vcenter_host_disk_throughput', 'read'),
            legendCustomTemplate: '',
          },
        },
      },
      hostDiskReadLatency: {
        name: 'Delay (R)',
        description: 'Read latency of disks on the ESXi host.',
        type: 'raw',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: diskJoin('vcenter_host_disk_latency_avg_milliseconds', 'read'),
            legendCustomTemplate: '',
          },
        },
      },
      hostDiskWriteThroughput: {
        name: 'Throughput (W)',
        description: 'Write throughput of disks on the ESXi host.',
        type: 'raw',
        unit: 'KiBs',
        sources: {
          prometheus: {
            expr: diskJoin('vcenter_host_disk_throughput', 'write'),
            legendCustomTemplate: '',
          },
        },
      },
      hostDiskWriteLatency: {
        name: 'Delay (W)',
        description: 'Write latency of disks on the ESXi host.',
        type: 'raw',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: diskJoin('vcenter_host_disk_latency_avg_milliseconds', 'write'),
            legendCustomTemplate: '',
          },
        },
      },
    },
  }
