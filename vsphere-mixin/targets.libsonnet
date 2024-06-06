local g = import './g.libsonnet';
local prometheusQuery = g.query.prometheus;
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils {
  labelsToPanelLegend(labels): std.join(' - ', ['{{%s}}' % [label] for label in labels]),
};

{
  new(this): {
    local vars = this.grafana.variables,
    local config = this.config,
    local clusterLegendLabel = ['vcenter_cluster_name'],
    local hostLegendLabel = clusterLegendLabel + ['vcenter_host_name'],
    local vmLegend = '{{vcenter_resource_pool_inventory_path}}{{vcenter_virtual_app_inventory_path}}/{{vcenter_vm_name}}',
    local rPoolLegend = '{{vcenter_resource_pool_inventory_path}}',
    local sumWithout = 'sum without(object)',
    local sumWithoutDirection = 'sum without(object, direction)',
    local datacenterSumBy = 'sum by (job, vcenter_datacenter_name)',
    local datastoreSumBy = 'sum by (job, vcenter_datacenter_name, vcenter_datastore_name)',
    local clusterSumBy = 'sum by (job, vcenter_datacenter_name, vcenter_cluster_name)',
    local hostSumBy = 'sum by (job, vcenter_datacenter_name, vcenter_cluster_name, vcenter_host_name)',

    clustersCount:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'count(count by(vcenter_cluster_name) (vcenter_cluster_vm_count{%(queriesSelector)s}))' % vars
      ),

    hostsCount:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'count(count by(vcenter_host_name) (vcenter_host_memory_usage_mebibytes{%(queriesSelector)s}))' % vars
      ),

    resourcePoolsCount:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'count(count by(vcenter_resource_pool_inventory_path) (vcenter_resource_pool_cpu_shares{%(queriesSelector)s}))' % vars
      ),

    vmsCount:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'count(count by(vcenter_resource_pool_inventory_path, vcenter_virtual_app_inventory_path, vcenter_vm_name) (vcenter_vm_memory_usage_mebibytes{%(queriesSelector)s}))' % vars
      ),

    clusteredVMsOnCount:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '%(datacenterSumBy)s (vcenter_cluster_vm_count{power_state="on", %(queriesSelector)s})' % vars { datacenterSumBy: datacenterSumBy }
      ),

    clusteredVMsOffCount:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '%(datacenterSumBy)s (vcenter_cluster_vm_count{power_state="off", %(queriesSelector)s})' % vars { datacenterSumBy: datacenterSumBy }
      ),

    clusteredVMsSuspendedCount:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '%(datacenterSumBy)s (vcenter_cluster_vm_count{power_state="suspended", %(queriesSelector)s})' % vars { datacenterSumBy: datacenterSumBy }
      ),

    clusteredVMTemplatesCount:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '%(datacenterSumBy)s (vcenter_cluster_vm_template_count{%(queriesSelector)s})' % vars { datacenterSumBy: datacenterSumBy }
      ),

    clusteredHostsActiveCount:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '%(datacenterSumBy)s (vcenter_cluster_host_count{effective="true", %(queriesSelector)s})' % vars { datacenterSumBy: datacenterSumBy }
      ),

    clusteredHostsInactiveCount:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '%(datacenterSumBy)s (vcenter_cluster_host_count{effective="false", %(queriesSelector)s})' % vars { datacenterSumBy: datacenterSumBy }
      ),

    topCPUUtilizationClusters:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk ($top_resource_count, (100 * %(clusterSumBy)s (vcenter_host_cpu_usage_MHz{vcenter_cluster_name!="",%(queriesSelector)s}) / clamp_min(vcenter_cluster_cpu_effective{%(queriesSelector)s},1)))' % vars { clusterSumBy: clusterSumBy }
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(clusterLegendLabel)),

    topMemoryUtilizationClusters:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk ($top_resource_count, (104857600 * %(clusterSumBy)s (vcenter_host_memory_usage_mebibytes{vcenter_cluster_name!="",%(queriesSelector)s}) / clamp_min(vcenter_cluster_memory_effective_bytes{%(queriesSelector)s},1)))' % vars { clusterSumBy: clusterSumBy }
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(clusterLegendLabel)),

    effectiveCPUClusters:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_cpu_effective{%(queriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(clusterLegendLabel)),

    effectiveMemoryClusters:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_memory_effective_bytes{%(queriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(clusterLegendLabel)),

    hostsActiveClustersCount:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_host_count{effective="true", %(queriesSelector)s}' % vars
      ),

    hostsInactiveClustersCount:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_host_count{effective="false", %(queriesSelector)s}' % vars
      ),

    vmsOnClustersCount:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_vm_count{power_state="on", %(queriesSelector)s}' % vars
      ),

    vmsOffClustersCount:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_vm_count{power_state="off", %(queriesSelector)s}' % vars
      ),

    vmsSuspendedClustersCount:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_vm_count{power_state="suspended", %(queriesSelector)s}' % vars
      ),

    topCPUUsageResourcePools:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk ($top_resource_count, vcenter_resource_pool_cpu_usage{%(queriesSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % rPoolLegend),

    topMemoryUsageResourcePools:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk ($top_resource_count, vcenter_resource_pool_memory_usage_mebibytes{%(queriesSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % rPoolLegend),

    topCPUShareResourcePools:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk ($top_resource_count, vcenter_resource_pool_cpu_shares{%(queriesSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % rPoolLegend),

    topMemoryShareResourcePools:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk ($top_resource_count, vcenter_resource_pool_memory_shares{%(queriesSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % rPoolLegend),

    topCPUUtilizationHosts:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk ($top_resource_count, vcenter_host_cpu_utilization_percent{%(queriesSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(hostLegendLabel)),

    topMemoryUtilizationHosts:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk ($top_resource_count, vcenter_host_memory_utilization_percent{%(queriesSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(hostLegendLabel)),

    topDiskAvgLatencyHosts:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk ($top_resource_count, %(hostSumBy)s (vcenter_host_disk_latency_avg_milliseconds{%(queriesSelector)s}))' % vars { hostSumBy: hostSumBy }
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(hostLegendLabel)),

    topPacketErrorRateHosts:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk ($top_resource_count, %(hostSumBy)s (vcenter_host_network_packet_error_rate{%(queriesSelector)s}) / clamp_min(%(hostSumBy)s (vcenter_host_network_packet_rate{%(queriesSelector)s}), 1))' % vars { hostSumBy: hostSumBy }
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(hostLegendLabel)),

    datastoreDiskTotal:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '%(datastoreSumBy)s (vcenter_datastore_disk_usage_bytes{%(queriesSelector)s})' % vars { datastoreSumBy: datastoreSumBy }
      ),

    datastoreDiskUtilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_datastore_disk_utilization_percent{%(queriesSelector)s}' % vars
      ),

    datastoreDiskAvailable:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_datastore_disk_usage_bytes{disk_state="available",%(queriesSelector)s}' % vars
      ),

    hostCPUUsage:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_host_cpu_usage_MHz{%(hostQueriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(hostLegendLabel)),

    hostCPUUtilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_host_cpu_utilization_percent{%(hostQueriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(hostLegendLabel)),

    hostMemoryUsage:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_host_memory_usage_mebibytes{%(hostQueriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(hostLegendLabel)),

    hostMemoryUtilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_host_memory_utilization_percent{%(hostQueriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(hostLegendLabel)),

    hostModifiedMemoryBallooned:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (job, vcenter_datacenter_name, vcenter_cluster_name, vcenter_host_name) (vcenter_vm_memory_ballooned_mebibytes{%(hostQueriesSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - ballooned' % utils.labelsToPanelLegend(hostLegendLabel)),

    hostModifiedMemorySwapped:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (job, vcenter_datacenter_name, vcenter_cluster_name, vcenter_host_name) (vcenter_vm_memory_swapped_mebibytes{%(hostQueriesSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - swapped' % utils.labelsToPanelLegend(hostLegendLabel)),

    hostNetworkTransmittedThroughputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '%(sumWithout)s (vcenter_host_network_throughput{direction="transmitted", %(hostQueriesSelector)s})' % vars { sumWithout: sumWithout }
      )
      + prometheusQuery.withLegendFormat('%s - transmitted' % utils.labelsToPanelLegend(hostLegendLabel)),

    hostNetworkReceivedThroughputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '%(sumWithout)s (vcenter_host_network_throughput{direction="received", %(hostQueriesSelector)s})' % vars { sumWithout: sumWithout }
      )
      + prometheusQuery.withLegendFormat('%s - received' % utils.labelsToPanelLegend(hostLegendLabel)),

    hostPacketReceivedErrorRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '%(sumWithout)s (vcenter_host_network_packet_error_rate{direction="received", %(hostQueriesSelector)s}) / clamp_min(%(sumWithout)s (vcenter_host_network_packet_rate{direction="received", %(hostQueriesSelector)s}), 1)' % vars { sumWithout: sumWithout }
      )
      + prometheusQuery.withLegendFormat('%s - received' % utils.labelsToPanelLegend(hostLegendLabel)),

    hostPacketTransmittedErrorRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '%(sumWithout)s (vcenter_host_network_packet_error_rate{direction="transmitted", %(hostQueriesSelector)s}) / clamp_min(%(sumWithout)s (vcenter_host_network_packet_rate{direction="transmitted", %(hostQueriesSelector)s}), 1)' % vars { sumWithout: sumWithout }
      )
      + prometheusQuery.withLegendFormat('%s - transmitted' % utils.labelsToPanelLegend(hostLegendLabel)),

    hostDiskReadLatency:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'label_join(vcenter_host_disk_latency_avg_milliseconds{direction="read", object!="", %(hostNoClusterQueriesSelector)s}, "disk_path", "/", "vcenter_host_name","object") or label_join(vcenter_host_disk_latency_avg_milliseconds{direction="read", object!="", %(hostWithClusterQueriesSelector)s}, "disk_path", "/", "vcenter_cluster_name","vcenter_host_name","object")' % vars
      ),

    hostDiskWriteLatency:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'label_join(vcenter_host_disk_latency_avg_milliseconds{direction="write", object!="", %(hostNoClusterQueriesSelector)s}, "disk_path", "/", "vcenter_host_name","object") or label_join(vcenter_host_disk_latency_avg_milliseconds{direction="write", object!="", %(hostWithClusterQueriesSelector)s}, "disk_path", "/", "vcenter_cluster_name","vcenter_host_name","object")' % vars
      ),

    hostDiskReadThroughput:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'label_join(vcenter_host_disk_throughput{direction="read", object!="", %(hostNoClusterQueriesSelector)s}, "disk_path", "/", "vcenter_host_name","object") or label_join(vcenter_host_disk_throughput{direction="read", object!="", %(hostWithClusterQueriesSelector)s}, "disk_path", "/", "vcenter_cluster_name","vcenter_host_name","object")' % vars
      ),

    hostDiskWriteThroughput:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'label_join(vcenter_host_disk_throughput{direction="write", object!="", %(hostNoClusterQueriesSelector)s}, "disk_path", "/", "vcenter_host_name","object") or label_join(vcenter_host_disk_throughput{direction="write", object!="", %(hostWithClusterQueriesSelector)s}, "disk_path", "/", "vcenter_cluster_name","vcenter_host_name","object")' % vars
      ),

    hostVMCPUUsage:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'label_join(vcenter_vm_cpu_usage_MHz{%(hostNoVAppQueriesSelector)s}, "vm_path", "/", "vcenter_resource_pool_inventory_path","vcenter_vm_name") or label_join(vcenter_vm_cpu_usage_MHz{%(hostNoRPoolQueriesSelector)s}, "vm_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name") or label_join(vcenter_vm_cpu_usage_MHz{%(hostNoRPoolOrVAppQueriesSelector)s}, "vm_path", "/", "vcenter_vm_name")' % vars
      ),

    hostVMCPUUtilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'label_join(vcenter_vm_cpu_utilization_percent{%(hostNoVAppQueriesSelector)s}, "vm_path", "/", "vcenter_resource_pool_inventory_path","vcenter_vm_name") or label_join(vcenter_vm_cpu_utilization_percent{%(hostNoRPoolQueriesSelector)s}, "vm_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name") or label_join(vcenter_vm_cpu_utilization_percent{%(hostNoRPoolOrVAppQueriesSelector)s}, "vm_path", "/", "vcenter_vm_name")' % vars
      ),

    hostVMDiskUsage:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'label_join(vcenter_vm_disk_usage_bytes{%(hostNoVAppQueriesSelector)s}, "vm_path", "/", "vcenter_resource_pool_inventory_path","vcenter_vm_name") or label_join(vcenter_vm_disk_usage_bytes{%(hostNoRPoolQueriesSelector)s}, "vm_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name") or label_join(vcenter_vm_disk_usage_bytes{%(hostNoRPoolOrVAppQueriesSelector)s}, "vm_path", "/", "vcenter_vm_name")' % vars
      ),

    hostVMDiskUtilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'label_join(vcenter_vm_disk_utilization_percent{%(hostNoVAppQueriesSelector)s}, "vm_path", "/", "vcenter_resource_pool_inventory_path","vcenter_vm_name") or label_join(vcenter_vm_disk_utilization_percent{%(hostNoRPoolQueriesSelector)s}, "vm_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name") or label_join(vcenter_vm_disk_utilization_percent{%(hostNoRPoolOrVAppQueriesSelector)s}, "vm_path", "/", "vcenter_vm_name")' % vars
      ),

    hostVMMemoryUsage:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'label_join(vcenter_vm_memory_usage_mebibytes{%(hostNoVAppQueriesSelector)s}, "vm_path", "/", "vcenter_resource_pool_inventory_path","vcenter_vm_name") or label_join(vcenter_vm_memory_usage_mebibytes{%(hostNoRPoolQueriesSelector)s}, "vm_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name") or label_join(vcenter_vm_memory_usage_mebibytes{%(hostNoRPoolOrVAppQueriesSelector)s}, "vm_path", "/", "vcenter_vm_name")' % vars
      ),

    hostVMMemoryUtilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'label_join(vcenter_vm_memory_utilization_percent{%(hostNoVAppQueriesSelector)s}, "vm_path", "/", "vcenter_resource_pool_inventory_path","vcenter_vm_name") or label_join(vcenter_vm_memory_utilization_percent{%(hostNoRPoolQueriesSelector)s}, "vm_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name") or label_join(vcenter_vm_memory_utilization_percent{%(hostNoRPoolOrVAppQueriesSelector)s}, "vm_path", "/", "vcenter_vm_name")' % vars
      ),

    hostVMNetworkThroughput:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'label_join(%(sumWithout)s (vcenter_vm_network_usage{%(hostNoVAppQueriesSelector)s}), "vm_path", "/", "vcenter_resource_pool_inventory_path","vcenter_vm_name") or label_join(%(sumWithout)s (vcenter_vm_network_usage{%(hostNoRPoolQueriesSelector)s}), "vm_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name") or label_join(%(sumWithout)s (vcenter_vm_network_usage{%(hostNoRPoolOrVAppQueriesSelector)s}), "vm_path", "/", "vcenter_vm_name")' % vars { sumWithout: sumWithout }
      ),

    hostVMPacketDropRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'label_join(%(sumWithoutDirection)s (vcenter_vm_network_packet_drop_rate{%(hostNoVAppQueriesSelector)s}) / clamp_min(%(sumWithoutDirection)s (vcenter_vm_network_packet_rate{%(hostNoVAppQueriesSelector)s}), 1), "vm_path", "/", "vcenter_resource_pool_inventory_path","vcenter_vm_name") or label_join(%(sumWithoutDirection)s (vcenter_vm_network_packet_drop_rate{%(hostNoRPoolQueriesSelector)s}) / clamp_min(%(sumWithoutDirection)s (vcenter_vm_network_packet_rate{%(hostNoRPoolQueriesSelector)s}), 1), "vm_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name") or label_join(%(sumWithoutDirection)s (vcenter_vm_network_packet_drop_rate{%(hostNoRPoolOrVAppQueriesSelector)s}) / clamp_min(%(sumWithoutDirection)s (vcenter_vm_network_packet_rate{%(hostNoRPoolOrVAppQueriesSelector)s}), 1), "vm_path", "/", "vcenter_vm_name")' % vars { sumWithoutDirection: sumWithoutDirection }
      ),

    vmCPUUsage:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_vm_cpu_usage_MHz{%(virtualMachinesQueriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % vmLegend),

    vmCPUUtilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_vm_cpu_utilization_percent{%(virtualMachinesQueriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % vmLegend),

    vmDiskUtilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_vm_disk_utilization_percent{%(virtualMachinesQueriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % vmLegend),

    vmDiskUsage:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_vm_disk_usage_bytes{disk_state="used", %(virtualMachinesQueriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % vmLegend),

    vmMemoryUsage:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_vm_memory_usage_mebibytes{%(virtualMachinesQueriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % vmLegend),

    vmMemoryUtilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_vm_memory_utilization_percent{%(virtualMachinesQueriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % vmLegend),

    vmModifiedMemoryBallooned:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_vm_memory_ballooned_mebibytes{%(virtualMachinesQueriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s - ballooned' % vmLegend),

    vmModifiedMemorySwapped:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_vm_memory_swapped_mebibytes{%(virtualMachinesQueriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s - swapped' % vmLegend),

    vmNetworkTransmittedThroughputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '%(sumWithout)s (vcenter_vm_network_throughput_bytes_per_sec{direction="transmitted", %(virtualMachinesQueriesSelector)s})' % vars { sumWithout: sumWithout }
      )
      + prometheusQuery.withLegendFormat('%s - transmitted' % vmLegend),

    vmNetworkReceivedThroughputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '%(sumWithout)s (vcenter_vm_network_throughput_bytes_per_sec{direction="received", %(virtualMachinesQueriesSelector)s})' % vars { sumWithout: sumWithout }
      )
      + prometheusQuery.withLegendFormat('%s - received' % vmLegend),

    vmPacketReceivedDropRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '%(sumWithout)s (vcenter_vm_network_packet_drop_rate{direction="received", %(virtualMachinesQueriesSelector)s}) / clamp_min(%(sumWithout)s (vcenter_vm_network_packet_rate{direction="received", %(virtualMachinesQueriesSelector)s}), 1)' % vars { sumWithout: sumWithout }
      )
      + prometheusQuery.withLegendFormat('%s - received' % vmLegend),

    vmPacketTransmittedDropRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '%(sumWithout)s (vcenter_vm_network_packet_drop_rate{direction="transmitted", %(virtualMachinesQueriesSelector)s}) / clamp_min(%(sumWithout)s (vcenter_vm_network_packet_rate{direction="transmitted", %(virtualMachinesQueriesSelector)s}), 1)' % vars { sumWithout: sumWithout }
      )
      + prometheusQuery.withLegendFormat('%s - transmitted' % vmLegend),

    vmDiskReadLatency:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'label_join(vcenter_vm_disk_latency_avg_milliseconds{direction="read", object!="", %(virtualMachinesNoVAppQueriesSelector)s}, "disk_path", "/", "vcenter_resource_pool_inventory_path","vcenter_vm_name","object") or label_join(vcenter_vm_disk_latency_avg_milliseconds{direction="read", object!="", %(virtualMachinesNoRPoolQueriesSelector)s}, "disk_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name","object") or label_join(vcenter_vm_disk_latency_avg_milliseconds{direction="read", object!="", %(virtualMachinesNoRPoolOrVAppQueriesSelector)s}, "disk_path", "/", "vcenter_vm_name","object")' % vars
      ),

    vmDiskWriteLatency:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'label_join(vcenter_vm_disk_latency_avg_milliseconds{direction="write", object!="", %(virtualMachinesNoVAppQueriesSelector)s}, "disk_path", "/", "vcenter_resource_pool_inventory_path","vcenter_vm_name","object") or label_join(vcenter_vm_disk_latency_avg_milliseconds{direction="write", object!="", %(virtualMachinesNoRPoolQueriesSelector)s}, "disk_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name","object") or label_join(vcenter_vm_disk_latency_avg_milliseconds{direction="write", object!="", %(virtualMachinesNoRPoolOrVAppQueriesSelector)s}, "disk_path", "/", "vcenter_vm_name","object")' % vars
      ),

    vmDiskReadThroughput:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'label_join(vcenter_vm_disk_throughput{direction="read", object!="", %(virtualMachinesNoVAppQueriesSelector)s}, "disk_path", "/", "vcenter_resource_pool_inventory_path","vcenter_vm_name","object") or label_join(vcenter_vm_disk_throughput{direction="read", object!="", %(virtualMachinesNoRPoolQueriesSelector)s}, "disk_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name","object") or label_join(vcenter_vm_disk_throughput{direction="read", object!="", %(virtualMachinesNoRPoolOrVAppQueriesSelector)s}, "disk_path", "/", "vcenter_vm_name","object")' % vars
      ),

    vmDiskWriteThroughput:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'label_join(vcenter_vm_disk_throughput{direction="write", object!="", %(virtualMachinesNoVAppQueriesSelector)s}, "disk_path", "/", "vcenter_resource_pool_inventory_path","vcenter_vm_name","object") or label_join(vcenter_vm_disk_throughput{direction="write", object!="", %(virtualMachinesNoRPoolQueriesSelector)s}, "disk_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name","object") or label_join(vcenter_vm_disk_throughput{direction="write", object!="", %(virtualMachinesNoRPoolOrVAppQueriesSelector)s}, "disk_path", "/", "vcenter_vm_name","object")' % vars
      ),

    clusterVMsOnCount:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_vm_count{power_state="on", %(clusterQueriesSelector)s}' % vars
      ),

    clusterVMsOffCount:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_vm_count{power_state="off", %(clusterQueriesSelector)s}' % vars
      ),

    clusterVMsSuspendedCount:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_vm_count{power_state="suspended", %(clusterQueriesSelector)s}' % vars
      ),

    clusterHostsActiveCount:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_host_count{effective="true", %(clusterQueriesSelector)s}' % vars
      ),

    clusterHostsInactiveCount:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_host_count{effective="false", %(clusterQueriesSelector)s}' % vars
      ),

    clusterResourcePoolsCount:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'count(vcenter_resource_pool_cpu_shares{%(clusterQueriesSelector)s})' % vars
      ),

    clusterCPUEffective:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_cpu_effective{%(clusterQueriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(clusterLegendLabel)),

    clusterCPULimit:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_cpu_limit{%(clusterQueriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(clusterLegendLabel)),

    clusterCPUUtilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '(100 * %(clusterSumBy)s (vcenter_host_cpu_usage_MHz{%(clusterQueriesSelector)s}) / clamp_min(vcenter_cluster_cpu_effective{%(clusterQueriesSelector)s}, 1))' % vars { clusterSumBy: clusterSumBy }
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(clusterLegendLabel)),

    clusterMemoryEffective:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_memory_effective_bytes{%(queriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(clusterLegendLabel)),

    clusterMemoryLimit:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_memory_limit_bytes{%(queriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(clusterLegendLabel)),

    clusterMemoryUtilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        ' 104857600 * %(clusterSumBy)s (vcenter_host_memory_usage_mebibytes{%(clusterQueriesSelector)s}) / clamp_min(vcenter_cluster_memory_effective_bytes{%(clusterQueriesSelector)s}, 1)' % vars { clusterSumBy: clusterSumBy }
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(clusterLegendLabel)),

    clusterHostCPUUsage:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_host_cpu_usage_MHz{%(clusterQueriesSelector)s}' % vars
      ),

    clusterHostCPUUtilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_host_cpu_utilization_percent{%(clusterQueriesSelector)s}' % vars
      ),

    clusterHostMemoryUsage:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_host_memory_usage_mebibytes{%(clusterQueriesSelector)s}' % vars
      ),

    clusterHostMemoryUtilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_host_memory_utilization_percent{%(clusterQueriesSelector)s}' % vars
      ),

    clusterHostDiskThroughput:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '%(sumWithoutDirection)s (vcenter_host_disk_throughput{%(clusterQueriesSelector)s})' % vars { sumWithoutDirection: sumWithoutDirection }
      ),

    clusterHostDiskLatency:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '%(sumWithoutDirection)s (vcenter_host_disk_latency_avg_milliseconds{%(clusterQueriesSelector)s})' % vars { sumWithoutDirection: sumWithoutDirection }
      ),

    clusterHostNetworkThroughput:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '%(sumWithout)s (vcenter_host_network_usage{%(clusterQueriesSelector)s})' % vars { sumWithout: sumWithout }
      ),

    clusterHostPacketErrorRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '%(sumWithoutDirection)s (vcenter_host_network_packet_error_rate{%(clusterQueriesSelector)s}) / clamp_min(%(sumWithoutDirection)s (vcenter_host_network_packet_rate{%(clusterQueriesSelector)s}), 1)' % vars { sumWithoutDirection: sumWithoutDirection }
      ),

    clusterVMCPUUsage:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'label_join(vcenter_vm_cpu_usage_MHz{%(clusterNoVAppQueriesSelector)s}, "vm_path", "/", "vcenter_resource_pool_inventory_path","vcenter_vm_name") or label_join(vcenter_vm_cpu_usage_MHz{%(clusterNoRPoolQueriesSelector)s}, "vm_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name") or label_join(vcenter_vm_cpu_usage_MHz{%(clusterNoRPoolOrVAppQueriesSelector)s}, "vm_path", "/", "vcenter_vm_name")' % vars
      ),

    clusterVMCPUUtilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'label_join(vcenter_vm_cpu_utilization_percent{%(clusterNoVAppQueriesSelector)s}, "vm_path", "/", "vcenter_resource_pool_inventory_path","vcenter_vm_name") or label_join(vcenter_vm_cpu_utilization_percent{%(clusterNoRPoolQueriesSelector)s}, "vm_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name") or label_join(vcenter_vm_cpu_utilization_percent{%(clusterNoRPoolOrVAppQueriesSelector)s}, "vm_path", "/", "vcenter_vm_name")' % vars
      ),

    clusterVMDiskUsage:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'label_join(vcenter_vm_disk_usage_bytes{%(clusterNoVAppQueriesSelector)s}, "vm_path", "/", "vcenter_resource_pool_inventory_path","vcenter_vm_name") or label_join(vcenter_vm_disk_usage_bytes{%(clusterNoRPoolQueriesSelector)s}, "vm_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name") or label_join(vcenter_vm_disk_usage_bytes{%(clusterNoRPoolOrVAppQueriesSelector)s}, "vm_path", "/", "vcenter_vm_name")' % vars
      ),

    clusterVMDiskUtilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'label_join(vcenter_vm_disk_utilization_percent{%(clusterNoVAppQueriesSelector)s}, "vm_path", "/", "vcenter_resource_pool_inventory_path","vcenter_vm_name") or label_join(vcenter_vm_disk_utilization_percent{%(clusterNoRPoolQueriesSelector)s}, "vm_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name") or label_join(vcenter_vm_disk_utilization_percent{%(clusterNoRPoolOrVAppQueriesSelector)s}, "vm_path", "/", "vcenter_vm_name")' % vars
      ),

    clusterVMMemoryUsage:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'label_join(vcenter_vm_memory_usage_mebibytes{%(clusterNoVAppQueriesSelector)s}, "vm_path", "/", "vcenter_resource_pool_inventory_path","vcenter_vm_name") or label_join(vcenter_vm_memory_usage_mebibytes{%(clusterNoRPoolQueriesSelector)s}, "vm_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name") or label_join(vcenter_vm_memory_usage_mebibytes{%(clusterNoRPoolOrVAppQueriesSelector)s}, "vm_path", "/", "vcenter_vm_name")' % vars
      ),

    clusterVMMemoryUtilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'label_join(vcenter_vm_memory_utilization_percent{%(clusterNoVAppQueriesSelector)s}, "vm_path", "/", "vcenter_resource_pool_inventory_path","vcenter_vm_name") or label_join(vcenter_vm_memory_utilization_percent{%(clusterNoRPoolQueriesSelector)s}, "vm_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name") or label_join(vcenter_vm_memory_utilization_percent{%(clusterNoRPoolOrVAppQueriesSelector)s}, "vm_path", "/", "vcenter_vm_name")' % vars
      ),

    clusterVMNetworkThroughput:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'label_join(%(sumWithout)s (vcenter_vm_network_usage{%(clusterNoVAppQueriesSelector)s}), "vm_path", "/", "vcenter_resource_pool_inventory_path","vcenter_vm_name") or label_join(%(sumWithout)s (vcenter_vm_network_usage{%(clusterNoRPoolQueriesSelector)s}), "vm_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name") or label_join(%(sumWithout)s (vcenter_vm_network_usage{%(clusterNoRPoolOrVAppQueriesSelector)s}), "vm_path", "/", "vcenter_vm_name")' % vars { sumWithout: sumWithout }
      ),

    clusterVMPacketDropRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'label_join(%(sumWithoutDirection)s (vcenter_vm_network_packet_drop_rate{%(clusterNoVAppQueriesSelector)s}) / clamp_min(%(sumWithoutDirection)s (vcenter_vm_network_packet_rate{%(clusterNoVAppQueriesSelector)s}), 1), "vm_path", "/", "vcenter_resource_pool_inventory_path", "vcenter_vm_name") or label_join(%(sumWithoutDirection)s (vcenter_vm_network_packet_drop_rate{%(clusterNoRPoolQueriesSelector)s}) / clamp_min(%(sumWithoutDirection)s (vcenter_vm_network_packet_rate{%(clusterNoRPoolQueriesSelector)s}), 1), "vm_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name") or label_join(%(sumWithoutDirection)s (vcenter_vm_network_packet_drop_rate{%(clusterNoRPoolOrVAppQueriesSelector)s}) / clamp_min(%(sumWithoutDirection)s (vcenter_vm_network_packet_rate{%(clusterNoRPoolOrVAppQueriesSelector)s}), 1), "vm_path", "/", "vcenter_vm_name")' % vars { sumWithoutDirection: sumWithoutDirection }
      ),
  },
}
