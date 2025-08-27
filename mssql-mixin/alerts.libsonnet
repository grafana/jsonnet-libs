{
  new(this): {
    groups: [
      {
        name: 'MSSQLAlerts',
        rules: [
          {
            alert: 'MSSQLHighNumberOfDeadlocks',
            expr: |||
              increase(mssql_deadlocks_total{}[5m]) > %(alertsWarningDeadlocks5m)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There are deadlocks occurring in the database.',
              description:
                ('{{ printf "%%.2f" $value }} deadlocks have occurred over the last 5 minutes on {{$labels.instance}}, ' +
                 'which is above threshold of %(alertsWarningDeadlocks5m)s deadlocks.') % this.config,
            },
          },
          {
            alert: 'MSSQLModerateReadStallTime',
            expr: |||
              1000 * increase(mssql_io_stall_seconds_total{operation="read"}[5m]) > %(alertsWarningModerateReadStallTimeMS)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There is a moderate amount of IO stall for database reads.',
              description:
                ('{{ printf "%%.2f" $value }}ms of IO read stall has occurred on {{$labels.instance}}, ' +
                 'which is above threshold of %(alertsWarningModerateReadStallTimeMS)sms.') % this.config,
            },
          },
          {
            alert: 'MSSQLHighReadStallTime',
            expr: |||
              1000 * increase(mssql_io_stall_seconds_total{operation="read"}[5m]) > %(alertsCriticalHighReadStallTimeMS)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There is a high amount of IO stall for database reads.',
              description:
                ('{{ printf "%%.2f" $value }}ms of IO read stall has occurred on {{$labels.instance}}, ' +
                 'which is above threshold of %(alertsCriticalHighReadStallTimeMS)sms.') % this.config,
            },
          },
          {
            alert: 'MSSQLModerateWriteStallTime',
            expr: |||
              1000 * increase(mssql_io_stall_seconds_total{operation="write"}[5m]) > %(alertsWarningModerateWriteStallTimeMS)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There is a moderate amount of IO stall for database writes.',
              description:
                ('{{ printf "%%.2f" $value }}ms of IO write stall has occurred on {{$labels.instance}}, ' +
                 'which is above threshold of %(alertsWarningModerateWriteStallTimeMS)sms.') % this.config,
            },
          },
          {
            alert: 'MSSQLHighWriteStallTime',
            expr: |||
              1000 * increase(mssql_io_stall_seconds_total{operation="write"}[5m]) > %(alertsCriticalHighWriteStallTimeMS)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There is a high amount of IO stall for database writes.',
              description:
                ('{{ printf "%%.2f" $value }}ms of IO write stall has occurred on {{$labels.instance}}, ' +
                 'which is above threshold of %(alertsCriticalHighWriteStallTimeMS)sms.') % this.config,
            },
          },
        ],
      },
    ],
  },
}
