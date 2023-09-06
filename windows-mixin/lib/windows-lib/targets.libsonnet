local g = import './g.libsonnet';
local prometheusQuery = g.query.prometheus;

{
    new(variables): {
        uptimeQuery:: "windows_system_system_up_time",
        
        reboot:
            prometheusQuery.new(
            '${' + variables.datasource.name+"}",
            self.uptimeQuery + '{%(queriesSelector)s}*1000 > $__from < $__to' % variables,
            ),
        uptime: 
            prometheusQuery.new(
            '${' + variables.datasource.name+"}",
            'time() - ' + self.uptimeQuery + '{%(queriesSelector)s}' % variables),
        cpuCount:
            prometheusQuery.new(
            '${' + variables.datasource.name+"}",
            'windows_cs_logical_processors{%(queriesSelector)s}' % variables),
        cpuUsage:
            prometheusQuery.new(
            '${' + variables.datasource.name+"}",
            '100 - (avg by (instance) (rate(windows_cpu_time_total{mode="idle", %(queriesSelector)s}[$__rate_interval])*100))'% variables
            )
            + prometheusQuery.withLegendFormat("CPU usage"),
        memoryTotalBytes:
            prometheusQuery.new(
            '${' + variables.datasource.name+"}",
            'windows_cs_physical_memory_bytes{%(queriesSelector)s}' % variables)
            + prometheusQuery.withLegendFormat("Memory total"),
        memoryFreeBytes:
            prometheusQuery.new(
            '${' + variables.datasource.name+"}",
            'windows_os_physical_memory_free_bytes{%(queriesSelector)s}' % variables)
            + prometheusQuery.withLegendFormat("Memory free"),
        memoryUsedBytes:
            prometheusQuery.new(
            '${' + variables.datasource.name+"}",
            'windows_cs_physical_memory_bytes{%(queriesSelector)s} - windows_os_physical_memory_free_bytes{%(queriesSelector)s}' % variables)
            + prometheusQuery.withLegendFormat("Memory used"),
        memoryUsagePercent:
            prometheusQuery.new(
            '${' + variables.datasource.name+"}",
            '100 - windows_os_physical_memory_free_bytes{%(queriesSelector)s} / windows_cs_physical_memory_bytes{%(queriesSelector)s} * 100' % variables),
        memoryPageTotalBytes:
            prometheusQuery.new(
            '${' + variables.datasource.name+"}",
            'windows_os_paging_limit_bytes{%(queriesSelector)s}' % variables),
        diskTotal:
            prometheusQuery.new(
            '${' + variables.datasource.name+"}",
            'max by (volume) (windows_logical_disk_size_bytes{%(queriesSelector)s})' % variables),
        diskTotalC:
            prometheusQuery.new(
            '${' + variables.datasource.name+"}",
            'windows_logical_disk_size_bytes{volume="C:", %(queriesSelector)s}' % variables),
        diskUsage:
            prometheusQuery.new(
            '${' + variables.datasource.name+"}",
            'max by (volume) (windows_logical_disk_size_bytes{%(queriesSelector)s}-windows_logical_disk_free_bytes{%(queriesSelector)s})' % variables),
        diskIOreadBytesPerSec:
            prometheusQuery.new(
            '${' + variables.datasource.name+"}",
            'irate(windows_logical_disk_read_bytes_total{%(queriesSelector)s}[$__rate_interval])' % variables)
            + prometheusQuery.withLegendFormat("{{ volume }} read"),
        diskIOwriteBytesPerSec:
            prometheusQuery.new(
            '${' + variables.datasource.name+"}",
            'irate(windows_logical_disk_write_bytes_total{%(queriesSelector)s}[$__rate_interval])' % variables)
            + prometheusQuery.withLegendFormat("{{ volume }} written"),

        osInfo:
            prometheusQuery.new(
            '${' + variables.datasource.name+"}",
            'windows_os_info{%(queriesSelector)s}' % variables,
            )
            + prometheusQuery.withFormat('table'),

        networkOutBitPerSec:
            prometheusQuery.new(
            '${' + variables.datasource.name+"}",
            'irate(windows_net_bytes_sent_total{%(queriesSelector)s}[$__rate_interval])*8' % variables)
            + prometheusQuery.withLegendFormat("{{ nic }} transmitted"),
        networkInBitPerSec:
            prometheusQuery.new(
            '${' + variables.datasource.name+"}",
            'irate(windows_net_bytes_received_total{%(queriesSelector)s}[$__rate_interval])*8' % variables)
            + prometheusQuery.withLegendFormat("{{ nic }} received"),
        
        networkOutErrorsPerSec:
            prometheusQuery.new(
            '${' + variables.datasource.name+"}",
            'irate(windows_net_packets_outbound_errors_total{%(queriesSelector)s}[$__rate_interval])' % variables)
            + prometheusQuery.withLegendFormat("{{ nic }} transmitted"),
        networkInErrorsPerSec:
            prometheusQuery.new(
            '${' + variables.datasource.name+"}",
            'irate(windows_net_packets_received_errors_total{%(queriesSelector)s}[$__rate_interval])' % variables)
            + prometheusQuery.withLegendFormat("{{ nic }} received"),
        networkInUknownPerSec:
            prometheusQuery.new(
            '${' + variables.datasource.name+"}",
            'irate(windows_net_packets_received_unknown_total{%(queriesSelector)s}[$__rate_interval])' % variables)
            + prometheusQuery.withLegendFormat("{{ nic }} received (unknown)"),

        networkOutDroppedPerSec:
            prometheusQuery.new(
            '${' + variables.datasource.name+"}",
            'irate(windows_net_packets_outbound_discarded_total{%(queriesSelector)s}[$__rate_interval])' % variables)
            + prometheusQuery.withLegendFormat("{{ nic }} transmitted"),
        networkInDroppedPerSec:
            prometheusQuery.new(
            '${' + variables.datasource.name+"}",
            'irate(windows_net_packets_received_discarded_total{%(queriesSelector)s}[$__rate_interval])' % variables)
            + prometheusQuery.withLegendFormat("{{ nic }} received"),

        networkInPacketsPerSec:
            prometheusQuery.new(
            '${' + variables.datasource.name+"}",
            'irate(windows_net_packets_received_total{%(queriesSelector)s}[$__rate_interval])' % variables)
            + prometheusQuery.withLegendFormat("{{ nic }} received"),
        networkOutPacketsPerSec:
            prometheusQuery.new(
            '${' + variables.datasource.name+"}",
            'irate(windows_net_packets_sent_total{%(queriesSelector)s}[$__rate_interval])' % variables)
            + prometheusQuery.withLegendFormat("{{ nic }} transmitted"),
        // TODO remove
        networkMulticast:
            prometheusQuery.new(
            '${' + variables.datasource.name+"}",
            'x{%(queriesSelector)s}' % variables),
    },
}