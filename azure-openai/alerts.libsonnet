{
  new(this): {

    groups: [
      {
        name: 'helloworld-alerts-' + this.config.uid,
        rules: [
          {
            alert: 'HelloWorldAlert1',
            expr: |||
              100 - (avg without (mode, core) (rate(metric1{%(filteringSelector)s}[5m])) * 100) > %(alertsThreshold1)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Something bad happened.',
              description: |||
                Something bad happened on {{ $labels.instance }} and now above %(alertsThreshold1)s%%. The currect value is {{ $value | printf "%%.2f" }}.
              ||| % this.config,
            },
          },
          {
            alert: 'HelloWorldAlert2',
            expr: |||
              100 - ((metric2{%(filteringSelector)s}
              /
              metric3{%(filteringSelector)s}) * 100) > %(alertsThreshold2)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Something else detected.',
              description: |||
                Something else detected on {{ $labels.instance }}, is above %(alertsThreshold2)s%%. The current value is {{ $value | printf "%%.2f" }}.
              ||| % this.config,
            },
          },
        ],
      },
    ],
  },
}
