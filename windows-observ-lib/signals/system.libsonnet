local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'avg',
    rangeFunction: 'irate',
    discoveryMetric: {
      prometheus: 'windows_os_info',
    },
    signals: {
      osInfo: {
        name: 'OS information',
        nameShort: 'OS info',
        type: 'info',
        description: 'Operating system information',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'windows_os_info{%(queriesSelector)s}',
            infoLabel: 'product',
          },
        },
      },
      uptime: {
        name: 'System uptime',
        nameShort: 'Uptime',
        type: 'raw',
        description: 'System uptime in seconds',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'time() - windows_system_system_up_time{%(queriesSelector)s}',
          },
        },
      },
      bootTime: {
        name: 'Boot time',
        nameShort: 'Boot time',
        type: 'gauge',
        description: 'System boot time',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'windows_system_system_up_time{%(queriesSelector)s}',
          },
        },
      },
      cpuCount: {
        name: 'CPU count',
        nameShort: 'Cores',
        type: 'gauge',
        description: 'Number of logical processors',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'windows_cs_logical_processors{%(queriesSelector)s}',
          },
        },
      },
      systemContextSwitches: {
        name: 'Context switches',
        nameShort: 'Context switches',
        type: 'counter',
        description: 'Number of context switches per second',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'windows_system_context_switches_total{%(queriesSelector)s}',
            legendCustomTemplate: 'Context switches',
          },
        },
      },
      systemInterrupts: {
        name: 'System interrupts',
        nameShort: 'Interrupts',
        type: 'raw',
        description: 'Number of system interrupts per second',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'sum without (core) (irate(windows_cpu_interrupts_total{%(queriesSelector)s}[%(interval)s]))',
            legendCustomTemplate: 'Interrupts',
          },
        },
      },
      systemExceptions: {
        name: 'System exceptions',
        nameShort: 'Exceptions',
        type: 'counter',
        description: 'Number of system exceptions per second',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'windows_system_exceptions_total{%(queriesSelector)s}',
          },
        },
      },
      systemCalls: {
        name: 'System calls',
        nameShort: 'Syscalls',
        type: 'counter',
        description: 'Number of system calls per second',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'windows_system_system_calls_total{%(queriesSelector)s}',
          },
        },
      },
      processorQueueLength: {
        name: 'Processor queue length',
        nameShort: 'Queue length',
        type: 'gauge',
        description: 'Average processor queue length',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'windows_system_processor_queue_length{%(queriesSelector)s}',
          },
        },
      },
      timeNtpStatus: {
        name: 'NTP status',
        nameShort: 'NTP status',
        type: 'gauge',
        description: 'Status of time synchronization',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'clamp_max(windows_time_ntp_client_time_sources{%(queriesSelector)s}, 1)',
            legendCustomTemplate: 'NTP status',
          },
        },
      },
      timeNtpDelay: {
        name: 'NTP delay',
        nameShort: 'NTP delay',
        type: 'gauge',
        description: 'Total roundtrip delay experienced by the NTP client in receiving a response from the server for the most recent request, in seconds',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'windows_time_ntp_round_trip_delay_seconds{%(queriesSelector)s}',
            legendCustomTemplate: 'NTP trip delay',
          },
        },
      },
      timeOffset: {
        name: 'Time offset',
        nameShort: 'Time offset',
        type: 'gauge',
        description: 'Absolute time offset between the system clock and the chosen time source, in seconds',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'windows_time_computed_time_offset_seconds{%(queriesSelector)s}',
            legendCustomTemplate: 'Time offset',
          },
        },
      },
      timeAdjustments: {
        name: 'Time adjustments',
        nameShort: 'Time adjustments',
        type: 'counter',
        description: 'Total adjustment made to the local system clock frequency by W32Time in parts per billion (PPB) units',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'windows_time_clock_frequency_adjustment_ppb_total{%(queriesSelector)s}',
            legendCustomTemplate: 'Time adjustments',
          },
        },
      },
      osTimezone: {
        name: 'OS timezone',
        nameShort: 'Timezone',
        type: 'info',
        description: 'Current system timezone',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'windows_os_timezone{%(queriesSelector)s}',
            infoLabel: 'timezone',
          },
        },
      },
    },
  } 