local g = import './g.libsonnet';
local prometheusQuery = g.query.prometheus;
local lokiQuery = g.query.loki;

{
  new(this): {
    local variables = this.variables,
    local config = this.config,
    uptimeQuery:: 'windows_system_system_up_time',

    reboot:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        self.uptimeQuery + '{%(queriesSelector)s}*1000 > $__from < $__to' % variables,
      ),
    serviceFailed:
      lokiQuery.new(
        '${' + variables.datasources.loki.name + '}',
        '{%(queriesSelector)s, source="Service Control Manager", level="Error"} |= "terminated" | json' % variables
      ),
    // those events should be rare, so can be shown as annotations
    criticalEvents:
      lokiQuery.new(
        '${' + variables.datasources.loki.name + '}',
        '{%(queriesSelector)s, channel="System", level="Critical"} | json' % variables
      ),
    alertsCritical:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        'count by (%(instanceLabels)s) (max_over_time(ALERTS{%(queriesSelector)s, alertstate="firing", severity="critical"}[1m])) * group by (%(instanceLabels)s) (windows_os_info{%(queriesSelector)s})' % variables { instanceLabels: std.join(',', this.config.instanceLabels) },
      ),
    alertsWarning:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        'count by (%(instanceLabels)s) (max_over_time(ALERTS{%(queriesSelector)s, alertstate="firing", severity="warning"}[1m])) * group by (%(instanceLabels)s) (windows_os_info{%(queriesSelector)s})' % variables { instanceLabels: std.join(',', this.config.instanceLabels) },
      ),

    uptime:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        'time() - ' + self.uptimeQuery + '{%(queriesSelector)s}' % variables
      ),
    cpuCount:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        'windows_cs_logical_processors{%(queriesSelector)s}' % variables
      ),
    cpuUsage:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        '100 - (avg without (mode,core) (rate(windows_cpu_time_total{mode="idle", %(queriesSelector)s}[$__rate_interval])*100))' % variables
      )
      + prometheusQuery.withLegendFormat('CPU usage'),
    cpuUsageByMode:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        |||
          sum by(instance, mode) (irate(windows_cpu_time_total{%(queriesSelector)s}[$__rate_interval])) 
          / on(instance) 
          group_left sum by (instance) ((irate(windows_cpu_time_total{%(queriesSelector)s}[$__rate_interval]))) * 100
        ||| % variables
      )
      + prometheusQuery.withLegendFormat('{{ mode }}'),

    // https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-2000-server/cc940375(v=technet.10)?redirectedfrom=MSDN
    cpuQueue:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        |||
          windows_system_processor_queue_length{%(queriesSelector)s}
        ||| % variables
      )
      + prometheusQuery.withLegendFormat('CPU average queue'),

    memoryTotalBytes:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        'windows_cs_physical_memory_bytes{%(queriesSelector)s}' % variables
      )
      + prometheusQuery.withLegendFormat('Memory total'),
    memoryFreeBytes:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        'windows_os_physical_memory_free_bytes{%(queriesSelector)s}' % variables
      )
      + prometheusQuery.withLegendFormat('Memory free'),
    memoryUsedBytes:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        'windows_cs_physical_memory_bytes{%(queriesSelector)s} - windows_os_physical_memory_free_bytes{%(queriesSelector)s}' % variables
      )
      + prometheusQuery.withLegendFormat('Memory used'),
    memoryUsagePercent:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        '100 - windows_os_physical_memory_free_bytes{%(queriesSelector)s} / windows_cs_physical_memory_bytes{%(queriesSelector)s} * 100' % variables
      ),
    memoryPageTotalBytes:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        'windows_os_paging_limit_bytes{%(queriesSelector)s}' % variables
      ),
    diskTotal:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        'windows_logical_disk_size_bytes{volume!~"%(ignoreVolumes)s", %(queriesSelector)s}' % variables { ignoreVolumes: config.ignoreVolumes }
      ),
    diskTotalC:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        'windows_logical_disk_size_bytes{volume="C:", %(queriesSelector)s}' % variables
      ),
    diskUsageC:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        'windows_logical_disk_size_bytes{volume="C:", %(queriesSelector)s}-windows_logical_disk_free_bytes{volume="C:", %(queriesSelector)s}' % variables
      ),
    diskUsageCPercent:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        '100 - windows_logical_disk_free_bytes{volume="C:", %(queriesSelector)s}/windows_logical_disk_size_bytes{volume="C:", %(queriesSelector)s}*100' % variables
      ),
    diskUsage:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        'windows_logical_disk_size_bytes{volume!~"%(ignoreVolumes)s", %(queriesSelector)s}-windows_logical_disk_free_bytes{volume!~"%(ignoreVolumes)s", %(queriesSelector)s}' % variables { ignoreVolumes: config.ignoreVolumes }
      ),
    diskUsagePercent:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        '100 - windows_logical_disk_free_bytes{volume!~"%(ignoreVolumes)s", %(queriesSelector)s}/windows_logical_disk_size_bytes{volume!~"%(ignoreVolumes)s", %(queriesSelector)s}*100' % variables { ignoreVolumes: config.ignoreVolumes }
      ),
    diskIOreadBytesPerSec:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        'irate(windows_logical_disk_read_bytes_total{volume!~"%(ignoreVolumes)s", %(queriesSelector)s}[$__rate_interval])' % variables { ignoreVolumes: config.ignoreVolumes }
      )
      + prometheusQuery.withLegendFormat('{{ volume }} read'),
    diskIOwriteBytesPerSec:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        'irate(windows_logical_disk_write_bytes_total{volume!~"%(ignoreVolumes)s", %(queriesSelector)s}[$__rate_interval])' % variables { ignoreVolumes: config.ignoreVolumes }
      )
      + prometheusQuery.withLegendFormat('{{ volume }} written'),
    diskIOutilization:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        '(1-clamp_max(irate(windows_logical_disk_idle_seconds_total{volume!~"%(ignoreVolumes)s", %(queriesSelector)s}[$__rate_interval]),1)) * 100' % variables { ignoreVolumes: config.ignoreVolumes }
      )
      + prometheusQuery.withLegendFormat('{{ volume }} io util'),
    osInfo:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        'windows_os_info{%(queriesSelector)s}' % variables,
      )
      + prometheusQuery.withFormat('table'),

    osTimezone:  //timezone label
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        'windows_os_timezone{%(queriesSelector)s}' % variables,
      )
      + prometheusQuery.withFormat('table'),
    systemContextSwitches:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        'irate(windows_system_context_switches_total{%(queriesSelector)s}[$__rate_interval])' % variables,
      )
      + prometheusQuery.withLegendFormat('Context switches'),
    windowsSystemThreads:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        'windows_system_threads{%(queriesSelector)s}' % variables,
      )
      + prometheusQuery.withLegendFormat('System threads'),
    windowsSystemExceptions:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        'irate(windows_system_exception_dispatches_total{%(queriesSelector)s}[$__rate_interval])' % variables,
      )
      + prometheusQuery.withLegendFormat('System exceptions dispatched'),
    windowsSystemCalls:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        'irate(windows_system_system_calls_total{%(queriesSelector)s}[$__rate_interval])' % variables,
      )
      + prometheusQuery.withLegendFormat('System calls'),

    systemInterrupts:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        'sum without (core) (irate(windows_cpu_interrupts_total{%(queriesSelector)s}[$__rate_interval]))' % variables,
      )
      + prometheusQuery.withLegendFormat('Interrupts'),

    timeNtpStatus:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        'clamp_max(windows_time_ntp_client_time_sources{%(queriesSelector)s}, 1)' % variables,
      )
      + prometheusQuery.withLegendFormat('NTP status'),
    timeNtpDelay:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        'windows_time_ntp_round_trip_delay_seconds{%(queriesSelector)s}' % variables,
      )
      + prometheusQuery.withLegendFormat('NTP trip delay'),

    timeOffset:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        'windows_time_computed_time_offset_seconds{%(queriesSelector)s}' % variables,
      )
      + prometheusQuery.withLegendFormat('Time offset'),

    // Total adjustment made to the local system clock frequency by W32Time in parts per billion (PPB) units. 1 PPB adjustment implies the system clock was adjusted at a rate of 1 nanosecond per second (1 ns/s). The smallest possible adjustment can vary and is expected to be in the order of 100's of PPB.
    timeAdjustments:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        'rate(windows_time_clock_frequency_adjustment_ppb_total{%(queriesSelector)s}[$__rate_interval])' % variables,
      )
      + prometheusQuery.withLegendFormat('Time adjustments'),


    networkOutBitPerSec:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        'irate(windows_net_bytes_sent_total{%(queriesSelector)s}[$__rate_interval])*8' % variables
      )
      + prometheusQuery.withLegendFormat('{{ nic }} transmitted'),
    networkInBitPerSec:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        'irate(windows_net_bytes_received_total{%(queriesSelector)s}[$__rate_interval])*8' % variables
      )
      + prometheusQuery.withLegendFormat('{{ nic }} received'),
    networkOutErrorsPerSec:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        'irate(windows_net_packets_outbound_errors_total{%(queriesSelector)s}[$__rate_interval])' % variables
      )
      + prometheusQuery.withLegendFormat('{{ nic }} transmitted'),
    networkInErrorsPerSec:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        'irate(windows_net_packets_received_errors_total{%(queriesSelector)s}[$__rate_interval])' % variables
      )
      + prometheusQuery.withLegendFormat('{{ nic }} received'),
    networkInUknownPerSec:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        'irate(windows_net_packets_received_unknown_total{%(queriesSelector)s}[$__rate_interval])' % variables
      )
      + prometheusQuery.withLegendFormat('{{ nic }} received (unknown)'),
    networkOutDroppedPerSec:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        'irate(windows_net_packets_outbound_discarded_total{%(queriesSelector)s}[$__rate_interval])' % variables
      )
      + prometheusQuery.withLegendFormat('{{ nic }} transmitted packets dropped'),
    networkInDroppedPerSec:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        'irate(windows_net_packets_received_discarded_total{%(queriesSelector)s}[$__rate_interval])' % variables
      )
      + prometheusQuery.withLegendFormat('{{ nic }} received packets dropped'),

    networkInPacketsPerSec:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        'irate(windows_net_packets_received_total{%(queriesSelector)s}[$__rate_interval])' % variables
      )
      + prometheusQuery.withLegendFormat('{{ nic }} received'),
    networkOutPacketsPerSec:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        'irate(windows_net_packets_sent_total{%(queriesSelector)s}[$__rate_interval])' % variables
      )
      + prometheusQuery.withLegendFormat('{{ nic }} transmitted'),
  },
}
