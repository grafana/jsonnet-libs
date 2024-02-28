local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;
{
  new(this): {
    local t = this.grafana.targets,
    local alertList = g.panel.alertList,
    local stat = g.panel.stat,
    local timeSeries = g.panel.timeSeries,
    local table = g.panel.table,

    placementStatus:
      commonlib.panels.generic.stat.base.new(
        'Placement status',
        targets=[t.placementStatus],
        description='Reports the status of the Placement resource-scheduling service.',
      )
      + stat.standardOptions.withUnit('string')
      + stat.options.withGraphMode('none')
      + stat.standardOptions.withMappings({
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
      commonlib.panels.generic.stat.base.new(
        'Keystone status',
        targets=[t.keystoneStatus],
        description='Reports the status of the Keystone identity service.',
      )
      + stat.standardOptions.withUnit('string')
      + stat.options.withGraphMode('none')
      + stat.standardOptions.withMappings({
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
      commonlib.panels.generic.stat.base.new(
        'Nova status',
        targets=[t.novaStatus],
        description='Reports the status of the Nova compute service.',
      )
      + stat.standardOptions.withUnit('string')
      + stat.options.withGraphMode('none')
      + stat.standardOptions.withMappings({
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
      commonlib.panels.generic.stat.base.new(
        'Neutron status',
        targets=[t.neutronStatus],
        description='Reports the status of the Neutron networking service.',
      )
      + stat.standardOptions.withUnit('string')
      + stat.options.withGraphMode('none')
      + stat.standardOptions.withMappings({
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
      commonlib.panels.generic.stat.base.new(
        'Cinder status',
        targets=[t.cinderStatus],
        description='Reports the status of the Cinder block storage service.',
      )
      + stat.standardOptions.withUnit('string')
      + stat.options.withGraphMode('none')
      + stat.standardOptions.withMappings({
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
      commonlib.panels.generic.stat.base.new(
        'Glance status',
        targets=[t.glanceStatus],
        description='Reports the status of the Glance image service.',
      )
      + stat.standardOptions.withUnit('string')
      + stat.options.withGraphMode('none')
      + stat.standardOptions.withMappings({
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
      alertList.new('Alerts')
      + alertList.panelOptions.withDescription('Panel to report on the status of firing alerts.')
      + alertList.options.UnifiedAlertListOptions.withAlertInstanceLabelFilter(this.grafana.variables.queriesGroupSelectorAdvanced),

    totalResources:
      table.new('Total resources')
      + table.queryOptions.withTargets([
        t.totalDiskCapacity,
        t.totalDiskUsage,
        t.totalMemoryCapacity,
        t.totalMemoryUsage,
        t.totalVCPUCapacity,
        t.totalVCPUUsage,
      ])
      + table.queryOptions.withDatasource('prometheus', '${prometheus_datasource}')
      + table.panelOptions.withDescription('Summary of the hardware resources available and used by OpenStack.')
      + table.standardOptions.withOverridesMixin([
        table.fieldOverride.byRegexp.new('/Disk/')
        + table.standardOptions.override.byRegexp.withPropertiesFromOptions(
          table.standardOptions.withUnit('decgbytes')
        ),
        table.fieldOverride.byRegexp.new('/Memory/')
        + table.standardOptions.override.byRegexp.withPropertiesFromOptions(
          table.standardOptions.withUnit('decmbytes')
        ),
      ])
      + table.queryOptions.withTransformationsMixin([
        {
          id: 'joinByField',
          options: {
            byField: 'instance',
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
            },
            indexByName: {
              instance: 0,
              '__name__ 1': 1,
              'resourcetype 1': 2,
              'Value #A': 3,
              'Value #B': 4,
              'Value #C': 5,
              'Value #D': 6,
              'Value #E': 7,
              'Value #F': 8,
              'Time 2': 9,
              '__name__ 2': 10,
              'hostname 2': 11,
              'job 2': 12,
              'resourcetype 2': 13,
              'Time 3': 14,
              '__name__ 3': 15,
              'hostname 3': 16,
              'job 3': 17,
              'resourcetype 3': 18,
              'Time 4': 19,
              '__name__ 4': 20,
              'hostname 4': 21,
              'job 4': 22,
              'resourcetype 4': 23,
              'Time 5': 24,
              '__name__ 5': 25,
              'hostname 5': 26,
              'job 5': 27,
              'resourcetype 5': 28,
              'Time 6': 29,
              '__name__ 6': 30,
              'hostname 6': 31,
              'job 6': 32,
              'resourcetype 6': 33,
              'Time 1': 34,
              'hostname 1': 35,
              'job 1': 36,
            },
            renameByName: {
              Time: '',
              'Value #A': 'Disk available',
              'Value #B': 'Disk used',
              'Value #C': 'Memory avaliable',
              'Value #D': 'Memory used',
              'Value #E': 'VCPUs available',
              'Value #F': 'VCPUs used',
              hostname: 'Hostname',
              instance: 'Instance',
              openstack_placement_resource_total: 'Total',
              openstack_placement_resource_usage: 'In use',
              resourcetype: 'Resource',
            },
            includeByName: {},
          },
        },
      ]),

    domains:
      commonlib.panels.generic.stat.base.new(
        'Domains',
        targets=[t.domains],
        description='The number of domains for the OpenStack cloud.',
      )
      + stat.options.withGraphMode('none'),

    projects:
      commonlib.panels.generic.stat.base.new(
        'Projects',
        targets=[t.projects],
        description='The number of projects for the OpenStack cloud.',
      )
      + stat.options.withGraphMode('none'),

    regions:
      commonlib.panels.generic.stat.base.new(
        'Regions',
        targets=[t.regions],
        description='The number of regions for the OpenStack cloud.',
      )
      + stat.options.withGraphMode('none'),

    users:
      commonlib.panels.generic.timeSeries.base.new(
        'Users',
        targets=[t.users],
        description='The number of users for the OpenStack cloud.',
      )
      + timeSeries.standardOptions.withDecimals(0),

    projectDetails:
      table.new('Project details')
      + table.queryOptions.withTargets([t.projectDetails])
      + table.queryOptions.withDatasource('prometheus', '${prometheus_datasource}')
      + table.panelOptions.withDescription('Details for the projects in the OpenStack cloud.')
      + table.standardOptions.withOverridesMixin([
        table.fieldOverride.byName.new('Enabled')
        + table.fieldOverride.byName.withProperty('custom.displayMode', 'color-text')
        + table.fieldOverride.byName.withPropertiesFromOptions(
          table.standardOptions.withMappings(
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
      + table.queryOptions.withTransformationsMixin([
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
      commonlib.panels.generic.timeSeries.base.new(
        'VMs',
        targets=[t.vms],
        description='The current number of total and running virtual machines.',
      )
      + timeSeries.standardOptions.withDecimals(0),

    instanceUsage:
      commonlib.panels.generic.timeSeries.percentage.new(
        'Instance usage',
        targets=[t.instanceUsage],
        description='Percentage of the maximum number of instances in use for each project.'
      )
      + timeSeries.standardOptions.withUnit('percentunit')
      + timeSeries.standardOptions.withMax(1)
      + timeSeries.standardOptions.withMin(0),

    vCPUUsage:
      commonlib.panels.generic.timeSeries.percentage.new(
        'VCPU usage',
        targets=[t.vCPUUsage],
        description='Percentage of the maximum number of virtual CPUs in use for each project.'
      )
      + timeSeries.standardOptions.withUnit('percentunit')
      + timeSeries.standardOptions.withMax(1)
      + timeSeries.standardOptions.withMin(0),

    memoryUsage:
      commonlib.panels.generic.timeSeries.percentage.new(
        'Memory usage',
        targets=[t.memoryUsage],
        description='Percentage of the maximum amount of memory in use for each project.'
      )
      + timeSeries.standardOptions.withUnit('percentunit')
      + timeSeries.standardOptions.withMax(1)
      + timeSeries.standardOptions.withMin(0),

    novaAgents:
      table.new('Agents')
      + table.queryOptions.withTargets([t.novaAgentState])
      + table.queryOptions.withDatasource('prometheus', '${prometheus_datasource}')
      + table.panelOptions.withDescription('Details for the agents for OpenStack Nova.')
      + table.standardOptions.withOverridesMixin([
        table.fieldOverride.byName.new('Admin state')
        + table.fieldOverride.byName.withProperty('custom.displayMode', 'color-text')
        + table.fieldOverride.byName.withPropertiesFromOptions(
          table.standardOptions.withMappings(
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
      + table.queryOptions.withTransformationsMixin([
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
      commonlib.panels.generic.timeSeries.base.new(
        'Networks',
        targets=[t.networks],
        description='The number of networks managed by Neutron.',
      )
      + timeSeries.standardOptions.withDecimals(0),

    subnets:
      commonlib.panels.generic.timeSeries.base.new(
        'Subnets',
        targets=[t.subnets],
        description='The number of networks managed by Neutron.'
      )
      + timeSeries.standardOptions.withDecimals(0),

    routers:
      commonlib.panels.generic.timeSeries.base.new(
        'Routers',
        targets=[t.routers, t.routersNotActive],
        description='The number of routers managed by Neutron.',
      )
      + timeSeries.standardOptions.withDecimals(0),

    routerDetails:
      table.new('Router details')
      + table.queryOptions.withTargets([t.routerDetails])
      + table.queryOptions.withDatasource('prometheus', '${prometheus_datasource}')
      + table.panelOptions.withDescription('Detailed view of the routers managed by Neutron.')
      + table.standardOptions.withOverridesMixin([
        table.fieldOverride.byRegexp.new('/Admin up|Status/')
        + table.fieldOverride.byRegexp.withProperty('custom.displayMode', 'color-text')
        + table.fieldOverride.byRegexp.withPropertiesFromOptions(
          table.standardOptions.withMappings(
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
      + table.queryOptions.withTransformationsMixin([
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
              Time: 7,
              Value: 10,
              __name__: 8,
              admin_state_up: 3,
              external_network_id: 4,
              id: 5,
              instance: 1,
              job: 9,
              name: 0,
              project_id: 6,
              status: 2,
            },
            renameByName: {
              Time: '',
              adminState: 'Admin state',
              admin_state_up: 'Admin up',
              external_network_id: 'External network ID',
              id: 'ID',
              instance: 'Instance',
              name: 'Name',
              project_id: 'Project ID',
              service: 'Service',
              status: 'Status',
              zone: 'Zone',
            },
          },
        },
      ]),

    ports:
      commonlib.panels.generic.timeSeries.base.new(
        'Ports',
        targets=[t.ports, t.portsLBNotActive, t.portsNoIPs],
        description='The number of routers managed by Neutron.',
      )
      + timeSeries.standardOptions.withDecimals(0),

    portDetails:
      table.new('Port details')
      + table.queryOptions.withTargets([t.portDetails])
      + table.queryOptions.withDatasource('prometheus', '${prometheus_datasource}')
      + table.panelOptions.withDescription('Detailed view of the ports managed by Neutron.')
      + table.standardOptions.withOverridesMixin([
        table.fieldOverride.byRegexp.new('/Admin up|Status/')
        + table.fieldOverride.byRegexp.withProperty('custom.displayMode', 'color-text')
        + table.fieldOverride.byRegexp.withPropertiesFromOptions(
          table.standardOptions.withMappings(
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
      + table.queryOptions.withTransformationsMixin([
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
            },
          },
        },
      ]),

    floatingIPs:
      commonlib.panels.generic.timeSeries.base.new(
        'Floating IPs',
        targets=[t.floatingIPs, t.floatingIPsAssociatedNotActive],
        description='The number of public IP addresses managed by Neutron.',
      )
      + timeSeries.standardOptions.withDecimals(0),

    ipsUsed:
      commonlib.panels.generic.timeSeries.percentage.new(
        'IPs used',
        targets=[t.ipsUsed],
        description='The usage of available IP addresses broken down by subnet.',
      )
      + timeSeries.standardOptions.withUnit('percentunit')
      + timeSeries.standardOptions.withDecimals(0)
      + timeSeries.options.legend.withPlacement('right')
      + timeSeries.standardOptions.withMax(1)
      + timeSeries.standardOptions.withMin(0),

    securityGroups:
      commonlib.panels.generic.timeSeries.base.new(
        'Security groups',
        targets=[t.securityGroups],
        description='The number of network security groups managed by Neutron.',
      )
      + timeSeries.standardOptions.withDecimals(0),

    neutronAgents:
      table.new('Agents')
      + table.queryOptions.withTargets([t.neutronAgentState])
      + table.queryOptions.withDatasource('prometheus', '${prometheus_datasource}')
      + table.panelOptions.withDescription('Details for the agents for OpenStack Neutron.')
      + table.standardOptions.withOverridesMixin([
        table.fieldOverride.byName.new('Admin state')
        + table.fieldOverride.byName.withProperty('custom.displayMode', 'color-text')
        + table.fieldOverride.byName.withPropertiesFromOptions(
          table.standardOptions.withMappings(
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
      + table.queryOptions.withTransformationsMixin([
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
      commonlib.panels.generic.timeSeries.base.new(
        'Volumes',
        targets=[t.volumes],
        description='The number of volumes managed by Cinder.',
      )
      + timeSeries.standardOptions.withDecimals(0),

    volumeStatus:
      commonlib.panels.generic.timeSeries.base.new(
        'Volume status',
        targets=[t.volumeErrorStatus, t.volumeNonErrorStatus],
        description='The current status of volumes in Cinder.',
      )
      + timeSeries.options.legend.withPlacement('right')
      + timeSeries.standardOptions.withDecimals(0),

    volumeUsage:
      commonlib.panels.generic.timeSeries.percentage.new(
        'Volume usage',
        targets=[t.volumeUsage],
        description='The percent of volume storage in use for Cinder.',
      )
      + timeSeries.standardOptions.withUnit('percentunit')
      + timeSeries.standardOptions.withMax(1)
      + timeSeries.standardOptions.withMin(0),

    backupUsage:
      commonlib.panels.generic.timeSeries.percentage.new(
        'Backup usage',
        targets=[t.backupUsage],
        description='The percent of backup storage in use for Cinder.',
      )
      + timeSeries.standardOptions.withUnit('percentunit')
      + timeSeries.standardOptions.withMax(1)
      + timeSeries.standardOptions.withMin(0),

    poolUsage:
      commonlib.panels.generic.timeSeries.percentage.new(
        'Pool usage',
        targets=[t.poolUsage],
        description='The percent of pool capacity in use for Cinder.',
      )
      + timeSeries.standardOptions.withUnit('percentunit')
      + timeSeries.standardOptions.withMax(1)
      + timeSeries.standardOptions.withMin(0),

    snapshots:
      commonlib.panels.generic.timeSeries.base.new(
        'Snapshots',
        targets=[t.snaphots],
        description='The number of volume snapshots in Cinder.',
      )
      + timeSeries.standardOptions.withDecimals(0),

    cinderAgents:
      table.new('Agents')
      + table.queryOptions.withTargets([t.cinderAgentState])
      + table.queryOptions.withDatasource('prometheus', '${prometheus_datasource}')
      + table.panelOptions.withDescription('Details for the agents for OpenStack Cinder.')
      + table.fieldConfig.defaults.custom.withCellOptions('color-text')
      + table.standardOptions.withOverridesMixin([
        table.fieldOverride.byName.new('Admin state')
        + table.fieldOverride.byName.withProperty('custom.displayMode', 'color-text')
        + table.fieldOverride.byName.withPropertiesFromOptions(
          table.standardOptions.withMappings(
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
      + table.queryOptions.withTransformationsMixin([
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
            },
          },
        },
      ]),

    imageCount:
      commonlib.panels.generic.timeSeries.base.new(
        'Image count',
        targets=[t.imageCount],
        description='The number of images present in Glance.',
      )
      + timeSeries.standardOptions.withDecimals(0),

    images:
      table.new('Images')
      + table.queryOptions.withTargets([t.imageDetails])
      + table.queryOptions.withDatasource('prometheus', '${prometheus_datasource}')
      + table.panelOptions.withDescription('Details for the images in Glance.')
      + table.standardOptions.withOverridesMixin([
        table.fieldOverride.byName.new('Size')
        + table.standardOptions.override.byName.withPropertiesFromOptions(
          table.standardOptions.withUnit('decbytes')
        ),
      ])
      + table.queryOptions.withTransformationsMixin([
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
            },
          },
        },
      ]),
  },
}
