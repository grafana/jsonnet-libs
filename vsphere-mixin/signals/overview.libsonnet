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
      clustersCount: raw(
        'Clusters',
        'count(count by(vcenter_cluster_name) (vcenter_cluster_vm_count{' + s.queriesSelector + '}))',
        'none',
        'The number of clusters in the datacenter.'
      ),
      hostsCount: raw(
        'ESXi hosts',
        'count(count by(vcenter_host_name) (vcenter_host_memory_usage_mebibytes{' + s.queriesSelector + '}))',
        'none',
        'The number of ESXi hosts in the datacenter.'
      ),
      resourcePoolsCount: raw(
        'Resource pools',
        'count(count by(vcenter_resource_pool_inventory_path) (vcenter_resource_pool_cpu_shares{' + s.queriesSelector + '}))',
        'none',
        'The number of resource pools in the datacenter.'
      ),
      vmsCount: raw(
        'VMs',
        'count(count by(vcenter_resource_pool_inventory_path, vcenter_virtual_app_inventory_path, vcenter_vm_name) (vcenter_vm_memory_usage_mebibytes{' + s.queriesSelector + '}))',
        'none',
        'The number of virtual machines in the datacenter.'
      ),
      clusteredVMsOnCount: raw(
        'Clustered VMs on',
        datacenterSumBy + ' (vcenter_cluster_vm_count{power_state="on", ' + s.queriesSelector + '})',
        'none',
        'Clustered virtual machines powered on.'
      ),
      clusteredVMsOffCount: raw(
        'Clustered VMs off',
        datacenterSumBy + ' (vcenter_cluster_vm_count{power_state="off", ' + s.queriesSelector + '})',
        'none',
        'Clustered virtual machines powered off.'
      ),
      clusteredVMsSuspendedCount: raw(
        'Clustered VMs suspended',
        datacenterSumBy + ' (vcenter_cluster_vm_count{power_state="suspended", ' + s.queriesSelector + '})',
        'none',
        'Clustered virtual machines suspended.'
      ),
      clusteredVMTemplatesCount: raw(
        'Clustered VM templates',
        datacenterSumBy + ' (vcenter_cluster_vm_template_count{' + s.queriesSelector + '})',
        'none',
        'Clustered virtual machine templates.'
      ),
      clusteredHostsActiveCount: raw(
        'Clustered active ESXi hosts',
        datacenterSumBy + ' (vcenter_cluster_host_count{effective="true", ' + s.queriesSelector + '})',
        'none',
        'Clustered ESXi hosts that are running.'
      ),
      clusteredHostsInactiveCount: raw(
        'Clustered inactive ESXi hosts',
        datacenterSumBy + ' (vcenter_cluster_host_count{effective="false", ' + s.queriesSelector + '})',
        'none',
        'Clustered ESXi hosts that are not running.'
      ),
      topCPUUtilizationClusters: raw(
        'Top CPU utilization by cluster',
        'topk ($top_resource_count, (100 * ' + clusterSumBy + ' (vcenter_host_cpu_usage_MHz{vcenter_cluster_name!="",' + s.queriesSelector + '}) / clamp_min(vcenter_cluster_cpu_limit{' + s.queriesSelector + '},1)))',
        'percent',
        'The clusters with the highest CPU utilization percentage.',
        clusterLegend
      ),
      topMemoryUtilizationClusters: raw(
        'Top memory utilization by cluster',
        'topk ($top_resource_count, (104857600 * ' + clusterSumBy + ' (vcenter_host_memory_usage_mebibytes{vcenter_cluster_name!="",' + s.queriesSelector + '}) / clamp_min(vcenter_cluster_memory_limit_bytes{' + s.queriesSelector + '},1)))',
        'percent',
        'The clusters with the highest memory utilization percentage.',
        clusterLegend
      ),
      totalCPUClusters: raw(
        'Total CPU by cluster',
        'vcenter_cluster_cpu_limit{' + s.queriesSelector + '}',
        'rotmhz',
        'The available CPU capacity of the cluster.',
        clusterLegend
      ),
      totalMemoryClusters: raw(
        'Total memory by cluster',
        'vcenter_cluster_memory_limit_bytes{' + s.queriesSelector + '}',
        'bytes',
        'The available memory capacity of the cluster.',
        clusterLegend
      ),
      hostsActiveClustersCount: raw(
        'Active ESXi hosts by cluster',
        'vcenter_cluster_host_count{effective="true", ' + s.queriesSelector + '}',
        'none',
        'Active ESXi hosts per cluster.'
      ),
      hostsInactiveClustersCount: raw(
        'Inactive ESXi hosts by cluster',
        'vcenter_cluster_host_count{effective="false", ' + s.queriesSelector + '}',
        'none',
        'Inactive ESXi hosts per cluster.'
      ),
      vmsOnClustersCount: raw(
        'VMs on by cluster',
        'vcenter_cluster_vm_count{power_state="on", ' + s.queriesSelector + '}',
        'none',
        'VMs powered on per cluster.'
      ),
      vmsOffClustersCount: raw(
        'VMs off by cluster',
        'vcenter_cluster_vm_count{power_state="off", ' + s.queriesSelector + '}',
        'none',
        'VMs powered off per cluster.'
      ),
      vmsSuspendedClustersCount: raw(
        'VMs suspended by cluster',
        'vcenter_cluster_vm_count{power_state="suspended", ' + s.queriesSelector + '}',
        'none',
        'VMs suspended per cluster.'
      ),
      topCPUUsageResourcePools: raw(
        'Top CPU usage by resource pools',
        'topk ($top_resource_count, vcenter_resource_pool_cpu_usage{' + s.queriesSelector + '})',
        'rotmhz',
        'The resource pools with the highest CPU usage.',
        rPoolLegend
      ),
      topMemoryUsageResourcePools: raw(
        'Top memory usage by resource pools',
        'topk ($top_resource_count, vcenter_resource_pool_memory_usage_mebibytes{' + s.queriesSelector + '})',
        'mbytes',
        'The resource pools with the highest memory usage.',
        rPoolLegend
      ),
      topCPUShareResourcePools: raw(
        'Top CPU shares by resource pools',
        'topk ($top_resource_count, vcenter_resource_pool_cpu_shares{' + s.queriesSelector + '})',
        'shares',
        'The resource pools with the highest CPU shares.',
        rPoolLegend
      ),
      topMemoryShareResourcePools: raw(
        'Top memory shares by resource pools',
        'topk ($top_resource_count, vcenter_resource_pool_memory_shares{' + s.queriesSelector + '})',
        'shares',
        'The resource pools with the highest memory shares.',
        rPoolLegend
      ),
      topCPUUtilizationHosts: raw(
        'Top CPU utilization by ESXi hosts',
        'topk ($top_resource_count, vcenter_host_cpu_utilization_percent{' + s.queriesSelector + '})',
        'percent',
        'The ESXi hosts with the highest CPU utilization.',
        hostLegend
      ),
      topMemoryUtilizationHosts: raw(
        'Top memory utilization by ESXi hosts',
        'topk ($top_resource_count, vcenter_host_memory_utilization_percent{' + s.queriesSelector + '})',
        'percent',
        'The ESXi hosts with the highest memory utilization.',
        hostLegend
      ),
      topDiskAvgLatencyHosts: raw(
        'Top avg disk latency by ESXi hosts',
        'topk ($top_resource_count, ' + hostSumBy + ' (vcenter_host_disk_latency_avg_milliseconds{' + s.queriesSelector + '}))',
        'ms',
        'The ESXi hosts with the highest average disk latency.',
        hostLegend
      ),
      topPacketErrorRateHosts: raw(
        'Top packet errors by ESXi hosts',
        'topk ($top_resource_count, ' + hostSumBy + ' (vcenter_host_network_packet_error_rate{object="",' + s.queriesSelector + '}) / clamp_min(' + hostSumBy + ' (vcenter_host_network_packet_rate{object="",' + s.queriesSelector + '}), 1))',
        'percent',
        'The ESXi hosts with the highest percentage of packet errors.',
        hostLegend
      ),
    },
  }
