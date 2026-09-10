// Datacenter-wide signals shown on the vSphere overview dashboard.
local selectors = import './selectors.libsonnet';

function(this)
  local s = selectors(this);
  local clusterLegend = '{{vcenter_cluster_name}}';
  local hostLegend = '{{vcenter_host_name}}';
  local rPoolLegend = '{{vcenter_resource_pool_inventory_path}}';
  local clusterSumBy = 'sum by (job, vcenter_datacenter_name, vcenter_cluster_name)';
  local hostSumBy = 'sum by (job, vcenter_datacenter_name, vcenter_cluster_name, vcenter_host_name)';
  // The dashboards expose a $top_resource_count variable that caps every "top N" panel.
  local topk = [['topk ($top_resource_count, ', ')']];
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
        type: 'gauge',
        unit: 'short',
        // Inner `count by (vcenter_cluster_name)` collapses each cluster to one series;
        // the outer bare count() then counts the clusters.
        aggLevel: 'aggKeepLabels',
        aggFunction: 'count',
        sources: {
          prometheus: {
            expr: 'vcenter_cluster_vm_count{' + s.queriesSelector + '}',
            aggKeepLabels: ['vcenter_cluster_name'],
            exprWrappers: [['count(', ')']],
            legendCustomTemplate: '',
          },
        },
      },
      hostsCount: {
        name: 'ESXi hosts',
        description: 'The number of ESXi hosts in the datacenter.',
        type: 'gauge',
        unit: 'short',
        aggLevel: 'aggKeepLabels',
        aggFunction: 'count',
        sources: {
          prometheus: {
            expr: 'vcenter_host_memory_usage_mebibytes{' + s.queriesSelector + '}',
            aggKeepLabels: ['vcenter_host_name'],
            exprWrappers: [['count(', ')']],
            legendCustomTemplate: '',
          },
        },
      },
      resourcePoolsCount: {
        name: 'Resource pools',
        description: 'The number of resource pools in the datacenter.',
        type: 'gauge',
        unit: 'short',
        aggLevel: 'aggKeepLabels',
        aggFunction: 'count',
        sources: {
          prometheus: {
            expr: 'vcenter_resource_pool_cpu_shares{' + s.queriesSelector + '}',
            aggKeepLabels: ['vcenter_resource_pool_inventory_path'],
            exprWrappers: [['count(', ')']],
            legendCustomTemplate: '',
          },
        },
      },
      vmsCount: {
        name: 'VMs',
        description: 'The number of virtual machines in the datacenter.',
        type: 'gauge',
        unit: 'short',
        aggLevel: 'aggKeepLabels',
        aggFunction: 'count',
        sources: {
          prometheus: {
            expr: 'vcenter_vm_memory_usage_mebibytes{' + s.queriesSelector + '}',
            aggKeepLabels: ['vcenter_resource_pool_inventory_path', 'vcenter_virtual_app_inventory_path', 'vcenter_vm_name'],
            exprWrappers: [['count(', ')']],
            legendCustomTemplate: '',
          },
        },
      },
      clusteredVMsOnCount: {
        name: 'Clustered VMs on',
        description: 'The number of virtual machines currently powered on that belong to a cluster in the datacenter.',
        type: 'gauge',
        unit: 'short',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'vcenter_cluster_vm_count{power_state="on", ' + s.queriesSelector + '}',
            aggKeepLabels: ['vcenter_datacenter_name'],
            legendCustomTemplate: '',
          },
        },
      },
      clusteredVMsOffCount: {
        name: 'Clustered VMs off',
        description: 'The number of virtual machines currently powered off that belong to a cluster in the datacenter.',
        type: 'gauge',
        unit: 'short',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'vcenter_cluster_vm_count{power_state="off", ' + s.queriesSelector + '}',
            aggKeepLabels: ['vcenter_datacenter_name'],
            legendCustomTemplate: '',
          },
        },
      },
      clusteredVMsSuspendedCount: {
        name: 'Clustered VMs suspended',
        description: 'The number of virtual machines currently in a suspended state that belong to a cluster in the datacenter.',
        type: 'gauge',
        unit: 'short',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'vcenter_cluster_vm_count{power_state="suspended", ' + s.queriesSelector + '}',
            aggKeepLabels: ['vcenter_datacenter_name'],
            legendCustomTemplate: '',
          },
        },
      },
      clusteredVMTemplatesCount: {
        name: 'Clustered VM templates',
        description: 'The number of virtual machine templates that belong to a cluster in the datacenter.',
        type: 'gauge',
        unit: 'short',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'vcenter_cluster_vm_template_count{' + s.queriesSelector + '}',
            aggKeepLabels: ['vcenter_datacenter_name'],
            legendCustomTemplate: '',
          },
        },
      },
      clusteredHostsActiveCount: {
        name: 'Clustered active ESXi hosts',
        description: 'The number of ESXi hosts that are currently running (responding and not in maintenance mode) that belong to a cluster within the datacenter.',
        type: 'gauge',
        unit: 'short',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'vcenter_cluster_host_count{effective="true", ' + s.queriesSelector + '}',
            aggKeepLabels: ['vcenter_datacenter_name'],
            legendCustomTemplate: '',
          },
        },
      },
      clusteredHostsInactiveCount: {
        name: 'Clustered inactive ESXi hosts',
        description: 'The number of ESXi hosts that are currently not running (not responding or in maintenance mode) that belong to a cluster within the datacenter.',
        type: 'gauge',
        unit: 'short',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'vcenter_cluster_host_count{effective="false", ' + s.queriesSelector + '}',
            aggKeepLabels: ['vcenter_datacenter_name'],
            legendCustomTemplate: '',
          },
        },
      },
      // Raw: host usage divided by cluster limit — two different metrics.
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
      // Raw: host usage divided by cluster limit — two different metrics.
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
        type: 'gauge',
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
        type: 'gauge',
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
        type: 'gauge',
        unit: 'short',
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
        type: 'gauge',
        unit: 'short',
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
        type: 'gauge',
        unit: 'short',
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
        type: 'gauge',
        unit: 'short',
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
        type: 'gauge',
        unit: 'short',
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
        type: 'gauge',
        unit: 'rotmhz',
        sources: {
          prometheus: {
            expr: 'vcenter_resource_pool_cpu_usage{' + s.queriesSelector + '}',
            exprWrappers: topk,
            legendCustomTemplate: rPoolLegend,
          },
        },
      },
      topMemoryUsageResourcePools: {
        name: 'Top memory usage by resource pools',
        description: 'The resource pools with the highest memory usage in the datacenter.',
        type: 'gauge',
        unit: 'mbytes',
        sources: {
          prometheus: {
            expr: 'vcenter_resource_pool_memory_usage_mebibytes{' + s.queriesSelector + '}',
            exprWrappers: topk,
            legendCustomTemplate: rPoolLegend,
          },
        },
      },
      topCPUShareResourcePools: {
        name: 'Top CPU shares by resource pools',
        description: 'The resource pools with the highest amount of CPU shares allocated in the datacenter.',
        type: 'gauge',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'vcenter_resource_pool_cpu_shares{' + s.queriesSelector + '}',
            exprWrappers: topk,
            legendCustomTemplate: rPoolLegend,
          },
        },
      },
      topMemoryShareResourcePools: {
        name: 'Top memory shares by resource pools',
        description: 'The resource pools with the highest amount of memory shares allocated in the datacenter.',
        type: 'gauge',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'vcenter_resource_pool_memory_shares{' + s.queriesSelector + '}',
            exprWrappers: topk,
            legendCustomTemplate: rPoolLegend,
          },
        },
      },
      topCPUUtilizationHosts: {
        name: 'Top CPU utilization by ESXi hosts',
        description: 'The ESXi hosts with the highest CPU utilization in the datacenter.',
        type: 'gauge',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'vcenter_host_cpu_utilization_percent{' + s.queriesSelector + '}',
            exprWrappers: topk,
            legendCustomTemplate: hostLegend,
          },
        },
      },
      topMemoryUtilizationHosts: {
        name: 'Top memory utilization by ESXi hosts',
        description: 'The ESXi hosts with the highest memory utilization in the datacenter.',
        type: 'gauge',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'vcenter_host_memory_utilization_percent{' + s.queriesSelector + '}',
            exprWrappers: topk,
            legendCustomTemplate: hostLegend,
          },
        },
      },
      topDiskAvgLatencyHosts: {
        name: 'Top avg disk latency by ESXi hosts',
        description: 'The ESXi hosts with the highest average disk latency in the datacenter.',
        type: 'gauge',
        unit: 'ms',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'vcenter_host_disk_latency_avg_milliseconds{' + s.queriesSelector + '}',
            aggKeepLabels: ['vcenter_datacenter_name', 'vcenter_cluster_name', 'vcenter_host_name'],
            exprWrappers: topk,
            legendCustomTemplate: hostLegend,
          },
        },
      },
      // Raw: ratio of two different metrics, each separately aggregated.
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
