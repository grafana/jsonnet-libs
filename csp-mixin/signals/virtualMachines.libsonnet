local commonlib = import 'common-lib/common/main.libsonnet';
function(this)
  {
    local s = self,
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
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
            expr: 'azure_microsoft_compute_virtualmachines_vmavailabilitymetric_average_count{%(queriesSelector)s}',
            legendCustomTemplate: '{{resourceName}}',
          },
        },
      },
      cpuUtilization: {
        name: 'CPU Utilization average',
        description: 'The percentage of allocated compute units that are currently in use by the Virtual Machine(s)',
        type: 'raw',
        unit: 'percent',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_compute_virtualmachines_percentage_cpu_average_percent{%(queriesSelector)s}',
            legendCustomTemplate: '{{resourceName}}',
          },
        },
      },

      availableMemory: {
        name: 'Available memory',
        description: 'Amount of physical memory, in bytes, immediately available for allocation to a process or for system use in the Virtual Machine',
        type: 'raw',
        unit: 'decbytes',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_compute_virtualmachines_available_memory_bytes_average_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '{{resourceName}}',
          },
        },
      },
      cpuCreditsConsumed: {
        name: 'CPU Credits Consumed',
        description: 'Total number of credits consumed by the Virtual Machine.',
        type: 'raw',
        unit: 'short',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_compute_virtualmachines_cpu_credits_consumed_average_count{%(queriesSelector)s}',
            legendCustomTemplate: '{{resourceName}}',
          },
        },
      },
      cpuCreditsRemaining: {
        name: 'CPU Credits Remaining',
        description: 'Total number of credits available to burst.',
        type: 'raw',
        unit: 'short',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_compute_virtualmachines_cpu_credits_remaining_average_count{%(queriesSelector)s}',
            legendCustomTemplate: '{{resourceName}}',
          },
        },
      },
      diskReadBytes: {
        name: 'Disk bytes (total)',
        description: 'Bytes read/written from/to disk during monitoring period',
        type: 'raw',
        unit: 'decbytes',
        sources: {
          azuremonitor: {
            expr: 'sum(rate(azure_microsoft_compute_virtualmachines_disk_read_bytes_total_bytes{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: 'Read',
          },
        },
      },

      diskWriteBytes: {
        name: 'Disk write bytes',
        description: 'Bytes written to disk during monitoring period',
        type: 'raw',
        unit: 'decbytes',
        sources: {
          azuremonitor: {
            expr: 'sum(rate(azure_microsoft_compute_virtualmachines_disk_write_bytes_total_bytes{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: 'Write',
          },
        },
      },

      diskReadOperations: {
        name: 'Disk Operations/Sec (average)',
        description: 'Disk Read/Write IOPS',
        type: 'raw',
        unit: 'cps',
        sources: {
          azuremonitor: {
            expr: 'sum(rate(azure_microsoft_compute_virtualmachines_disk_read_operations_sec_average_countpersecond{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: 'Read',
          },
        },
      },

      diskWriteOperations: {
        name: 'Disk Write Operations',
        description: 'Disk Write IOPS',
        type: 'raw',
        unit: 'cps',
        sources: {
          azuremonitor: {
            expr: 'sum(rate(azure_microsoft_compute_virtualmachines_disk_write_operations_sec_average_countpersecond{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: 'Write',
          },
        },
      },

      networkInTotal: {
        name: 'Network throughput send/received',
        description: 'The number of bytes sent/received over the network.',
        type: 'raw',
        unit: 'decbytes',
        sources: {
          azuremonitor: {
            expr: 'sum(rate(azure_microsoft_compute_virtualmachines_network_in_total_total_bytes{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: 'Received',
          },
        },
      },

      networkOutTotal: {
        name: 'Network throughput sent',
        description: 'The number of bytes sent over the network.',
        type: 'raw',
        unit: 'decbytes',
        sources: {
          azuremonitor: {
            expr: 'sum(rate(azure_microsoft_compute_virtualmachines_network_out_total_total_bytes{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: 'Sent',
          },
        },
      },

      inboundFlows: {
        name: 'Connections',
        description: 'Number of current flows in the inbound/outbound direction',
        type: 'raw',
        unit: 'cps',
        sources: {
          azuremonitor: {
            expr: 'sum(rate(azure_microsoft_compute_virtualmachines_inbound_flows_average_count{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: 'In',
          },
        },
      },

      outboundFlows: {
        name: 'Outbound connections',
        description: 'Number of current flows in the outbound direction',
        type: 'raw',
        unit: 'cps',
        sources: {
          azuremonitor: {
            expr: 'sum(rate(azure_microsoft_compute_virtualmachines_outbound_flows_average_count{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: 'Out',
          },
        },
      },

      networkInByVM: {
        name: 'Network throughput received',
        description: 'The number of bytes received on all network interfaces by the Virtual Machine(s)',
        type: 'raw',
        unit: 'decbytes',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_compute_virtualmachines_network_in_total_total_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '{{resourceName}}',
          },
        },
      },

      networkOutByVM: {
        name: 'Network throughput sent',
        description: 'The number of bytes sent to all network interfaces by the Virtual Machine(s)',
        type: 'raw',
        unit: 'decbytes',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_compute_virtualmachines_network_out_total_total_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '{{resourceName}}',
          },
        },
      },

      diskReadByVM: {
        name: 'Disk Read bytes (total)',
        description: 'Bytes read from disk during monitoring period',
        type: 'raw',
        unit: 'decbytes',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_compute_virtualmachines_disk_read_bytes_total_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '{{resourceName}}',
          },
        },
      },

      diskWriteByVM: {
        name: 'Disk write bytes (total)',
        description: 'Bytes written to disk during monitoring period',
        type: 'raw',
        unit: 'decbytes',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_compute_virtualmachines_disk_write_bytes_total_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '{{resourceName}}',
          },
        },
      },

      diskReadOperationsByVM: {
        name: 'Disk Read Operations/Sec (average)',
        description: 'Disk Read IOPS',
        type: 'raw',
        unit: 'cps',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_compute_virtualmachines_disk_read_operations_sec_average_countpersecond{%(queriesSelector)s}',
            legendCustomTemplate: '{{resourceName}}',
          },
        },
      },

      diskWriteOperationsByVM: {
        name: 'Disk Write Operations/Sec (average)',
        description: 'Disk Write IOPS',
        type: 'raw',
        unit: 'cps',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_compute_virtualmachines_disk_write_operations_sec_average_countpersecond{%(queriesSelector)s}',
            legendCustomTemplate: '{{resourceName}}',
          },
        },
      },
      top5CpuUtilization: {
        name: 'Top 5 Instances - CPU utilitization',
        description: 'Fractional utilization of allocated CPU on an instance',
        type: 'raw',
        sources: {
          azuremonitor: {
            expr: 'topk(5, sum by (resourceName, job, resourceGroup)(azure_microsoft_compute_virtualmachines_percentage_cpu_average_percent{%(queriesSelector)s}))',
            legendCustomTemplate: '',
          },
        },
      },

      top5DiskRead: {
        name: 'Top 5 Instances - Disk read bytes',
        description: 'List of top 5 Instances by disk read bytes',
        type: 'raw',
        sources: {
          azuremonitor: {
            expr: 'topk(5, sum by (resourceName, job, resourceGroup)(azure_microsoft_compute_virtualmachines_disk_read_bytes_total_bytes{%(queriesSelector)s}))',
            legendCustomTemplate: '',
          },
        },
      },
    },
  }
