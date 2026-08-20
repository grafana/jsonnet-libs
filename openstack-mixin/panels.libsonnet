local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(this): {
    local signals = this.signals,

    local statBase = commonlib.panels.generic.stat.base,
    local statInfo = commonlib.panels.generic.stat.info,
    local tableBase = commonlib.panels.generic.table.base,
    local timeSeriesBase = commonlib.panels.generic.timeSeries.base,
    local timeSeriesPercentage = commonlib.panels.generic.timeSeries.percentage,

    placementStatus:
      signals.placement.placement_up.asStat()
      + statBase.stylize()
      + g.panel.stat.options.withGraphMode('none')
      + g.panel.stat.standardOptions.withMappings({
        type: 'value',
        options: {
          '0': {
            color: 'red',
            index: 1,
            text: 'Down',
          },
          '1': {
            color: 'green',
            index: 0,
            text: 'Up',
          },
        },
      }),

    keystoneStatus:
      signals.identity.identity_up.asStat()
      + statBase.stylize()
      + g.panel.stat.options.withGraphMode('none')
      + g.panel.stat.standardOptions.withMappings({
        type: 'value',
        options: {
          '0': {
            color: 'red',
            index: 1,
            text: 'Down',
          },
          '1': {
            color: 'green',
            index: 0,
            text: 'Up',
          },
        },
      }),

    novaStatus:
      signals.nova.nova_up.asStat()
      + statBase.stylize()
      + g.panel.stat.options.withGraphMode('none')
      + g.panel.stat.standardOptions.withMappings({
        type: 'value',
        options: {
          '0': {
            color: 'red',
            index: 1,
            text: 'Down',
          },
          '1': {
            color: 'green',
            index: 0,
            text: 'Up',
          },
        },
      }),

    neutronStatus:
      signals.neutron.neutron_up.asStat()
      + statBase.stylize()
      + g.panel.stat.options.withGraphMode('none')
      + g.panel.stat.standardOptions.withMappings({
        type: 'value',
        options: {
          '0': {
            color: 'red',
            index: 1,
            text: 'Down',
          },
          '1': {
            color: 'green',
            index: 0,
            text: 'Up',
          },
        },
      }),

    cinderStatus:
      signals.cinder.cinder_up.asStat()
      + statBase.stylize()
      + g.panel.stat.options.withGraphMode('none')
      + g.panel.stat.standardOptions.withMappings({
        type: 'value',
        options: {
          '0': {
            color: 'red',
            index: 1,
            text: 'Down',
          },
          '1': {
            color: 'green',
            index: 0,
            text: 'Up',
          },
        },
      }),

    glanceStatus:
      signals.glance.glance_up.asStat()
      + statBase.stylize()
      + g.panel.stat.options.withGraphMode('none')
      + g.panel.stat.standardOptions.withMappings({
        type: 'value',
        options: {
          '0': {
            color: 'red',
            index: 1,
            text: 'Down',
          },
          '1': {
            color: 'green',
            index: 0,
            text: 'Up',
          },
        },
      }),

    alertsPanel:
      // common-lib has no alert list panel, so this is built from grafonnet directly.
      g.panel.alertList.new('Alerts')
      + g.panel.alertList.panelOptions.withDescription('Panel to report on the status of firing alerts.')
      + g.panel.alertList.options.UnifiedAlertListOptions.withAlertInstanceLabelFilter(this.grafana.variables.queriesGroupSelectorAdvanced),

    totalResources:
      tableBase.new(
        'Total resources',
        targets=[
          signals.placement.placement_resource_total_disk.asTableTarget(),
          signals.placement.placement_resource_usage_disk.asTableTarget(),
          signals.placement.placement_resource_total_memory.asTableTarget(),
          signals.placement.placement_resource_usage_memory.asTableTarget(),
          signals.placement.placement_resource_total_vcpu.asTableTarget(),
          signals.placement.placement_resource_usage_vcpu.asTableTarget(),
        ],
        description='Summary of the hardware resources available and used by OpenStack.',
      )
      + g.panel.table.fieldConfig.defaults.custom.withAlign('center')
      + g.panel.table.standardOptions.withOverridesMixin([
        g.panel.table.fieldOverride.byRegexp.new('/Disk/')
        + g.panel.table.standardOptions.override.byRegexp.withPropertiesFromOptions(
          g.panel.table.standardOptions.withUnit('decgbytes')
        ),
        g.panel.table.fieldOverride.byRegexp.new('/Memory/')
        + g.panel.table.standardOptions.override.byRegexp.withPropertiesFromOptions(
          g.panel.table.standardOptions.withUnit('decmbytes')
        ),
      ])
      + g.panel.table.queryOptions.withTransformationsMixin([
        {
          id: 'joinByField',
          options: {
            byField: 'Time',
            mode: 'outer',
          },
        },
        {
          id: 'organize',
          options: {
            excludeByName: {
              Time: true,
              'Time 1': true,
              'Time 3': true,
              'Time 4': true,
              'Time 5': true,
              'Time 6': true,
              '__name__ 1': true,
              '__name__ 2': true,
              '__name__ 3': true,
              '__name__ 4': true,
              '__name__ 5': true,
              '__name__ 6': true,
              'hostname 1': true,
              'hostname 2': true,
              'hostname 3': true,
              'hostname 4': true,
              'hostname 5': true,
              'hostname 6': true,
              job: true,
              'job 1': true,
              'job 2': true,
              'job 3': true,
              'job 4': true,
              'job 5': true,
              'job 6': true,
              'resourcetype 1': true,
              'resourcetype 2': true,
              'resourcetype 3': true,
              'resourcetype 4': true,
              'resourcetype 5': true,
              'resourcetype 6': true,
              'cluster 1': false,
              'cluster 2': true,
              'cluster 3': true,
              'cluster 4': true,
              'cluster 5': true,
              'cluster 6': true,
            },
            indexByName: {
              'cluster 1': 0,
              'Value #Placement disk capacity': 1,
              'Value #Placement disk usage': 2,
              'Value #Placement memory capacity': 3,
              'Value #Placement memory usage': 4,
              'Value #Placement vCPU capacity': 5,
              'Value #Placement vCPU usage': 6,
              Time: 7,
              'cluster 2': 8,
              'cluster 3': 9,
              'cluster 4': 10,
              'cluster 5': 11,
              'cluster 6': 12,
            },
            renameByName: {
              Time: '',
              'Value #Placement disk capacity': 'Disk available',
              'Value #Placement disk usage': 'Disk used',
              'Value #Placement memory capacity': 'Memory avaliable',
              'Value #Placement memory usage': 'Memory used',
              'Value #Placement vCPU capacity': 'VCPUs available',
              'Value #Placement vCPU usage': 'VCPUs used',
              hostname: 'Hostname',
              instance: 'Instance',
              openstack_placement_resource_total: 'Total',
              openstack_placement_resource_usage: 'In use',
              resourcetype: 'Resource',
              'cluster 1': 'cluster',
            },
            includeByName: {},
          },
        },
      ]),

    vCPUUsedStat:
      signals.placement.placement_vcpu_usage_ratio.asGauge()
      + g.panel.gauge.standardOptions.withMin(0)
      + g.panel.gauge.standardOptions.withMax(150)
      + g.panel.gauge.standardOptions.thresholds.withSteps([
        g.panel.gauge.standardOptions.threshold.step.withValue(0) +
        g.panel.gauge.standardOptions.threshold.step.withColor('green'),
        g.panel.gauge.standardOptions.threshold.step.withValue(99) +
        g.panel.gauge.standardOptions.threshold.step.withColor('red'),
      ]),

    RAMUsedStat:
      signals.placement.placement_memory_usage_ratio.asGauge()
      + g.panel.gauge.standardOptions.withMin(0)
      + g.panel.gauge.standardOptions.withMax(150)
      + g.panel.gauge.standardOptions.thresholds.withSteps([
        g.panel.gauge.standardOptions.threshold.step.withValue(0) +
        g.panel.gauge.standardOptions.threshold.step.withColor('green'),
        g.panel.gauge.standardOptions.threshold.step.withValue(99) +
        g.panel.gauge.standardOptions.threshold.step.withColor('red'),
      ]),

    freeIPsStat:
      signals.neutron.neutron_free_ips.asStat()
      + g.panel.stat.standardOptions.thresholds.withSteps([
        g.panel.stat.standardOptions.threshold.step.withValue(0) +
        g.panel.stat.standardOptions.threshold.step.withColor('red'),
        g.panel.stat.standardOptions.threshold.step.withValue(20) +
        g.panel.stat.standardOptions.threshold.step.withColor('green'),
      ]),

    domains:
      signals.identity.identity_domains.asStat()
      + statInfo.stylize(),

    projects:
      signals.identity.identity_projects.asStat()
      + statInfo.stylize(),

    regions:
      signals.identity.identity_regions.asStat()
      + statInfo.stylize(),

    users:
      signals.identity.identity_users.asTimeSeries()
      + timeSeriesBase.stylize()
      + g.panel.timeSeries.queryOptions.withInterval('1m')
      + g.panel.timeSeries.standardOptions.withDecimals(0),

    projectDetails:
      tableBase.new(
        'Project details',
        targets=[signals.identity.identity_project_info.asTableTarget()],
        description='Details for the projects in the OpenStack cloud.',
      )
      + g.panel.table.fieldConfig.defaults.custom.withAlign('center')
      + g.panel.table.standardOptions.withOverridesMixin([
        g.panel.table.fieldOverride.byName.new('Enabled')
        + g.panel.table.fieldOverride.byName.withProperty('custom.displayMode', 'color-text')
        + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
          g.panel.table.standardOptions.withMappings(
            {
              type: 'value',
              options: {
                'false': {
                  color: 'red',
                  index: 1,
                  text: 'False',
                },
                'true': {
                  color: 'green',
                  index: 0,
                  text: 'True',
                },
              },
            }
          ),
        ),
      ])
      + g.panel.table.queryOptions.withTransformationsMixin([
        {
          id: 'joinByField',
          options: {
            byField: 'Time',
            mode: 'outer',
          },
        },
        {
          id: 'organize',
          options: {
            excludeByName: {
              Time: true,
              Value: true,
              __name__: true,
              description: true,
              job: true,
              parent_id: true,
            },
            includeByName: {},
            indexByName: {
              Time: 3,
              Value: 11,
              __name__: 4,
              description: 5,
              domain_id: 7,
              enabled: 6,
              id: 1,
              instance: 2,
              is_domain: 8,
              job: 10,
              name: 0,
              parent_id: 9,
            },
            renameByName: {
              domain_id: 'Domain ID',
              enabled: 'Enabled',
              id: 'ID',
              instance: 'Instance',
              is_domain: 'Is domain',
              name: 'Name',
            },
          },
        },
      ]),

    vms:
      signals.nova.nova_total_vms.asTimeSeries()
      + timeSeriesBase.stylize()
      + g.panel.timeSeries.queryOptions.withInterval('1m')
      + g.panel.timeSeries.standardOptions.withDecimals(0),

    instanceUsage:
      timeSeriesPercentage.new(
        'Instance usage',
        targets=[
          signals.nova.nova_instance_usage.asTarget()
          + g.panel.timeSeries.queryOptions.withInterval('1m'),
        ],
        description='Percentage of the maximum number of instances in use for each project.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('percentunit')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.standardOptions.withMax(1)
      + g.panel.timeSeries.standardOptions.withMin(0),

    vCPUUsage:
      timeSeriesPercentage.new(
        'VCPU usage',
        targets=[
          signals.nova.nova_vcpu_usage.asTarget()
          + g.panel.timeSeries.queryOptions.withInterval('1m'),
        ],
        description='Percentage of the maximum number of virtual CPUs in use for each project.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('percentunit')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.standardOptions.withMax(1)
      + g.panel.timeSeries.standardOptions.withMin(0),

    memoryUsage:
      timeSeriesPercentage.new(
        'Memory usage',
        targets=[
          signals.nova.nova_memory_usage.asTarget()
          + g.panel.timeSeries.queryOptions.withInterval('1m'),
        ],
        description='Percentage of the maximum amount of memory in use for each project.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('percentunit')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.standardOptions.withMax(1)
      + g.panel.timeSeries.standardOptions.withMin(0),

    novaAgents:
      tableBase.new(
        'Agents',
        targets=[signals.nova.nova_agent_state.asTableTarget()],
        description='Details for the agents for OpenStack Nova.',
      )
      + g.panel.table.fieldConfig.defaults.custom.withAlign('center')
      + g.panel.table.standardOptions.withOverridesMixin([
        g.panel.table.fieldOverride.byName.new('Admin state')
        + g.panel.table.fieldOverride.byName.withProperty('custom.displayMode', 'color-text')
        + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
          g.panel.table.standardOptions.withMappings(
            {
              type: 'value',
              options: {
                disabled: {
                  color: 'red',
                  index: 1,
                  text: 'Disabled',
                },
                enabled: {
                  color: 'green',
                  index: 0,
                  text: 'Enabled',
                },
              },
            }
          ),
        ),
      ])
      + g.panel.table.queryOptions.withTransformationsMixin([
        {
          id: 'joinByField',
          options: {
            byField: 'Time',
            mode: 'outer',
          },
        },
        {
          id: 'organize',
          options: {
            excludeByName: {
              Time: true,
              Value: true,
              __name__: true,
              hostname: true,
              job: true,
            },
            includeByName: {},
            indexByName: {
              Time: 6,
              Value: 9,
              __name__: 7,
              adminState: 3,
              hostname: 5,
              id: 4,
              instance: 1,
              job: 8,
              service: 0,
              zone: 2,
            },
            renameByName: {
              Time: '',
              adminState: 'Admin state',
              id: 'ID',
              instance: 'Instance',
              service: 'Service',
              zone: 'Zone',
            },
          },
        },
      ]),

    networks:
      signals.neutron.neutron_networks.asTimeSeries()
      + timeSeriesBase.stylize()
      + g.panel.timeSeries.queryOptions.withInterval('1m')
      + g.panel.timeSeries.standardOptions.withDecimals(0),

    subnets:
      signals.neutron.neutron_subnets.asTimeSeries()
      + timeSeriesBase.stylize()
      + g.panel.timeSeries.queryOptions.withInterval('1m')
      + g.panel.timeSeries.standardOptions.withDecimals(0),

    routers:
      timeSeriesBase.new(
        'Routers',
        targets=[
          signals.neutron.neutron_routers.withLegendFormat('{{instance}} - total').asTarget()
          + g.panel.timeSeries.queryOptions.withInterval('1m'),
          signals.neutron.neutron_routers_not_active.withLegendFormat('{{instance}} - inactive').asTarget()
          + g.panel.timeSeries.queryOptions.withInterval('1m'),
        ],
        description='The number of routers managed by Neutron.',
      )
      + g.panel.timeSeries.standardOptions.withDecimals(0),

    routerDetails:
      tableBase.new(
        'Router details',
        targets=[signals.neutron.neutron_router_info.asTableTarget()],
        description='Detailed view of the routers managed by Neutron.',
      )
      + g.panel.table.fieldConfig.defaults.custom.withAlign('center')
      + g.panel.table.standardOptions.withOverridesMixin([
        g.panel.table.fieldOverride.byRegexp.new('/Admin up|Status/')
        + g.panel.table.fieldOverride.byRegexp.withProperty('custom.displayMode', 'color-text')
        + g.panel.table.fieldOverride.byRegexp.withPropertiesFromOptions(
          g.panel.table.standardOptions.withMappings(
            {
              type: 'value',
              options: {
                ACTIVE: {
                  color: 'green',
                  index: 2,
                  text: 'Active',
                },
                DOWN: {
                  color: 'red',
                  index: 3,
                  text: 'Down',
                },
                'false': {
                  color: 'red',
                  index: 1,
                  text: 'False',
                },
                'true': {
                  color: 'green',
                  index: 0,
                  text: 'True',
                },
              },
            }
          ),
        ),
      ])
      + g.panel.table.queryOptions.withTransformationsMixin([
        {
          id: 'joinByField',
          options: {
            byField: 'Time',
            mode: 'outer',
          },
        },
        {
          id: 'organize',
          options: {
            excludeByName: {
              Time: true,
              Value: true,
              __name__: true,
              hostname: true,
              job: true,
              project_id: true,
            },
            indexByName: {
              name: 0,
              instance: 1,
              status: 2,
              admin_state_up: 3,
              id: 4,
              external_network_id: 5,
              project_id: 6,
              Time: 7,
              __name__: 8,
              job: 9,
              Value: 10,
            },
            renameByName: {
              Time: '',
              adminState: 'Admin state',
              admin_state_up: 'Admin up',
              external_network_id: 'External network ID',
              id: 'ID',
              instance: 'Instance',
              name: 'Name',
              project_id: '',
              service: 'Service',
              status: 'Status',
              zone: 'Zone',
            },
            includeByName: {},
          },
        },
      ]),

    ports:
      timeSeriesBase.new(
        'Ports',
        targets=[
          signals.neutron.neutron_ports.withLegendFormat('{{instance}} - total').asTarget()
          + g.panel.timeSeries.queryOptions.withInterval('1m'),
          signals.neutron.neutron_ports_lb_not_active.withLegendFormat('{{instance}} - load balancer inactive').asTarget()
          + g.panel.timeSeries.queryOptions.withInterval('1m'),
          signals.neutron.neutron_ports_no_ips.withLegendFormat('{{instance}} - no IPs').asTarget()
          + g.panel.timeSeries.queryOptions.withInterval('1m'),
        ],
        description='The number of routers managed by Neutron.',
      )
      + g.panel.timeSeries.standardOptions.withDecimals(0),

    portDetails:
      tableBase.new(
        'Port details',
        targets=[signals.neutron.neutron_port_info.asTableTarget()],
        description='Detailed view of the ports managed by Neutron.',
      )
      + g.panel.table.fieldConfig.defaults.custom.withAlign('center')
      + g.panel.table.standardOptions.withOverridesMixin([
        g.panel.table.fieldOverride.byRegexp.new('/Admin up|Status/')
        + g.panel.table.fieldOverride.byRegexp.withProperty('custom.displayMode', 'color-text')
        + g.panel.table.fieldOverride.byRegexp.withPropertiesFromOptions(
          g.panel.table.standardOptions.withMappings(
            {
              type: 'value',
              options: {
                ACTIVE: {
                  color: 'green',
                  index: 2,
                  text: 'Active',
                },
                DOWN: {
                  color: 'red',
                  index: 3,
                  text: 'Down',
                },
                'false': {
                  color: 'red',
                  index: 1,
                  text: 'False',
                },
                'true': {
                  color: 'green',
                  index: 0,
                  text: 'True',
                },
              },
            }
          ),
        ),
      ])
      + g.panel.table.queryOptions.withTransformationsMixin([
        {
          id: 'joinByField',
          options: {
            byField: 'Time',
            mode: 'outer',
          },
        },
        {
          id: 'organize',
          options: {
            excludeByName: {
              Time: true,
              Value: true,
              __name__: true,
              hostname: true,
              job: true,
              fixed_ips: true,
            },
            indexByName: {
              Time: 8,
              Value: 11,
              __name__: 9,
              admin_state_up: 3,
              binding_vif_type: 6,
              device_owner: 5,
              instance: 0,
              job: 10,
              mac_address: 1,
              network_id: 4,
              status: 2,
              uuid: 7,
            },
            renameByName: {
              Time: '',
              adminState: 'Admin state',
              admin_state_up: 'Admin up',
              binding_vif_type: 'Binding VIF type',
              device_owner: 'Device owner',
              id: 'ID',
              instance: 'Instance',
              mac_address: 'MAC address',
              network_id: 'Network ID',
              service: 'Service',
              status: 'Status',
              uuid: 'UUID',
              zone: 'Zone',
              fixed_ips: '',
            },
            includeByName: {},
          },
        },
      ]),

    floatingIPs:
      timeSeriesBase.new(
        'Floating IPs',
        targets=[
          signals.neutron.neutron_floating_ips.withLegendFormat('{{instance}} - total').asTarget()
          + g.panel.timeSeries.queryOptions.withInterval('1m'),
          signals.neutron.neutron_floating_ips_associated_not_active.withLegendFormat('{{instance}} - associated inactive').asTarget()
          + g.panel.timeSeries.queryOptions.withInterval('1m'),
        ],
        description='The number of public IP addresses managed by Neutron.',
      )
      + g.panel.timeSeries.standardOptions.withDecimals(0),

    ipsUsed:
      timeSeriesPercentage.new(
        'IPs used',
        targets=[
          signals.neutron.neutron_ip_usage_ratio.asTarget()
          + g.panel.timeSeries.queryOptions.withInterval('1m'),
        ],
        description='The usage of available IP addresses broken down by subnet.',
      )
      + g.panel.timeSeries.standardOptions.withUnit('percentunit')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.standardOptions.withMax(1)
      + g.panel.timeSeries.standardOptions.withMin(0),

    securityGroups:
      signals.neutron.neutron_security_groups.asTimeSeries()
      + timeSeriesBase.stylize()
      + g.panel.timeSeries.queryOptions.withInterval('1m')
      + g.panel.timeSeries.standardOptions.withDecimals(0),

    neutronAgents:
      tableBase.new(
        'Agents',
        targets=[signals.neutron.neutron_agent_state.asTableTarget()],
        description='Details for the agents for OpenStack Neutron.',
      )
      + g.panel.table.fieldConfig.defaults.custom.withAlign('center')
      + g.panel.table.standardOptions.withOverridesMixin([
        g.panel.table.fieldOverride.byName.new('Admin state')
        + g.panel.table.fieldOverride.byName.withProperty('custom.displayMode', 'color-text')
        + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
          g.panel.table.standardOptions.withMappings(
            {
              type: 'value',
              options: {
                down: {
                  color: 'red',
                  index: 1,
                  text: 'Down',
                },
                up: {
                  color: 'green',
                  index: 0,
                  text: 'Up',
                },
              },
            }
          ),
        ),
      ])
      + g.panel.table.queryOptions.withTransformationsMixin([
        {
          id: 'joinByField',
          options: {
            byField: 'Time',
            mode: 'outer',
          },
        },
        {
          id: 'organize',
          options: {
            excludeByName: {
              Time: true,
              Value: true,
              __name__: true,
              hostname: true,
              job: true,
            },
            includeByName: {},
            indexByName: {
              Time: 6,
              Value: 9,
              __name__: 7,
              adminState: 3,
              hostname: 5,
              id: 4,
              instance: 1,
              job: 8,
              service: 0,
              zone: 2,
            },
            renameByName: {
              Time: '',
              adminState: 'Admin state',
              id: 'ID',
              instance: 'Instance',
              service: 'Service',
              zone: 'Zone',
            },
          },
        },
      ]),

    volumes:
      signals.cinder.cinder_volumes.asTimeSeries()
      + timeSeriesBase.stylize()
      + g.panel.timeSeries.queryOptions.withInterval('1m')
      + g.panel.timeSeries.standardOptions.withDecimals(0),

    volumeStatus:
      timeSeriesBase.new(
        'Volume status',
        targets=[
          signals.cinder.cinder_volume_error_status.asTarget()
          + g.panel.timeSeries.queryOptions.withInterval('1m'),
          signals.cinder.cinder_volume_top_statuses.asTarget()
          + g.panel.timeSeries.queryOptions.withInterval('1m'),
        ],
        description='The current status of volumes in Cinder.',
      )
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withStackingMixin({
        group: 'A',
        mode: 'normal',
      })
      + g.panel.timeSeries.standardOptions.withDecimals(0),

    volumeUsage:
      timeSeriesPercentage.new(
        'Volume usage',
        targets=[
          signals.cinder.cinder_volume_usage.asTarget()
          + g.panel.timeSeries.queryOptions.withInterval('1m'),
        ],
        description='The percent of volume storage in use for Cinder.',
      )
      + g.panel.timeSeries.standardOptions.withUnit('percentunit')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.standardOptions.withMax(1)
      + g.panel.timeSeries.standardOptions.withMin(0),

    backupUsage:
      timeSeriesPercentage.new(
        'Backup usage',
        targets=[
          signals.cinder.cinder_backup_usage.asTarget()
          + g.panel.timeSeries.queryOptions.withInterval('1m'),
        ],
        description='The percent of backup storage in use for Cinder.',
      )
      + g.panel.timeSeries.standardOptions.withUnit('percentunit')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.standardOptions.withMax(1)
      + g.panel.timeSeries.standardOptions.withMin(0),

    poolUsage:
      timeSeriesPercentage.new(
        'Pool usage',
        targets=[
          signals.cinder.cinder_pool_usage.asTarget()
          + g.panel.timeSeries.queryOptions.withInterval('1m'),
        ],
        description='The percent of pool capacity in use for Cinder.',
      )
      + g.panel.timeSeries.standardOptions.withUnit('percentunit')
      + g.panel.timeSeries.standardOptions.withMax(1)
      + g.panel.timeSeries.standardOptions.withMin(0),

    snapshots:
      signals.cinder.cinder_snapshots.asTimeSeries()
      + timeSeriesBase.stylize()
      + g.panel.timeSeries.queryOptions.withInterval('1m')
      + g.panel.timeSeries.standardOptions.withDecimals(0),

    cinderAgents:
      tableBase.new(
        'Agents',
        targets=[signals.cinder.cinder_agent_state.asTableTarget()],
        description='Details for the agents for OpenStack Cinder.',
      )
      + g.panel.table.fieldConfig.defaults.custom.withAlign('center')
      + g.panel.table.fieldConfig.defaults.custom.withCellOptions('color-text')
      + g.panel.table.standardOptions.withOverridesMixin([
        g.panel.table.fieldOverride.byName.new('Admin state')
        + g.panel.table.fieldOverride.byName.withProperty('custom.displayMode', 'color-text')
        + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
          g.panel.table.standardOptions.withMappings(
            {
              type: 'value',
              options: {
                disabled: {
                  color: 'red',
                  index: 1,
                  text: 'Disabled',
                },
                enabled: {
                  color: 'green',
                  index: 0,
                  text: 'Enabled',
                },
              },
            }
          ),
        ),
      ])
      + g.panel.table.queryOptions.withTransformationsMixin([
        {
          id: 'joinByField',
          options: {
            byField: 'Time',
            mode: 'outer',
          },
        },
        {
          id: 'organize',
          options: {
            excludeByName: {
              Time: true,
              Value: true,
              __name__: true,
              hostname: true,
              job: true,
            },
            indexByName: {
              Time: 6,
              Value: 9,
              __name__: 7,
              adminState: 3,
              hostname: 5,
              instance: 1,
              job: 8,
              service: 0,
              uuid: 4,
              zone: 2,
            },
            renameByName: {
              Time: '',
              adminState: 'Admin state',
              id: 'ID',
              instance: 'Instance',
              service: 'Service',
              zone: 'Zone',
              uuid: 'UUID',
            },
            includeByName: {},
          },
        },
      ]),

    imageCount:
      signals.glance.glance_images.asTimeSeries()
      + timeSeriesBase.stylize()
      + g.panel.timeSeries.queryOptions.withInterval('1m')
      + g.panel.timeSeries.standardOptions.withDecimals(0),

    images:
      tableBase.new(
        'Images',
        targets=[signals.glance.glance_image_bytes.asTableTarget()],
        description='Details for the images in Glance.',
      )
      + g.panel.table.fieldConfig.defaults.custom.withAlign('center')
      + g.panel.table.standardOptions.withOverridesMixin([
        g.panel.table.fieldOverride.byName.new('Size')
        + g.panel.table.standardOptions.override.byName.withPropertiesFromOptions(
          g.panel.table.standardOptions.withUnit('decbytes')
        ),
      ])
      + g.panel.table.queryOptions.withTransformationsMixin([
        {
          id: 'joinByField',
          options: {
            byField: 'Time',
            mode: 'outer',
          },
        },
        {
          id: 'organize',
          options: {
            excludeByName: {
              Time: true,
              __name__: true,
              job: true,
            },
            includeByName: {},
            indexByName: {
              Time: 5,
              Value: 2,
              __name__: 6,
              id: 1,
              instance: 3,
              job: 7,
              name: 0,
              tenant_id: 4,
            },
            renameByName: {
              Value: 'Size',
              id: 'ID',
              instance: 'Instance',
              name: 'Name',
              tenant_id: 'Tenant ID',
            },
          },
        },
      ]),
  },
}
