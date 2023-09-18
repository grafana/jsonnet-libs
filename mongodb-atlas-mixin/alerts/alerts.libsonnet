{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'mongodb-atlas-alerts',
        rules: [
          {
            alert: 'MongoDBAtlasHighNumberOfCollectionExclusiveDeadlocks',
            expr: |||
              sum without(cl_role,process_port,rs_nm,rs_state) (increase(mongodb_locks_Collection_deadlockCount_W[5m])) > %(alertsDeadlocks)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There is a high number of collection exclusive deadlocks occurring.',
              description:
                (
                  'The number of collection exclusive-lock deadlocks occurring on node {{$labels.instance}} in cluster {{$labels.cl_name}} is {{printf "%%.0f" $value}} which is above the threshold of %(alertsDeadlocks)s.'
                ) % $._config,
            },
          },
          {
            alert: 'MongoDBAtlasHighNumberOfCollectionIntentExclusiveDeadlocks',
            expr: |||
              sum without(cl_role,process_port,rs_nm,rs_state) (increase(mongodb_locks_Collection_deadlockCount_w[5m])) > %(alertsDeadlocks)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There is a high number of collection intent-exclusive deadlocks occurring.',
              description:
                (
                  'The number of collection intent-exclusive-lock deadlocks occurring on node {{$labels.instance}} in cluster {{$labels.cl_name}} is {{printf "%%.0f" $value}} which is above the threshold of %(alertsDeadlocks)s.'
                ) % $._config,
            },
          },
          {
            alert: 'MongoDBAtlasHighNumberOfCollectionSharedDeadlocks',
            expr: |||
              sum without(cl_role,process_port,rs_nm,rs_state) (increase(mongodb_locks_Collection_deadlockCount_R[5m])) > %(alertsDeadlocks)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There is a high number of collection shared deadlocks occurring.',
              description:
                (
                  'The number of collection shared-lock deadlocks occurring on node {{$labels.instance}} in cluster {{$labels.cl_name}} is {{printf "%%.0f" $value}} which is above the threshold of %(alertsDeadlocks)s.'
                ) % $._config,
            },
          },
          {
            alert: 'MongoDBAtlasHighNumberOfCollectionIntentSharedDeadlocks',
            expr: |||
              sum without(cl_role,process_port,rs_nm,rs_state) (increase(mongodb_locks_Collection_deadlockCount_r[5m])) > %(alertsDeadlocks)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There is a high number of collection intent-shared deadlocks occurring.',
              description:
                (
                  'The number of collection intent-shared-lock deadlocks occurring on node {{$labels.instance}} in cluster {{$labels.cl_name}} is {{printf "%%.0f" $value}} which is above the threshold of %(alertsDeadlocks)s.'
                ) % $._config,
            },
          },
          {
            alert: 'MongoDBAtlasHighNumberOfDatabaseExclusiveDeadlocks',
            expr: |||
              sum without(cl_role,process_port,rs_nm,rs_state) (increase(mongodb_locks_Database_deadlockCount_W[5m])) > %(alertsDeadlocks)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There is a high number of database exclusive deadlocks occurring.',
              description:
                (
                  'The number of database exclusive-lock deadlocks occurring on node {{$labels.instance}} in cluster {{$labels.cl_name}} is {{printf "%%.0f" $value}} which is above the threshold of %(alertsDeadlocks)s.'
                ) % $._config,
            },
          },
          {
            alert: 'MongoDBAtlasHighNumberOfDatabaseIntentExclusiveDeadlocks',
            expr: |||
              sum without(cl_role,process_port,rs_nm,rs_state) (increase(mongodb_locks_Database_deadlockCount_w[5m])) > %(alertsDeadlocks)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There is a high number of database intent-exclusive deadlocks occurring.',
              description:
                (
                  'The number of database intent-exclusive-lock deadlocks occurring on node {{$labels.instance}} in cluster {{$labels.cl_name}} is {{printf "%%.0f" $value}} which is above the threshold of %(alertsDeadlocks)s.'
                ) % $._config,
            },
          },
          {
            alert: 'MongoDBAtlasHighNumberOfDatabaseSharedDeadlocks',
            expr: |||
              sum without(cl_role,process_port,rs_nm,rs_state) (increase(mongodb_locks_Database_deadlockCount_R[5m])) > %(alertsDeadlocks)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There is a high number of database shared deadlocks occurring.',
              description:
                (
                  'The number of database shared-lock deadlocks occurring on node {{$labels.instance}} in cluster {{$labels.cl_name}} is {{printf "%%.0f" $value}} which is above the threshold of %(alertsDeadlocks)s.'
                ) % $._config,
            },
          },
          {
            alert: 'MongoDBAtlasHighNumberOfDatabaseIntentSharedDeadlocks',
            expr: |||
              sum without(cl_role,process_port,rs_nm,rs_state) (increase(mongodb_locks_Database_deadlockCount_r[5m])) > %(alertsDeadlocks)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There is a high number of database intent-shared deadlocks occurring.',
              description:
                (
                  'The number of database intent-shared-lock deadlocks occurring on node {{$labels.instance}} in cluster {{$labels.cl_name}} is {{printf "%%.0f" $value}} which is above the threshold of %(alertsDeadlocks)s.'
                ) % $._config,
            },
          },
          {
            alert: 'MongoDBAtlasHighNumberOfSlowNetworkRequests',
            expr: |||
              sum without (cl_role,rs_nm,rs_state,process_port) (increase(mongodb_network_numSlowSSLOperations[5m])) + sum without (cl_role,rs_nm,rs_state,process_port) (increase(mongodb_network_numSlowDNSOperations[5m])) > %(alertsSlowNetworkRequests)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There is a high number of slow network requests.',
              description:
                (
                  'The number of DNS and SSL operations taking more than 1 second to complete on node {{$labels.instance}} in cluster {{$labels.cl_name}} is {{printf "%%.0f" $value}} which is above the threshold of %(alertsSlowNetworkRequests)s.'
                ) % $._config,
            },
          },
          {
            alert: 'MongoDBAtlasDiskSpaceLow',
            expr: |||
              100 * ((sum without (disk_name) (hardware_disk_metrics_disk_space_used_bytes)) / clamp_min((sum without (disk_name) (hardware_disk_metrics_disk_space_used_bytes)) + (sum without (disk_name) (hardware_disk_metrics_disk_space_free_bytes)), 1)) > %(alertsHighDiskUsage)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Hardware is running out of disk space.',
              description:
                (
                  'The amount of hardware disk space being used on node {{$labels.instance}} in cluster {{$labels.cl_name}} is {{printf "%%.0f" $value}}%% which is above the threshold of %(alertsHighDiskUsage)s%%.'
                ) % $._config,
            },
          },
          {
            alert: 'MongoDBAtlasSlowHardwareIO',
            expr: |||
              (sum without (disk_name) (increase(hardware_disk_metrics_read_time_milliseconds[5m])) + sum without (disk_name) (increase(hardware_disk_metrics_write_time_milliseconds[5m]))) / 1000 > %(alertsSlowHardwareIO)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Read and write I/Os are taking too long to complete.',
              description:
                (
                  'The latency time for read and write I/Os on node {{$labels.instance}} in cluster {{$labels.cl_name}} is {{printf "%%.0f" $value}} seconds which is above the threshold of %(alertsSlowHardwareIO)s seconds.'
                ) % $._config,
            },
          },
          {
            alert: 'MongoDBAtlasHighNumberOfTimeoutElections',
            expr: |||
              sum without (cl_role,process_port,instance,rs_state) (increase(mongodb_electionMetrics_electionTimeout_called[5m])) > %(alertsHighTimeoutElections)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There is a high number of elections being called due to the primary node timing out.',
              description:
                (
                  'The number of elections being called due to the primary node timing out in replica set {{$labels.rs_m}} in cluster {{$labels.cl_name}} is {{printf "%%.0f" $value}} which is above the threshold of %(alertsHighTimeoutElections)s.'
                ) % $._config,
            },
          },
        ],
      },
    ],
  },
}
