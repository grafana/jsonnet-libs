local g = import './g.libsonnet';
local prometheusQuery = g.query.prometheus;

{
  new(this): {
    local vars = this.grafana.variables,
    local config = this.config,

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
        ''
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
        ''
      ),

    clusterCountStatus:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'count(count by (vcenter_cluster_name) (vcenter_cluster_vm_count{, %(queriesSelector)s}))' % vars
      ),

    resourcePoolCountStatus:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'count(count by (vcenter_resource_pool_name) (vcenter_resource_pool_cpu_shares{, %(queriesSelector)s}))' % vars
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
        'topk by (vcenter_cluster_name) (777, (100 * vcenter_cluster_cpu_effective{%(queriesSelector)s} / vcenter_cluster_cpu_limit{%(queriesSelector)s}))'
      ),

    topMemoryUtilizationClusters:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (vcenter_cluster_name) (777, (100 * vcenter_cluster_memory_effective_bytes{%(queriesSelector)s} / vcenter_cluster_memory_limit_bytes{%(queriesSelector)s}))'
      ),

    topCPUUsageResourcePools:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (vcenter_cluster_name) (777, (vcenter_resource_pool_cpu_usage{%(queriesSelector)s}))'
      ),

    topMemoryUsageResourcePools:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (vcenter_cluster_name) (777, (vcenter_resource_pool_memory_usage_mebibytes{%(queriesSelector)s}))'
      ),

    topCPUShareResourcePools:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (vcenter_cluster_name) (777, vcenter_resource_pool_cpu_shares{%(queriesSelector)s})'
      ),

    topMemoryShareResourcePools:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (vcenter_cluster_name) (777, vcenter_resource_pool_memory_shares{%(queriesSelector)s})'
      ),

    topCPUUtilizationEsxiHosts:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (vcenter_cluster_name) (777, vcenter_host_cpu_utilization_percent{%(queriesSelector)h sostnameandclustername})'
      ),

    topMemoryUsageEsxiHosts:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (vcenter_cluster_name) (777, vcenter_host_memory_utilization_percent{%(queriesSelector)s hostnameandclustername})'
      ),

    topNetworksActiveEsxiHosts:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        ''
      ),

    topPacketErrorEsxiHosts:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (vcenter_cluster_name) (vcenter_cluster_name), sum by (vcenter_cluster_name) (increase(vcenter_host_network_packet_errors{%(queriesSelector)s}[$__interval:])))'
      ),

    hostCPUUsage:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_host_cpu_usage_MHz{%(hostQueriesSelector)s}'
      ),

    hostCPUUtilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_host_cpu_utilization_percent{%(hostQueriesSelector)s}'
      ),

    hostMemoryUsage:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_host_memory_usage_mebibytes{%(hostQueriesSelector)s}'
      ),

    hostMemoryUtilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_host_memory_utilization_percent{%(hostQueriesSelector)s}'
      ),

    modifiedMemoryBallooned:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (vcenter_cluster_name, vcenter_host_name, vcenter_resource_pool_name) (increase(vcenter_vm_memory_ballooned_mebibytes{%(hostQueriesSelector)s}[$__interval:]))'
      ),

    modifiedMemorySwapped:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (vcenter_cluster_name, vcenter_host_name, vcenter_resource_pool_name) (increase(vcenter_vm_memory_swapped_mebibytes{%(hostQueriesSelector)s}[$__interval:]))'
      ),

    modifiedMemorySwappedSSD:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (vcenter_cluster_name, vcenter_host_name, vcenter_resource_pool_name) (increase(vcenter_vm_memory_swapped_ssd_kibibytes{%(hostQueriesSelector)s}[$__interval:]))'
      ),

    networkTransmittedThroughputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_host_network_throughput{direction="transmitted", %(hostQueriesSelector)s}' % vars
      ),

    networkReceivedThroughputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_host_network_throughput{direction="received", %(hostQueriesSelector)s}' % vars
      ),
    networkThroughputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_host_network_throughput{direction="received", %(hostQueriesSelector)s} + vcenter_host_network_throughput{direction="transmitted", %(hostQueriesSelector)s}' % vars
      ),

    packetReceivedRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_vm_network_packet_count{direction="received", %(hostQueriesSelector)s}' % vars
      ),

    packetTransmittedRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_vm_network_packet_count{direction="transmitted", %(hostQueriesSelector)s}' % vars
      ),

    vmCPUUsage:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_host_cpu_usage_MHz{%(virtualMachinesQueriesSelector)s}'
      ),

    vmCPUUtilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_host_cpu_utilization_percent{%(virtualMachinesQueriesSelector)s}'
      ),

    vmMemoryUsage:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_host_memory_usage_mebibytes{%(virtualMachinesQueriesSelector)s}'
      ),

    vmMemoryUtilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_host_memory_utilization_percent{%(virtualMachinesQueriesSelector)s}'
      ),

    vmModifiedMemoryBallooned:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (vcenter_cluster_name, vcenter_host_name, vcenter_resource_pool_name, vcenter_vm_id) (increase(vcenter_vm_memory_ballooned_mebibytes{%(virtualMachinesQueriesSelector)s}[$__interval:]))'
      ),

    vmModifiedMemorySwapped:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (vcenter_cluster_name, vcenter_host_name, vcenter_resource_pool_name, vcenter_vm_id) (increase(vcenter_vm_memory_swapped_mebibytes{%(virtualMachinesQueriesSelector)s}[$__interval:]))'
      ),

    vmModifiedMemorySwappedSSD:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (vcenter_cluster_name, vcenter_host_name, vcenter_resource_pool_name, vcenter_vm_id) (increase(vcenter_vm_memory_swapped_ssd_kibibytes{%(virtualMachinesQueriesSelector)s}[$__interval:]))'
      ),

    vmNetworkTransmittedThroughputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_host_network_throughput{direction="transmitted", %(virtualMachinesQueriesSelector)s}' % vars
      ),

    vmNetworkReceivedThroughputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_host_network_throughput{direction="received", %(virtualMachinesQueriesSelector)s}' % vars
      ),

    vmPacketReceivedRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_vm_network_packet_count{direction="received", %(virtualMachinesQueriesSelector)s}' % vars
      ),

    vmPacketTransmittedRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_vm_network_packet_count{direction="transmitted", %(virtualMachinesQueriesSelector)s}' % vars
      ),

    vmPacketErrorTotal:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_host_network_packet_errors{direction="received", %(virtualMachinesQueriesSelector)s} + vcenter_host_network_packet_errors{direction="transmitted", %(virtualMachinesQueriesSelector)s} ' % vars
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
        '(100 * vcenter_cluster_cpu_effective{%(clusterQueriesSelector)s} / vcenter_cluster_cpu_limit{%(clusterQueriesSelector)s}))' % vars
      ),

    clusterMemoryEffective:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_memory_effective_bytes{%(clusterQueriesSelector)s}' % vars
      ),
    clusterMemoryLimit:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_memory_effective_bytes{%(clusterQueriesSelector)s}' % vars
      ),
    clusterMemoryUtilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_memory_limit_bytes{%(clusterQueriesSelector)s}' % vars
      ),
  },
}
