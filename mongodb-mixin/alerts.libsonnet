{
  new(this): {
    local instanceLabel = this.config.instanceLabels[std.length(this.config.instanceLabels) - 1],
    local groupLabel = this.config.groupLabels[std.length(this.config.groupLabels) - 1],
    local agg = std.join(',', this.config.groupLabels + this.config.instanceLabels),
    local groupAgg = std.join(',', this.config.groupLabels),
    local signals = this.signals.alerts,
    groups+: [
      {
        name: 'MongodbAlerts',
        rules: [
          {
            alert: 'MongodbDown',
            expr: '(%s) == 0' % signals.mongodbUp.asRuleExpression(),
            'for': '5m',
            labels: { severity: 'critical' },
            annotations: {
              summary: 'MongoDB instance is down.',
              description: 'MongoDB instance {{ $labels.%s }} is down.' % instanceLabel,
            },
          },
          {
            alert: 'MongodbReplicaMemberUnhealthy',
            expr: '(%s) == 0' % signals.replicaMemberHealth.asRuleExpression(),
            labels: { severity: 'critical' },
            annotations: {
              summary: 'MongoDB replica member is unhealthy.',
              description: 'MongoDB replica member is unhealthy (instance {{ $labels.%s }}).' % instanceLabel,
            },
          },
          {
            alert: 'MongodbReplicationLag',
            expr: '(%s) > %s' % [
              signals.secondaryReplicationLag.asRuleExpression(),
              this.config.alertsCriticalReplicationLag,
            ],
            'for': '5m',
            labels: { severity: 'critical' },
            annotations: {
              summary: 'MongoDB replication lag is exceeding the threshold.',
              description: 'MongoDB replication lag is more than %ss (instance {{ $labels.%s }}).' % [
                this.config.alertsCriticalReplicationLag,
                instanceLabel,
              ],
            },
          },
          {
            alert: 'MongodbReplicationHeadroom',
            expr: |||
              (
                avg by (%(groupAgg)s) (%(oplogWindow)s)
                - (
                  avg by (%(groupAgg)s) (%(primaryOptime)s)
                  - avg(%(secondaryOptime)s)
                )
              ) <= 0
            ||| % {
              groupAgg: groupAgg,
              oplogWindow: signals.oplogWindow.asRuleExpression(),
              primaryOptime: signals.primaryOptime.asRuleExpression(),
              secondaryOptime: signals.secondaryOptime.asRuleExpression(),
            },
            'for': '5m',
            labels: { severity: 'critical' },
            annotations: {
              summary: 'MongoDB replication headroom is exceeding the threshold.',
              description: 'MongoDB replication headroom is <= 0 for {{ $labels.%s }}.' % groupLabel,
            },
          },
          {
            alert: 'MongodbNumberCursorsOpen',
            expr: '(%s) > %s' % [
              signals.cursorsOpenTotal.asRuleExpression(),
              this.config.alertsWarningCursorsOpen,
            ],
            'for': '2m',
            labels: { severity: 'warning' },
            annotations: {
              summary: 'MongoDB number of cursors open too high.',
              description: 'Too many cursors opened by MongoDB for clients (> %s) on {{ $labels.%s }}.' % [
                this.config.alertsWarningCursorsOpen,
                instanceLabel,
              ],
            },
          },
          {
            alert: 'MongodbCursorsTimeouts',
            expr: '(%s) > %s' % [
              signals.cursorTimeouts.asRuleExpression(),
              this.config.alertsWarningCursorsTimeouts,
            ],
            'for': '2m',
            labels: { severity: 'warning' },
            annotations: {
              summary: 'MongoDB cursors timeouts are exceeding the threshold.',
              description: 'Too many cursors are timing out on {{ $labels.%s }}.' % instanceLabel,
            },
          },
          {
            alert: 'MongodbTooManyConnections',
            expr: |||
              100 * sum by (%(agg)s) (%(current)s)
              / sum by (%(agg)s) (%(total)s) > %(threshold)s
            ||| % {
              agg: agg,
              current: signals.currentConnections.asRuleExpression(),
              total: signals.totalConnections.asRuleExpression(),
              threshold: this.config.alertsWarningConnectionUtilization,
            },
            'for': '2m',
            labels: { severity: 'warning' },
            annotations: {
              summary: 'MongoDB has too many connections.',
              description: 'Too many connections to MongoDB instance {{ $labels.%s }} (> %s%%).' % [
                instanceLabel,
                this.config.alertsWarningConnectionUtilization,
              ],
            },
          },
          {
            alert: 'MongodbVirtualMemoryUsage',
            expr: |||
              sum by (%(agg)s) (%(virtual)s)
              / sum by (%(agg)s) (%(mapped)s) > %(threshold)s
            ||| % {
              agg: agg,
              virtual: signals.virtualMemory.asRuleExpression(),
              mapped: signals.mappedMemory.asRuleExpression(),
              threshold: this.config.alertsWarningVirtualMemoryRatio,
            },
            'for': '5m',
            labels: { severity: 'warning' },
            annotations: {
              summary: 'MongoDB high memory usage.',
              description: 'MongoDB virtual memory usage is too high on {{ $labels.%s }}.' % instanceLabel,
            },
          },
          {
            alert: 'MongodbReadRequestsQueueingUp',
            expr: '(%s) > 0' % signals.readQueueDelta.asRuleExpression(),
            'for': '5m',
            labels: { severity: 'warning' },
            annotations: {
              summary: 'MongoDB read requests are queuing up.',
              description: 'MongoDB requests are queuing up on {{ $labels.%s }}.' % instanceLabel,
            },
          },
          {
            alert: 'MongodbWriteRequestsQueueingUp',
            expr: '(%s) > 0' % signals.writeQueueDelta.asRuleExpression(),
            'for': '5m',
            labels: { severity: 'warning' },
            annotations: {
              summary: 'MongoDB write requests are queueing up.',
              description: 'MongoDB write requests are queueing up on {{ $labels.%s }}.' % instanceLabel,
            },
          },
        ],
      },
    ],
  },
}
