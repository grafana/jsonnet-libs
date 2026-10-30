local common = import './common.libsonnet';

function(this)
  // Only per-interface metrics have a device label; connections and conntrack don't.
  local deviceSources(expr, extra={}) =
    common.sources(std.strReplace(expr, '%(queriesSelector)s', '%(queriesSelector)s, ' + this.networkInterfaceSelector), extra);
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'instance',
    aggFunction: 'sum',
    discoveryMetric: common.discoveryMetric,
    signals: {
      networkIO: {
        name: 'Network traffic',
        nameShort: 'Traffic',
        type: 'counter',
        description: 'Bits received and transmitted per interface.',
        unit: 'bps',
        sources: deviceSources('system_network_io{%(queriesSelector)s}', { aggKeepLabels: ['device', 'direction'], exprWrappers: [['8 * (', ')']] }),
      },
      networkIOTotal: {
        name: 'Network traffic',
        nameShort: 'Traffic',
        type: 'counter',
        description: 'Bits received and transmitted across all interfaces.',
        unit: 'bps',
        sources: deviceSources('system_network_io{%(queriesSelector)s}', { exprWrappers: [['8 * (', ')']] }),
      },
      networkPackets: {
        name: 'Network packets',
        nameShort: 'Packets',
        type: 'counter',
        description: 'Packets received and transmitted per interface.',
        unit: 'pps',
        sources: deviceSources('system_network_packets{%(queriesSelector)s}', { aggKeepLabels: ['device', 'direction'] }),
      },
      networkErrors: {
        name: 'Network errors',
        nameShort: 'Errors',
        type: 'counter',
        description: 'Errored packets per interface.',
        unit: 'pps',
        sources: deviceSources('system_network_errors{%(queriesSelector)s}', { aggKeepLabels: ['device', 'direction'] }),
      },
      networkDropped: {
        name: 'Dropped packets',
        nameShort: 'Dropped',
        type: 'counter',
        description: 'Dropped packets per interface.',
        unit: 'pps',
        sources: deviceSources('system_network_dropped{%(queriesSelector)s}', { aggKeepLabels: ['device', 'direction'] }),
      },
      networkErrorsTotal: {
        name: 'Network errors',
        nameShort: 'Errors',
        type: 'counter',
        description: 'Errored packets across all interfaces.',
        unit: 'pps',
        sources: deviceSources('system_network_errors{%(queriesSelector)s}'),
      },
      networkDroppedTotal: {
        name: 'Dropped packets',
        nameShort: 'Dropped',
        type: 'counter',
        description: 'Dropped packets across all interfaces.',
        unit: 'pps',
        sources: deviceSources('system_network_dropped{%(queriesSelector)s}'),
      },
      networkConnections: {
        name: 'Network connections',
        nameShort: 'Connections',
        type: 'gauge',
        description: 'Open connections by state.',
        unit: 'short',
        sources: common.sources('system_network_connections{%(queriesSelector)s}', { aggKeepLabels: ['state'] }),
      },
      conntrackCount: {
        name: 'NF conntrack entries',
        nameShort: 'Entries',
        type: 'gauge',
        aggFunction: 'max',
        description: 'Entries in the connection tracking table.',
        unit: 'short',
        sources: common.sources('system_network_conntrack_count{%(queriesSelector)s}'),
      },
      conntrackMax: {
        name: 'NF conntrack limit',
        nameShort: 'Limit',
        type: 'gauge',
        aggFunction: 'max',
        description: 'Size limit of the connection tracking table.',
        unit: 'short',
        sources: common.sources('system_network_conntrack_max{%(queriesSelector)s}'),
      },
    },
  }
