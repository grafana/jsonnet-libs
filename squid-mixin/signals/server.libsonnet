function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'avg',
    signals: {

      ftpRequests: {
        name: 'Server FTP requests',
        type: 'counter',
        unit: 'reqps',
        description: 'The number of FTP server requests.',
        sources: {
          prometheus: {
            expr: 'squid_server_ftp_requests_total{%(queriesSelector)s}',
            legendCustomTemplate: 'FTP',
          },
        },
      },

      httpRequests: {
        name: 'Server HTTP requests',
        type: 'counter',
        unit: 'reqps',
        description: 'The number of HTTP server requests.',
        sources: {
          prometheus: {
            expr: 'squid_server_http_requests_total{%(queriesSelector)s}',
            legendCustomTemplate: 'HTTP',
          },
        },
      },

      otherRequests: {
        name: 'Server other requests',
        type: 'counter',
        unit: 'reqps',
        description: 'The number of other server requests.',
        sources: {
          prometheus: {
            expr: 'squid_server_other_requests_total{%(queriesSelector)s}',
            legendCustomTemplate: 'other',
          },
        },
      },

      ftpErrors: {
        name: 'Server FTP errors',
        type: 'counter',
        unit: 'errors/s',
        description: 'The number of FTP server request errors.',
        sources: {
          prometheus: {
            expr: 'squid_server_ftp_errors_total{%(queriesSelector)s}',
            legendCustomTemplate: 'FTP',
          },
        },
      },

      httpErrors: {
        name: 'Server HTTP errors',
        type: 'counter',
        unit: 'errors/s',
        description: 'The number of HTTP server request errors.',
        sources: {
          prometheus: {
            expr: 'squid_server_http_errors_total{%(queriesSelector)s}',
            legendCustomTemplate: 'HTTP',
          },
        },
      },

      otherErrors: {
        name: 'Server other errors',
        type: 'counter',
        unit: 'errors/s',
        description: 'The number of other server request errors.',
        sources: {
          prometheus: {
            expr: 'squid_server_other_errors_total{%(queriesSelector)s}',
            legendCustomTemplate: 'other',
          },
        },
      },

      ftpSentThroughput: {
        name: 'Server FTP sent throughput',
        type: 'counter',
        unit: 'KBs',
        description: 'The throughput of FTP server data sent.',
        sources: {
          prometheus: {
            expr: 'squid_server_ftp_kbytes_out_kbytes_total{%(queriesSelector)s}',
            legendCustomTemplate: 'FTP',
          },
        },
      },

      httpSentThroughput: {
        name: 'Server HTTP sent throughput',
        type: 'counter',
        unit: 'KBs',
        description: 'The throughput of HTTP server data sent.',
        sources: {
          prometheus: {
            expr: 'squid_server_http_kbytes_out_kbytes_total{%(queriesSelector)s}',
            legendCustomTemplate: 'HTTP',
          },
        },
      },

      otherSentThroughput: {
        name: 'Server other sent throughput',
        type: 'counter',
        unit: 'KBs',
        description: 'The throughput of other server data sent.',
        sources: {
          prometheus: {
            expr: 'squid_server_other_kbytes_out_kbytes_total{%(queriesSelector)s}',
            legendCustomTemplate: 'other',
          },
        },
      },

      swapIns: {
        name: 'Server object swap ins',
        type: 'counter',
        unit: 'cps',
        description: 'The number of objects read from disk.',
        sources: {
          prometheus: {
            expr: 'squid_swap_ins_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}} - read',
          },
        },
      },

      swapOuts: {
        name: 'Server object swap outs',
        type: 'counter',
        unit: 'cps',
        description: 'The number of objects saved to disk.',
        sources: {
          prometheus: {
            expr: 'squid_swap_outs_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}} - saved',
          },
        },
      },

      ftpReceivedThroughput: {
        name: 'Server FTP received throughput',
        type: 'counter',
        unit: 'KBs',
        description: 'The throughput of FTP server data received.',
        sources: {
          prometheus: {
            expr: 'squid_server_ftp_kbytes_in_kbytes_total{%(queriesSelector)s}',
            legendCustomTemplate: 'FTP',
          },
        },
      },

      httpReceivedThroughput: {
        name: 'Server HTTP received throughput',
        type: 'counter',
        unit: 'KBs',
        description: 'The throughput of HTTP server data received.',
        sources: {
          prometheus: {
            expr: 'squid_server_http_kbytes_in_kbytes_total{%(queriesSelector)s}',
            legendCustomTemplate: 'HTTP',
          },
        },
      },

      otherReceivedThroughput: {
        name: 'Server other received throughput',
        type: 'counter',
        unit: 'KBs',
        description: 'The throughput of other server data received.',
        sources: {
          prometheus: {
            expr: 'squid_server_other_kbytes_in_kbytes_total{%(queriesSelector)s}',
            legendCustomTemplate: 'other',
          },
        },
      },
    },
  }
