local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'none',
    aggFunction: 'avg',
    signals: {
      tcpSentBytesTotal: {
        name: 'TCP bytes sent',
        nameShort: 'TCP sent',
        type: 'counter',
        description: 'Total bytes sent in TCP connections.',
        unit: 'binBps',
        sources: {
          prometheus: {
            expr: 'istio_tcp_sent_bytes_total{%(queriesSelector)s}',
          },
        },
      },

      tcpReceivedBytesTotal: {
        name: 'TCP bytes received',
        nameShort: 'TCP received',
        type: 'counter',
        description: 'Total bytes received in TCP connections.',
        unit: 'binBps',
        sources: {
          prometheus: {
            expr: 'istio_tcp_received_bytes_total{%(queriesSelector)s}',
          },
        },
      },
    },
  }
