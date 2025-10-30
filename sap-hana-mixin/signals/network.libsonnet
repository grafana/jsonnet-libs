local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'sum',
    signals: {
      network_receive_rate_kb_per_seconds: {
        name: 'Network receive rate',
        type: 'gauge',
        aggLevel: 'none',
        description: 'Network receive rate in KB/s.',
        unit: 'KBs',
        sources: {
          prometheus: {
            expr: 'sum by (job, sid, host) (hanadb_network_receive_rate_kb_per_seconds{%(queriesSelector)s})',
            legendCustomTemplate: '{{host}} - receive',
          },
        },
      },

      network_receive_rate_kb_per_seconds_by_interface: {
        name: 'Network receive rate by interface',
        type: 'gauge',
        aggLevel: 'none',
        description: 'Network receive rate by interface in KB/s.',
        unit: 'KBs',
        sources: {
          prometheus: {
            expr: 'sum by (job, sid, host, interface) (hanadb_network_receive_rate_kb_per_seconds{%(queriesSelector)s})',
            legendCustomTemplate: '{{host}} - {{interface}} - receive',
          },
        },
      },

      network_transmission_rate_kb_per_seconds: {
        name: 'Network transmission rate',
        type: 'gauge',
        aggLevel: 'none',
        description: 'Network transmission rate in KB/s.',
        unit: 'KBs',
        sources: {
          prometheus: {
            expr: 'sum by (job, sid, host) (hanadb_network_transmission_rate_kb_per_seconds{%(queriesSelector)s})',
            legendCustomTemplate: '{{host}} - transmit',
          },
        },
      },

      network_transmission_rate_kb_per_seconds_by_interface: {
        name: 'Network transmission rate by interface',
        type: 'gauge',
        aggLevel: 'none',
        description: 'Network transmission rate by interface in KB/s.',
        unit: 'KBs',
        sources: {
          prometheus: {
            expr: 'sum by (job, sid, host, interface) (hanadb_network_transmission_rate_kb_per_seconds{%(queriesSelector)s})',
            legendCustomTemplate: '{{host}} - {{interface}} - transmit',
          },
        },
      },
    },
  }
