{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'ApacheCouchDBAlerts',
        rules: [
          {
            alert: 'CouchDBUnhealthyCluster',
            expr: |||
              min by(job, couchdb_cluster) (couchdb_couch_replicator_cluster_is_stable) < %(alertsCriticalClusterIsUnstable5m)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'At least one of the nodes in a cluster is reporting the cluster as being unstable.',
              description:
                (
                  '{{$labels.couchdb_cluster}} has reported a value of {{ printf "%%.0f" $value }} for its stability over the last 5 minutes, ' +
                  'which is below the threshold of %(alertsCriticalClusterIsUnstable5m)s.'
                ) % $._config,
            },
          },
          {
            alert: 'CouchDBHigh4xxResponseCodes',
            expr: |||
              sum by(job, instance) (increase(couchdb_httpd_status_codes{code=~"4.*"}[5m])) > %(alertsWarning4xxResponseCodes5m)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There are a high number of 4xx responses for incoming requests to a node.',
              description:
                (
                  '{{ printf "%%.0f" $value }} 4xx responses have been detected over the last 5 minutes on {{$labels.instance}}, ' +
                  'which is above the threshold of %(alertsWarning4xxResponseCodes5m)s.'
                ) % $._config,
            },
          },
          {
            alert: 'CouchDBHigh5xxResponseCodes',
            expr: |||
              sum by(job, instance) (increase(couchdb_httpd_status_codes{code=~"5.*"}[5m])) > %(alertsCritical5xxResponseCodes5m)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There are a high number of 5xx responses for incoming requests to a node.',
              description:
                (
                  '{{ printf "%%.0f" $value }} 5xx responses have been detected over the last 5 minutes on {{$labels.instance}}, ' +
                  'which is above the threshold of %(alertsCritical5xxResponseCodes5m)s.'
                ) % $._config,
            },
          },
          {
            alert: 'CouchDBModerateRequestLatency',
            expr: |||
              sum by(job, instance) (couchdb_request_time_seconds_sum / couchdb_request_time_seconds_count) > %(alertsWarningRequestLatency5m)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There is a moderate level of request latency for a node.',
              description:
                (
                  'An average of {{ printf "%%.0f" $value }}ms of request latency has occurred over the last 5 minutes on {{$labels.instance}}, ' +
                  'which is above the threshold of %(alertsWarningRequestLatency5m)sms. '
                ) % $._config,
            },
          },
          {
            alert: 'CouchDBHighRequestLatency',
            expr: |||
              sum by(job, instance) (couchdb_request_time_seconds_sum / couchdb_request_time_seconds_count) > %(alertsCriticalRequestLatency5m)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There is a high level of request latency for a node.',
              description:
                (
                  'An average of {{ printf "%%.0f" $value }}ms of request latency has occurred over the last 5 minutes on {{$labels.instance}}, ' +
                  'which is above the threshold of %(alertsCriticalRequestLatency5m)sms. '
                ) % $._config,
            },
          },
          {
            alert: 'CouchDBManyReplicatorJobsPending',
            expr: |||
              sum by(job, instance) (couchdb_couch_replicator_jobs_pending) > %(alertsWarningPendingReplicatorJobs5m)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There is a high number of replicator jobs pending for a node.',
              description:
                (
                  '{{ printf "%%.0f" $value }} replicator jobs are pending on {{$labels.instance}}, ' +
                  'which is above the threshold of %(alertsWarningPendingReplicatorJobs5m)s. '
                ) % $._config,
            },
          },
          {
            alert: 'CouchDBReplicatorJobsCrashing',
            expr: |||
              sum by(job, instance) (increase(couchdb_couch_replicator_jobs_crashes_total[5m])) > %(alertsCriticalCrashingReplicatorJobs5m)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There are replicator jobs crashing for a node.',
              description:
                (
                  '{{ printf "%%.0f" $value }} replicator jobs have crashed over the last 5 minutes on {{$labels.instance}}, ' +
                  'which is above the threshold of %(alertsCriticalCrashingReplicatorJobs5m)s. '
                ) % $._config,
            },
          },
          {
            alert: 'CouchDBReplicatorChangesQueuesDying',
            expr: |||
              sum by(job, instance) (increase(couchdb_couch_replicator_changes_queue_deaths_total[5m])) > %(alertsWarningDyingReplicatorChangesQueues5m)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There are replicator changes queue process deaths for a node.',
              description:
                (
                  '{{ printf "%%.0f" $value }} replicator changes queue processes have died over the last 5 minutes on {{$labels.instance}}, ' +
                  'which is above the threshold of %(alertsWarningDyingReplicatorChangesQueues5m)s. '
                ) % $._config,
            },
          },
          {
            alert: 'CouchDBReplicatorConnectionOwnersCrashing',
            expr: |||
              sum by(job, instance) (increase(couchdb_couch_replicator_connection_owner_crashes_total[5m])) > %(alertsWarningCrashingReplicatorConnectionOwners5m)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There are replicator connection owner process crashes for a node.',
              description:
                (
                  '{{ printf "%%.0f" $value }} replicator connection owner processes have crashed over the last 5 minutes on {{$labels.instance}}, ' +
                  'which is above the threshold of %(alertsWarningCrashingReplicatorConnectionOwners5m)s. '
                ) % $._config,
            },
          },
          {
            alert: 'CouchDBReplicatorConnectionWorkersCrashing',
            expr: |||
              sum by(job, instance) (increase(couchdb_couch_replicator_connection_worker_crashes_total[5m])) > %(alertsWarningCrashingReplicatorConnectionWorkers5m)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There are replicator connection worker process crashes for a node.',
              description:
                (
                  '{{ printf "%%.0f" $value }} replicator connection worker processes have crashed over the last 5 minutes on {{$labels.instance}}, ' +
                  'which is above the threshold of %(alertsWarningCrashingReplicatorConnectionWorkers5m)s. '
                ) % $._config,
            },
          },
        ],
      },
    ],
  },
}
