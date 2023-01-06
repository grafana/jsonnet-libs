{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'OracleDBAlerts',
        rules: [
          {
            alert: 'OracledbReachingSessionLimit',
            expr: |||
              oracledb_resource_current_utilization{resource_name="sessions"} / oracledb_resource_limit_value{resource_name="sessions"} * 100 > %(alertsSessionThreshold)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'The number of processess being utilized exceeded %(alertsSessionThreshold)s%%.' % $._config,
              description:
                ('{{ printf "%%.2f" $value }}%% of sessions are being utilized which is above the ' +
                 'threshold %(alertsSessionThreshold)s%%. This could mean that {{$labels.instance}} is being overutilized.') % $._config,
            },
          },
          {
            alert: 'OracledbReachingProcessLimit',
            expr: |||
              oracledb_resource_current_utilization{resource_name="processes"} / oracledb_resource_limit_value{resource_name="processes"} * 100 > %(alertsProcessThreshold)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'The number of processess being utilized exceeded the threshold of %(alertsProcessThreshold)s%%.' % $._config,
              description:
                ('{{ printf "%%.2f" $value }} of processes are being utilized which is above the' +
                 'threshold %(alertsProcessThreshold)s%%. This could potentially mean that ' +
                 '{{$labels.instance}} runs out of processes it can spin up.') % $._config,
            },
          },
          {
            alert: 'OracledbTablespaceReachingCapacity',
            expr: |||
              oracledb_tablespace_bytes / oracledb_tablespace_max_bytes * 100 > %(alertsTablespaceThreshold)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'A tablespace is exceeding more than %(alertsTablespaceThreshold)s%% of its maximum allotted space.' % $._config,
              description:
                ('{{ printf "%%.2f" $value }}%% of bytes are being utilized by the tablespace {{$labels.tablespace}} on the instance {{$labels.instance}}, ' +
                 'which is above the threshold %(alertsTablespaceThreshold)s%%.') % $._config,
            },
          },
          {
            alert: 'OracledbFileDescriptorLimit',
            expr: |||
              process_open_fds / process_max_fds * 100 > %(alertsFileDescriptorThreshold)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'File descriptors usage is reaching its threshold of %(alertsFileDescriptorThreshold)s%%.' % $._config,
              description:
                ('{{ printf "%%.2f" $value }}%% of file descriptors are open on {{$labels.instance}}, which is above the ' +
                 'threshold %(alertsFileDescriptorThreshold)s%%.') % $._config,
            },
          },
        ],
      },
    ],
  },
}
