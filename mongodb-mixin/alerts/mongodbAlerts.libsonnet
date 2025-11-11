local xtd = import 'github.com/jsonnet-libs/xtd/main.libsonnet';
{
  prometheusAlerts+:: {
    local config =
      $._config
      {
        agg: std.join(',', $._config.groupLabels + $._config.instanceLabels),
        aggCluster: std.join(',', $._config.groupLabels),
        instanceLabel: xtd.array.slice($._config.instanceLabels, -1)[0],
        groupLabel: xtd.array.slice($._config.groupLabels, -1)[0],

      },
    groups+: [
      {
        name: 'MongodbAlerts',
        rules: [
          {
            alert: 'MongodbDown',
            annotations: {
              summary: 'MongoDB instance is down.',
              description: 'MongoDB instance {{ $labels.%(instanceLabel)s }} is down.' % config,
            },
            expr: 'mongodb_up{%(filteringSelector)s} == 0' % config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
          },
          {
            alert: 'MongodbReplicaMemberUnhealthy',
            annotations: {
              description: 'MongoDB replica member is unhealthy (instance {{ $labels.%(instanceLabel)s }}).' % config,
              summary: 'MongoDB replica member is unhealthy.',
            },
            expr: 'mongodb_mongod_replset_member_health{%(filteringSelector)s} == 0' % config,
            labels: {
              severity: 'critical',
            },
          },
          {
            alert: 'MongodbReplicationLag',
            annotations: {
              description: 'MongoDB replication lag is more than 60s (instance {{ $labels.%(instanceLabel)s }})' % config,
              summary: 'MongoDB replication lag is exceeding the threshold.',
            },
            expr: 'mongodb_mongod_replset_member_replication_lag{state="SECONDARY", %(filteringSelector)s} > 60' % config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
          },
          {
            alert: 'MongodbReplicationHeadroom',
            annotations: {
              description: 'MongoDB replication headroom is <= 0 for {{ $labels.%(groupLabel)s }}.' % config,
              summary: 'MongoDB replication headroom is exceeding the threshold.',
            },
            expr: '(avg by (%(aggCluster)s) (mongodb_mongod_replset_oplog_tail_timestamp{%(filteringSelector)s} - mongodb_mongod_replset_oplog_head_timestamp{%(filteringSelector)s}) - (avg by (%(aggCluster)s) (mongodb_mongod_replset_member_optime_date{state="PRIMARY"}) - avg(mongodb_mongod_replset_member_optime_date{state="SECONDARY",%(filteringSelector)s}))) <= 0' % config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
          },
          {
            alert: 'MongodbNumberCursorsOpen',
            annotations: {
              description: 'Too many cursors opened by MongoDB for clients (> 10k) on {{ $labels.%(instanceLabel)s }}.' % config,
              summary: 'MongoDB number of cursors open too high.',
            },
            expr: 'mongodb_mongod_metrics_cursor_open{state="total", %(filteringSelector)s} > 10 * 1000' % config,
            'for': '2m',
            labels: {
              severity: 'warning',
            },
          },
          {
            alert: 'MongodbCursorsTimeouts',
            annotations: {
              description: 'Too many cursors are timing out on {{ $labels.%(instanceLabel)s }}.',
              summary: 'MongoDB cursors timeouts are exceeding the threshold.',
            },
            expr: 'increase(mongodb_mongod_metrics_cursor_timed_out_total{%(filteringSelector)s}[1m]) > 100' % config,
            'for': '2m',
            labels: {
              severity: 'warning',
            },
          },
          {
            alert: 'MongodbTooManyConnections',
            annotations: {
              description: 'Too many connections to MongoDB instance {{ $labels.%(instanceLabel)s }} (> 80%%).' % config,
              summary: 'MongoDB has too many connections.',
            },
            expr: 'avg by (%(agg)s) (rate(mongodb_connections{state="current",%(filteringSelector)s}[1m])) / avg by (%(agg)s) (sum (mongodb_connections) by (%(agg)s)) * 100 > 80' % config,
            'for': '2m',
            labels: {
              severity: 'warning',
            },
          },
          {
            alert: 'MongodbVirtualMemoryUsage',
            annotations: {
              description: 'MongoDB virtual memory usage is too high on {{ $labels.%(instanceLabel)s }}.' % config,
              summary: 'MongoDB high memory usage.',
            },
            expr: '(sum(mongodb_memory{type="virtual",%(filteringSelector)s}) by (%(agg)s) / sum(mongodb_memory{type="mapped",%(filteringSelector)s}) by (%(agg)s)) > 3' % config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
          },
          {
            alert: 'MongodbReadRequestsQueueingUp',
            annotations: {
              description: 'MongoDB requests are queuing up on {{ $labels.%(instanceLabel)s }}.' % config,
              summary: 'MongoDB read requests are queuing up.',
            },
            expr: 'delta(mongodb_mongod_global_lock_current_queue{type="reader",%(filteringSelector)s}[1m]) > 0' % config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
          },
          {
            alert: 'MongodbWriteRequestsQueueingUp',
            annotations: {
              description: 'MongoDB write requests are queueing up on {{ $labels.%(instanceLabel)s }}.' % config,
              summary: 'MongoDB write requests are queueing up.',
            },
            expr: 'delta(mongodb_mongod_global_lock_current_queue{type="writer",%(filteringSelector)s}[1m]) > 0' % config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
          },
        ],
      },
    ],
  },
}
