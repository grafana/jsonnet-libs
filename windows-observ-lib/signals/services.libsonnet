local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'avg',
    discoveryMetric: {
      prometheus: 'windows_service_status',
    },
    signals: {
      serviceStatus: {
        name: 'Service status',
        nameShort: 'Status',
        type: 'gauge',
        description: 'Windows service status',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'windows_service_status{%(queriesSelector)s}',
            legendCustomTemplate: '{{ name }}',
            valueMappings: [
              {
                type: 'value',
                options: {
                  '1': {
                    text: 'OK',
                    color: 'light-green',
                    index: 1,
                  },
                  '0': {
                    text: 'Not OK',
                    color: 'light-red',
                    index: 0,
                  },
                }
              },
            ],
          },
        },
      },
      serviceNotHealthy: {
        name: 'Service not healthy',
        nameShort: 'Not healthy',
        type: 'gauge',
        description: 'Services not in healthy state',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'windows_service_status{status!~"starting|stopping|ok", %(queriesSelector)s}',
            legendCustomTemplate: '{{ name }} ({{ status }})',
          },
        },
      },

      ntpDelay: {
        name: 'NTP round trip delay',
        nameShort: 'NTP delay',
        type: 'gauge',
        description: 'NTP round trip delay in seconds',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'windows_time_ntp_round_trip_delay_seconds{%(queriesSelector)s}',
          },
        },
      },
      ntpTimeOffset: {
        name: 'NTP time offset',
        nameShort: 'NTP offset',
        type: 'gauge',
        description: 'NTP computed time offset in seconds',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'windows_time_computed_time_offset_seconds{%(queriesSelector)s}',
          },
        },
      },
    },
  } 