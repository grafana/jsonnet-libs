local commonlib = import 'common-lib/common/main.libsonnet';
function(this)
  {
    local s = self,
    filteringSelector: 'job!=""',
    groupLabels: ['job', 'project_id'],
    instanceLabels: [],
    aggLevel: 'instance',
    discoveryMetric: {
      stackdriver: 'stackdriver_gce_instance_compute_googleapis_com_instance_cpu_utilization',
    },
    signals: {
      instanceCount: {
        name: 'Instance count',
        description: 'Number of VM instances',
        type: 'gauge',
        aggFunction: 'sum',
        unit: 'short',
        sources: {
          stackdriver: {
            expr: 'stackdriver_gce_instance_compute_googleapis_com_instance_cpu_utilization{%(queriesSelector)s}',
            legendCustomTemplate: 'Number of instances',
            aggKeepLabels: ['instance_name'],
            exprWrappers: [['count(', ')']],
          },
        },
      },
      systemProblemCount: {
        name: 'System problem count',
        description: 'Number of errors fired on all instances.',
        type: 'raw',
        unit: 'short',
        sources: {
          stackdriver: {
            expr: 'sum(increase(stackdriver_gce_instance_compute_googleapis_com_guest_system_problem_count{%(queriesSelector)s}[$__range]))',
            legendCustomTemplate: 'Total errors',
          },
        },
      },
      top5CpuUtilization: {
        name: 'Top 5 Instances by CPU Utilitization',
        description: 'Fractional utilization of allocated CPU on an instance',
        type: 'gauge',
        aggFunction: 'sum',
        sources: {
          stackdriver: {
            expr: 'stackdriver_gce_instance_compute_googleapis_com_instance_cpu_utilization{%(queriesSelector)s}',
            legendCustomTemplate: '',
            aggKeepLabels: ['instance_name'],
            exprWrappers: [['topk(5, 100*', ')']],
          },
        },
      },

      top5SystemProblem: {
        name: 'Top 5 Instances by System problem',
        description: 'List of top 5 instances with system problems.',
        type: 'gauge',
        aggFunction: 'sum',
        sources: {
          stackdriver: {
            expr: 'increase(stackdriver_gce_instance_compute_googleapis_com_guest_system_problem_count{%(queriesSelector)s}[$__range])',
            legendCustomTemplate: '',
            aggKeepLabels: ['instance_name'],
            exprWrappers: [['topk(5,', ')']],
          },
        },
      },

      top5DiskWrite: {
        name: 'Top 5 Instances by Disk write bytes',
        description: 'List of top 5 instances by disk write bytes',
        type: 'gauge',
        aggFunction: 'sum',
        unit: 'bytes',
        sources: {
          stackdriver: {
            expr: 'increase(stackdriver_gce_instance_compute_googleapis_com_instance_disk_write_bytes_count{%(queriesSelector)s}[$__range])',
            legendCustomTemplate: '',
            aggKeepLabels: ['instance_name'],
            exprWrappers: [['topk(5,', ')']],
          },
        },
      },

      top5DiskRead: {
        name: 'Top 5 Instances by Disk read bytes',
        description: 'List of top 5 instances by disk read bytes',
        type: 'gauge',
        aggFunction: 'sum',
        unit: 'bytes',
        sources: {
          stackdriver: {
            expr: 'increase(stackdriver_gce_instance_compute_googleapis_com_instance_disk_read_bytes_count{%(queriesSelector)s}[$__range])',
            aggKeepLabels: ['instance_name'],
            legendCustomTemplate: '',
            exprWrappers: [['topk(5,', ')']],
          },
        },
      },

      // Table
      tableCpuUtilization: {
        name: 'tableCpuUtilization',
        type: 'gauge',
        aggFunction: 'sum',
        sources: {
          stackdriver: {
            expr: 'stackdriver_gce_instance_compute_googleapis_com_instance_cpu_utilization{%(queriesSelector)s}',
            legendCustomTemplate: '',
            aggKeepLabels: ['instance_name'],
            exprWrappers: [['100 *', '']],
          },
        },
      },
      tableUptime: {
        name: 'tableUptime',
        type: 'gauge',
        sources: {
          stackdriver: {
            expr: 'stackdriver_gce_instance_compute_googleapis_com_instance_uptime_total{%(queriesSelector)s}',
            legendCustomTemplate: '',
            aggKeepLabels: ['instance_name'],
          },
        },
      },
      tableSentPackets: {
        name: 'tableSentPackets',
        type: 'gauge',
        sources: {
          stackdriver: {
            expr: 'rate(stackdriver_gce_instance_compute_googleapis_com_instance_network_sent_packets_count{%(queriesSelector)s}[5m])',
            legendCustomTemplate: '',
            aggKeepLabels: ['instance_name'],
          },
        },
      },
      tableReceivedPackets: {
        name: 'tableReceivedPackets',
        type: 'gauge',
        sources: {
          stackdriver: {
            expr: 'rate(stackdriver_gce_instance_compute_googleapis_com_instance_network_received_packets_count{%(queriesSelector)s}[5m])',
            legendCustomTemplate: '',
            aggKeepLabels: ['instance_name'],
          },
        },
      },
      tableNetworkSentBytes: {
        name: 'tableNetworkSentBytes',
        type: 'gauge',
        sources: {
          stackdriver: {
            expr: 'rate(stackdriver_gce_instance_compute_googleapis_com_instance_network_sent_bytes_count{%(queriesSelector)s}[5m])',
            legendCustomTemplate: '',
            aggKeepLabels: ['instance_name'],
          },
        },
      },
      tableNetworkReceivedBytes: {
        name: 'tableNetworkReceivedBytes',
        type: 'gauge',
        sources: {
          stackdriver: {
            expr: 'rate(stackdriver_gce_instance_compute_googleapis_com_instance_network_received_bytes_count{%(queriesSelector)s}[5m])',
            legendCustomTemplate: '',
            aggKeepLabels: ['instance_name'],
          },
        },
      },
      tableDiskReadBytes: {
        name: 'tableDiskReadBytes',
        type: 'gauge',
        sources: {
          stackdriver: {
            expr: 'rate(stackdriver_gce_instance_compute_googleapis_com_instance_disk_read_bytes_count{%(queriesSelector)s}[5m])',
            legendCustomTemplate: '',
            aggKeepLabels: ['instance_name'],
          },
        },
      },
      tableDiskWriteBytes: {
        name: 'tableDiskWriteBytes',
        type: 'gauge',
        sources: {
          stackdriver: {
            expr: 'rate(stackdriver_gce_instance_compute_googleapis_com_instance_disk_write_bytes_count{%(queriesSelector)s}[5m])',
            legendCustomTemplate: '',
            aggKeepLabels: ['instance_name'],
          },
        },
      },
      // end table

      memoryUtilization: {
        name: 'Memory Utilization',
        description: 'Memory Utilization',
        type: 'raw',
        unit: 'bytes',
        sources: {
          stackdriver: {
            expr: 'sum(stackdriver_gce_instance_compute_googleapis_com_instance_memory_balloon_ram_size{%(queriesSelector)s}) + sum(stackdriver_gce_instance_compute_googleapis_com_guest_memory_bytes_used{%(queriesSelector)s})',
            legendCustomTemplate: 'Total Memory Capacity',
          },
        },
      },

      memoryUsed: {
        name: 'Memory Utilization2',
        description: 'Memory used',
        type: 'raw',
        unit: 'bytes',
        sources: {
          stackdriver: {
            expr: 'sum(stackdriver_gce_instance_compute_googleapis_com_instance_memory_balloon_ram_used{%(queriesSelector)s}) + sum(stackdriver_gce_instance_compute_googleapis_com_guest_memory_bytes_used{%(queriesSelector)s, state!="free"})',
            legendCustomTemplate: 'Total Memory Used',
          },
        },
      },

      packetsSent: {
        name: 'Total packets count sent/received',
        description: 'Count of packets sent/received over the network. Sampled every 60 seconds',
        type: 'counter',
        unit: 'sishort',
        aggFunction: 'sum',
        sources: {
          stackdriver: {
            expr: 'stackdriver_gce_instance_compute_googleapis_com_instance_network_sent_packets_count{%(queriesSelector)s}',
            legendCustomTemplate: 'Sent',
          },
        },
      },

      packetsReceived: {
        name: 'Total packets count received',
        description: 'Count of packets sent/received over the network. Sampled every 60 seconds',
        type: 'counter',
        unit: 'sishort',
        aggFunction: 'sum',
        sources: {
          stackdriver: {
            expr: 'stackdriver_gce_instance_compute_googleapis_com_instance_network_received_packets_count{%(queriesSelector)s}',
            legendCustomTemplate: 'Received',
          },
        },
      },

      networkSent: {
        name: 'Network throughput Sent/Received',
        description: 'Count of bytes sent/received over the network. Sampled every 60 seconds',
        type: 'counter',
        unit: 'bytes',
        sources: {
          stackdriver: {
            expr: 'stackdriver_gce_instance_compute_googleapis_com_instance_network_sent_bytes_count{%(queriesSelector)s}',
            legendCustomTemplate: 'Sent',
          },
        },
      },

      networkReceived: {
        name: 'Network throughput Received',
        description: 'Count of bytes sent/received over the network. Sampled every 60 seconds',
        type: 'counter',
        unit: 'bytes',
        sources: {
          stackdriver: {
            expr: 'stackdriver_gce_instance_compute_googleapis_com_instance_network_received_bytes_count{%(queriesSelector)s}',
            legendCustomTemplate: 'Received',
          },
        },
      },

      diskBytesRead: {
        name: 'Total Bytes count read/write',
        description: 'Total count of bytes read/write from disk. Sampled every 60 seconds',
        type: 'counter',
        unit: 'bytes',
        sources: {
          stackdriver: {
            expr: 'stackdriver_gce_instance_compute_googleapis_com_instance_disk_read_bytes_count{%(queriesSelector)s}',
            legendCustomTemplate: 'Read',
          },
        },
      },

      diskBytesWrite: {
        name: 'Total Bytes count write',
        description: 'Total count of bytes read/write from disk. Sampled every 60 seconds',
        type: 'counter',
        unit: 'bytes',
        sources: {
          stackdriver: {
            expr: 'stackdriver_gce_instance_compute_googleapis_com_instance_disk_write_bytes_count{%(queriesSelector)s}',
            legendCustomTemplate: 'Write',
          },
        },
      },
    },
  }
