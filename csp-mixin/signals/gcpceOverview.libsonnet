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
        type: 'raw',
        unit: 'short',
        sources: {
          stackdriver: {
            expr: 'count(sum by (instance_name) (stackdriver_gce_instance_compute_googleapis_com_instance_cpu_utilization{%(queriesSelector)s}))',
            legendCustomTemplate: '',
          },
        },
      },
      systemProblemCount: {
        name: 'System problem count',
        description: 'Number of times a machine problem has happened.',
        type: 'raw',
        unit: 'short',
        sources: {
          stackdriver: {
            expr: 'count(sum by(instance_id)(stackdriver_gce_instance_compute_googleapis_com_guest_system_problem_count{%(queriesSelector)s}))',
            legendCustomTemplate: '',
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
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'topk(5, sum by (instance_name, job, project_id) (increase(stackdriver_gce_instance_compute_googleapis_com_guest_system_problem_count{%(queriesSelector)s}[$__range])))',
            legendCustomTemplate: '',
          },
        },
      },

      top5DiskWrite: {
        name: 'Top 5 Instances by Disk write bytes',
        description: 'List of top 5 instances by disk write bytes',
        type: 'raw',
        unit: 'bytes',
        sources: {
          stackdriver: {
            expr: 'topk(5, sum by (instance_name, job, project_id) (increase(stackdriver_gce_instance_compute_googleapis_com_instance_disk_write_bytes_count{%(queriesSelector)s}[$__range])))',
            legendCustomTemplate: '',
          },
        },
      },

      top5DiskRead: {
        name: 'Top 5 Instances by Disk read bytes',
        description: 'List of top 5 instances by disk read bytes',
        type: 'raw',
        unit: 'bytes',
        sources: {
          stackdriver: {
            expr: 'topk(5, sum by (instance_name, job, project_id) (increase(stackdriver_gce_instance_compute_googleapis_com_instance_disk_read_bytes_count{%(queriesSelector)s}[$__range])))',
            legendCustomTemplate: '',
          },
        },
      },

      // Table
      tableCpuUtilization: {
        name: 'tableCpuUtilization',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: '100 * sum by (instance_name, job, project_id)(stackdriver_gce_instance_compute_googleapis_com_instance_cpu_utilization{%(queriesSelector)s})',
            legendCustomTemplate: '',
            step: '1m',
          },
        },
      },
      tableUptime: {
        name: 'tableUptime',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'sum by (instance_name, job, project_id)(stackdriver_gce_instance_compute_googleapis_com_instance_uptime_total{%(queriesSelector)s})',
            legendCustomTemplate: '',
          },
        },
      },
      tableSentPackets: {
        name: 'tableSentPackets',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'sum by (instance_name, job, project_id)(rate(stackdriver_gce_instance_compute_googleapis_com_instance_network_sent_packets_count{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '',
            step: '1m',
          },
        },
      },
      tableReceivedPackets: {
        name: 'tableReceivedPackets',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'sum by (instance_name, job, project_id)(rate(stackdriver_gce_instance_compute_googleapis_com_instance_network_received_packets_count{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '',
            step: '1m',
          },
        },
      },
      tableSentBytes: {
        name: 'tableSentBytes',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'sum by (instance_name, job, project_id)(rate(stackdriver_gce_instance_compute_googleapis_com_instance_network_sent_bytes_count{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '',
            step: '1m',
          },
        },
      },
      tableReceivedBytes: {
        name: 'tableReceivedBytes',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'sum by (instance_name, job, project_id)(rate(stackdriver_gce_instance_compute_googleapis_com_instance_network_received_bytes_count{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '',
            step: '1m',
          },
        },
      },
      tableReadBytes: {
        name: 'tableReadBytes',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'sum by (instance_name, job, project_id)(rate(stackdriver_gce_instance_compute_googleapis_com_instance_disk_read_bytes_count{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '',
            step: '1m',
          },
        },
      },
      tableWriteBytes: {
        name: 'tableWriteBytes',
        type: 'raw',
        sources: {
          stackdriver: {
            expr: 'sum by (instance_name, job, project_id)(rate(stackdriver_gce_instance_compute_googleapis_com_instance_disk_write_bytes_count{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '',
            step: '1m',
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
            expr: 'sum(stackdriver_gce_instance_compute_googleapis_com_instance_memory_balloon_ram_size{instance_name=~"$instance_name"} or on() vector(0)) + sum(stackdriver_gce_instance_compute_googleapis_com_guest_memory_bytes_used{instance_name=~"$instance_name"} OR on() vector(0))',
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
            expr: 'sum(stackdriver_gce_instance_compute_googleapis_com_instance_memory_balloon_ram_used{instance_name=~"$instance_name"} OR on() vector(0)) + sum(stackdriver_gce_instance_compute_googleapis_com_guest_memory_bytes_used{instance_name=~"$instance_name", state!="free"} OR on() vector(0))',
            legendCustomTemplate: 'Total Memory Used',
          },
        },
      },

      packetsSent: {
        name: 'Total packets count sent/received',
        description: 'Count of packets sent/received over the network. Sampled every 60 seconds',
        type: 'counter',
        unit: 'short',
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
        unit: 'short',
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
