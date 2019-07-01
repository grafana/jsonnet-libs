local g = (import 'grafana-builder/grafana.libsonnet') + {
  qpsPanelErrTotal(selectorErr, selectorTotal):: {
    local expr(selector) = 'sum(rate(' + selector + '[1m]))',

    aliasColors: {
      success: '#7EB26D',
      'error': '#E24D42',
    },
    targets: [
      {
        expr: expr(selectorErr),
        format: 'time_series',
        intervalFactor: 2,
        legendFormat: 'error',
        refId: 'A',
        step: 10,
      },
      {
        expr: expr(selectorTotal) + ' - ' + expr(selectorErr),
        format: 'time_series',
        intervalFactor: 2,
        legendFormat: 'success',
        refId: 'B',
        step: 10,
      },
    ],
  } + $.stack,
};

{
  dashboards+: {
    'jaeger-write.json':
      g.dashboard('Jaeger / Write')
      .addRow(
        g.row('Services')
        .addPanel(
          g.panel('span creation rate') +
          g.qpsPanelErrTotal('jaeger_reporter_spans{result=~"dropped|err"}', 'jaeger_reporter_spans') +
          g.stack
        )
        .addPanel(
          g.panel('% spans dropped') +
          g.queryPanel('sum(rate(jaeger_reporter_spans{result=~"dropped|err"}[1m])) by (namespace) / scalar(sum(rate(jaeger_reporter_spans[1m])))', '{{namespace}}') +
          { yaxes: g.yaxes({ format: 'percentunit', max: 1 }) } +
          g.stack
        )
      )
      .addRow(
        g.row('Agent')
        .addPanel(
          g.panel('batch ingest rate') +
          g.qpsPanelErrTotal('jaeger_agent_reporter_batches_failures_total', 'jaeger_agent_reporter_batches_submitted_total') +
          g.stack
        )
        .addPanel(
          g.panel('% batches dropped') +
          g.queryPanel('sum(rate(jaeger_agent_reporter_batches_failures_total[1m])) by (cluster) / scalar(sum(rate(jaeger_agent_reporter_batches_submitted_total[1m])))', '{{cluster}}') +
          { yaxes: g.yaxes({ format: 'percentunit', max: 1 }) } +
          g.stack
        )
      )
      .addRow(
        g.row('Collector')
        .addPanel(
          g.panel('span ingest rate') +
          g.qpsPanelErrTotal('jaeger_collector_spans_dropped_total', 'jaeger_collector_spans_received_total') +
          g.stack
        )
        .addPanel(
          g.panel('% spans dropped') +
          g.queryPanel('sum(rate(jaeger_collector_spans_dropped_total[1m])) by (instance) / scalar(sum(rate(jaeger_collector_spans_received_total[1m])))', '{{instance}}') +
          { yaxes: g.yaxes({ format: 'percentunit', max: 1 }) } +
          g.stack
        )
      )
      .addRow(
        g.row('Collector - Queue Stats')
        .addPanel(
          g.panel('span queue length') +
          g.queryPanel('jaeger_collector_queue_length', '{{instance}}') +
          g.stack
        )
        .addPanel(
          g.panel('span queue time - 95 percentile') +
          g.queryPanel('histogram_quantile(0.95, sum(rate(jaeger_collector_in_queue_latency_bucket[1m])) by (le, instance))', '{{instance}}')
        )
      )
      .addRow(
        g.row('Cassandra')
        .addPanel(
          g.panel('insert attempt rate') +
          g.qpsPanelErrTotal('jaeger_cassandra_errors_total', 'jaeger_cassandra_attempts_total') +
          g.stack
        )
        .addPanel(
          g.panel('% inserts erroring') +
          g.queryPanel('sum(rate(jaeger_cassandra_errors_total[1m])) by (instance) / sum(rate(jaeger_cassandra_attempts_total[1m])) by (instance)', '{{instance}}') +
          { yaxes: g.yaxes({ format: 'percentunit', max: 1 }) } +
          g.stack,
        )
      ),

    'jaeger-read.json':
      g.dashboard('Jaeger / Read')
      .addRow(
        g.row('Query')
        .addPanel(
          g.panel('qps') +
          g.qpsPanelErrTotal('jaeger_query_requests_total{result="err"}', 'jaeger_query_requests_total') +
          g.stack
        )
        .addPanel(
          g.panel('latency - 99 percentile') +
          g.queryPanel('histogram_quantile(0.99, sum(rate(jaeger_query_latency_bucket[1m])) by (le, instance))', '{{instance}}') +
          g.stack
        )
      )
      .addRow(
        g.row('Cassandra')
        .addPanel(
          g.panel('qps') +
          g.qpsPanelErrTotal('jaeger_cassandra_read_errors_total', 'jaeger_cassandra_read_attempts_total') +
          g.stack
        )
        .addPanel(
          g.panel('latency - 99 percentile') +
          g.queryPanel('histogram_quantile(0.99, sum(rate(jaeger_cassandra_read_latency_ok_bucket[1m])) by (le, instance))', '{{instance}}') +
          g.stack,
        )
      ),
  },
}
