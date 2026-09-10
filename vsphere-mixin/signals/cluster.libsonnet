// Cluster signals shown on the vSphere clusters dashboard.
local selectors = import './selectors.libsonnet';

function(this)
  local s = selectors(this);
  local clusterLegend = '{{vcenter_cluster_name}}';
  local clusterSumBy = 'sum by (job, vcenter_datacenter_name, vcenter_cluster_name)';
  local swd = 'sum without(object, direction)';
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: [],
    datasource: 'prometheus_datasource',
    aggLevel: 'none',
    aggFunction: 'avg',
    signals: {
      clusterVMsOnCount: {
        name: 'VMs on',
        description: 'The number of virtual machines currently powered on within the cluster.',
        type: 'gauge',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'vcenter_cluster_vm_count{power_state="on", ' + s.clusterQueriesSelector + '}',
            legendCustomTemplate: '',
          },
        },
      },
      clusterVMsOffCount: {
        name: 'VMs off',
        description: 'The number of virtual machines currently powered off within the cluster.',
        type: 'gauge',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'vcenter_cluster_vm_count{power_state="off", ' + s.clusterQueriesSelector + '}',
            legendCustomTemplate: '',
          },
        },
      },
      clusterVMsSuspendedCount: {
        name: 'VMs suspended',
        description: 'The number of virtual machines currently in a suspended state within the cluster.',
        type: 'gauge',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'vcenter_cluster_vm_count{power_state="suspended", ' + s.clusterQueriesSelector + '}',
            legendCustomTemplate: '',
          },
        },
      },
      clusterHostsActiveCount: {
        name: 'Active ESXi hosts',
        description: 'The number of ESXi hosts that are currently running (responding and not in maintenance mode) within the cluster.',
        type: 'gauge',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'vcenter_cluster_host_count{effective="true", ' + s.clusterQueriesSelector + '}',
            legendCustomTemplate: '',
          },
        },
      },
      clusterHostsInactiveCount: {
        name: 'Inactive ESXi hosts',
        description: 'The number of ESXi hosts that are currently not running (not responding or in maintenance mode) within the cluster.',
        type: 'gauge',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'vcenter_cluster_host_count{effective="false", ' + s.clusterQueriesSelector + '}',
            legendCustomTemplate: '',
          },
        },
      },
      clusterResourcePoolsCount: {
        name: 'Resource pools',
        description: 'The number of resource pools within the cluster (including nested).',
        type: 'gauge',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'vcenter_resource_pool_cpu_shares{' + s.clusterQueriesSelector + '}',
            // Bare count() over every series, no by-clause, so it rides as a wrapper.
            exprWrappers: [['count(', ')']],
            legendCustomTemplate: '',
          },
        },
      },
      clusterCPUEffective: {
        name: 'Cluster CPU effective',
        description: 'The effective CPU capacity of the cluster.',
        type: 'gauge',
        unit: 'rotmhz',
        sources: {
          prometheus: {
            expr: 'vcenter_cluster_cpu_effective{' + s.clusterQueriesSelector + '}',
            legendCustomTemplate: clusterLegend,
          },
        },
      },
      clusterCPULimit: {
        name: 'Cluster CPU limit',
        description: 'The available CPU capacity of the cluster.',
        type: 'gauge',
        unit: 'rotmhz',
        sources: {
          prometheus: {
            expr: 'vcenter_cluster_cpu_limit{' + s.clusterQueriesSelector + '}',
            legendCustomTemplate: clusterLegend,
          },
        },
      },
      // Raw: host usage divided by cluster limit — two different metrics.
      clusterCPUUtilization: {
        name: 'Cluster CPU utilization',
        description: 'The CPU utilization percentage of the cluster.',
        type: 'raw',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: '(100 * ' + clusterSumBy + ' (vcenter_host_cpu_usage_MHz{' + s.clusterQueriesSelector + '}) / clamp_min(vcenter_cluster_cpu_limit{' + s.clusterQueriesSelector + '}, 1))',
            legendCustomTemplate: clusterLegend,
          },
        },
      },
      clusterMemoryEffective: {
        name: 'Cluster memory effective',
        description: 'The effective memory capacity of the cluster.',
        type: 'gauge',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'vcenter_cluster_memory_effective_bytes{' + s.queriesSelector + '}',
            legendCustomTemplate: clusterLegend,
          },
        },
      },
      clusterMemoryLimit: {
        name: 'Cluster memory limit',
        description: 'The available memory capacity of the cluster.',
        type: 'gauge',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'vcenter_cluster_memory_limit_bytes{' + s.queriesSelector + '}',
            legendCustomTemplate: clusterLegend,
          },
        },
      },
      // Raw: host usage divided by cluster limit — two different metrics.
      clusterMemoryUtilization: {
        name: 'Cluster memory utilization',
        description: 'The memory utilization percentage of the cluster.',
        type: 'raw',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: ' 104857600 * ' + clusterSumBy + ' (vcenter_host_memory_usage_mebibytes{' + s.clusterQueriesSelector + '}) / clamp_min(vcenter_cluster_memory_limit_bytes{' + s.clusterQueriesSelector + '}, 1)',
            legendCustomTemplate: clusterLegend,
          },
        },
      },
      clusterHostCPUUsage: {
        name: 'CPU usage',
        description: 'CPU usage of ESXi hosts in the cluster.',
        type: 'gauge',
        unit: 'rotmhz',
        sources: {
          prometheus: {
            expr: 'vcenter_host_cpu_usage_MHz{' + s.clusterQueriesSelector + '}',
            legendCustomTemplate: '',
          },
        },
      },
      clusterHostCPUUtilization: {
        name: 'CPU utilization',
        description: 'CPU utilization of ESXi hosts in the cluster.',
        type: 'gauge',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'vcenter_host_cpu_utilization_percent{' + s.clusterQueriesSelector + '}',
            legendCustomTemplate: '',
          },
        },
      },
      clusterHostMemoryUsage: {
        name: 'Memory usage',
        description: 'Memory usage of ESXi hosts in the cluster.',
        type: 'gauge',
        unit: 'mbytes',
        sources: {
          prometheus: {
            expr: 'vcenter_host_memory_usage_mebibytes{' + s.clusterQueriesSelector + '}',
            legendCustomTemplate: '',
          },
        },
      },
      clusterHostMemoryUtilization: {
        name: 'Memory utilization',
        description: 'Memory utilization of ESXi hosts in the cluster.',
        type: 'gauge',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'vcenter_host_memory_utilization_percent{' + s.clusterQueriesSelector + '}',
            legendCustomTemplate: '',
          },
        },
      },
      clusterHostDiskThroughput: {
        name: 'Disk throughput',
        description: 'Disk throughput of ESXi hosts in the cluster.',
        type: 'gauge',
        unit: 'KiBs',
        sources: {
          prometheus: {
            expr: 'vcenter_host_disk_throughput{object="",' + s.clusterQueriesSelector + '}',
            // `sum without(...)` has no aggLevel equivalent (the framework only emits
            // `by (...)`), so the collapse rides as a wrapper.
            exprWrappers: [[swd + ' (', ')']],
            legendCustomTemplate: '',
          },
        },
      },
      clusterHostDiskLatency: {
        name: 'Disk delay',
        description: 'Disk latency of ESXi hosts in the cluster.',
        type: 'gauge',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'vcenter_host_disk_latency_avg_milliseconds{' + s.clusterQueriesSelector + '}',
            exprWrappers: [[swd + ' (', ')']],
            legendCustomTemplate: '',
          },
        },
      },
      clusterHostNetworkThroughput: {
        name: 'Net throughput',
        description: 'Network throughput of ESXi hosts in the cluster.',
        type: 'gauge',
        unit: 'KiBs',
        sources: {
          prometheus: {
            expr: 'vcenter_host_network_usage{object="",' + s.clusterQueriesSelector + '}',
            exprWrappers: [[swd + ' (', ')']],
            legendCustomTemplate: '',
          },
        },
      },
      // Raw: ratio of two different metrics, each separately collapsed.
      clusterHostPacketErrorRate: {
        name: 'Packet errors',
        description: 'Packet error rate of ESXi hosts in the cluster.',
        type: 'raw',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: swd + ' (vcenter_host_network_packet_error_rate{object="",' + s.clusterQueriesSelector + '}) / clamp_min(' + swd + ' (vcenter_host_network_packet_rate{object="",' + s.clusterQueriesSelector + '}), 1)',
            legendCustomTemplate: '',
          },
        },
      },
      // Raw: 3-way label_join / or chain over mutually exclusive selectors.
      clusterVMCPUUsage: {
        name: 'CPU usage',
        description: 'CPU usage of VMs in the cluster.',
        type: 'raw',
        unit: 'rotmhz',
        sources: {
          prometheus: {
            expr: 'label_join(vcenter_vm_cpu_usage_MHz{' + s.clusterNoVAppQueriesSelector + '}, "vm_path", "/", "vcenter_resource_pool_inventory_path","vcenter_vm_name") or '
                  + 'label_join(vcenter_vm_cpu_usage_MHz{' + s.clusterNoRPoolQueriesSelector + '}, "vm_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name") or '
                  + 'label_join(vcenter_vm_cpu_usage_MHz{' + s.clusterNoRPoolOrVAppQueriesSelector + '}, "vm_path", "/", "vcenter_vm_name")',
            legendCustomTemplate: '',
          },
        },
      },
      // Raw: 3-way label_join / or chain over mutually exclusive selectors.
      clusterVMCPUUtilization: {
        name: 'CPU utilization',
        description: 'CPU utilization of VMs in the cluster.',
        type: 'raw',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'label_join(vcenter_vm_cpu_utilization_percent{' + s.clusterNoVAppQueriesSelector + '}, "vm_path", "/", "vcenter_resource_pool_inventory_path","vcenter_vm_name") or '
                  + 'label_join(vcenter_vm_cpu_utilization_percent{' + s.clusterNoRPoolQueriesSelector + '}, "vm_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name") or '
                  + 'label_join(vcenter_vm_cpu_utilization_percent{' + s.clusterNoRPoolOrVAppQueriesSelector + '}, "vm_path", "/", "vcenter_vm_name")',
            legendCustomTemplate: '',
          },
        },
      },
      // Raw: 3-way label_join / or chain over mutually exclusive selectors.
      clusterVMMemoryUsage: {
        name: 'Memory usage',
        description: 'Memory usage of VMs in the cluster.',
        type: 'raw',
        unit: 'mbytes',
        sources: {
          prometheus: {
            expr: 'label_join(vcenter_vm_memory_usage_mebibytes{' + s.clusterNoVAppQueriesSelector + '}, "vm_path", "/", "vcenter_resource_pool_inventory_path","vcenter_vm_name") or '
                  + 'label_join(vcenter_vm_memory_usage_mebibytes{' + s.clusterNoRPoolQueriesSelector + '}, "vm_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name") or '
                  + 'label_join(vcenter_vm_memory_usage_mebibytes{' + s.clusterNoRPoolOrVAppQueriesSelector + '}, "vm_path", "/", "vcenter_vm_name")',
            legendCustomTemplate: '',
          },
        },
      },
      // Raw: 3-way label_join / or chain over mutually exclusive selectors.
      clusterVMMemoryUtilization: {
        name: 'Memory utilization',
        description: 'Memory utilization of VMs in the cluster.',
        type: 'raw',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'label_join(vcenter_vm_memory_utilization_percent{' + s.clusterNoVAppQueriesSelector + '}, "vm_path", "/", "vcenter_resource_pool_inventory_path","vcenter_vm_name") or '
                  + 'label_join(vcenter_vm_memory_utilization_percent{' + s.clusterNoRPoolQueriesSelector + '}, "vm_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name") or '
                  + 'label_join(vcenter_vm_memory_utilization_percent{' + s.clusterNoRPoolOrVAppQueriesSelector + '}, "vm_path", "/", "vcenter_vm_name")',
            legendCustomTemplate: '',
          },
        },
      },
      // Raw: 3-way label_join / or chain over mutually exclusive selectors.
      clusterVMDiskUsage: {
        name: 'Disk usage',
        description: 'Disk usage of VMs in the cluster.',
        type: 'raw',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'label_join(vcenter_vm_disk_usage_bytes{' + s.clusterNoVAppQueriesSelector + '}, "vm_path", "/", "vcenter_resource_pool_inventory_path","vcenter_vm_name") or '
                  + 'label_join(vcenter_vm_disk_usage_bytes{' + s.clusterNoRPoolQueriesSelector + '}, "vm_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name") or '
                  + 'label_join(vcenter_vm_disk_usage_bytes{' + s.clusterNoRPoolOrVAppQueriesSelector + '}, "vm_path", "/", "vcenter_vm_name")',
            legendCustomTemplate: '',
          },
        },
      },
      // Raw: 3-way label_join / or chain over mutually exclusive selectors.
      clusterVMDiskUtilization: {
        name: 'Disk utilization',
        description: 'Disk utilization of VMs in the cluster.',
        type: 'raw',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'label_join(vcenter_vm_disk_utilization_percent{' + s.clusterNoVAppQueriesSelector + '}, "vm_path", "/", "vcenter_resource_pool_inventory_path","vcenter_vm_name") or '
                  + 'label_join(vcenter_vm_disk_utilization_percent{' + s.clusterNoRPoolQueriesSelector + '}, "vm_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name") or '
                  + 'label_join(vcenter_vm_disk_utilization_percent{' + s.clusterNoRPoolOrVAppQueriesSelector + '}, "vm_path", "/", "vcenter_vm_name")',
            legendCustomTemplate: '',
          },
        },
      },
      // Raw: 3-way label_join / or chain, each branch separately aggregated.
      clusterVMNetworkThroughput: {
        name: 'Net throughput',
        description: 'Network throughput of VMs in the cluster.',
        type: 'raw',
        unit: 'KiBs',
        sources: {
          prometheus: {
            expr: 'label_join(' + swd + ' (vcenter_vm_network_usage{object="",' + s.clusterNoVAppQueriesSelector + '}), "vm_path", "/", "vcenter_resource_pool_inventory_path","vcenter_vm_name") or '
                  + 'label_join(' + swd + ' (vcenter_vm_network_usage{object="",' + s.clusterNoRPoolQueriesSelector + '}), "vm_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name") or '
                  + 'label_join(' + swd + ' (vcenter_vm_network_usage{object="",' + s.clusterNoRPoolOrVAppQueriesSelector + '}), "vm_path", "/", "vcenter_vm_name")',
            legendCustomTemplate: '',
          },
        },
      },
      // Raw: 3-way label_join / or chain of two-metric ratios.
      clusterVMPacketDropRate: {
        name: 'Packet drops',
        description: 'Packet drop rate of VMs in the cluster.',
        type: 'raw',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'label_join(' + swd + ' (vcenter_vm_network_packet_drop_rate{object="",' + s.clusterNoVAppQueriesSelector + '}) / clamp_min(' + swd + ' (vcenter_vm_network_packet_rate{object="",' + s.clusterNoVAppQueriesSelector + '}), 1), "vm_path", "/", "vcenter_resource_pool_inventory_path", "vcenter_vm_name") or '
                  + 'label_join(' + swd + ' (vcenter_vm_network_packet_drop_rate{object="",' + s.clusterNoRPoolQueriesSelector + '}) / clamp_min(' + swd + ' (vcenter_vm_network_packet_rate{object="",' + s.clusterNoRPoolQueriesSelector + '}), 1), "vm_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name") or '
                  + 'label_join(' + swd + ' (vcenter_vm_network_packet_drop_rate{object="",' + s.clusterNoRPoolOrVAppQueriesSelector + '}) / clamp_min(' + swd + ' (vcenter_vm_network_packet_rate{object="",' + s.clusterNoRPoolOrVAppQueriesSelector + '}), 1), "vm_path", "/", "vcenter_vm_name")',
            legendCustomTemplate: '',
          },
        },
      },
    },
  }
