function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '2m',
    discoveryMetric: {
      prometheus: 'cloudflare_worker_requests_count',
    },
    signals: {
      cpuTime: {
        name: 'Worker CPU time',
        nameShort: 'CPU time',
        type: 'gauge',
        description: 'CPU time consumed by the worker.',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'cloudflare_worker_cpu_time{%(queriesSelector)s}',
            legendCustomTemplate: '{{ script_name }} - {{ quantile }}',
          },
        },
      },
      duration: {
        name: 'Worker duration',
        nameShort: 'Duration',
        type: 'gauge',
        description: 'Duration of worker execution.',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'cloudflare_worker_duration{%(queriesSelector)s}',
            legendCustomTemplate: '{{ script_name }} - {{ quantile }}',
          },
        },
      },
      requestsCount: {
        name: 'Worker requests',
        nameShort: 'Requests',
        type: 'counter',
        description: 'Number of requests to the worker.',
        unit: '/ sec',
        sources: {
          prometheus: {
            expr: 'cloudflare_worker_requests_count{%(queriesSelector)s}',
            legendCustomTemplate: '{{ script_name }}',
          },
        },
      },
      errorsCount: {
        name: 'Worker errors',
        nameShort: 'Errors',
        type: 'counter',
        description: 'Number of errors from the worker.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'cloudflare_worker_errors_count{%(queriesSelector)s}',
            legendCustomTemplate: '{{ script_name }}',
            rangeFunction: 'increase',
          },
        },
      },
    },
  }
