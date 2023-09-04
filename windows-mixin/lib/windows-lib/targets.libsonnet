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
        memoryTotal:
            prometheusQuery.new(
            '${' + variables.datasource.name+"}",
            'windows_cs_physical_memory_bytes{%(queriesSelector)s}' % variables),
        memoryUsage:
            prometheusQuery.new(
            '${' + variables.datasource.name+"}",
            '100 - windows_os_physical_memory_free_bytes{%(queriesSelector)s} / windows_cs_physical_memory_bytes{%(queriesSelector)s} * 100' % variables),
        memoryPageTotal:
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
        diskIO:
            prometheusQuery.new(
            '${' + variables.datasource.name+"}",
            'x{%(queriesSelector)s}' % variables),            

        osInfo:
            prometheusQuery.new(
            '${' + variables.datasource.name+"}",
            'windows_os_info{%(queriesSelector)s}' % variables,
            )
            + prometheusQuery.withFormat('table'),

        networkErrors:
            prometheusQuery.new(
            '${' + variables.datasource.name+"}",
            'x{%(queriesSelector)s}' % variables),

        networkDropped:
            prometheusQuery.new(
            '${' + variables.datasource.name+"}",
            'x{%(queriesSelector)s}' % variables),     

        networkUsage:
            prometheusQuery.new(
            '${' + variables.datasource.name+"}",
            'x{%(queriesSelector)s}' % variables),
        networkPackets:
            prometheusQuery.new(
            '${' + variables.datasource.name+"}",
            'x{%(queriesSelector)s}' % variables),
        networkMulticast:
            prometheusQuery.new(
            '${' + variables.datasource.name+"}",
            'x{%(queriesSelector)s}' % variables),
    },
}