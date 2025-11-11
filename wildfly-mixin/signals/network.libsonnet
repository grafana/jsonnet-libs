// for Network related signals
function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '5m',
    discoveryMetric: {
      prometheus: 'wildfly_undertow_bytes_received_total_bytes',
    },
    signals: {
      networkReceivedThroughput: {
        name: 'Network received throughput',
        nameShort: 'Network received',
        type: 'counter',
        description: 'Throughput rate of data received over time',
        unit: 'binBps',
        sources: {
          prometheus: {
            expr: 'wildfly_undertow_bytes_received_total_bytes{%(queriesSelector)s,server=~"$server"}',
            legendCustomTemplate: '{{server}} - {{http_listener}}{{https_listener}}',
          },
        },
      },
      networkSentThroughput: {
        name: 'Network sent throughput',
        nameShort: 'Network sent',
        type: 'counter',
        description: 'Throughput rate of data sent over time',
        unit: 'binBps',
        sources: {
          prometheus: {
            expr: 'wildfly_undertow_bytes_sent_total_bytes{%(queriesSelector)s,server=~"$server"}',
            legendCustomTemplate: '{{server}} - {{http_listener}}{{https_listener}}',
          },
        },
      },
    },
  }
