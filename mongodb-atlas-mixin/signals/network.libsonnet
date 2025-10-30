function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'group',
    aggFunction: 'sum',
    signals: {

      networkBytesIn: {
        name: 'Network bytes received',
        type: 'counter',
        description: 'Network bytes received.',
        unit: 'Bps',
        sources: {
          prometheus: {
            expr: 'mongodb_network_bytesIn{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{cl_name}} - received',
          },
        },
      },

      networkBytesOut: {
        name: 'Network bytes sent',
        type: 'counter',
        description: 'Network bytes sent.',
        unit: 'Bps',
        sources: {
          prometheus: {
            expr: 'mongodb_network_bytesOut{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{cl_name}} - sent',
          },
        },
      },

      networkBytesInByInstance: {
        name: 'Network bytes received by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Network bytes received per instance.',
        unit: 'Bps',
        sources: {
          prometheus: {
            expr: 'mongodb_network_bytesIn{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - received',
          },
        },
      },

      networkBytesOutByInstance: {
        name: 'Network bytes sent by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Network bytes sent per instance.',
        unit: 'Bps',
        sources: {
          prometheus: {
            expr: 'mongodb_network_bytesOut{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - sent',
          },
        },
      },

      networkRequests: {
        name: 'Network requests',
        type: 'counter',
        description: 'Number of network requests received.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'mongodb_network_numRequests{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{cl_name}}',
          },
        },
      },

      networkRequestsByInstance: {
        name: 'Network requests by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Number of network requests received per instance.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'mongodb_network_numRequests{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      networkSlowDNS: {
        name: 'Slow DNS operations',
        type: 'counter',
        description: 'Number of slow DNS operations (>1s).',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_network_numSlowDNSOperations{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{cl_name}} - DNS',
          },
        },
      },

      networkSlowSSL: {
        name: 'Slow SSL operations',
        type: 'counter',
        description: 'Number of slow SSL operations (>1s).',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_network_numSlowSSLOperations{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{cl_name}} - SSL',
          },
        },
      },

      networkSlowDNSByInstance: {
        name: 'Slow DNS operations by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Number of slow DNS operations (>1s) per instance.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_network_numSlowDNSOperations{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - DNS',
          },
        },
      },

      networkSlowSSLByInstance: {
        name: 'Slow SSL operations by instance',
        type: 'counter',
        aggLevel: 'none',
        description: 'Number of slow SSL operations (>1s) per instance.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_network_numSlowSSLOperations{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - SSL',
          },
        },
      },
    },
  }
