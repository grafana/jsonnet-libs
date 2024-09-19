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
            expr: 'avg by (resourceName, job, resourceGroup, subscriptionName) (azure_microsoft_compute_virtualmachines_vmavailabilitymetric_average_count{%(queriesSelector)s})',
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
            expr: 'topk(5, sum by (resourceName, job, resourceGroup, subscriptionName)(azure_microsoft_compute_virtualmachines_percentage_cpu_average_percent{%(queriesSelector)s}))',
            legendCustomTemplate: '',
          },
        },
      },

      top5DiskRead: {
        name: 'Top 5 Instances - Disk read bytes',
        description: 'List of top 5 Instances by disk read bytes',
        type: 'raw',
        unit: 'decbytes',
        sources: {
          azuremonitor: {
            expr: 'topk(5, sum by (resourceName, job, resourceGroup, subscriptionName)(azure_microsoft_compute_virtualmachines_disk_read_bytes_total_bytes{%(queriesSelector)s}))',
            legendCustomTemplate: '',
          },
        },
      },

      top5DiskWrite: {
        name: 'Top 5 Instances - Disk write bytes',
        description: 'List of top 5 Instances by disk write bytes',
        type: 'raw',
        unit: 'decbytes',
        sources: {
          azuremonitor: {
            expr: 'topk(5, sum by (resourceName, job, resourceGroup, subscriptionName)(azure_microsoft_compute_virtualmachines_disk_write_bytes_total_bytes{%(queriesSelector)s}))',
            legendCustomTemplate: '',
          },
        },
      },

      top5DiskReadOperations: {
        name: 'Top 5 Instances - Disk read operations/sec',
        description: 'List of top 5 Instances with higher disk read IOPS',
        type: 'raw',
        unit: 'cps',
        sources: {
          azuremonitor: {
            expr: 'topk(5, sum by (resourceName, job, resourceGroup, subscriptionName)(rate(azure_microsoft_compute_virtualmachines_disk_read_operations_sec_average_countpersecond{%(queriesSelector)s}[$__rate_interval])))',
            legendCustomTemplate: '',
          },
        },
      },

      top5DiskWriteOperations: {
        name: 'Top 5 Instances - Disk write operations/sec',
        description: 'List of top 5 Instances with higher disk write IOPS',
        type: 'raw',
        unit: 'cps',
        sources: {
          azuremonitor: {
            expr: 'topk(5, sum by (resourceName, job, resourceGroup, subscriptionName)(rate(azure_microsoft_compute_virtualmachines_disk_write_operations_sec_average_countpersecond{%(queriesSelector)s}[$__rate_interval])))',
            legendCustomTemplate: '',
          },
        },
      },

      top5NetworkIn: {
        name: 'Top 5 Instances - Network throughput received',
        description: 'List of top 5 Instances with higher number of bytes received over the network.',
        type: 'raw',
        unit: 'decbytes',
        sources: {
          azuremonitor: {
            expr: 'topk(5, sum by (resourceName, job, resourceGroup, subscriptionName)(rate(azure_microsoft_compute_virtualmachines_network_in_total_total_bytes{%(queriesSelector)s}[$__rate_interval])))',
            legendCustomTemplate: '',
          },
        },
      },

      top5NetworkOut: {
        name: 'Top 5 Instances - Network throughput sent',
        description: 'List of top 5 Instances with higher number of bytes sent over the network.',
        type: 'raw',
        unit: 'decbytes',
        sources: {
          azuremonitor: {
            expr: 'topk(5, sum by (resourceName, job, resourceGroup, subscriptionName)(rate(azure_microsoft_compute_virtualmachines_network_out_total_total_bytes{%(queriesSelector)s}[$__rate_interval])))',
            legendCustomTemplate: '',
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
    },
  }
