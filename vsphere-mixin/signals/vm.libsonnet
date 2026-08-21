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
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: [],
    datasource: 'prometheus_datasource',
    aggLevel: 'none',
    aggFunction: 'avg',
    signals: {
      vmCPUUsage: {
        name: 'CPU usage',
        description: 'The amount of CPU used by the VMs.',
        type: 'raw',
        unit: 'rotmhz',
        sources: {
          prometheus: {
            expr: 'vcenter_vm_cpu_usage_MHz{' + vmSel + '}',
            legendCustomTemplate: vmLegend,
          },
        },
      },
      vmCPUUtilization: {
        name: 'CPU utilization',
        description: 'The CPU utilization percentage of VMs.',
        type: 'raw',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'vcenter_vm_cpu_utilization_percent{' + vmSel + '}',
            legendCustomTemplate: vmLegend,
          },
        },
      },
      vmMemoryUsage: {
        name: 'Memory usage',
        description: 'The amount of memory used by the VMs.',
        type: 'raw',
        unit: 'mbytes',
        sources: {
          prometheus: {
            expr: 'vcenter_vm_memory_usage_mebibytes{' + vmSel + '}',
            legendCustomTemplate: vmLegend,
          },
        },
      },
      vmMemoryUtilization: {
        name: 'Memory utilization',
        description: 'The memory utilization percentage of the VMs.',
        type: 'raw',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'vcenter_vm_memory_utilization_percent{' + vmSel + '}',
            legendCustomTemplate: vmLegend,
          },
        },
      },
      vmDiskUsage: {
        name: 'Disk usage',
        description: 'The amount of disk space used by the VMs.',
        type: 'raw',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'vcenter_vm_disk_usage_bytes{disk_state="used", ' + vmSel + '}',
            legendCustomTemplate: vmLegend,
          },
        },
      },
      vmDiskUtilization: {
        name: 'Disk utilization',
        description: 'The disk utilization percentage of VMs.',
        type: 'raw',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'vcenter_vm_disk_utilization_percent{' + vmSel + '}',
            legendCustomTemplate: vmLegend,
          },
        },
      },
      vmModifiedMemoryBallooned: {
        name: 'Modified memory ballooned',
        description: 'The amount of memory ballooned on the VMs.',
        type: 'raw',
        unit: 'mbytes',
        sources: {
          prometheus: {
            expr: 'vcenter_vm_memory_ballooned_mebibytes{' + vmSel + '} != 0',
            legendCustomTemplate: vmLegend + ' - ballooned',
          },
        },
      },
      vmModifiedMemorySwapped: {
        name: 'Modified memory swapped',
        description: 'The amount of memory swapped on the VMs.',
        type: 'raw',
        unit: 'mbytes',
        sources: {
          prometheus: {
            expr: 'vcenter_vm_memory_swapped_mebibytes{' + vmSel + '} != 0',
            legendCustomTemplate: vmLegend + ' - swapped',
          },
        },
      },
      vmNetworkReceivedThroughputRate: {
        name: 'Network throughput received',
        description: 'Data received over the network of the VMs.',
        type: 'raw',
        unit: 'KiBs',
        sources: {
          prometheus: {
            expr: 'vcenter_vm_network_throughput_bytes_per_sec{direction="received", object="", ' + vmSel + '}',
            legendCustomTemplate: vmLegend + ' - received',
          },
        },
      },
      vmNetworkTransmittedThroughputRate: {
        name: 'Network throughput transmitted',
        description: 'Data transmitted over the network of the VMs.',
        type: 'raw',
        unit: 'KiBs',
        sources: {
          prometheus: {
            expr: 'vcenter_vm_network_throughput_bytes_per_sec{direction="transmitted", object="", ' + vmSel + '}',
            legendCustomTemplate: vmLegend + ' - transmitted',
          },
        },
      },
      vmPacketReceivedDropRate: {
        name: 'Packet drops received',
        description: 'Received packet drop rate of the VMs.',
        type: 'raw',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'vcenter_vm_network_packet_drop_rate{direction="received", object="", ' + vmSel + '} / clamp_min(vcenter_vm_network_packet_rate{direction="received", object="", ' + vmSel + '}, 1) != 0',
            legendCustomTemplate: vmLegend + ' - received',
          },
        },
      },
      vmPacketTransmittedDropRate: {
        name: 'Packet drops transmitted',
        description: 'Transmitted packet drop rate of the VMs.',
        type: 'raw',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'vcenter_vm_network_packet_drop_rate{direction="transmitted", object="", ' + vmSel + '} / clamp_min(vcenter_vm_network_packet_rate{direction="transmitted", object="", ' + vmSel + '}, 1) != 0',
            legendCustomTemplate: vmLegend + ' - transmitted',
          },
        },
      },
      vmDiskReadThroughput: {
        name: 'Throughput (R)',
        description: 'Read throughput of disks on the VMs.',
        type: 'raw',
        unit: 'KiBs',
        sources: {
          prometheus: {
            expr: diskJoin('vcenter_vm_disk_throughput', 'read'),
            legendCustomTemplate: '',
          },
        },
      },
      vmDiskReadLatency: {
        name: 'Delay (R)',
        description: 'Read latency of disks on the VMs.',
        type: 'raw',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: diskJoin('vcenter_vm_disk_latency_avg_milliseconds', 'read'),
            legendCustomTemplate: '',
          },
        },
      },
      vmDiskWriteThroughput: {
        name: 'Throughput (W)',
        description: 'Write throughput of disks on the VMs.',
        type: 'raw',
        unit: 'KiBs',
        sources: {
          prometheus: {
            expr: diskJoin('vcenter_vm_disk_throughput', 'write'),
            legendCustomTemplate: '',
          },
        },
      },
      vmDiskWriteLatency: {
        name: 'Delay (W)',
        description: 'Write latency of disks on the VMs.',
        type: 'raw',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: diskJoin('vcenter_vm_disk_latency_avg_milliseconds', 'write'),
            legendCustomTemplate: '',
          },
        },
      },
    },
  }
