{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'TensorFlowAlerts',
        rules: [
          {
            alert: 'TensorFlowModelRequestHighErrorRate',
            expr: |||
              100 * sum(rate(:tensorflow:serving:request_count{status!="OK"}[5m])) by (instance) / sum(rate(:tensorflow:serving:request_count[5m])) by (instance) > %(alertsModelRequestErrorRate)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'More than %(alertsModelRequestErrorRate)s%% of all model requests are not successful.' % $._config,
              description:
                ('{{ printf "%%.2f" $value }}%% of all model requests are not successful, ' +
                 'which is above the threshold %(alertsModelRequestErrorRate)s%%, ' +
                 'indicating a potentially larger issue for {{$labels.instance}}') % $._config,
            },
          },
          {
            alert: 'TensorFlowHighBatchQueuingLatency',
            expr: |||
              increase(:tensorflow:serving:batching_session:queuing_latency_sum[2m]) / increase(:tensorflow:serving:batching_session:queuing_latency_count[2m]) > %(alertsBatchQueuingLatency)s
            ||| % $._config,
            'for': '1m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Batch queuing latency more than %(alertsBatchQueuingLatency)sµs.' % $._config,
              description:
                ('Batch queuing latency greater than {{ printf "%%.2f" $value }}µs, ' +
                 'which is above the threshold %(alertsBatchQueuingLatency)sµs, ' +
                 'indicating a potentially larger issue for {{$labels.instance}}') % $._config,
            },
          },
        ],
      },
    ],
  },
}
