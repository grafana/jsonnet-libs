{
  new(this): {
    groups+: [
      {
        name: 'MongodbAlerts',
        rules: [
          {
            alert: 'MongodbDown',
            annotations: {
              summary: 'MongoDB instance is down.',
              description: 'MongoDB instance {{ $labels.%(instanceLabel)s }} is down.' % this.config {
                instanceLabel: this.config.instanceLabels[std.length(this.config.instanceLabels) - 1],
              },
            },
            expr: 'mongodb_up{%(filteringSelector)s} == 0' % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
          },
          {
            alert: 'MongodbReplicaMemberUnhealthy',
            annotations: {
              summary: 'MongoDB replica member is unhealthy.',
              description: 'MongoDB replica member is unhealthy (instance {{ $labels.%(instanceLabel)s }}).' % this.config {
                instanceLabel: this.config.instanceLabels[std.length(this.config.instanceLabels) - 1],
              },
            },
            expr: 'mongodb_mongod_replset_member_health{%(filteringSelector)s} == 0' % this.config,
            labels: {
              severity: 'critical',
            },
          },
          {
            alert: 'MongodbReplicationLag',
            annotations: {
              summary: 'MongoDB replication lag is exceeding the threshold.',
              description: 'MongoDB replication lag is more than %(alertsCriticalReplicationLag)ss (instance {{ $labels.%(instanceLabel)s }}).' % this.config {
                instanceLabel: this.config.instanceLabels[std.length(this.config.instanceLabels) - 1],
              },
            },
            expr: 'mongodb_mongod_replset_member_replication_lag{state="SECONDARY", %(filteringSelector)s} > %(alertsCriticalReplicationLag)s' % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
          },
          {
            local aggCluster = std.join(',', this.config.groupLabels),
            local groupLabel = this.config.groupLabels[std.length(this.config.groupLabels) - 1],
            alert: 'MongodbReplicationHeadroom',
            annotations: {
              summary: 'MongoDB replication headroom is exceeding the threshold.',
              description: 'MongoDB replication headroom is <= 0 for {{ $labels.%s }}.' % groupLabel,
            },
            expr: '(avg by (%(aggCluster)s) (mongodb_mongod_replset_oplog_tail_timestamp{%(filteringSelector)s} - mongodb_mongod_replset_oplog_head_timestamp{%(filteringSelector)s}) - (avg by (%(aggCluster)s) (mongodb_mongod_replset_member_optime_date{state="PRIMARY"}) - avg(mongodb_mongod_replset_member_optime_date{state="SECONDARY",%(filteringSelector)s}))) <= 0' % this.config { aggCluster: aggCluster },
            'for': '5m',
            labels: {
              severity: 'critical',
            },
          },
          {
            alert: 'MongodbNumberCursorsOpen',
            annotations: {
              summary: 'MongoDB number of cursors open too high.',
              description: 'Too many cursors opened by MongoDB for clients (> %(alertsWarningCursorsOpen)s) on {{ $labels.%(instanceLabel)s }}.' % this.config {
                instanceLabel: this.config.instanceLabels[std.length(this.config.instanceLabels) - 1],
              },
            },
            expr: 'mongodb_mongod_metrics_cursor_open{state="total", %(filteringSelector)s} > %(alertsWarningCursorsOpen)s' % this.config,
            'for': '2m',
            labels: {
              severity: 'warning',
            },
          },
          {
            alert: 'MongodbCursorsTimeouts',
            annotations: {
              summary: 'MongoDB cursors timeouts are exceeding the threshold.',
              description: 'Too many cursors are timing out on {{ $labels.%(instanceLabel)s }}.' % this.config {
                instanceLabel: this.config.instanceLabels[std.length(this.config.instanceLabels) - 1],
              },
            },
            expr: 'increase(mongodb_mongod_metrics_cursor_timed_out_total{%(filteringSelector)s}[1m]) > %(alertsWarningCursorsTimeouts)s' % this.config,
            'for': '2m',
            labels: {
              severity: 'warning',
            },
          },
          {
            local agg = std.join(',', this.config.groupLabels + this.config.instanceLabels),
            alert: 'MongodbTooManyConnections',
            annotations: {
              summary: 'MongoDB has too many connections.',
              description: 'Too many connections to MongoDB instance {{ $labels.%(instanceLabel)s }} (> %(alertsWarningConnectionUtilization)s%%%%).' % this.config {
                instanceLabel: this.config.instanceLabels[std.length(this.config.instanceLabels) - 1],
              },
            },
            expr: 'avg by (%(agg)s) (rate(mongodb_connections{state="current",%(filteringSelector)s}[1m])) / avg by (%(agg)s) (sum (mongodb_connections) by (%(agg)s)) * 100 > %(alertsWarningConnectionUtilization)s' % this.config { agg: agg },
            'for': '2m',
            labels: {
              severity: 'warning',
            },
          },
          {
            local agg = std.join(',', this.config.groupLabels + this.config.instanceLabels),
            alert: 'MongodbVirtualMemoryUsage',
            annotations: {
              summary: 'MongoDB high memory usage.',
              description: 'MongoDB virtual memory usage is too high on {{ $labels.%(instanceLabel)s }}.' % this.config {
                instanceLabel: this.config.instanceLabels[std.length(this.config.instanceLabels) - 1],
              },
            },
            expr: '(sum(mongodb_memory{type="virtual",%(filteringSelector)s}) by (%(agg)s) / sum(mongodb_memory{type="mapped",%(filteringSelector)s}) by (%(agg)s)) > %(alertsWarningVirtualMemoryRatio)s' % this.config { agg: agg },
            'for': '5m',
            labels: {
              severity: 'warning',
            },
          },
          {
            alert: 'MongodbReadRequestsQueueingUp',
            annotations: {
              summary: 'MongoDB read requests are queuing up.',
              description: 'MongoDB requests are queuing up on {{ $labels.%(instanceLabel)s }}.' % this.config {
                instanceLabel: this.config.instanceLabels[std.length(this.config.instanceLabels) - 1],
              },
            },
            expr: 'delta(mongodb_mongod_global_lock_current_queue{type="reader",%(filteringSelector)s}[1m]) > 0' % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
          },
          {
            alert: 'MongodbWriteRequestsQueueingUp',
            annotations: {
              summary: 'MongoDB write requests are queueing up.',
              description: 'MongoDB write requests are queueing up on {{ $labels.%(instanceLabel)s }}.' % this.config {
                instanceLabel: this.config.instanceLabels[std.length(this.config.instanceLabels) - 1],
              },
            },
            expr: 'delta(mongodb_mongod_global_lock_current_queue{type="writer",%(filteringSelector)s}[1m]) > 0' % this.config,
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
