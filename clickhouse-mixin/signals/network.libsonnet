local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '2m',
    discoveryMetric: {
      prometheus: 'ClickHouseProfileEvents_NetworkReceiveBytes',
    },
    signals: {
      networkReceiveBytes: {
        name: 'Network received',
        nameShort: 'Net RX',
        type: 'counter',
        description: 'Received network throughput',
        unit: 'Bps',
        sources: {
          prometheus: {
            expr: 'ClickHouseProfileEvents_NetworkReceiveBytes{%(queriesSelector)s}',
            legendCustomTemplate: 'Network receive bytes',
            interval: '1m',
          },
        },
      },
      networkSendBytes: {
        name: 'Network transmitted',
        nameShort: 'Net TX',
        type: 'counter',
        description: 'Transmitted network throughput',
        unit: 'Bps',
        sources: {
          prometheus: {
            expr: 'ClickHouseProfileEvents_NetworkSendBytes{%(queriesSelector)s}',
            legendCustomTemplate: 'Network send bytes',
            interval: '1m',
          },
        },
      },
      networkReceiveLatency: {
        name: 'Network receive latency',
        nameShort: 'RX latency',
        type: 'counter',
        description: 'Latency of inbound network traffic',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'ClickHouseProfileEvents_NetworkReceiveElapsedMicroseconds{%(queriesSelector)s}',
            legendCustomTemplate: 'Network receive elapsed',
            interval: '1m',
          },
        },
      },
      networkSendLatency: {
        name: 'Network transmit latency',
        nameShort: 'TX latency',
        type: 'counter',
        description: 'Latency of outbound network traffic',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'ClickHouseProfileEvents_NetworkSendElapsedMicroseconds{%(queriesSelector)s}',
            legendCustomTemplate: 'Network send elapsed',
            interval: '1m',
          },
        },
      },
    },
  }
