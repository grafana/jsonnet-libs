local commonlib = import 'common-lib/common/main.libsonnet';
function(this)
  {
    local s = self,
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: [],
    aggLevel: 'instance',
    discoveryMetric: {
      azuremonitor: 'azure_microsoft_compute_virtualmachines_vmavailabilitymetric_average_count',
    },
    signals: {
      instanceCount: {
        name: 'Instance count',
        description: 'Number of VM instances',
        type: 'raw',
        unit: 'short',
        sources: {
          azuremonitor: {
            expr: 'count(sum by (resourceName) (azure_microsoft_compute_virtualmachines_vmavailabilitymetric_average_count{%(queriesSelector)s}))',
            legendCustomTemplate: '',
          },
        },
      },

      vmAvailability: {
        name: 'VM Availability',
        description: 'Measure of Availability of Virtual machines',
        type: 'raw',
        unit: 'short',
        sources: {
          azuremonitor: {
            expr: 'avg by(resourceName) (azure_microsoft_compute_virtualmachines_vmavailabilitymetric_average_count{%(queriesSelector)s})',
            legendCustomTemplate: '',
          },
        },
      },
      top5CpuUtilization: {
        name: 'Top 5 Instances - CPU utilitization',
        description: 'Fractional utilization of allocated CPU on an instance',
        type: 'gauge',
        aggFunction: 'sum',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_compute_virtualmachines_percentage_cpu_average_percent{%(queriesSelector)s}',
            legendCustomTemplate: '',
            aggKeepLabels: ['resourceName'],
            exprWrappers: [['topk(5,', ')']],
          },
        },
      },

      bottom5MemoryAvailable: {
        name: 'Top 5 Instances - Less available memory',
        description: 'List of top 5 Instances with less amount of physical memory immediately available for allocation.',
        type: 'gauge',
        unit: 'decbytes',
        aggFunction: 'avg',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_compute_virtualmachines_available_memory_bytes_average_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '',
            aggKeepLabels: ['resourceName'],
            exprWrappers: [['bottomk(5,', ')']],
          },
        },
      },

      top5DiskRead: {
        name: 'Top 5 Instances - Disk read bytes',
        description: 'List of top 5 Instances by disk read bytes',
        type: 'gauge',
        unit: 'decbytes',
        aggFunction: 'sum',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_compute_virtualmachines_disk_read_bytes_total_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '',
            aggKeepLabels: ['resourceName'],
            exprWrappers: [['topk(5,', ')']],
          },
        },
      },

      top5DiskWrite: {
        name: 'Top 5 Instances - Disk write bytes',
        description: 'List of top 5 Instances by disk write bytes',
        type: 'gauge',
        unit: 'decbytes',
        aggFunction: 'sum',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_compute_virtualmachines_disk_write_bytes_total_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '',
            aggKeepLabels: ['resourceName'],
            exprWrappers: [['topk(5,', ')']],
          },
        },
      },

      diskReadBytes: {
        name: 'Disk bytes (total)',
        description: 'Bytes read/written from/to disk during monitoring period',
        type: 'counter',
        unit: 'decbytes',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_compute_virtualmachines_disk_read_bytes_total_bytes{%(queriesSelector)s}',
            legendCustomTemplate: 'Read',
            exprWrappers: [['avg(', ')']],
          },
        },
      },

      diskWriteBytes: {
        name: 'Disk write bytes',
        description: 'Bytes written to disk during monitoring period',
        type: 'counter',
        unit: 'decbytes',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_compute_virtualmachines_disk_write_bytes_total_bytes{%(queriesSelector)s}',
            legendCustomTemplate: 'Write',
            exprWrappers: [['avg(', ')']],
          },
        },
      },

      diskReadOperations: {
        name: 'Disk Operations/Sec (average)',
        description: 'Disk Read/Write IOPS',
        type: 'counter',
        unit: 'cps',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_compute_virtualmachines_disk_read_operations_sec_average_countpersecond{%(queriesSelector)s}',
            legendCustomTemplate: 'Read',
            exprWrappers: [['avg(', ')']],
          },
        },
      },

      diskWriteOperations: {
        name: 'Disk Write Operations',
        description: 'Disk Write IOPS',
        type: 'counter',
        unit: 'cps',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_compute_virtualmachines_disk_write_operations_sec_average_countpersecond{%(queriesSelector)s}',
            legendCustomTemplate: 'Write',
            exprWrappers: [['avg(', ')']],
          },
        },
      },

      networkInTotal: {
        name: 'Network throughput send/received',
        description: 'The number of bytes sent/received over the network.',
        type: 'counter',
        unit: 'decbytes',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_compute_virtualmachines_network_in_total_total_bytes{%(queriesSelector)s}',
            legendCustomTemplate: 'Received',
            exprWrappers: [['avg(', ')']],
          },
        },
      },

      networkOutTotal: {
        name: 'Network throughput sent',
        description: 'The number of bytes sent over the network.',
        type: 'counter',
        unit: 'decbytes',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_compute_virtualmachines_network_out_total_total_bytes{%(queriesSelector)s}',
            legendCustomTemplate: 'Sent',
            exprWrappers: [['avg(', ')']],
          },
        },
      },

      inboundFlows: {
        name: 'Connections',
        description: 'Number of current flows in the inbound/outbound direction',
        type: 'counter',
        unit: 'cps',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_compute_virtualmachines_inbound_flows_average_count{%(queriesSelector)s}',
            legendCustomTemplate: 'In',
            exprWrappers: [['avg(', ')']],
          },
        },
      },

      outboundFlows: {
        name: 'Outbound connections',
        description: 'Number of current flows in the outbound direction',
        type: 'counter',
        unit: 'cps',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_compute_virtualmachines_outbound_flows_average_count{%(queriesSelector)s}',
            legendCustomTemplate: 'Out',
            exprWrappers: [['avg(', ')']],
          },
        },
      },
    },
  }
