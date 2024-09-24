local commonlib = import 'common-lib/common/main.libsonnet';
function(this)
  {
    local s = self,
    filteringSelector: 'job!=""',
    groupLabels: ['job', 'project_id'],
    instanceLabels: ['instance_name'],
    aggLevel: 'instance',
    discoveryMetric: {
      stackdriver: 'stackdriver_gce_instance_compute_googleapis_com_instance_cpu_utilization',
    },
    signals: {
      cpuUtilization: {
        name: 'CPU Utilization',
        description: 'Fractional utilization of allocated CPU on this instance.',
        type: 'raw',
        unit: 'percentunit',
        sources: {
          stackdriver: {
            expr: 'stackdriver_gce_instance_compute_googleapis_com_instance_cpu_utilization{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance_name}}',
          },
        },
      },

      networkReceived: {
        name: 'Network received',
        description: 'Count of bytes received from the network. Sampled every 60 seconds.',
        type: 'counter',
        unit: 'bytes',
        aggFunction: 'avg',
        sources: {
          stackdriver: {
            expr: 'stackdriver_gce_instance_compute_googleapis_com_instance_network_received_bytes_count{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance_name}}',
          },
        },
      },
      cpuUsageTime: {
        name: 'Cpu usage time',
        description: 'CPU usage, in seconds. For Container-Optimized OS, or Ubuntu running GKE.',
        type: 'counter',
        unit: 'seconds',
        aggFunction: 'avg',
        sources: {
          stackdriver: {
            expr: 'stackdriver_gce_instance_compute_googleapis_com_instance_cpu_usage_time{instance_name=~"$instance"}',
            legendCustomTemplate: '{{instance_name}}',
          },
        },
      },
      networkSent: {
        name: 'Network sent',
        description: 'Count of bytes sent from the network. Sampled every 60 seconds.',
        type: 'raw',
        unit: 'bytes',
        aggFunction: 'avg',
        sources: {
          stackdriver: {
            expr: 'rate(stackdriver_gce_instance_compute_googleapis_com_instance_network_sent_bytes_count{instance_name=~"$instance"}[$__rate_interval])',
            legendCustomTemplate: '{{instance_name}}',
          },
        },
      },

      diskReadBytes: {
        name: 'Count of disk read bytes',
        description: 'Count of bytes read from disk. Sampled every 60 seconds.',
        type: 'counter',
        unit: 'bytes',
        aggFunction: 'avg',
        sources: {
          stackdriver: {
            expr: 'stackdriver_gce_instance_compute_googleapis_com_instance_disk_read_bytes_count{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance_name}}',
            exprWrappers: [['', '> 0']],
          },
        },
      },

      diskReadOperations: {
        name: 'Count of disk read operations',
        description: 'Count of disk read IO operations. Sampled every 60 seconds.',
        type: 'counter',
        unit: 'short',
        aggFunction: 'avg',
        sources: {
          stackdriver: {
            expr: 'stackdriver_gce_instance_compute_googleapis_com_instance_disk_read_ops_count{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance_name}}',
          },
        },
      },

      diskWriteBytes: {
        name: 'Count of disk write bytes',
        description: 'Count of bytes written to disk. Sampled every 60 seconds.',
        type: 'counter',
        unit: 'bytes',
        aggFunction: 'avg',
        sources: {
          stackdriver: {
            expr: 'stackdriver_gce_instance_compute_googleapis_com_instance_disk_write_bytes_count{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance_name}}',
          },
        },
      },

      diskWriteOperations: {
        name: 'Count of disk write operations',
        description: 'Count of disk write IO operations. Sampled every 60 seconds.',
        type: 'counter',
        unit: 'short',
        aggFunction: 'avg',
        sources: {
          stackdriver: {
            expr: 'stackdriver_gce_instance_compute_googleapis_com_instance_disk_write_ops_count{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance_name}}',
          },
        },
      },
    },
  }
