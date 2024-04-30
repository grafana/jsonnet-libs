local g = import './g.libsonnet';
local prometheusQuery = g.query.prometheus;

{
  new(this): {
    local vars = this.grafana.variables,
    local config = this.config,

    vmOnStatus:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_vm_count{power_state="on"}'
      ),

    vmOffStatus:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_vm_count{power_state="off"}'
      ),

    vmSuspendedStatus:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_vm_count{power_state="suspended"}'
      ),

    vmTemplateStatus:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        ''
      ),

    clusterCountStatus:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'count(count by (vcenter_cluster_name) (vcenter_cluster_vm_count{}))'
      ),

    resourcePoolCountStatus:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'count(count by (vcenter_resource_pool_name) (vcenter_resource_pool_cpu_shares{}))'
      ),

    esxiHostsActiveStatus:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_host_count{effective="true"}'
      ),

    esxiHostsInactiveStatus:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_host_count{effective="false"}'
      ),

    topCPUUtilizationClusters:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (vcenter_cluster_name) (777, (100 * vcenter_cluster_cpu_effective{} / vcenter_cluster_cpu_limit{}))'
      ),

    topMemoryUtilizationClusters:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (vcenter_cluster_name) (777, (100 * vcenter_cluster_memory_effective_bytes{} / vcenter_cluster_memory_limit_bytes{}))'
      ),

    topCPUUsageResourcePools:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        ''
      ),

    topMemoryUsageResourcePools:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        ''
      ),

    topCPUShareResourcePools:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (vcenter_cluster_name) (777, vcenter_resource_pool_cpu_shares{})'
      ),

    topMemoryShareResourcePools:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (vcenter_cluster_name) (777, vcenter_resource_pool_memory_shares{})'
      ),

    topCPUUtilizationEsxiHosts:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (vcenter_cluster_name) (777, vcenter_host_cpu_utilization_percent{hostnameandclustername})'
      ),

    topMemoryUsageEsxiHosts:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (vcenter_cluster_name) (777, vcenter_host_memory_utilization_percent{hostnameandclustername})'

      ),

    topNetworksActiveEsxiHosts:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        ''

      ),

    topPacketErrorEsxiHosts:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (vcenter_cluster_name) (vcenter_cluster_name), sum by (vcenter_cluster_name) (increase(vcenter_host_network_packet_errors{}[$__interval:])))'
      ),

    hostCPUUsage:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_host_cpu_usage_MHz{hostnameandcluster}'
      ),

    hostCPUUtilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_host_cpu_utilization_percent{hostnameandclustername}'
      ),

    hostMemoryUsage:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_host_memory_usage_mebibytes{hostnameandclustername}'
      ),

    hostMemoryUtilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_host_memory_utilization_percent{hostnameandclustername}'
      ),

    modifiedMemoryBallooned:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (vcenter_cluster_name, vcenter_host_name, vcenter_resource_pool_name, vcenter_vm_id) (increase(vcenter_vm_memory_ballooned_mebibytes{}[$__interval:]))'
      ),

    modifiedMemorySwapped:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (vcenter_cluster_name, vcenter_host_name, vcenter_resource_pool_name, vcenter_vm_id) (increase(vcenter_vm_memory_swapped_mebibytes{}[$__interval:]))'
      ),

    modifiedMemorySwappedSSD:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (vcenter_cluster_name, vcenter_host_name, vcenter_resource_pool_name, vcenter_vm_id) (increase(vcenter_vm_memory_swapped_ssd_kibibytes{}[$__interval:]))'
      ),

    networkTransmittedThroughputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_host_network_throughput{direction="transmitted"}'
      ),

    networkReceivedThroughputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_host_network_throughput{direction="received"}'
      ),

    packetReceivedRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_vm_network_packet_count{direction="received"}'
      ),

    packetTransmittedRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_vm_network_packet_count{direction="transmitted"}'
      ),

    clusterCPUEffective:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_cpu_effective{}'
      ),

    clusterCPULimit:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_cpu_limit{}'
      ),

    clusterCPUUtilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '(100 * vcenter_cluster_cpu_effective{} / vcenter_cluster_cpu_limit{}))'
      ),

    clusterMemoryEffective:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_memory_effective_bytes{}'
      ),
    clusterMemoryLimit:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_memory_effective_bytes'
      ),
    clusterMemoryUtilization:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'vcenter_cluster_memory_limit_bytes{}'
      ),
  },
}
