local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');

local stackstyle = {
  line: 1,
  fill: 5,
  fillGradient: 10,
};

function(targets) {
  total_containers_panel: grafana.statPanel.new(
    'Total Containers',
    description='Total number of running containers last seen by the exporter.',
    datasource='$prometheus_datasource',
    graphMode='none',
    reducerFunction='lastNotNull',
    unit='short',
  )
  .addTarget(targets.total_containers.target),

  total_images_panel: grafana.statPanel.new(
    'Total Images',
    description='Total number of distinct images found across running containers',
    datasource='$prometheus_datasource',
    graphMode='none',
    reducerFunction='lastNotNull',
    unit='short'
  )
  .addTarget(targets.total_images.target),

  cpu_usage_panel: grafana.singlestat.new(
    'CPU Utilization by Containers',
    description='Cumulative cpu time consumed in seconds.',
    format='percentunit',
    gaugeShow=true,
    thresholds='.80,.90',
    span=2,
    datasource='$prometheus_datasource',
    gaugeMaxValue=1
  )
  .addTarget(targets.cpu_usage.target),

  mem_reserved_panel: grafana.singlestat.new(
    'Memory Reserved by Containers',
    description='Memory reserved by the containers on the machine.',
    format='percentunit',
    gaugeShow=true,
    thresholds='.80,.90',
    span=2,
    datasource='$prometheus_datasource',
    gaugeMaxValue=1,
  )
  .addTarget(targets.host_mem_reserved.target),

  mem_usage_panel: grafana.singlestat.new(
    'Memory Utilization by Containers',
    description='Current memory usage in bytes, including all memory regardless of when it was accessed.',
    format='percentunit',
    gaugeShow=true,
    thresholds='.80,.90',
    span=2,
    datasource='$prometheus_datasource',
    gaugeMaxValue=1,
  )
  .addTarget(targets.host_mem_consumed.target),

  cpu_by_container_panel: grafana.graphPanel.new(
    'CPU',
    description='Cpu time consumed in seconds by container.',
    span=6,
    datasource='$prometheus_datasource',
  ) +
  g.queryPanel(
    [targets.cpu_by_container.target.expr],
    ['{{name}}'],
  ) +
  g.stack +
  stackstyle +
  {
    yaxes: g.yaxes('percentunit'),
  },

  mem_by_container_panel: grafana.graphPanel.new(
    'Memory',
    description='Current memory usage in bytes, including all memory regardless of when it was accessed by container.',
    span=6,
    datasource='$prometheus_datasource',
  ) +
  g.queryPanel(
    [targets.mem_by_container.target.expr],
    ['{{name}}'],
  ) +
  g.stack +
  stackstyle +
  { yaxes: g.yaxes('bytes') },

  net_throughput_panel: grafana.graphPanel.new(
    'Bandwidth',
    description='Cumulative count of bytes transmitted.',
    span=6,
    datasource='$prometheus_datasource',
  ) +
  g.queryPanel(
    [targets.net_rx_by_container.target.expr, targets.net_tx_by_container.target.expr],
    ['{{name}} rx', '{{name}} tx'],
  ) +
  g.stack +
  stackstyle +
  {
    yaxes: g.yaxes({ format: 'binBps', min: null }),
  } + {
    seriesOverrides: [{ alias: '/.*tx/', transform: 'negative-Y' }],
  },

  tcp_socket_by_state_panel: grafana.graphPanel.new(
    'TCP Sockets By State',
    description='TCP sockets on containers by state.',
    datasource='$prometheus_datasource',
    span=6,
  ) +
  g.queryPanel(
    [targets.tcp_socket_by_state.target.expr],
    ['{{tcp_state}}'],
  ) +
  stackstyle,

  disk_usage_panel: g.tablePanel(
    [targets.fs_usage_by_device.target.expr, targets.fs_inode_usage_by_device.target.expr],
    {
      instance: { alias: 'Instance' },
      device: { alias: 'Device' },
      'Value #A': { alias: 'Disk Usage', unit: 'percentunit' },
      'Value #B': { alias: 'Inode Usage', unit: 'percentunit' },
    }
  ) + { span: 12, datasource: '$prometheus_datasource' },
}