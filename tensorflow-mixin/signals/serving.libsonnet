local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  local groupAggListWithInstance = std.join(',', this.groupLabels) + (if std.length(this.instanceLabels) > 0 then ',' + std.join(',', this.instanceLabels) else '');
  local groupAggListWithoutInstance = std.join(',', this.groupLabels);
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    legendCustomTemplate: std.join(' ', std.map(function(label) '{{' + label + '}}', this.instanceLabels)),
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '5m',
    discoveryMetric: {
      prometheus: ':tensorflow:serving:request_count',
    },
    signals: {
      requestCount: {
        name: 'Model request rate',
        nameShort: 'Request rate',
        type: 'raw',
        description: 'Rate of requests over time for the selected model. Grouped by statuses.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'rate(:tensorflow:serving:request_count{%(queriesSelector)s, model_name=~"$model_name"}[$__rate_interval])',
          },
        },
      },
      requestLatency: {
        name: 'Model predict request latency',
        nameShort: 'Request latency',
        type: 'raw',
        description: 'Average request latency of predict requests for the selected model.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'increase(:tensorflow:serving:request_latency_sum{%(queriesSelector)s, model_name=~"$model_name"}[$__rate_interval])/increase(:tensorflow:serving:request_latency_count{%(queriesSelector)s, model_name=~"$model_name"}[$__rate_interval])',
          },
        },
      },
      runtimeLatency: {
        name: 'Model runtime latency',
        nameShort: 'Runtime latency',
        type: 'raw',
        description: 'Average runtime latency of predict requests for the selected model.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'increase(:tensorflow:serving:runtime_latency_sum{%(queriesSelector)s, model_name=~"$model_name"}[$__rate_interval])/increase(:tensorflow:serving:runtime_latency_count{%(queriesSelector)s, model_name=~"$model_name"}[$__rate_interval])',
          },
        },
      },
      batchQueuingLatency: {
        name: 'Batch queuing latency',
        nameShort: 'Batch latency',
        type: 'raw',
        description: 'Average batch queuing latency for the selected model.',
        unit: 'batches/s',
        sources: {
          prometheus: {
            expr: 'increase(:tensorflow:serving:batching_session:queuing_latency_sum{%(queriesSelector)s}[$__rate_interval])/increase(:tensorflow:serving:batching_session:queuing_latency_count{%(queriesSelector)s}[$__rate_interval])',
          },
        },
      },
      batchQueuingRate: {
        name: 'Batch queuing rate',
        nameShort: 'Batch rate',
        type: 'raw',
        description: 'Rate of batch queuing operations.',
        unit: 'batches/s',
        sources: {
          prometheus: {
            expr: 'rate(:tensorflow:serving:batching_session:queuing_latency_count{%(queriesSelector)s}[$__rate_interval])',
          },
        },
      },
    },
  }
