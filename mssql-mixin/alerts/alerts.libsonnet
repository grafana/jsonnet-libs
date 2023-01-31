{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'MSSQLAlerts',
        rules: [
          {
            alert: 'MSSQLHighNumberOfDeadlocks',
            expr: |||
              increase(mssql_deadlocks_total{}[5m]) > %(alertsWarningDeadlocks5m)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There are deadlocks ocurring in the database.',
              description:
                ('{{ printf "%%.2f" $value }} deadlocks have ocurred over the last 5 minutes on {{$labels.instance}}, ' +
                 'which is above threshold of %(alertsWarningDeadlocks5m)s deadlocks.') % $._config,
            },
          },
          {
            alert: 'MSSQLModerateReadStallTime',
            expr: |||
              1000 * increase(mssql_io_stall_seconds_total{operation="read"}[5m]) > %(alertsWarningModerateReadStallTimeMS)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There is a moderate amount of IO stall for database reads.',
              description:
                ('{{ printf "%%.2f" $value }}ms of IO read stall has ocurred on {{$labels.instance}}, ' +
                 'which is above threshold of %(alertsWarningModerateReadStallTimeMS)sms.') % $._config,
            },
          },
          {
            alert: 'MSSQLHighReadStallTime',
            expr: |||
              1000 * increase(mssql_io_stall_seconds_total{operation="read"}[5m]) > %(alertsCriticalHighReadStallTimeMS)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There is a high amount of IO stall for database reads.',
              description:
                ('{{ printf "%%.2f" $value }}ms of IO read stall has ocurred on {{$labels.instance}}, ' +
                 'which is above threshold of %(alertsCriticalHighReadStallTimeMS)sms.') % $._config,
            },
          },
          {
            alert: 'MSSQLModerateWriteStallTime',
            expr: |||
              1000 * increase(mssql_io_stall_seconds_total{operation="write"}[5m]) > %(alertsWarningModerateWriteStallTimeMS)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There is a moderate amount of IO stall for database writes.',
              description:
                ('{{ printf "%%.2f" $value }}ms of IO write stall has ocurred on {{$labels.instance}}, ' +
                 'which is above threshold of %(alertsWarningModerateWriteStallTimeMS)sms.') % $._config,
            },
          },
          {
            alert: 'MSSQLHighWriteStallTime',
            expr: |||
              1000 * increase(mssql_io_stall_seconds_total{operation="write"}[5m]) > %(alertsCriticalHighWriteStallTimeMS)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There is a high amount of IO stall for database writes.',
              description:
                ('{{ printf "%%.2f" $value }}ms of IO write stall has ocurred on {{$labels.instance}}, ' +
                 'which is above threshold of %(alertsCriticalHighWriteStallTimeMS)sms.') % $._config,
            },
          },
        ],
      },
    ],
  },
}
