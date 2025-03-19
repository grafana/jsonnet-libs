{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'aerospike',
        rules: [
          {
            alert: 'AerospikeNodeHighMemoryUsage',
            expr: |||
              100 - sum without (service) (aerospike_node_stats_system_free_mem_pct) >= %(alertsCriticalNodeHighMemoryUsage)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There is a limited amount of memory available for a node.',
              description:
                (
                  '{{ printf "%%.0f" $value }} percent of system memory used on node {{$labels.instance}} on cluster {{$labels.aerospike_cluster}}, ' +
                  'which is above the threshold of %(alertsCriticalNodeHighMemoryUsage)s.'
                ) % $._config,
            },
          },
          {
            alert: 'AerospikeNamespaceHighDiskUsage',
            expr: |||
              100 - sum without (service) (aerospike_namespace_device_free_pct) >= %(alertsCriticalNamespaceHighDiskUsage)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There is a limited amount of disk space available for a node.',
              description:
                (
                  '{{ printf "%%.0f" $value }} percent of disk space available for namespace {{$labels.ns}} on node {{$labels.instance}}, on cluster {{$labels.aerospike_cluster}}, ' +
                  'which is above the threshold of %(alertsCriticalNamespaceHighDiskUsage)s.'
                ) % $._config,
            },
          },
          {
            alert: 'AerospikeUnavailablePartitions',
            expr: |||
              sum without(service) (aerospike_namespace_unavailable_partitions) > %(alertsCriticalUnavailablePartitions)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There are unavailable partitions in the Aerospike cluster.',
              description:
                (
                  '{{ printf "%%.0f" $value }} unavailable partition(s) in namespace {{$labels.ns}}, on node {{$labels.instance}}, on cluster {{$labels.aerospike_cluster}}, ' +
                  'which is above the threshold of %(alertsCriticalUnavailablePartitions)s.'
                ) % $._config,
            },
          },
          {
            alert: 'AerospikeDeadPartitions',
            expr: |||
              sum without(service) (aerospike_namespace_dead_partitions) > %(alertsCriticalDeadPartitions)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There are dead partitions in the Aerospike cluster.',
              description:
                (
                  '{{ printf "%%.0f" $value }} dead partition(s) in namespace {{$labels.ns}}, on node {{$labels.instance}}, on cluster {{$labels.aerospike_cluster}}, ' +
                  'which is above the threshold of %(alertsCriticalDeadPartitions)s.'
                ) % $._config,
            },
          },
          {
            alert: 'AerospikeNamespaceRejectingWrites',
            expr: |||
              sum without(service) (aerospike_namespace_stop_writes + aerospike_namespace_clock_skew_stop_writes) > %(alertsCriticalSystemRejectingWrites)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'A namespace is currently rejecting all writes. Check for unavailable/dead partitions, clock skew, or nodes running out of memory/disk.',
              description:
                (
                  'Namespace {{$labels.ns}} on node {{$labels.instance}} on cluster {{$labels.aerospike_cluster}} is currently rejecting all client-originated writes.'
                ) % $._config,
            },
          },
          {
            alert: 'AerospikeHighClientReadErrorRate',
            expr: |||
              sum without(service) (rate(aerospike_namespace_client_read_error[5m])) / (clamp_min(sum without(service) (rate(aerospike_namespace_client_read_error[5m])) + sum without(service) (rate(aerospike_namespace_client_read_success[5m])), 1)) > %(alertsWarningHighClientReadErrorRate)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There is a high rate of errors for client read transactions.',
              description:
                (
                  '{{ printf "%%.0f" $value }} percent of client read transactions are resulting in errors for namespace {{$labels.ns}}, on node {{$labels.instance}}, on cluster {{$labels.aerospike_cluster}}, ' +
                  'which is above the threshold of %(alertsWarningHighClientReadErrorRate)s.'
                ) % $._config,
            },
          },
          {
            alert: 'AerospikeHighClientWriteErrorRate',
            expr: |||
              sum without(service) (rate(aerospike_namespace_client_write_error[5m])) / (clamp_min(sum without(service) (rate(aerospike_namespace_client_write_error[5m])) + sum without(service) (rate(aerospike_namespace_client_write_success[5m])), 1)) > %(alertsWarningHighClientWriteErrorRate)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There is a high rate of errors for client write transactions.',
              description:
                (
                  '{{ printf "%%.0f" $value }} percent of client write transactions are resulting in errors for namespace {{$labels.ns}}, on node {{$labels.instance}}, on cluster {{$labels.aerospike_cluster}}, ' +
                  'which is above the threshold of %(alertsWarningHighClientWriteErrorRate)s.'
                ) % $._config,
            },
          },
          {
            alert: 'AerospikeHighClientUDFErrorRate',
            expr: |||
              sum without(service) (rate(aerospike_namespace_client_udf_error[5m])) / (clamp_min(sum without(service) (rate(aerospike_namespace_client_udf_error[5m])) + sum without(service) (rate(aerospike_namespace_client_udf_complete[5m])), 1)) > %(alertsWarningHighClientUDFErrorRate)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There is a high rate of errors for client UDF transactions.',
              description:
                (
                  '{{ printf "%%.0f" $value }} percent of client UDF transactions are resulting in errors for namespace {{$labels.ns}}, on node {{$labels.instance}}, on cluster {{$labels.aerospike_cluster}}, ' +
                  'which is above the threshold of %(alertsWarningHighClientUDFErrorRate)s.'
                ) % $._config,
            },
          },
        ],
      },
    ],
  },
}
