local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(this): {
    gce_instance_count:
      this.signals.gcpceOverview.instanceCount.asStat()
      + g.panel.stat.standardOptions.color.withMode('fixed')
      + g.panel.stat.standardOptions.color.withFixedColor('text')
      + g.panel.table.standardOptions.withOverrides([
        {
          matcher: {
            id: 'byFrameRefID',
            options: 'Instance count',
          },
          properties: [
            {
              id: 'mappings',
              value: [],
            },
            {
              id: 'unit',
              value: 'short',
            },
          ],
        },
      ]),
    gce_system_problem_count:
      this.signals.gcpceOverview.systemProblemCount.asStat()
      + g.panel.stat.standardOptions.color.withMode('fixed')
      + g.panel.stat.standardOptions.color.withFixedColor('text')
      + g.panel.table.standardOptions.withOverrides([
        {
          matcher: {
            id: 'byFrameRefID',
            options: 'System problem count',
          },
          properties: [
            {
              id: 'mappings',
              value: [],
            },
            {
              id: 'unit',
              value: 'short',
            },
          ],
        },
      ]),
    gce_top5_cpu_utilization:
      this.signals.gcpceOverview.top5CpuUtilization.asTable(format='table')
      + g.panel.table.standardOptions.withOverrides([
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
            options: 'instance_name',
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
            options: 'job',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Job',
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'project_id',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Project ID',
            },
          ],
        },
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
                mode: 'basic',
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
                    color: 'yellow',
                    value: null,
                  },
                  {
                    color: 'green',
                    value: 30,
                  },
                  {
                    color: 'red',
                    value: 85,
                  },
                ],
              },
            },
          ],
        },
      ]),
    gce_top5_system_problem:
      this.signals.gcpceOverview.top5SystemProblem.asTable(format='table')
      + g.panel.table.standardOptions.withOverrides([
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
            options: 'instance_name',
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
            options: 'job',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Job',
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'project_id',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Project ID',
            },
          ],
        },
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
      ]),
    gce_top5_disk_read_bytes:
      this.signals.gcpceOverview.top5DiskRead.asTable(format='table')
      + g.panel.table.standardOptions.withUnit('bytes')
      + g.panel.table.standardOptions.withOverrides([
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
            options: 'instance_name',
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
            options: 'job',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Job',
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'project_id',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Project ID',
            },
          ],
        },
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
      ]),
    gce_top5_disk_write_bytes:
      this.signals.gcpceOverview.top5DiskWrite.asTable(format='table')
      + g.panel.table.standardOptions.withUnit('bytes')
      + g.panel.table.standardOptions.withOverrides([
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
            options: 'instance_name',
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
            options: 'job',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Job',
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'project_id',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Project ID',
            },
          ],
        },
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
      ]),

    gce_instances:
      g.panel.table.new('Instances')
      + g.panel.table.queryOptions.withTargets(
        [
          this.signals.gcpceOverview.tableCpuUtilization.asTarget()
          + g.query.prometheus.withInstant(true)
          + g.query.prometheus.withFormat('table'),
          this.signals.gcpceOverview.tableUptime.asTarget()
          + g.query.prometheus.withInstant(true)
          + g.query.prometheus.withFormat('table'),
          this.signals.gcpceOverview.tableSentPackets.asTarget()
          + g.query.prometheus.withInstant(true)
          + g.query.prometheus.withFormat('table'),
          this.signals.gcpceOverview.tableReceivedPackets.asTarget()
          + g.query.prometheus.withInstant(true)
          + g.query.prometheus.withFormat('table'),
          this.signals.gcpceOverview.tableNetworkSentBytes.asTarget()
          + g.query.prometheus.withInstant(true)
          + g.query.prometheus.withFormat('table'),
          this.signals.gcpceOverview.tableNetworkReceivedBytes.asTarget()
          + g.query.prometheus.withInstant(true)
          + g.query.prometheus.withFormat('table'),
          this.signals.gcpceOverview.tableDiskReadBytes.asTarget()
          + g.query.prometheus.withInstant(true)
          + g.query.prometheus.withFormat('table'),
          this.signals.gcpceOverview.tableDiskWriteBytes.asTarget()
          + g.query.prometheus.withInstant(true)
          + g.query.prometheus.withFormat('table'),
        ]
      )
      + g.panel.table.standardOptions.withOverrides([
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
            options: 'instance_name',
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
            options: 'job',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Job',
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'project_id',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Project ID',
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Value #tableCpuUtilization',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Cpu utilization',
            },
            {
              id: 'unit',
              value: 'percent',
            },
            {
              id: 'custom.width',
              value: 100,
            },
            {
              id: 'custom.cellOptions',
              value: {
                mode: 'basic',
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
                    color: 'yellow',
                    value: null,
                  },
                  {
                    color: 'green',
                    value: 30,
                  },
                  {
                    color: 'red',
                    value: 85,
                  },
                ],
              },
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Value #tableUptime',
          },
          properties: [
            {
              id: 'unit',
              value: 's',
            },
            {
              id: 'displayName',
              value: 'Uptime',
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Value #tableSentPackets',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Sent packets [5m]',
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Value #tableReceivedPackets',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Received packets [5m]',
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Value #tableNetworkSentBytes',
          },
          properties: [
            {
              id: 'unit',
              value: 'decbytes',
            },
            {
              id: 'displayName',
              value: 'Network sent [5m]',
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Value #tableNetworkReceivedBytes',
          },
          properties: [
            {
              id: 'unit',
              value: 'decbytes',
            },
            {
              id: 'displayName',
              value: 'Network received [5m]',
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Value #tableDiskReadBytes',
          },
          properties: [
            {
              id: 'unit',
              value: 'decbytes',
            },
            {
              id: 'displayName',
              value: 'Disk read bytes [5m]',
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Value #tableDiskWriteBytes',
          },
          properties: [
            {
              id: 'unit',
              value: 'decbytes',
            },
            {
              id: 'displayName',
              value: 'Disk write bytes [5m]',
            },
          ],
        },
      ])
      + g.panel.table.queryOptions.withTransformations([
        {
          id: 'merge',
          options: {},
        },
      ]),

    gce_memory_utilization:
      this.signals.gcpceOverview.memoryUtilization.asTimeSeries()
      + this.signals.gcpceOverview.memoryUsed.asPanelMixin(),
    gce_total_packets_sent_received:
      this.signals.gcpceOverview.packetsSent.asTimeSeries()
      + this.signals.gcpceOverview.packetsReceived.asPanelMixin(),
    gce_network_send_received:
      this.signals.gcpceOverview.networkSent.asTimeSeries()
      + this.signals.gcpceOverview.networkReceived.asPanelMixin(),
    gce_bytes_read_write:
      this.signals.gcpceOverview.diskBytesRead.asTimeSeries()
      + this.signals.gcpceOverview.diskBytesWrite.asPanelMixin(),

    gce_text_instances:
      g.panel.text.new('Instances')
      + g.panel.text.options.withContent('Use this section to look at one instance at a time by picking a value in the *Instance* picker at the top of the dashboard.'),
    gce_cpu_utilization:
      this.signals.gcpce.cpuUtilization.asTimeSeries(),
    gce_cpu_usage_time:
      this.signals.gcpce.cpuUsageTime.asTimeSeries(),
    gce_network_received:
      this.signals.gcpce.networkReceived.asTimeSeries(),
    gce_network_sent:
      this.signals.gcpce.networkSent.asTimeSeries(),
    gce_count_disk_read_bytes:
      this.signals.gcpce.diskReadBytes.asTimeSeries(),
    gce_count_disk_write_bytes:
      this.signals.gcpce.diskWriteBytes.asTimeSeries(),
    gce_count_disk_read_operations:
      this.signals.gcpce.diskReadOperations.asTimeSeries(),
    gce_count_disk_write_operations:
      this.signals.gcpce.diskWriteOperations.asTimeSeries(),
  },
}
