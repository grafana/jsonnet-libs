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
      cpuUtilization: {
        name: 'CPU Utilization average',
        description: 'The percentage of allocated compute units that are currently in use by the Virtual Machine(s)',
        type: 'raw',
        unit: 'percent',
        sources: {
          azuremonitor: {
            expr: 'avg by (resourceName, job, resourceGroup, subscriptionName) (azure_microsoft_compute_virtualmachines_percentage_cpu_average_percent{%(queriesSelector)s})',
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
            expr: 'sum by (resourceName, job, resourceGroup, subscriptionName) (azure_microsoft_compute_virtualmachines_available_memory_bytes_average_bytes{%(queriesSelector)s})',
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
            expr: 'sum by (resourceName, job, resourceGroup, subscriptionName) (azure_microsoft_compute_virtualmachines_cpu_credits_consumed_average_count{%(queriesSelector)s})',
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
            expr: 'sum by (resourceName, job, resourceGroup, subscriptionName) (azure_microsoft_compute_virtualmachines_cpu_credits_remaining_average_count{%(queriesSelector)s})',
            legendCustomTemplate: '{{resourceName}}',
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
            expr: 'sum by (resourceName, job, resourceGroup, subscriptionName) (azure_microsoft_compute_virtualmachines_network_in_total_total_bytes{%(queriesSelector)s})',
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
            expr: 'sum by (resourceName, job, resourceGroup, subscriptionName) (azure_microsoft_compute_virtualmachines_network_out_total_total_bytes{%(queriesSelector)s})',
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
            expr: 'sum by (resourceName, job, resourceGroup, subscriptionName) (azure_microsoft_compute_virtualmachines_disk_read_bytes_total_bytes{%(queriesSelector)s})',
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
            expr: 'sum by (resourceName, job, resourceGroup, subscriptionName) (azure_microsoft_compute_virtualmachines_disk_write_bytes_total_bytes{%(queriesSelector)s})',
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
            expr: 'sum by (resourceName, job, resourceGroup, subscriptionName) (azure_microsoft_compute_virtualmachines_disk_read_operations_sec_average_countpersecond{%(queriesSelector)s})',
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
            expr: 'sum by (resourceName, job, resourceGroup, subscriptionName) (azure_microsoft_compute_virtualmachines_disk_write_operations_sec_average_countpersecond{%(queriesSelector)s})',
            legendCustomTemplate: '{{resourceName}}',
          },
        },
      },
    },
  }
