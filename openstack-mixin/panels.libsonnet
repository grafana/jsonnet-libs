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
    local gauge = g.panel.gauge,

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
      + table.fieldConfig.defaults.custom.withAlign('center')
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
              'Value #A': 1,
              'Value #B': 2,
              'Value #C': 3,
              'Value #D': 4,
              'Value #E': 5,
              'Value #F': 6,
              Time: 7,
              'cluster 2': 8,
              'cluster 3': 9,
              'cluster 4': 10,
              'cluster 5': 11,
              'cluster 6': 12,
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
              'cluster 1': 'cluster',
            },
            includeByName: {},
          },
        },
        {
          id: 'filterFieldsByName',
          options: {
            include: {
              pattern: 'Disk.*|Memory.*|VCPU.*|cluster',
            },
          },
        },
      ]),

    vCPUusedStat:
      gauge.new(
        'vCPU used'
      )
      + gauge.queryOptions.withTargetsMixin(t.vCPUused)
      + gauge.standardOptions.withUnit('percent')
      + gauge.standardOptions.withMin('0')
      + gauge.standardOptions.withMax('150')
      + gauge.standardOptions.thresholds.withSteps([
        gauge.standardOptions.threshold.step.withValue(0) +
        gauge.standardOptions.threshold.step.withColor('green'),
        gauge.standardOptions.threshold.step.withValue(99) +
        gauge.standardOptions.threshold.step.withColor('red'),
      ]),

    RAMusedStat:
      gauge.new(
        'Memory used'
      )
      + gauge.queryOptions.withTargetsMixin(t.RAMused)
      + gauge.standardOptions.withUnit('percent')
      + gauge.standardOptions.withMin('0')
      + gauge.standardOptions.withMax('150')
      + gauge.standardOptions.thresholds.withSteps([
        gauge.standardOptions.threshold.step.withValue(0) +
        gauge.standardOptions.threshold.step.withColor('green'),
        gauge.standardOptions.threshold.step.withValue(99) +
        gauge.standardOptions.threshold.step.withColor('red'),
      ]),

    freeIPsStat:
      stat.new(
        'Free IPs',
      )
      + stat.queryOptions.withTargetsMixin(t.freeIPs)
      + stat.standardOptions.thresholds.withSteps([
        stat.standardOptions.threshold.step.withValue(0) +
        stat.standardOptions.threshold.step.withColor('red'),
        stat.standardOptions.threshold.step.withValue(20) +
        stat.standardOptions.threshold.step.withColor('green'),
      ]),

    domains:
      commonlib.panels.generic.stat.info.new(
        'Domains',
        targets=[t.domains],
        description='The number of domains for the OpenStack cloud.',
      )
      + stat.options.withGraphMode('none'),

    projects:
      commonlib.panels.generic.stat.info.new(
        'Projects',
        targets=[t.projects],
        description='The number of projects for the OpenStack cloud.',
      )
      + stat.options.withGraphMode('none'),

    regions:
      commonlib.panels.generic.stat.info.new(
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
      + table.fieldConfig.defaults.custom.withAlign('center')
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
      commonlib.panels.generic.timeSeries.base.new(
        'Instance count',
        targets=[t.instanceUsage],
        description='Number of instances in use for each project.'
      )
      + timeSeries.standardOptions.withUnit('short')
      + timeSeries.options.legend.withPlacement('right')
      + timeSeries.options.legend.withCalcs('lastNotNull')
      + timeSeries.options.legend.withDisplayMode('table')
      + timeSeries.options.legend.withSortBy('Last *')
      + timeSeries.options.legend.withSortDesc(true)
      + timeSeries.fieldConfig.defaults.custom.withLineWidth('1'),

    vCPUUsage:
      commonlib.panels.generic.timeSeries.base.new(
        'VCPU usage',
        targets=[t.vCPUUsage],
        description='Number of virtual CPUs in use for each project.'
      )
      + timeSeries.standardOptions.withUnit('short')
      + timeSeries.options.legend.withPlacement('right')
      + timeSeries.options.legend.withCalcs('lastNotNull')
      + timeSeries.options.legend.withDisplayMode('table')
      + timeSeries.options.legend.withSortBy('Last *')
      + timeSeries.options.legend.withSortDesc(true)
      + timeSeries.fieldConfig.defaults.custom.withLineWidth('1'),

    memoryUsage:
      commonlib.panels.generic.timeSeries.base.new(
        'Memory usage',
        targets=[t.memoryUsage],
        description='Maximum amount of memory in use for each project.'
      )
      + timeSeries.standardOptions.withUnit('bytes')
      + timeSeries.options.legend.withPlacement('right')
      + timeSeries.options.legend.withCalcs('lastNotNull')
      + timeSeries.options.legend.withDisplayMode('table')
      + timeSeries.options.legend.withSortBy('Last *')
      + timeSeries.options.legend.withSortDesc(true)
      + timeSeries.fieldConfig.defaults.custom.withLineWidth('1'),

    novaAgents:
      table.new('Agents')
      + table.queryOptions.withTargets([t.novaAgentState])
      + table.queryOptions.withDatasource('prometheus', '${prometheus_datasource}')
      + table.panelOptions.withDescription('Details for the agents for OpenStack Nova.')
      + table.fieldConfig.defaults.custom.withAlign('center')
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
      + table.fieldConfig.defaults.custom.withAlign('center')
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
      + table.fieldConfig.defaults.custom.withAlign('center')
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
      commonlib.panels.generic.timeSeries.base.new(
        'Floating IPs',
        targets=[t.floatingIPs, t.floatingIPsAssociatedNotActive],
        description='The number of public IP addresses managed by Neutron.',
      )
      + timeSeries.standardOptions.withDecimals(0),

    ipsUsed:
      commonlib.panels.generic.timeSeries.base.new(
        'IPs used',
        targets=[t.ipsUsed],
        description='The usage of available IP addresses broken down by subnet.',
      )
      + timeSeries.standardOptions.withUnit('percentunit')
      + timeSeries.options.legend.withPlacement('right')
      + timeSeries.options.legend.withCalcs('lastNotNull')
      + timeSeries.options.legend.withDisplayMode('table')
      + timeSeries.options.legend.withSortBy('Last *')
      + timeSeries.options.legend.withSortDesc(true)
      + timeSeries.fieldConfig.defaults.custom.withLineWidth('1'),

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
      + table.fieldConfig.defaults.custom.withAlign('center')
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
      + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
        group: 'A',
        mode: 'normal',
      })
      + timeSeries.standardOptions.withDecimals(0),

    volumeUsage:
      commonlib.panels.generic.timeSeries.base.new(
        'Volume usage in GB',
        targets=[t.volumeUsage],
        description='Volume storage usage in bytes in use for Cinder.',
      )
      + timeSeries.standardOptions.withUnit('decgbytes')
      + timeSeries.options.legend.withPlacement('right')
      + timeSeries.options.legend.withCalcs('lastNotNull')
      + timeSeries.options.legend.withDisplayMode('table')
      + timeSeries.options.legend.withSortBy('Last *')
      + timeSeries.options.legend.withSortDesc(true)
      + timeSeries.fieldConfig.defaults.custom.withLineWidth('1'),

    backupUsage:
      commonlib.panels.generic.timeSeries.base.new(
        'Backup usage in GB',
        targets=[t.backupUsage],
        description='Backup storage usage in bytes in use for Cinder.',
      )
      + timeSeries.standardOptions.withUnit('decgbytes')
      + timeSeries.options.legend.withPlacement('right')
      + timeSeries.options.legend.withCalcs('lastNotNull')
      + timeSeries.options.legend.withDisplayMode('table')
      + timeSeries.options.legend.withSortBy('Last *')
      + timeSeries.options.legend.withSortDesc(true)
      + timeSeries.fieldConfig.defaults.custom.withLineWidth('1'),

    poolUsage:
      commonlib.panels.generic.timeSeries.base.new(
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
      + table.fieldConfig.defaults.custom.withAlign('center')
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
      + table.fieldConfig.defaults.custom.withAlign('center')
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
