// Datacenter-wide signals shown on the vSphere overview dashboard.
// Each signal is type 'raw' carrying the verbatim legacy PromQL (selector +
// aggregation baked in) so the rendered dashboards stay byte-identical.
local selectors = import './selectors.libsonnet';

function(this)
  local s = selectors(this);
  local clusterLegend = '{{vcenter_cluster_name}}';
  local hostLegend = '{{vcenter_host_name}}';
  local rPoolLegend = '{{vcenter_resource_pool_inventory_path}}';
  local datacenterSumBy = 'sum by (job, vcenter_datacenter_name)';
  local clusterSumBy = 'sum by (job, vcenter_datacenter_name, vcenter_cluster_name)';
  local hostSumBy = 'sum by (job, vcenter_datacenter_name, vcenter_cluster_name, vcenter_host_name)';
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: [],
    datasource: 'prometheus_datasource',
    aggLevel: 'none',
    aggFunction: 'avg',
    signals: {
      clustersCount: {
        name: 'Clusters',
        description: 'The number of clusters in the datacenter.',
        type: 'raw',
        unit: '',
        sources: {
          prometheus: {
            expr: 'count(count by(vcenter_cluster_name) (vcenter_cluster_vm_count{' + s.queriesSelector + '}))',
            legendCustomTemplate: '',
          },
        },
      },
      hostsCount: {
        name: 'ESXi hosts',
        description: 'The number of ESXi hosts in the datacenter.',
        type: 'raw',
        unit: '',
        sources: {
          prometheus: {
            expr: 'count(count by(vcenter_host_name) (vcenter_host_memory_usage_mebibytes{' + s.queriesSelector + '}))',
            legendCustomTemplate: '',
          },
        },
      },
      resourcePoolsCount: {
        name: 'Resource pools',
        description: 'The number of resource pools in the datacenter.',
        type: 'raw',
        unit: '',
        sources: {
          prometheus: {
            expr: 'count(count by(vcenter_resource_pool_inventory_path) (vcenter_resource_pool_cpu_shares{' + s.queriesSelector + '}))',
            legendCustomTemplate: '',
          },
        },
      },
      vmsCount: {
        name: 'VMs',
        description: 'The number of virtual machines in the datacenter.',
        type: 'raw',
        unit: '',
        sources: {
          prometheus: {
            expr: 'count(count by(vcenter_resource_pool_inventory_path, vcenter_virtual_app_inventory_path, vcenter_vm_name) (vcenter_vm_memory_usage_mebibytes{' + s.queriesSelector + '}))',
            legendCustomTemplate: '',
          },
        },
      },
      clusteredVMsOnCount: {
        name: 'Clustered VMs on',
        description: 'The number of virtual machines currently powered on that belong to a cluster in the datacenter.',
        type: 'raw',
        unit: '',
        sources: {
          prometheus: {
            expr: datacenterSumBy + ' (vcenter_cluster_vm_count{power_state="on", ' + s.queriesSelector + '})',
            legendCustomTemplate: '',
          },
        },
      },
      clusteredVMsOffCount: {
        name: 'Clustered VMs off',
        description: 'The number of virtual machines currently powered off that belong to a cluster in the datacenter.',
        type: 'raw',
        unit: '',
        sources: {
          prometheus: {
            expr: datacenterSumBy + ' (vcenter_cluster_vm_count{power_state="off", ' + s.queriesSelector + '})',
            legendCustomTemplate: '',
          },
        },
      },
      clusteredVMsSuspendedCount: {
        name: 'Clustered VMs suspended',
        description: 'The number of virtual machines currently in a suspended state that belong to a cluster in the datacenter.',
        type: 'raw',
        unit: '',
        sources: {
          prometheus: {
            expr: datacenterSumBy + ' (vcenter_cluster_vm_count{power_state="suspended", ' + s.queriesSelector + '})',
            legendCustomTemplate: '',
          },
        },
      },
      clusteredVMTemplatesCount: {
        name: 'Clustered VM templates',
        description: 'The number of virtual machine templates that belong to a cluster in the datacenter.',
        type: 'raw',
        unit: '',
        sources: {
          prometheus: {
            expr: datacenterSumBy + ' (vcenter_cluster_vm_template_count{' + s.queriesSelector + '})',
            legendCustomTemplate: '',
          },
        },
      },
      clusteredHostsActiveCount: {
        name: 'Clustered active ESXi hosts',
        description: 'The number of ESXi hosts that are currently running (responding and not in maintenance mode) that belong to a cluster within the datacenter.',
        type: 'raw',
        unit: '',
        sources: {
          prometheus: {
            expr: datacenterSumBy + ' (vcenter_cluster_host_count{effective="true", ' + s.queriesSelector + '})',
            legendCustomTemplate: '',
          },
        },
      },
      clusteredHostsInactiveCount: {
        name: 'Clustered inactive ESXi hosts',
        description: 'The number of ESXi hosts that are currently not running (not responding or in maintenance mode) that belong to a cluster within the datacenter.',
        type: 'raw',
        unit: '',
        sources: {
          prometheus: {
            expr: datacenterSumBy + ' (vcenter_cluster_host_count{effective="false", ' + s.queriesSelector + '})',
            legendCustomTemplate: '',
          },
        },
      },
      topCPUUtilizationClusters: {
        name: 'Top CPU utilization by cluster',
        description: 'The clusters with the highest CPU utilization percentage in the datacenter.',
        type: 'raw',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'topk ($top_resource_count, (100 * ' + clusterSumBy + ' (vcenter_host_cpu_usage_MHz{vcenter_cluster_name!="",' + s.queriesSelector + '}) / clamp_min(vcenter_cluster_cpu_limit{' + s.queriesSelector + '},1)))',
            legendCustomTemplate: clusterLegend,
          },
        },
      },
      topMemoryUtilizationClusters: {
        name: 'Top memory utilization by cluster',
        description: 'The clusters with the highest memory utilization percentage in the datacenter.',
        type: 'raw',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'topk ($top_resource_count, (104857600 * ' + clusterSumBy + ' (vcenter_host_memory_usage_mebibytes{vcenter_cluster_name!="",' + s.queriesSelector + '}) / clamp_min(vcenter_cluster_memory_limit_bytes{' + s.queriesSelector + '},1)))',
            legendCustomTemplate: clusterLegend,
          },
        },
      },
      totalCPUClusters: {
        name: 'Total CPU by cluster',
        description: 'The available CPU capacity of the cluster.',
        type: 'raw',
        unit: 'rotmhz',
        sources: {
          prometheus: {
            expr: 'vcenter_cluster_cpu_limit{' + s.queriesSelector + '}',
            legendCustomTemplate: clusterLegend,
          },
        },
      },
      totalMemoryClusters: {
        name: 'Total memory by cluster',
        description: 'The available memory capacity of the cluster.',
        type: 'raw',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'vcenter_cluster_memory_limit_bytes{' + s.queriesSelector + '}',
            legendCustomTemplate: clusterLegend,
          },
        },
      },
      hostsActiveClustersCount: {
        name: 'Active ESXi hosts by cluster',
        description: 'Active ESXi hosts per cluster.',
        type: 'raw',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'vcenter_cluster_host_count{effective="true", ' + s.queriesSelector + '}',
            legendCustomTemplate: '',
          },
        },
      },
      hostsInactiveClustersCount: {
        name: 'Inactive ESXi hosts by cluster',
        description: 'Inactive ESXi hosts per cluster.',
        type: 'raw',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'vcenter_cluster_host_count{effective="false", ' + s.queriesSelector + '}',
            legendCustomTemplate: '',
          },
        },
      },
      vmsOnClustersCount: {
        name: 'VMs on by cluster',
        description: 'VMs powered on per cluster.',
        type: 'raw',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'vcenter_cluster_vm_count{power_state="on", ' + s.queriesSelector + '}',
            legendCustomTemplate: '',
          },
        },
      },
      vmsOffClustersCount: {
        name: 'VMs off by cluster',
        description: 'VMs powered off per cluster.',
        type: 'raw',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'vcenter_cluster_vm_count{power_state="off", ' + s.queriesSelector + '}',
            legendCustomTemplate: '',
          },
        },
      },
      vmsSuspendedClustersCount: {
        name: 'VMs suspended by cluster',
        description: 'VMs suspended per cluster.',
        type: 'raw',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'vcenter_cluster_vm_count{power_state="suspended", ' + s.queriesSelector + '}',
            legendCustomTemplate: '',
          },
        },
      },
      topCPUUsageResourcePools: {
        name: 'Top CPU usage by resource pools',
        description: 'The resource pools with the highest CPU usage in the datacenter.',
        type: 'raw',
        unit: 'rotmhz',
        sources: {
          prometheus: {
            expr: 'topk ($top_resource_count, vcenter_resource_pool_cpu_usage{' + s.queriesSelector + '})',
            legendCustomTemplate: rPoolLegend,
          },
        },
      },
      topMemoryUsageResourcePools: {
        name: 'Top memory usage by resource pools',
        description: 'The resource pools with the highest memory usage in the datacenter.',
        type: 'raw',
        unit: 'mbytes',
        sources: {
          prometheus: {
            expr: 'topk ($top_resource_count, vcenter_resource_pool_memory_usage_mebibytes{' + s.queriesSelector + '})',
            legendCustomTemplate: rPoolLegend,
          },
        },
      },
      topCPUShareResourcePools: {
        name: 'Top CPU shares by resource pools',
        description: 'The resource pools with the highest amount of CPU shares allocated in the datacenter.',
        type: 'raw',
        unit: 'shares',
        sources: {
          prometheus: {
            expr: 'topk ($top_resource_count, vcenter_resource_pool_cpu_shares{' + s.queriesSelector + '})',
            legendCustomTemplate: rPoolLegend,
          },
        },
      },
      topMemoryShareResourcePools: {
        name: 'Top memory shares by resource pools',
        description: 'The resource pools with the highest amount of memory shares allocated in the datacenter.',
        type: 'raw',
        unit: 'shares',
        sources: {
          prometheus: {
            expr: 'topk ($top_resource_count, vcenter_resource_pool_memory_shares{' + s.queriesSelector + '})',
            legendCustomTemplate: rPoolLegend,
          },
        },
      },
      topCPUUtilizationHosts: {
        name: 'Top CPU utilization by ESXi hosts',
        description: 'The ESXi hosts with the highest CPU utilization in the datacenter.',
        type: 'raw',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'topk ($top_resource_count, vcenter_host_cpu_utilization_percent{' + s.queriesSelector + '})',
            legendCustomTemplate: hostLegend,
          },
        },
      },
      topMemoryUtilizationHosts: {
        name: 'Top memory utilization by ESXi hosts',
        description: 'The ESXi hosts with the highest memory utilization in the datacenter.',
        type: 'raw',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'topk ($top_resource_count, vcenter_host_memory_utilization_percent{' + s.queriesSelector + '})',
            legendCustomTemplate: hostLegend,
          },
        },
      },
      topDiskAvgLatencyHosts: {
        name: 'Top avg disk latency by ESXi hosts',
        description: 'The ESXi hosts with the highest average disk latency in the datacenter.',
        type: 'raw',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'topk ($top_resource_count, ' + hostSumBy + ' (vcenter_host_disk_latency_avg_milliseconds{' + s.queriesSelector + '}))',
            legendCustomTemplate: hostLegend,
          },
        },
      },
      topPacketErrorRateHosts: {
        name: 'Top packet errors by ESXi hosts',
        description: 'The ESXi hosts with the highest percentage of packet errors in the datacenter.',
        type: 'raw',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'topk ($top_resource_count, ' + hostSumBy + ' (vcenter_host_network_packet_error_rate{object="",' + s.queriesSelector + '}) / clamp_min(' + hostSumBy + ' (vcenter_host_network_packet_rate{object="",' + s.queriesSelector + '}), 1))',
            legendCustomTemplate: hostLegend,
          },
        },
      },
    },
  }
