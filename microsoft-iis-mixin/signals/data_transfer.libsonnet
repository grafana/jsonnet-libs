function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'none',
    aggFunction: 'sum',
    signals: {
      bytesSent: {
        name: 'Bytes sent per second',
        type: 'counter',
        description: 'The traffic sent by an IIS site.',
        unit: 'Bps',
        sources: {
          prometheus: {
            expr: 'windows_iis_sent_bytes_total{%(queriesSelector)s, site=~"$site"}',
            legendCustomTemplate: '{{instance}} - {{site}}',
          },
        },
      },

      bytesReceived: {
        name: 'Bytes received per second',
        type: 'counter',
        description: 'The traffic received by an IIS site.',
        unit: 'Bps',
        sources: {
          prometheus: {
            expr: 'windows_iis_received_bytes_total{%(queriesSelector)s, site=~"$site"}',
            legendCustomTemplate: '{{instance}} - {{site}}',
          },
        },
      },

      filesSent: {
        name: 'Files sent per second',
        type: 'counter',
        description: 'The files sent by an IIS site.',
        unit: 'files/s',
        sources: {
          prometheus: {
            expr: 'windows_iis_files_sent_total{%(queriesSelector)s, site=~"$site"}',
            legendCustomTemplate: '{{instance}} - {{site}}',
          },
        },
      },

      filesReceived: {
        name: 'Files received per second',
        type: 'counter',
        description: 'The files received by an IIS site.',
        unit: 'files/s',
        sources: {
          prometheus: {
            expr: 'windows_iis_files_received_total{%(queriesSelector)s, site=~"$site"}',
            legendCustomTemplate: '{{instance}} - {{site}}',
          },
        },
      },
    },
  }
