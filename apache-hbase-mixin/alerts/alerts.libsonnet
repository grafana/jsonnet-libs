{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'apache-hbase-alerts',
        rules: [
          {
            alert: 'HighHeapMemUsage',
            expr: |||
              100 * sum without(context, hostname, processname) (jvm_metrics_mem_heap_used_m / clamp_min(jvm_metrics_mem_heap_committed_m, 1))  > %(alertsHighHeapMemUsage)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There is a limited amount of heap memory available to the JVM.',
              description:
                (
                  'The heap memory usage for the JVM on instance {{$labels.instance}} in cluster {{$labels.hbase_cluster}} is {{printf "%%.0f" $labels.value}} percent, which is above the threshold of %(alertsHighHeapMemUsage)s'
                ) % $._config,
            },
          },
          {
            alert: 'HighNonHeapMemUsage',
            expr: |||
              100 * sum without(context, hostname, processname) (jvm_metrics_mem_non_heap_used_m / clamp_min(jvm_metrics_mem_non_heap_committed_m, 1))  > %(alertsHighNonHeapMemUsage)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There is a limited amount of non-heap memory available to the JVM.',
              description:
                (
                  'The non-heap memory usage for the JVM on instance {{$labels.instance}} in cluster {{$labels.hbase_cluster}} is {{printf "%%.0f" $labels.value}} percent, which is above the threshold of %(alertsHighNonHeapMemUsage)s'
                ) % $._config,
            },
          },
          {
            alert: 'DeadRegionServer',
            expr: |||
              server_num_dead_region_servers > %(alertsDeadRegionServer)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'One or more RegionServer(s) has become unresponsive.',
              description:
                (
                  '{{$labels.value}} RegionServer(s) in cluster {{$labels.hbase_cluster}} are unresponsive, which is above the threshold of %(alertsDeadRegionServer)s. The name(s) of the dead RegionServer(s) are {{$labels.deadregionservers}}'
                ) % $._config,
            },
          },
          {
            alert: 'OldRegionsInTransition',
            expr: |||
              100 * assignment_manager_rit_count_over_threshold / clamp_min(assignment_manager_rit_count, 1) > %(alertsOldRegionsInTransition)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'RegionServers are in transition for longer than expected.',
              description:
                (
                  '{{printf "%%.0f" $labels.value}} percent of RegionServers in transition in cluster {{$labels.hbase_cluster}} are transitioning for longer than expected, which is above the threshold of %(alertsOldRegionsInTransition)s'
                ) % $._config,
            },
          },
          {
            alert: 'HighMasterAuthFailRate',
            expr: |||
              100 * rate(master_authentication_failures[5m]) / (clamp_min(rate(master_authentication_successes[5m]), 1) + clamp_min(rate(master_authentication_failures[5m]), 1)) > %(alertsHighMasterAuthFailRate)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'A high percentage of authentication attempts to the master are failing.',
              description:
                (
                  '{{printf "%%.0f" $labels.value}} percent of authentication attempts to the master are failing in cluster {{$labels.hbase_cluster}}, which is above the threshold of %(alertsHighMasterAuthFailRate)s'
                ) % $._config,
            },
          },
          {
            alert: 'HighRSAuthFailRate',
            expr: |||
              100 * rate(region_server_authentication_failures[5m]) / (clamp_min(rate(region_server_authentication_successes[5m]), 1) + clamp_min(rate(region_server_authentication_failures[5m]), 1)) > %(alertsHighRSAuthFailRate)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'A high percentage of authentication attempts to a RegionServer are failing.',
              description:
                (
                  '{{printf "%%.0f" $labels.value}} percent of authentication attempts to the RegionServer {{$labels.instance}} are failing in cluster {{$labels.hbase_cluster}}, which is above the threshold of %(alertsHighRSAuthFailRate)s'
                ) % $._config,
            },
          },
        ],
      },
    ],
  },
}
