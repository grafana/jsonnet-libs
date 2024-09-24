local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(this): {
    // Azure Virtual Machines

    avm_instance_count:
      this.signals.azurevmOverview.instanceCount.asStat()
      + commonlib.panels.generic.stat.base.stylize(),

    avm_availability:
      this.signals.azurevmOverview.vmAvailability.asTable(format='table')
      + commonlib.panels.generic.table.base.stylize()
      + g.panel.table.standardOptions.withOverrides([
        {
          matcher: {
            id: 'byName',
            options: 'Value',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Status',
            },
            {
              id: 'mappings',
              value: [
                {
                  options: {
                    '0': {
                      color: 'red',
                      index: 1,
                      text: 'Not Available',
                    },
                    '1': {
                      color: 'green',
                      index: 0,
                      text: 'Available',
                    },
                  },
                  type: 'value',
                },
              ],
            },
            {
              id: 'custom.cellOptions',
              value: {
                type: 'color-background',
              },
            },
            {
              id: 'custom.width',
              value: 150,
            },
            {
              id: 'custom.align',
              value: 'center',
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Time',
          },
          properties: [
            {
              id: 'custom.hidden',
              value: true,
            },
          ],
        },
      ])
      + g.panel.table.queryOptions.withTransformations([
        {
          id: 'organize',
          options: {
            excludeByName: {
              Time: true,
              job: true,
              resourceGroup: true,
              subscriptionName: true,
            },
            includeByName: {},
            indexByName: {},
            renameByName: {
              resourceName: 'Instance',
            },
          },
        },
      ]),

    avm_cpu_utilization:
      this.signals.azurevm.cpuUtilization.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withNoValue('0'),

    avm_available_memory:
      this.signals.azurevm.availableMemory.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withNoValue('0'),

    avm_cpu_credits_consumed:
      this.signals.azurevm.cpuCreditsConsumed.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withNoValue('0'),

    avm_cpu_credits_remaining:
      this.signals.azurevm.cpuCreditsRemaining.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withNoValue('0'),

    avm_disk_total_bytes:
      this.signals.azurevmOverview.diskReadBytes.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + this.signals.azurevmOverview.diskWriteBytes.asPanelMixin()
      + g.panel.timeSeries.standardOptions.withNoValue('0'),

    avm_disk_operations:
      this.signals.azurevmOverview.diskReadOperations.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + this.signals.azurevmOverview.diskWriteOperations.asPanelMixin()
      + g.panel.timeSeries.standardOptions.withNoValue('0'),

    avm_network_total:
      this.signals.azurevmOverview.networkInTotal.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + this.signals.azurevmOverview.networkOutTotal.asPanelMixin(),

    avm_connections:
      this.signals.azurevmOverview.inboundFlows.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + this.signals.azurevmOverview.outboundFlows.asPanelMixin(),

    avm_network_in_by_instance:
      this.signals.azurevm.networkInByVM.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),

    avm_network_out_by_instance:
      this.signals.azurevm.networkOutByVM.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),

    avm_disk_read_by_instance:
      this.signals.azurevm.diskReadByVM.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withNoValue('0'),

    avm_disk_write_by_instance:
      this.signals.azurevm.diskWriteByVM.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withNoValue('0'),

    avm_disk_read_operations_by_instance:
      this.signals.azurevm.diskReadOperationsByVM.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withNoValue('0'),

    avm_disk_write_operations_by_instance:
      this.signals.azurevm.diskWriteOperationsByVM.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withNoValue('0'),

    avm_top5_cpu_utilization:
      this.signals.azurevmOverview.top5CpuUtilization.asTable(format='table')
      + commonlib.panels.generic.table.base.stylize()
      + g.panel.table.standardOptions.withOverrides([
        {
          matcher: {
            id: 'byName',
            options: 'Value',
          },
          properties: [
            {
              id: 'custom.width',
              value: 100,
            },
            {
              id: 'unit',
              value: 'percent',
            },
            {
              id: 'custom.cellOptions',
              value: {
                mode: 'gradient',
                type: 'gauge',
                valueDisplayMode: 'text',
              },
            },
            {
              id: 'thresholds',
              value: {
                mode: 'absolute',
                steps: [
                  {
                    color: 'green',
                    value: null,
                  },
                  {
                    color: 'orange',
                    value: 70,
                  },
                  {
                    color: 'red',
                    value: 90,
                  },
                ],
              },
            },
            {
              id: 'decimals',
              value: 2,
            },
            {
              id: 'min',
              value: 0,
            },
            {
              id: 'max',
              value: 100,
            },
          ],
        },
      ])
      + g.panel.table.queryOptions.withTransformations([
        {
          id: 'organize',
          options: {
            excludeByName: {
              Time: true,
              job: false,
              subscriptionName: true,
            },
            indexByName: {
              Time: 1,
              Value: 4,
              job: 2,
              resourceGroup: 3,
              resourceName: 0,
            },
            renameByName: {
              job: 'Job',
              resourceGroup: 'Group',
              resourceName: 'Instance',
            },
          },
        },
      ]),

    avm_bottom5_memory_available:
      this.signals.azurevmOverview.bottom5MemoryAvailable.asTable(format='table')
      + commonlib.panels.generic.table.base.stylize()
      + g.panel.table.standardOptions.withUnit('decbytes')
      + g.panel.table.queryOptions.withTransformations([
        {
          id: 'organize',
          options: {
            excludeByName: {
              Time: true,
              subscriptionName: true,
              resourceGroup: false,
            },
            indexByName: {
              resourceName: 0,
              Time: 1,
              job: 2,
              resourceGroup: 3,
              subscriptionName: 4,
              Value: 5,
            },
            renameByName: {
              Value: '',
              resourceGroup: 'Group',
              job: 'Job',
              resourceName: 'Instance',
            },
            includeByName: {},
          },
        },
      ]),

    avm_top5_disk_read:
      this.signals.azurevmOverview.top5DiskRead.asTable(format='table')
      + commonlib.panels.generic.table.base.stylize()
      + g.panel.table.standardOptions.withUnit('decbytes')
      + g.panel.table.standardOptions.withOverrides([
        {
          matcher: {
            id: 'byName',
            options: 'Value',
          },
          properties: [
            {
              id: 'custom.width',
              value: 100,
            },
          ],
        },
      ])
      + g.panel.table.queryOptions.withTransformations([
        {
          id: 'organize',
          options: {
            excludeByName: {
              Time: true,
              job: false,
              subscriptionName: true,
            },
            indexByName: {
              Time: 1,
              Value: 4,
              job: 2,
              resourceGroup: 3,
              resourceName: 0,
            },
            renameByName: {
              job: 'Job',
              resourceGroup: 'Group',
              resourceName: 'Instance',
            },
          },
        },
      ]),

    avm_top5_disk_write:
      this.signals.azurevmOverview.top5DiskWrite.asTable(format='table')
      + commonlib.panels.generic.table.base.stylize()
      + g.panel.table.standardOptions.withUnit('decbytes')
      + g.panel.table.standardOptions.withOverrides([
        {
          matcher: {
            id: 'byName',
            options: 'Value',
          },
          properties: [
            {
              id: 'custom.width',
              value: 100,
            },
          ],
        },
      ])
      + g.panel.table.queryOptions.withTransformations([
        {
          id: 'organize',
          options: {
            excludeByName: {
              Time: true,
              job: false,
              subscriptionName: true,
            },
            indexByName: {
              Time: 1,
              Value: 4,
              job: 2,
              resourceGroup: 3,
              resourceName: 0,
            },
            renameByName: {
              job: 'Job',
              resourceGroup: 'Group',
              resourceName: 'Instance',
            },
          },
        },
      ]),

    avm_instances_table:
      this.signals.azurevm.cpuUtilization.asTable(name='Instances', format='table')
      + this.signals.azurevm.availableMemory.asTableColumn(format='table')
      + this.signals.azurevm.diskReadByVM.asTableColumn(format='table')
      + this.signals.azurevm.diskWriteByVM.asTableColumn(format='table')
      + this.signals.azurevm.networkInByVM.asTableColumn(format='table')
      + this.signals.azurevm.networkOutByVM.asTableColumn(format='table')
      + g.panel.table.standardOptions.withOverrides([
        {
          matcher: {
            id: 'byName',
            options: 'Value #CPU Utilization average',
          },
          properties: [
            {
              id: 'custom.cellOptions',
              value: {
                type: 'gauge',
              },
            },
            {
              id: 'unit',
              value: 'percent',
            },
            {
              id: 'min',
              value: 0,
            },
            {
              id: 'max',
              value: 100,
            },
            {
              id: 'thresholds',
              value: {
                mode: 'absolute',
                steps: [
                  {
                    color: 'green',
                    value: null,
                  },
                  {
                    color: 'orange',
                    value: 70,
                  },
                  {
                    color: 'red',
                    value: 90,
                  },
                ],
              },
            },
            {
              id: 'decimals',
              value: 2,
            },
            {
              id: 'displayName',
              value: 'Cpu utilization',
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Value #Available memory',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Available memory',
            },
            {
              id: 'unit',
              value: 'decbytes',
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Value #Disk read bytes (total)',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Disk read bytes',
            },
            {
              id: 'unit',
              value: 'decbytes',
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Value #Disk write bytes (total)',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Disk write bytes',
            },
            {
              id: 'unit',
              value: 'decbytes',
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Time',
          },
          properties: [
            {
              id: 'custom.hidden',
              value: true,
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'resourceName',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Instance',
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Value #Network throughput received',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Network received',
            },
            {
              id: 'unit',
              value: 'decbytes',
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Value #Network throughput sent',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Network sent',
            },
            {
              id: 'unit',
              value: 'decbytes',
            },
          ],
        },
      ])
      + g.panel.table.queryOptions.withTransformations([
        {
          id: 'merge',
          options: {},
        },
        {
          id: 'organize',
          options: {
            excludeByName: {},
            includeByName: {},
            indexByName: {
              Time: 0,
              'Value #CPU Utilization average': 5,
              'Value #Available memory': 6,
              'Value #Disk read bytes (total)': 7,
              'Value #Disk write bytes (total)': 8,
              'Value #Network throughput received': 9,
              'Value #Network throughput sent': 10,
              job: 2,
              resourceGroup: 3,
              resourceName: 1,
              subscriptionName: 4,
            },
            renameByName: {
              job: 'Job',
              resourceGroup: 'Group',
              resourceName: 'Instance',
              subscriptionName: 'Subscription',
            },
          },
        },
      ]),

    avm_text_instances:
      g.panel.text.new('Instances')
      + g.panel.text.options.withContent('Use this section to look at one instance at a time by picking a value in the *ResourceName* picker at the top of the dashboard.'),
  },
}
