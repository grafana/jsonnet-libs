{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'mongodb-atlas-alerts',
        rules: [
          {
            alert: 'AtlasHighNumberOfDeadlocks',
            expr: |||
              sum without(cl_role,instance,process_port,rs_nm,rs_state) (increase(mongodb_locks_Collection_deadlockCount_R[5m])) + sum without(cl_role,instance,process_port,rs_nm,rs_state) (increase(mongodb_locks_Collection_deadlockCount_W[5m])) + sum without(cl_role,instance,process_port,rs_nm,rs_state) (increase(mongodb_locks_Collection_deadlockCount_r[5m])) + sum without(cl_role,instance,process_port,rs_nm,rs_state) (increase(mongodb_locks_Collection_deadlockCount_w[5m])) + sum without(cl_role,instance,process_port,rs_nm,rs_state) (increase(mongodb_locks_Database_deadlockCount_R[5m])) + sum without(cl_role,instance,process_port,rs_nm,rs_state) (increase(mongodb_locks_Database_deadlockCount_W[5m])) + sum without(cl_role,instance,process_port,rs_nm,rs_state) (increase(mongodb_locks_Database_deadlockCount_r[5m])) + sum without(cl_role,instance,process_port,rs_nm,rs_state) (increase(mongodb_locks_Database_deadlockCount_w[5m])) > %(alertsDeadlocks)
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There are a high number of deadlocks occurring.',
              description:
                (
                  'The number of deadlocks occurring in {{$labels.cl_name}} is {{$labels.value}} which is above the threshold of %(alertsDeadlocks)s'
                ) % $._config,
            },
          },
          {
            alert: 'AtlasHighNumberOfSlowNetworkRequests',
            expr: |||
              sum without (cl_role,rs_nm,instance,rs_state,process_port) (increase(mongodb_network_numSlowSSLOperations[5m])) + sum without (cl_role,rs_nm,instance,rs_state,process_port) (increase(mongodb_network_numSlowDNSOperations[5m])) > %(alertsSlowNetworkRequests)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There are a high number of slow network requests.',
              description:
                (
                  'The number of DNS and SSL operations taking more than 1 second to complete is {{$labels.value}} which is above the threshold of %(alertsSlowNetworkRequests)s'
                ) % $._config,
            },
          },
          {
            alert: 'AtlasDiskSpaceLow',
            expr: |||
              100 * ((sum without (instance,disk_name) (hardware_disk_metrics_disk_space_used_bytes)) / ((sum without (instance,disk_name) (hardware_disk_metrics_disk_space_used_bytes)) + (sum without (instance,disk_name) (hardware_disk_metrics_disk_space_free_bytes)))) > %(alertsHighDiskUsage)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Hardware is running out of disk space.',
              description:
                (
                  'The amount of hardware disk space being used is {{$labels.value}} which is above the threshold of %(alertsHighDiskUsage)s'
                ) % $._config,
            },
          },
          {
            alert: 'AtlasSlowHardwareIO',
            expr: |||
              (sum without (disk_name,instance) (increase(hardware_disk_metrics_read_time_milliseconds[5m])) + sum without (disk_name,instance) (increase(hardware_disk_metrics_write_time_milliseconds[5m]))) / 1000 > %(alertsSlowHardwareIO)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Read and write I/Os are taking too long to complete.',
              description:
                (
                  'The latency time for read and write I/Os is {{$labels.value}} which is above the threshold of %(alertsSlowHardwareIO)s'
                ) % $._config,
            },
          },
          {
            alert: 'AtlasHighNumberOfTimeoutElections',
            expr: |||
              sum without (cl_role,instance,process_port,rs_nm,rs_state) (increase(mongodb_electionMetrics_electionTimeout_called[5m])) > %(alertsHighTimeoutElections)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There are a high number of elections being called due to the primary node timing out.',
              description:
                (
                  'The number of elections being called due to the primary node timing out is {{$labels.value}} which is above the threshold of %(alertsHighTimeoutElections)s'
                ) % $._config,
            },
          },
        ],
      },
    ],
  },
}
