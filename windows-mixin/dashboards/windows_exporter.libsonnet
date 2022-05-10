local win = import './wintable.libsonnet';
local g = import 'grafana-builder/grafana.libsonnet';
local grafana = import 'grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;
local graphPanel = grafana.graphPanel;

{
  grafanaDashboards+:: {
    'windows_exporter.json':
      g.dashboard('Windows', 'e68fe518dbf1')
      .addTemplate('job', 'windows_cs_hostname', 'job')
      .addMultiTemplate('hostname', 'windows_cs_hostname{job=~"$job"}', 'hostname')
      .addRow(
        g.row('Overview')
        .addPanel(
          win.wintable('Usage', '$datasource')
          .addQuery('windows_os_info{job=~"$job"} * on(instance) group_right(product) windows_cs_hostname', 'group', 'group')
          .addQuery('100 - (avg by (instance) (irate(windows_cpu_time_total{job=~"$job",mode="idle"}[$__rate_interval])) * 100)', 'CPU Usage %', 'cpuusage')
          .addQuery('time() - windows_system_system_up_time{job=~"$job"}', 'Uptime', 'uptime')
          .addQuery('windows_cs_logical_processors{job=~"$job"} - 0', 'CPUs', 'cpus')
          .addQuery('windows_cs_physical_memory_bytes{job=~"$job"} - 0', 'Memory', 'memory')
          .addQuery('100 - 100 * windows_os_physical_memory_free_bytes{job=~"$job"} / windows_cs_physical_memory_bytes{job=~"$job"}', 'Memory Used', 'memoryused')
          .addQuery('(windows_logical_disk_free_bytes{job=~"$job",volume=~"C:"}/windows_logical_disk_size_bytes{job=~"$job",volume=~"C:"}) * 100', 'C:\\ Free %', 'cfree')
          .hideColumn('Time')
          .hideColumn('domain')
          .hideColumn('fqdn')
          .hideColumn('job')
          .hideColumn('agent_hostname')
          .hideColumn('Value #group')
          .hideColumn('instance')
          .renameColumn('Value #cpuusage', 'CPU Usage %')
          .addThreshold('CPU Usage %', [
            {
              color: 'dark-green',
              value: 0,
            },
            {
              color: 'dark-yellow',
              value: 40,
            },
            {
              color: 'dark-red',
              value: 80,
            },
          ], 'absolute')
          .renameColumn('Value #uptime', 'Uptime')
          .setColumnUnit('Uptime', 's')
          .addThreshold('Uptime', [
            {
              color: 'dark-red',
              value: 0,
            },
            {
              color: 'dark-yellow',
              value: 259200,
            },
            {
              color: 'dark-green',
              value: 432000,
            },
          ], 'absolute')
          .renameColumn('Value #cpus', 'CPUs')
          .renameColumn('Value #memory', 'Total Memory')
          .setColumnUnit('Total Memory', 'bytes')
          .renameColumn('Value #memoryused', 'Memory Used %')
          .addThreshold('Memory Used %', [
            {
              color: 'dark-green',
              value: 0,
            },
            {
              color: 'dark-yellow',
              value: 60,
            },
            {
              color: 'dark-red',
              value: 80,
            },
          ], 'absolute')
          .renameColumn('Value #cfree', 'C:\\ Free %')
          .hideColumn('volume')
          .addThreshold('C:\\ Free %', [
            {
              color: 'dark-green',
              value: 80,
            },
            {
              color: 'dark-yellow',
              value: 20,
            },
            {
              color: 'dark-red',
              value: 0,
            },
          ], 'absolute')
        )
      )
      .addRow(
        win.winrow('Overview Graphs')
        .addWinPanel(perCpu)
        .addWinPanel(perMemory)
      )
      .addRow(
        win.winrow('Resource details : $hostname')
        .addWinPanel(uptime)
        .addWinPanel(errorService)
        .addWinPanel(diskUsage)
        .addWinPanel(diskIO)
        .addWinPanel(networkUsage)
        .addWinPanel(iisConnections)
        + { repeat: 'hostname' },
      ),

  },


  local perCpu =
    graphPanel.new(
      title='CPU usage % of each host',
      datasource='$datasource',
      span=6,
      min=0,
      max=100,
      legend_show=false,
      percentage=true,
      format='percent'
    )
    .addTarget(prometheus.target(
      expr='100 - (avg by (hostname) (irate(windows_cpu_time_total{job=~"$job",mode="idle"}[$__rate_interval])) * 100)',
      legendFormat='{{hostname}}',
      intervalFactor=2,
    )),
  local perMemory =
    graphPanel.new(
      title='Memory usage % of each host',
      datasource='$datasource',
      span=6,
      min=0,
      max=100,
      legend_show=false,
      percentage=true,
      format='percent'
    )
    .addTarget(prometheus.target(
      expr='100.0 - 100 * windows_os_physical_memory_free_bytes{job=~"$job"} / windows_cs_physical_memory_bytes{job=~"$job"}',
      legendFormat='{{hostname}}',
    )),


  local iisConnections =
    graphPanel.new(
      title='IIS Connections',
      datasource='$datasource',
      span=3,
    )
    .addTarget(prometheus.target(
      expr='windows_iis_current_connections{job=~"$job",agent_hostname=~"$hostname"}',
      legendFormat='{{agent_hostname}}',
    )),

  local diskUsage =
    win.winbargauge('Usage rate of each partition', [
      {
        color: 'green',
        value: null,
      },
      {
        color: '#EAB839',
        value: 80,
      },
      {
        color: 'red',
        value: 90,
      },
    ], '100 - (windows_logical_disk_free_bytes{job=~"$job",agent_hostname=~"$hostname"} / windows_logical_disk_size_bytes{job=~"$job",agent_hostname=~"$hostname"})*100'
                    , '{{volume}}', span=2),

  local diskIO =
    graphPanel.new(
      title='Disk Read Write',
      datasource='$datasource',
      legend_min=true,
      legend_max=true,
      legend_avg=true,
      legend_current=true,
      legend_alignAsTable=true,
      legend_values=true,
      format='Bps',
      span=2
    )
    .addTarget(prometheus.target(
      expr='irate(windows_logical_disk_write_bytes_total{job=~"$job",agent_hostname=~"$hostname"}[$__rate_interval])',
      legendFormat='write {{volume}}',
    ))
    .addTarget(prometheus.target(
      expr='irate(windows_logical_disk_read_bytes_total{job=~"$job",agent_hostname=~"$hostname"}[$__rate_interval])',
      legendFormat='read {{volume}}',
    )),

  local errorService = win.winstat(
    span=1,
    title='Services in error',
    datasource='$datasource',
    unit='short',
    overrides=[
      {
        matcher: {
          id: 'byFrameRefID',
          options: 'A',
        },
        properties: [
          {
            id: 'thresholds',
            value: {
              mode: 'absolute',
              steps: [

                {
                  color: 'dark-green',
                  value: 0,
                },
                {
                  color: 'dark-red',
                  value: 1,
                },
              ],
            },
          },
          {
            id: 'color',
          },
        ],
      },
    ],
  )
                       .addTarget(prometheus.target(
    expr='sum(windows_service_status{status="error",job=~"$job",agent_hostname=~"$hostname"})',
    instant=true,

  )),

  local networkUsage = graphPanel.new(
    title='Network Usage',
    datasource='$datasource',
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_current=true,
    legend_alignAsTable=true,
    legend_values=true,
    format='percent',
    bars=true,
    lines=false,
    min=0,
    max=100,
    span=3
  )
                       .addTarget(prometheus.target(
    expr='(irate(windows_net_bytes_total{job=~"$job",agent_hostname=~"$hostname",nic!~"isatap.*|VPN.*"}[$__rate_interval]) * 8 / windows_net_current_bandwidth{job=~"$job",agent_hostname=~"$hostname",nic!~"isatap.*|VPN.*"}) * 100',
    legendFormat='{{nic}}',
  )),


  local uptime = win.winstat(
    span=1,
    title='Uptime',
    datasource='$datasource',
    format='s',
    overrides=[
      {
        matcher: {
          id: 'byFrameRefID',
          options: 'A',
        },
        properties: [
          {
            id: 'thresholds',
            value: {
              mode: 'absolute',
              steps: [
                {
                  color: 'dark-red',
                  value: null,
                },
                {
                  color: 'dark-yellow',
                  value: 259200,
                },
                {
                  color: 'dark-green',
                  value: 432000,
                },
              ],
            },
          },
          {
            id: 'color',
          },
        ],
      },
    ],
  )
                 .addTarget(prometheus.target(
    expr='time() - windows_system_system_up_time{job=~"$job",agent_hostname=~"$hostname"}',
    instant=true,

  )),

}
