local commonlib = import 'common-lib/common/main.libsonnet';
function(this)
  {
    local s = self,
    filteringSelector: 'job!=""',
    groupLabels: this.groupLabels,
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
        name: 'VM Availability',
        description: 'Measure of availability of virtual machines',
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
            aggKeepLabels: ['instance_name', 'job', 'project_id'],
            exprWrappers: [['topk(5, 100*', ')']],
          },
        },
      },

      top5SystemProblem: {
        name: 'Top 5 Instances by System problem',
        description: 'List of top 5 instances with system problems.',
        type: 'gauge',
        unit: 'decbytes',
        aggFunction: 'avg',
        sources: {
          stackdriver: {
            expr: 'stackdriver_gce_instance_compute_googleapis_com_guest_system_problem_count{%(queriesSelector)s}',
            legendCustomTemplate: '',
            aggKeepLabels: ['instance_name', 'job', 'project_id'],
            exprWrappers: [['topk(5,', ')']],
          },
        },
      },

      top5DiskWrite: {
        name: 'Top 5 Instances by Disk write bytes',
        description: 'List of top 5 instances by disk write bytes',
        type: 'gauge',
        unit: 'decbytes',
        aggFunction: 'sum',
        sources: {
          stackdriver: {
            expr: 'stackdriver_gce_instance_compute_googleapis_com_instance_disk_write_bytes_count{%(queriesSelector)s}',
            legendCustomTemplate: '',
            aggKeepLabels: ['instance_name', 'job', 'project_id'],
            exprWrappers: [['topk(5,', ')']],
          },
        },
      },

      top5DiskRead: {
        name: 'Top 5 Instances by Disk read bytes',
        description: 'List of top 5 instances by disk read bytes',
        type: 'gauge',
        unit: 'decbytes',
        aggFunction: 'sum',
        sources: {
          stackdriver: {
            expr: 'stackdriver_gce_instance_compute_googleapis_com_instance_disk_read_bytes_count{%(queriesSelector)s}',
            legendCustomTemplate: '',
            aggKeepLabels: ['instance_name', 'job', 'project_id'],
            exprWrappers: [['topk(5,', ')']],
          },
        },
      },

    //   To do: add Instances table

    memoryUtilization: {
        name: 'Memory Utilization',
        description: 'Memory Utilization',
        type: 'raw',
        unit: 'bytes',
        sources: {
          stackdriver: {
            expr: 'sum(stackdriver_gce_instance_compute_googleapis_com_instance_memory_balloon_ram_size{instance_name=~"$instance"} or on() vector(0)) + sum(stackdriver_gce_instance_compute_googleapis_com_guest_memory_bytes_used{instance_name=~"$instance"} OR on() vector(0))',
            legendCustomTemplate: 'Total Memory Capacity',
          },
        },
      },

      memoryUsed: {
        name: 'Memory Utilization',
        description: 'Memory Utilization',
        type: 'raw',
        unit: 'bytes',
        sources: {
          stackdriver: {
            expr: 'sum(stackdriver_gce_instance_compute_googleapis_com_instance_memory_balloon_ram_used{instance_name=~"$instance"} OR on() vector(0)) + sum(stackdriver_gce_instance_compute_googleapis_com_guest_memory_bytes_used{instance_name=~"$instance", state!="free"} OR on() vector(0))',
            legendCustomTemplate: 'Total Memory Used',
          },
        },
      },

      packetsSent: {
        name: 'Total packets count sent/received',
        description: 'Count of packets sent/received over the network. Sampled every 60 seconds',
        type: 'gauge',
        unit: 'short',
        sources: {
          stackdriver: {
            expr: 'stackdriver_gce_instance_compute_googleapis_com_instance_network_sent_packets_count{%(queriesSelector)s}',
            legendCustomTemplate: 'Sent',
            exprWrappers: [['sum(', ')']],
          },
        },
      },

      packetsReceived: {
        name: 'Total packets count sent/received',
        description: 'Count of packets sent/received over the network. Sampled every 60 seconds',
        type: 'gauge',
        unit: 'short',
        sources: {
          stackdriver: {
            expr: 'stackdriver_gce_instance_compute_googleapis_com_instance_network_received_packets_count{%(queriesSelector)s}',
            legendCustomTemplate: 'Received',
            exprWrappers: [['sum(', ')']],
          },
        },
      },

      networkSent: {
        name: 'Network throughput Sent/Received',
        description: 'Count of bytes sent/received over the network. Sampled every 60 seconds',
        type: 'gauge',
        unit: 'bytes',
        sources: {
          stackdriver: {
            expr: 'stackdriver_gce_instance_compute_googleapis_com_instance_network_sent_bytes_count{%(queriesSelector)s}',
            legendCustomTemplate: 'Sent',
            exprWrappers: [['sum(', ')']],
          },
        },
      },

      networkReceived: {
       name: 'Network throughput Sent/Received',
        description: 'Count of bytes sent/received over the network. Sampled every 60 seconds',
        type: 'gauge',
        unit: 'bytes',
        sources: {
          stackdriver: {
            expr: 'azure_microsoft_compute_virtualmachines_disk_write_operations_sec_average_countpersecond{%(queriesSelector)s}',
            legendCustomTemplate: 'Received',
            exprWrappers: [['sum(', ')']],
          },
        },
      },

      diskBytesRead: {
        name: 'Total Bytes count read/write',
        description: 'Total count of bytes read/write from disk. Sampled every 60 seconds',
        type: 'gauge',
        unit: 'bytes',
        sources: {
          stackdriver: {
            expr: 'stackdriver_gce_instance_compute_googleapis_com_instance_disk_read_bytes_count{%(queriesSelector)s}',
            legendCustomTemplate: 'Sent',
            exprWrappers: [['sum(', ')']],
          },
        },
      },

      diskBytesWrite: {
        name: 'Total Bytes count read/write',
        description: 'Total count of bytes read/write from disk. Sampled every 60 seconds',
        type: 'gauge',
        unit: 'bytes',
        sources: {
          stackdriver: {
            expr: 'stackdriver_gce_instance_compute_googleapis_com_instance_disk_write_bytes_count{%(queriesSelector)s}',
            legendCustomTemplate: 'In',
            exprWrappers: [['sum(', ')']],
          },
        },
      },
    },
  }
