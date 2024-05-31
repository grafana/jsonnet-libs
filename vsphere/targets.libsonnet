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
    local sumWithout = 'sum without(object)',
    local sumWithoutDirection = 'sum without(object, direction)',
    local hostSumBy = 'sum by (job, vcenter_datacenter_name, vcenter_cluster_name, vcenter_host_name)',

    vmNumberTotal:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (vcenter_cluster_name) (vcenter_cluster_vm_count{%(queriesSelector)s})' % vars
      ),
    vmOnStatus:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_vm_count{power_state="on", %(queriesSelector)s}' % vars
      ),

    vmOffStatus:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_vm_count{power_state="off", %(queriesSelector)s}' % vars
      ),

    vmSuspendedStatus:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_vm_count{power_state="suspended", %(queriesSelector)s}' % vars
      ),

    vmTemplateStatus:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_vm_template_count{%(queriesSelector)s}' % vars
      ),

    vmOnStatusCluster:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_vm_count{power_state="on", %(queriesSelector)s}' % vars
      ),

    vmOffStatusCluster:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_vm_count{power_state="off", %(queriesSelector)s}' % vars
      ),

    vmSuspendedStatusCluster:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_vm_count{power_state="suspended", %(queriesSelector)s}' % vars
      ),

    vmTemplateStatusCluster:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_vm_template_count{%(queriesSelector)s}' % vars
      ),

    clusterCountStatus:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'count(count by (vcenter_cluster_name) (vcenter_cluster_vm_count{%(queriesSelector)s}))' % vars
      ),

    resourcePoolCountStatus:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'count(count by (vcenter_resource_pool_name) (vcenter_resource_pool_cpu_shares{%(queriesSelector)s}))' % vars
      ),

    esxiHostsActiveStatus:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_host_count{effective="true", %(queriesSelector)s}' % vars
      ),

    esxiHostsInactiveStatusCluster:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_host_count{effective="false", %(queriesSelector)s}' % vars
      ),
    esxiHostsActiveStatusCluster:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_host_count{effective="true", %(queriesSelector)s}' % vars
      ),

    esxiHostsInactiveStatus:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_host_count{effective="false", %(queriesSelector)s}' % vars
      ),

    topCPUUtilizationClusters:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (vcenter_cluster_name) ($top_cluster_count, (100 * sum by (vcenter_datacenter_name, vcenter_cluster_name) (vcenter_host_cpu_usage_MHz{%(queriesSelector)s}) / clamp_min(sum by (vcenter_datacenter_name, vcenter_cluster_name) (vcenter_cluster_cpu_effective{%(queriesSelector)s}),1)))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(clusterLegendLabel)),

    topMemoryUtilizationClusters:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (vcenter_cluster_name) ($top_cluster_count, (100000000 * sum by (vcenter_datacenter_name, vcenter_cluster_name) (vcenter_host_memory_usage_mebibytes{%(queriesSelector)s}) / clamp_min(sum by (vcenter_datacenter_name, vcenter_cluster_name) (vcenter_cluster_memory_effective_bytes{%(queriesSelector)s}), 1)))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(clusterLegendLabel)),

    topCPUUsageResourcePools:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (vcenter_cluster_name) ($top_cluster_count, (sum by (vcenter_datacenter_name, vcenter_cluster_name) (vcenter_resource_pool_cpu_usage{%(queriesSelector)s})))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(clusterLegendLabel)),

    topMemoryUsageResourcePools:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (vcenter_cluster_name) ($top_cluster_count, (sum by (vcenter_datacenter_name, vcenter_cluster_name) (vcenter_resource_pool_memory_usage_mebibytes{%(queriesSelector)s})))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(clusterLegendLabel)),

    topCPUShareResourcePools:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (vcenter_cluster_name) ($top_cluster_count, sum by (vcenter_datacenter_name, vcenter_cluster_name) (vcenter_resource_pool_cpu_shares{%(queriesSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(clusterLegendLabel)),

    topMemoryShareResourcePools:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (vcenter_cluster_name) ($top_cluster_count, sum by (vcenter_datacenter_name, vcenter_cluster_name) (vcenter_resource_pool_memory_shares{%(queriesSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(clusterLegendLabel)),

    topCPUUtilizationEsxiHosts:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (vcenter_cluster_name) ($top_cluster_count, sum by (vcenter_datacenter_name, vcenter_cluster_name) (vcenter_host_cpu_utilization_percent{%(queriesSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(clusterLegendLabel)),

    topMemoryUtilizationEsxiHosts:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (vcenter_cluster_name) ($top_cluster_count, vcenter_host_memory_utilization_percent{%(queriesSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(clusterLegendLabel)),

    topNetworksActiveEsxiHosts:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (vcenter_cluster_name) ($top_cluster_count, sum by (vcenter_datacenter_name, vcenter_cluster_name) (vcenter_host_network_packet_count{%(queriesSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(clusterLegendLabel)),

    topPacketErrorEsxiHosts:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (vcenter_cluster_name) ($top_cluster_count, sum by (vcenter_datacenter_name, vcenter_cluster_name) (increase(vcenter_host_network_packet_errors{%(queriesSelector)s}[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(clusterLegendLabel)),

    datastoreDiskUsage:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_datastore_disk_usage_bytes{%(datastoreSelector)s}' % vars
      ),

    datastoreDiskUtilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_datastore_disk_utilization_percent{%(datastoreSelector)s}' % vars
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
        '%(sumWithout)s (vcenter_host_network_throughput{direction="transmitted", %(hostQueriesSelector)s})' % vars {sumWithout: sumWithout}
      )
      + prometheusQuery.withLegendFormat('%s - transmitted' % utils.labelsToPanelLegend(hostLegendLabel)),

    hostNetworkReceivedThroughputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '%(sumWithout)s (vcenter_host_network_throughput{direction="received", %(hostQueriesSelector)s})' % vars {sumWithout: sumWithout}
      )
      + prometheusQuery.withLegendFormat('%s - received' % utils.labelsToPanelLegend(hostLegendLabel)),

    hostPacketReceivedErrorRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '%(sumWithout)s (vcenter_host_network_packet_error_rate{direction="received", %(hostQueriesSelector)s}) / clamp_min(%(sumWithout)s (vcenter_host_network_packet_rate{direction="received", %(hostQueriesSelector)s}), 1)' % vars {sumWithout: sumWithout}
      )
      + prometheusQuery.withLegendFormat('%s - received' % utils.labelsToPanelLegend(hostLegendLabel)),

    hostPacketTransmittedErrorRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '%(sumWithout)s (vcenter_host_network_packet_error_rate{direction="transmitted", %(hostQueriesSelector)s}) / clamp_min(%(sumWithout)s (vcenter_host_network_packet_rate{direction="transmitted", %(hostQueriesSelector)s}), 1)' % vars {sumWithout: sumWithout}
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
        'label_join(%(sumWithout)s (vcenter_vm_network_usage{%(hostNoVAppQueriesSelector)s}), "vm_path", "/", "vcenter_resource_pool_inventory_path","vcenter_vm_name") or label_join(%(sumWithout)s (vcenter_vm_network_usage{%(hostNoRPoolQueriesSelector)s}), "vm_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name") or label_join(%(sumWithout)s (vcenter_vm_network_usage{%(hostNoRPoolOrVAppQueriesSelector)s}), "vm_path", "/", "vcenter_vm_name")' % vars {sumWithout: sumWithout}
      ),

    hostVMPacketDropRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'label_join(%(sumWithoutDirection)s (vcenter_vm_network_packet_drop_rate{%(hostNoVAppQueriesSelector)s}) / clamp_min(%(sumWithoutDirection)s (vcenter_vm_network_packet_rate{%(hostNoVAppQueriesSelector)s}), 1), "vm_path", "/", "vcenter_resource_pool_inventory_path","vcenter_vm_name") or label_join(%(sumWithoutDirection)s (vcenter_vm_network_packet_drop_rate{%(hostNoRPoolQueriesSelector)s}) / clamp_min(%(sumWithoutDirection)s (vcenter_vm_network_packet_rate{%(hostNoRPoolQueriesSelector)s}), 1), "vm_path", "/", "vcenter_virtual_app_inventory_path","vcenter_vm_name") or label_join(%(sumWithoutDirection)s (vcenter_vm_network_packet_drop_rate{%(hostNoRPoolOrVAppQueriesSelector)s}) / clamp_min(%(sumWithoutDirection)s (vcenter_vm_network_packet_rate{%(hostNoRPoolOrVAppQueriesSelector)s}), 1), "vm_path", "/", "vcenter_vm_name")' % vars {sumWithoutDirection: sumWithoutDirection}
      ),

    vmCPUUtilizationHost:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_vm_cpu_utilization_percent{%(hostQueriesSelector)s}' % vars
      ),

    vmMemoryUtilizationHost:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_vm_memory_utilization_percent{%(hostQueriesSelector)s}' % vars
      ),

    vmNetDiskThroughputHost:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (vcenter_cluster_name, vcenter_host_name, vcenter_resource_pool_name, vcenter_vm_id) (vcenter_vm_disk_throughput{%(hostQueriesSelector)s})' % vars
      ),

    modifiedMemoryBallooned:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (job, vcenter_datacenter_name, vcenter_cluster_name, vcenter_host_name) (vcenter_vm_memory_ballooned_mebibytes{%(hostQueriesSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - ballooned' % utils.labelsToPanelLegend(hostLegendLabel)),

    modifiedMemorySwapped:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (job, vcenter_datacenter_name, vcenter_cluster_name, vcenter_host_name) (vcenter_vm_memory_swapped_mebibytes{%(hostQueriesSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - swapped' % utils.labelsToPanelLegend(hostLegendLabel)),

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
        '%(sumWithout)s (vcenter_vm_network_throughput_bytes_per_sec{direction="transmitted", %(virtualMachinesQueriesSelector)s})' % vars {sumWithout: sumWithout}
      )
      + prometheusQuery.withLegendFormat('%s - transmitted' % vmLegend),

    vmNetworkReceivedThroughputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '%(sumWithout)s (vcenter_vm_network_throughput_bytes_per_sec{direction="received", %(virtualMachinesQueriesSelector)s})' % vars {sumWithout: sumWithout}
      )
      + prometheusQuery.withLegendFormat('%s - received' % vmLegend),

    vmPacketReceivedDropRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '%(sumWithout)s (vcenter_vm_network_packet_drop_rate{direction="received", %(virtualMachinesQueriesSelector)s}) / clamp_min(%(sumWithout)s (vcenter_vm_network_packet_rate{direction="received", %(virtualMachinesQueriesSelector)s}), 1)' % vars {sumWithout: sumWithout}
      )
      + prometheusQuery.withLegendFormat('%s - received' % vmLegend),

    vmPacketTransmittedDropRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '%(sumWithout)s (vcenter_vm_network_packet_drop_rate{direction="transmitted", %(virtualMachinesQueriesSelector)s}) / clamp_min(%(sumWithout)s (vcenter_vm_network_packet_rate{direction="transmitted", %(virtualMachinesQueriesSelector)s}), 1)' % vars {sumWithout: sumWithout}
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

    clusterCPUEffective:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_cpu_effective{%(queriesSelector)s}' % vars
      ),

    clusterCPULimit:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_cpu_limit{%(queriesSelector)s}' % vars
      ),

    clusterCPUUtilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '(100 * vcenter_cluster_cpu_effective{%(queriesSelector)s} / clamp_min(vcenter_cluster_cpu_limit{%(queriesSelector)s}, 1))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(clusterLegendLabel)),

    clusterMemoryEffective:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_memory_effective_bytes{%(queriesSelector)s}' % vars
      ),
    clusterMemoryLimit:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_memory_limit_bytes{%(queriesSelector)s}' % vars
      ),
    clusterMemoryUtilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        ' 100 * vcenter_cluster_memory_effective_bytes{%(queriesSelector)s} / clamp_min(vcenter_cluster_memory_limit_bytes{%(queriesSelector)s}, 1)' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(clusterLegendLabel)),

    hostCPUUsageCluster:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_host_cpu_usage_MHz{%(queriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(hostLegendLabel)),

    hostCPUUtilizationCluster:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_host_cpu_utilization_percent{%(queriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(hostLegendLabel)),

    hostMemoryUsageCluster:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_host_memory_usage_mebibytes{%(queriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(hostLegendLabel)),

    hostMemoryUtilizationCluster:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_host_memory_utilization_percent{%(queriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(hostLegendLabel)),

    networkThroughputRateCluster:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (vcenter_host_name) (vcenter_host_network_throughput{direction="received", %(queriesSelector)s}) + sum by (vcenter_host_name) (vcenter_host_network_throughput{direction="transmitted", %(queriesSelector)s})' % vars
      ),

    vmCPUUtilizationCluster:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_vm_cpu_utilization_percent{%(queriesSelector)s}' % vars
      ),

    vmMemoryUtilizationCluster:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_vm_memory_utilization_percent{%(queriesSelector)s}' % vars
      ),

    vmModifiedMemoryBalloonedCluster:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (vcenter_cluster_name, vcenter_host_name, vcenter_resource_pool_name, vcenter_vm_id) (vcenter_vm_memory_ballooned_mebibytes{%(queriesSelector)s})' % vars
      ),

    vmModifiedMemorySwappedCluster:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (vcenter_cluster_name, vcenter_host_name, vcenter_resource_pool_name, vcenter_vm_id) (vcenter_vm_memory_swapped_mebibytes{%(queriesSelector)s})' % vars
      ),

    vmNetDiskThroughputCluster:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (vcenter_cluster_name, vcenter_host_name, vcenter_resource_pool_name, vcenter_vm_id) (vcenter_vm_disk_throughput{%(queriesSelector)s})' % vars
      ),
    packetDropRateCluster:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (vcenter_datacenter_name, vcenter_cluster_name, vcenter_host_name, vcenter_resource_pool_name, vcenter_vm_id) (vcenter_vm_network_packet_drop_rate{%(queriesSelector)s})' % vars
      ),
  },
}
