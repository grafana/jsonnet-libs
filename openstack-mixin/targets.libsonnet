local g = import './g.libsonnet';
local prometheusQuery = g.query.prometheus;
local lokiQuery = g.query.loki;

{
  new(this): {
    local vars = this.grafana.variables,
    local config = this.config,
    local panel = g.panel,

    placementStatus:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'openstack_placement_up{%(queriesSelector)s}' % vars
      ),
    keystoneStatus:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'openstack_placement_up{%(queriesSelector)s}' % vars
      ),
    novaStatus:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'openstack_placement_up{%(queriesSelector)s}' % vars
      ),
    neutronStatus:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'openstack_placement_up{%(queriesSelector)s}' % vars
      ),
    cinderStatus:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'openstack_placement_up{%(queriesSelector)s}' % vars
      ),
    glanceStatus:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'openstack_placement_up{%(queriesSelector)s}' % vars
      ),
    totalDiskCapacity:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum(openstack_placement_resource_total{%(queriesSelector)s, resourcetype="DISK_GB"})' % vars
      )
      + prometheusQuery.withFormat('table')
      + prometheusQuery.withInstant(true),
    totalDiskUsage:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum(openstack_placement_resource_usage{%(queriesSelector)s, resourcetype="DISK_GB"})' % vars
      )
      + prometheusQuery.withFormat('table')
      + prometheusQuery.withInstant(true),
    totalMemoryCapacity:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum(openstack_placement_resource_total{%(queriesSelector)s, resourcetype="MEMORY_MB"})' % vars
      )
      + prometheusQuery.withFormat('table')
      + prometheusQuery.withInstant(true),
    totalMemoryUsage:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum(openstack_placement_resource_usage{%(queriesSelector)s, resourcetype="MEMORY_MB"})' % vars
      )
      + prometheusQuery.withFormat('table')
      + prometheusQuery.withInstant(true),
    totalVCPUCapacity:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum(openstack_placement_resource_total{%(queriesSelector)s, resourcetype="VCPU"})' % vars
      )
      + prometheusQuery.withFormat('table')
      + prometheusQuery.withInstant(true),
    totalVCPUUsage:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum(openstack_placement_resource_usage{%(queriesSelector)s, resourcetype="VCPU"})' % vars
      )
      + prometheusQuery.withFormat('table')
      + prometheusQuery.withInstant(true),
    domains:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'openstack_identity_domains{%(queriesSelector)s}' % vars
      ),
    projects:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'openstack_identity_projects{%(queriesSelector)s}' % vars
      ),
    regions:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'openstack_identity_regions{%(queriesSelector)s}' % vars
      ),
    users:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'openstack_identity_users{%(queriesSelector)s}' % vars
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{cluster}}'),

    projectDetails:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'openstack_identity_project_info{%(queriesSelector)s}' % vars
      )
      + prometheusQuery.withFormat('table')
      + prometheusQuery.withInstant(true),
    vms:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'openstack_nova_total_vms{%(queriesSelector)s}' % vars
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{cluster}}'),
    instanceUsage:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'openstack_nova_limits_instances_used{%(queriesSelector)s}' % vars
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{tenant}}'),
    vCPUUsage:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'openstack_nova_limits_vcpus_used{%(queriesSelector)s}' % vars
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{tenant}}'),
    memoryUsage:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'openstack_nova_limits_memory_used{%(queriesSelector)s} * 1024 * 1024' % vars
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{tenant}}'),
    novaAgentState:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'openstack_nova_agent_state{%(queriesSelector)s}' % vars
      )
      + prometheusQuery.withFormat('table')
      + prometheusQuery.withInstant(true),
    networks:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'openstack_neutron_networks{%(queriesSelector)s}' % vars
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{cluster}}'),
    subnets:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'openstack_neutron_subnets{%(queriesSelector)s}' % vars
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{cluster}}'),
    routers:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'openstack_neutron_routers{%(queriesSelector)s}' % vars
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('total'),
    routersNotActive:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'openstack_neutron_routers_not_active{%(queriesSelector)s}' % vars
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('inactive'),
    routerDetails:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'openstack_neutron_router{%(queriesSelector)s}' % vars
      )
      + prometheusQuery.withFormat('table')
      + prometheusQuery.withInstant(true),
    ports:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'openstack_neutron_ports{%(queriesSelector)s}' % vars
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('total'),
    portsLBNotActive:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'openstack_neutron_ports_lb_not_active{%(queriesSelector)s}' % vars
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('load balancer inactive'),
    portsNoIPs:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'openstack_neutron_ports_no_ips{%(queriesSelector)s}' % vars
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('no IPs'),
    portDetails:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'openstack_neutron_port{%(queriesSelector)s}' % vars
      )
      + prometheusQuery.withFormat('table')
      + prometheusQuery.withInstant(true),
    floatingIPs:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'openstack_neutron_floating_ips{%(queriesSelector)s}' % vars
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('total'),
    floatingIPsAssociatedNotActive:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'openstack_neutron_floating_ips_associated_not_active{%(queriesSelector)s}' % vars
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('associated inactive'),
    ipsUsed:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (job, instance, ip_version, network_name, subnet_name) (openstack_neutron_network_ip_availabilities_used{%(queriesSelector)s, network_name=~"%(alertsIPutilizationNetworksMatcher)s"}) / sum by (job, instance, ip_version, network_name, subnet_name)(openstack_neutron_network_ip_availabilities_total{%(queriesSelector)s, network_name=~"%(alertsIPutilizationNetworksMatcher)s"})' % vars {alertsIPutilizationNetworksMatcher: config.alertsIPutilizationNetworksMatcher}
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{network_name}}/{{subnet_name}}'),
    securityGroups:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'openstack_neutron_security_groups{%(queriesSelector)s}' % vars
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{cluster}}'),
    neutronAgentState:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'openstack_neutron_agent_state{%(queriesSelector)s}' % vars
      )
      + prometheusQuery.withFormat('table')
      + prometheusQuery.withInstant(true),
    volumes:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'openstack_cinder_volumes{%(queriesSelector)s}' % vars
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{cluster}}'),
    volumeErrorStatus:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'openstack_cinder_volume_status_counter{%(queriesSelector)s, status=~"error|error_backing-up|error_deleting|error_extending|error_restoring"} > 0' % vars
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{status}}'),
    volumeNonErrorStatus:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(5, openstack_cinder_volume_status_counter{%(queriesSelector)s, status!~"error|error_backing-up|error_deleting|error_extending|error_restoring"}) > 0' % vars
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{status}}'),
    volumeUsage:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'openstack_cinder_limits_volume_used_gb{%(queriesSelector)s}' % vars
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{tenant}}'),
    backupUsage:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'openstack_cinder_limits_backup_used_gb{%(queriesSelector)s}' % vars
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{tenant}}'),
    poolUsage:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '(openstack_cinder_pool_capacity_total_gb{%(queriesSelector)s} - openstack_cinder_pool_capacity_free_gb{%(queriesSelector)s}) / clamp_min(openstack_cinder_pool_capacity_total_gb{%(queriesSelector)s}, 1)' % vars
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{name}}'),
    snaphots:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'openstack_cinder_snapshots{%(queriesSelector)s}' % vars
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{cluster}}'),
    cinderAgentState:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'openstack_cinder_agent_state{%(queriesSelector)s}' % vars
      )
      + prometheusQuery.withFormat('table')
      + prometheusQuery.withInstant(true),
    imageCount:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'openstack_glance_images{%(queriesSelector)s}' % vars
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{cluster}}'),
    imageDetails:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'openstack_glance_image_bytes{%(queriesSelector)s}' % vars
      )
      + prometheusQuery.withFormat('table')
      + prometheusQuery.withInstant(true),
    vCPUused:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '(100*sum(openstack_placement_resource_usage{%(queriesSelector)s,resourcetype="VCPU"}))/sum(openstack_placement_resource_total{%(queriesSelector)s,resourcetype="VCPU"})' % vars
      ),
    RAMused:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '(100*sum(openstack_placement_resource_usage{%(queriesSelector)s,resourcetype="MEMORY_MB"}))/sum(openstack_placement_resource_total{%(queriesSelector)s,resourcetype="MEMORY_MB"})' % vars
      ),
    freeIPs:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'openstack_neutron_network_ip_availabilities_total{%(queriesSelector)s,network_name=~"%(alertsIPutilizationNetworksMatcher)s"}-openstack_neutron_network_ip_availabilities_used{%(queriesSelector)s,network_name=~"%(alertsIPutilizationNetworksMatcher)s"}' % vars {alertsIPutilizationNetworksMatcher: config.alertsIPutilizationNetworksMatcher}
      )
      + prometheusQuery.withLegendFormat('{{network_name}}'),
  },
}
