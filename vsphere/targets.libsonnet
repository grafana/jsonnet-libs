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
    local clusterLegendLabel = ['vcenter_datacenter_name', 'vcenter_cluster_name'],
    local hostLegendLabel = clusterLegendLabel + ['vcenter_host_name'],
    local vmLegendLabel = hostLegendLabel + ['vcenter_resource_pool_name', 'vcenter_vm_name'],

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
        'vcenter_cluster_vm_count{power_state="on", %(clusterQueriesSelector)s}' % vars
      ),

    vmOffStatusCluster:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_vm_count{power_state="off", %(clusterQueriesSelector)s}' % vars
      ),

    vmSuspendedStatusCluster:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_vm_count{power_state="suspended", %(clusterQueriesSelector)s}' % vars
      ),

    vmTemplateStatusCluster:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_vm_template_count{%(clusterQueriesSelector)s}' % vars
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
        'vcenter_cluster_host_count{effective="false", %(clusterQueriesSelector)s}' % vars
      ),
    esxiHostsActiveStatusCluster:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_host_count{effective="true", %(clusterQueriesSelector)s}' % vars
      ),

    esxiHostsInactiveStatus:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_host_count{effective="false", %(queriesSelector)s}' % vars
      ),

    topCPUUtilizationClusters:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (vcenter_cluster_name) ($top_cluster_count, (100 * sum by (vcenter_datacenter_name, vcenter_cluster_name) (vcenter_host_cpu_usage_MHz{%(queriesSelector)s}) / sum by (vcenter_datacenter_name, vcenter_cluster_name) (vcenter_cluster_cpu_effective{%(queriesSelector)s})))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(clusterLegendLabel)),

    topMemoryUtilizationClusters:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (vcenter_cluster_name) ($top_cluster_count, (100000000 * sum by (vcenter_datacenter_name, vcenter_cluster_name) (vcenter_host_memory_usage_mebibytes{%(queriesSelector)s}) / sum by (vcenter_datacenter_name, vcenter_cluster_name) (vcenter_cluster_memory_effective_bytes{%(queriesSelector)s})))' % vars
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

    topMemoryUsageEsxiHosts:
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
        'vcenter_datastore_disk_usage_bytes{%(queriesSelector)s}' % vars
      ),

    datastoreDiskUtilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_datastore_disk_utilization_percent{%(queriesSelector)s}' % vars
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

    hostDiskLatency:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (vcenter_datacenter_name, vcenter_cluster_name, vcenter_host_name) (vcenter_host_disk_latency_avg_milliseconds{direction="read", %(hostQueriesSelector)s}) + sum by (vcenter_datacenter_name, vcenter_cluster_name, vcenter_host_name) (vcenter_host_disk_latency_avg_milliseconds{direction="write", %(hostQueriesSelector)s})' % vars
      ),

    hostMemoryUtilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_host_memory_utilization_percent{%(hostQueriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(hostLegendLabel)),

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
        'sum by (vcenter_cluster_name, vcenter_host_name, vcenter_resource_pool_name, vcenter_vm_id) (vcenter_vm_disk_throughput{direction="write", %(hostQueriesSelector)s}) + sum by (vcenter_cluster_name, vcenter_host_name, vcenter_resource_pool_name, vcenter_vm_id) (vcenter_vm_disk_throughput{direction="read", %(hostQueriesSelector)s})' % vars
      ),

    modifiedMemoryBallooned:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (vcenter_datacenter_name, vcenter_cluster_name, vcenter_host_name) (vcenter_vm_memory_ballooned_mebibytes{%(hostQueriesSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - ballooned' % utils.labelsToPanelLegend(hostLegendLabel)),

    modifiedMemorySwapped:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (vcenter_datacenter_name, vcenter_cluster_name, vcenter_host_name) (vcenter_vm_memory_swapped_mebibytes{%(hostQueriesSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - swapped' % utils.labelsToPanelLegend(hostLegendLabel)),

    modifiedMemorySwappedSSD:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (vcenter_datacenter_name, vcenter_cluster_name, vcenter_host_name) (vcenter_vm_memory_swapped_ssd_kibibytes{%(hostQueriesSelector)s})' % vars
      ),

    networkTransmittedThroughputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (vcenter_datacenter_name, vcenter_cluster_name, vcenter_host_name) (vcenter_host_network_throughput{direction="transmitted", %(hostQueriesSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - transmitted' % utils.labelsToPanelLegend(hostLegendLabel)),

    networkReceivedThroughputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (vcenter_datacenter_name, vcenter_cluster_name, vcenter_host_name) (vcenter_host_network_throughput{direction="received", %(hostQueriesSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - received' % utils.labelsToPanelLegend(hostLegendLabel)),

    networkThroughputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (vcenter_host_name) (vcenter_host_network_throughput{direction="received", %(hostQueriesSelector)s}) + sum by (vcenter_host_name) (vcenter_host_network_throughput{direction="transmitted", %(hostQueriesSelector)s})' % vars
      ),

    diskThroughputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (vcenter_datacenter_name, vcenter_cluster_name, vcenter_host_name) (vcenter_host_disk_throughput{direction="read", %(hostQueriesSelector)s}) + sum by (vcenter_datacenter_name, vcenter_cluster_name, vcenter_host_name) (vcenter_host_disk_throughput{direction="write", %(hostQueriesSelector)s})' % vars
      ),

    packetReceivedRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (vcenter_datacenter_name, vcenter_cluster_name, vcenter_host_name) (vcenter_vm_network_packet_count{direction="received", %(hostQueriesSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - received' % utils.labelsToPanelLegend(hostLegendLabel)),

    packetTransmittedRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (vcenter_datacenter_name, vcenter_cluster_name, vcenter_host_name) (vcenter_vm_network_packet_count{direction="transmitted", %(hostQueriesSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - transmitted' % utils.labelsToPanelLegend(hostLegendLabel)),

    vmCPUUsage:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_vm_cpu_usage_MHz{%(virtualMachinesQueriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(vmLegendLabel)),

    vmCPUUtilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_vm_cpu_utilization_percent{%(virtualMachinesQueriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(vmLegendLabel)),

    vmDiskUtilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_vm_disk_utilization_percent{%(virtualMachinesQueriesSelector)s}' % vars
      ),

    vmDiskUsage:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_vm_disk_usage_bytes{%(virtualMachinesQueriesSelector)s}' % vars
      ),

    vmMemoryUsage:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_vm_memory_usage_mebibytes{%(virtualMachinesQueriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(vmLegendLabel)),

    vmMemoryUtilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_vm_memory_utilization_percent{%(virtualMachinesQueriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(vmLegendLabel)),

    vmModifiedMemoryBallooned:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (vcenter_datacenter_name, vcenter_cluster_name, vcenter_host_name, vcenter_resource_pool_name, vcenter_vm_name) (vcenter_vm_memory_ballooned_mebibytes{%(virtualMachinesQueriesSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - ballooned' % utils.labelsToPanelLegend(vmLegendLabel)),

    vmModifiedMemorySwapped:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (vcenter_datacenter_name, vcenter_cluster_name, vcenter_host_name, vcenter_resource_pool_name, vcenter_vm_name) (vcenter_vm_memory_swapped_mebibytes{%(virtualMachinesQueriesSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - swapped' % utils.labelsToPanelLegend(vmLegendLabel)),

    vmModifiedMemorySwappedSSD:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (vcenter_cluster_name, vcenter_host_name, vcenter_resource_pool_name, vcenter_vm_id) (vcenter_vm_memory_swapped_ssd_kibibytes{%(virtualMachinesQueriesSelector)s})' % vars
      ),

    vmNetworkTransmittedThroughputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_vm_network_throughput_bytes_per_sec{direction="transmitted", %(virtualMachinesQueriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s - transmitted' % utils.labelsToPanelLegend(vmLegendLabel)),

    vmNetworkReceivedThroughputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_vm_network_throughput_bytes_per_sec{direction="received", %(virtualMachinesQueriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s - received' % utils.labelsToPanelLegend(vmLegendLabel)),

    vmPacketReceivedRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (vcenter_datacenter_name, vcenter_cluster_name, vcenter_resource_pool_name, vcenter_host_name, vcenter_vm_name) (vcenter_vm_network_packet_count{direction="received", %(virtualMachinesQueriesSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - received' % utils.labelsToPanelLegend(vmLegendLabel)),

    vmPacketTransmittedRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (vcenter_datacenter_name, vcenter_cluster_name, vcenter_resource_pool_name, vcenter_host_name, vcenter_vm_name) (vcenter_vm_network_packet_count{direction="transmitted", %(virtualMachinesQueriesSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - transmitted' % utils.labelsToPanelLegend(vmLegendLabel)),

    vmDiskLatency:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_vm_network_packet_count{direction="received", %(virtualMachinesQueriesSelector)s}' % vars
      ),

    vmNetDiskThroughput:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (vcenter_cluster_name, vcenter_host_name, vcenter_resource_pool_name, vcenter_vm_id) (vcenter_vm_disk_throughput{direction="write", %(virtualMachinesQueriesSelector)s}) + sum by (vcenter_cluster_name, vcenter_host_name, vcenter_resource_pool_name, vcenter_vm_id) (vcenter_vm_disk_throughput{direction="read", %(virtualMachinesQueriesSelector)s})' % vars
      ),

    clusterCPUEffective:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_cpu_effective{%(clusterQueriesSelector)s}' % vars
      ),

    clusterCPULimit:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_cpu_limit{%(clusterQueriesSelector)s}' % vars
      ),

    clusterCPUUtilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '(100 * vcenter_cluster_cpu_effective{%(clusterQueriesSelector)s} / vcenter_cluster_cpu_limit{%(clusterQueriesSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(clusterLegendLabel)),

    clusterMemoryEffective:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_memory_effective_bytes{%(clusterQueriesSelector)s}' % vars
      ),
    clusterMemoryLimit:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_memory_limit_bytes{%(clusterQueriesSelector)s}' % vars
      ),
    clusterMemoryUtilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        ' 100 * vcenter_cluster_memory_effective_bytes{%(clusterQueriesSelector)s} / vcenter_cluster_memory_limit_bytes{%(clusterQueriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(clusterLegendLabel)),

    hostCPUUsageCluster:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_host_cpu_usage_MHz{%(clusterQueriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(hostLegendLabel)),

    hostCPUUtilizationCluster:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_host_cpu_utilization_percent{%(clusterQueriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(hostLegendLabel)),

    hostMemoryUsageCluster:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_host_memory_usage_mebibytes{%(clusterQueriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(hostLegendLabel)),

    hostMemoryUtilizationCluster:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_host_memory_utilization_percent{%(clusterQueriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(hostLegendLabel)),

    networkThroughputRateCluster:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (vcenter_host_name) (vcenter_host_network_throughput{direction="received", %(clusterQueriesSelector)s}) + sum by (vcenter_host_name) (vcenter_host_network_throughput{direction="transmitted", %(clusterQueriesSelector)s})' % vars
      ),

    vmCPUUtilizationCluster:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_vm_cpu_utilization_percent{%(clusterQueriesSelector)s}' % vars
      ),

    vmMemoryUtilizationCluster:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_vm_memory_utilization_percent{%(clusterQueriesSelector)s}' % vars
      ),

    vmModifiedMemoryBalloonedCluster:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (vcenter_cluster_name, vcenter_host_name, vcenter_resource_pool_name, vcenter_vm_id) (vcenter_vm_memory_ballooned_mebibytes{%(clusterQueriesSelector)s})' % vars
      ),

    vmModifiedMemorySwappedCluster:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (vcenter_cluster_name, vcenter_host_name, vcenter_resource_pool_name, vcenter_vm_id) (vcenter_vm_memory_swapped_mebibytes{%(clusterQueriesSelector)s})' % vars
      ),

    vmNetDiskThroughputCluster:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (vcenter_cluster_name, vcenter_host_name, vcenter_resource_pool_name, vcenter_vm_id) (vcenter_vm_disk_throughput{direction="write", %(clusterQueriesSelector)s}) + sum by (vcenter_cluster_name, vcenter_host_name, vcenter_resource_pool_name, vcenter_vm_id) (vcenter_vm_disk_throughput{direction="read", %(clusterQueriesSelector)s})' % vars
      ),
    packetErrorEsxiHostsCluster:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(vcenter_host_network_packet_errors{direction="recieved", %(queriesSelector)s}[$__interval:]) + increase(vcenter_host_network_packet_errors{direction="transmitted", %(queriesSelector)s}[$__interval:])' % vars
      ),
  },
}
