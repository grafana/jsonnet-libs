{
  new(this): {

    groups: [
      {
        name: 'alerts-' + this.config.uid,
        rules: [
          {
            alert: 'HighLatency',
            expr: |||
              100 - (avg (rate(azure_microsoft_cognitiveservices_accounts_latency{%(filteringSelector)s}[5m])) * 100) > %(alertsThresholdLatency)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'High latency for Azure OpenAI calls.',
              description: |||
                Latency for Azure OpenAI calls on {{ $labels.resourceName }} is greater than %(alertsThresholdLatency)s%%. The currect value is {{ $value | printf "%%.2f" }}.
              ||| % this.config,
            },
          },
          {
            alert: 'HighErrorRate',
            expr: |||
              100 - (avg (rate(azure_microsoft_cognitiveservices_accounts_successrate_average_percent{%(filteringSelector)s}[5m])) * 100) > %(alertsThresholdErrorRate)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'High error for Azure OpenAI calls.',
              description: |||
                Error rate for Azure OpenAI calls on {{ $labels.resourceName }} is greater than %(alertsThresholdErrorRate)s%%. The currect value is {{ $value | printf "%%.2f" }}.
              ||| % this.config,
            },
          },
        ],
      },
    ],
  },
}
