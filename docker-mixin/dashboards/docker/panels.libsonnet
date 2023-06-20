local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');

local stackstyle = {
  line: 1,
  fill: 5,
  fillGradient: 10,
};

function(targets) {
  total_containers: {
    docs: targets.total_containers.docs,
    spec: grafana.statPanel.new(
      'Total Containers',
      description='Total number of running containers last seen by the exporter.',
      datasource='$prometheus_datasource',
      graphMode='none',
      reducerFunction='lastNotNull',
      unit='short',
    )
    .addTarget(targets.total_containers.spec),
  },

  total_images: {
    docs: targets.total_images.docs,
    spec: grafana.statPanel.new(
      'Total Images',
      description='Total number of distinct images found across running containers',
      datasource='$prometheus_datasource',
      graphMode='none',
      reducerFunction='lastNotNull',
      unit='short'
    )
    .addTarget(targets.total_images.spec),
  },

  cpu_usage: {
    docs: targets.cpu_usage.docs,
    spec: grafana.singlestat.new(
      'CPU Utilization by Containers',
      description='Cumulative cpu time consumed in seconds.',
      format='percentunit',
      gaugeShow=true,
      thresholds='.80,.90',
      span=2,
      datasource='$prometheus_datasource',
      gaugeMaxValue=1
    )
    .addTarget(targets.cpu_usage.spec),
  },

  mem_reserved: {
    docs: targets.host_mem_reserved.docs,
    spec: grafana.singlestat.new(
      'Memory Reserved by Containers',
      description='Memory reserved by the containers on the machine.',
      format='percentunit',
      gaugeShow=true,
      thresholds='.80,.90',
      span=2,
      datasource='$prometheus_datasource',
      gaugeMaxValue=1,
    )
    .addTarget(targets.host_mem_reserved.spec),
  },

  mem_usage: {
    docs: targets.host_mem_consumed.docs,
    spec: grafana.singlestat.new(
      'Memory Utilization by Containers',
      description='Current memory usage in bytes, including all memory regardless of when it was accessed.',
      format='percentunit',
      gaugeShow=true,
      thresholds='.80,.90',
      span=2,
      datasource='$prometheus_datasource',
      gaugeMaxValue=1,
    )
    .addTarget(targets.host_mem_consumed.spec),
  },

  cpu_by_container: {
    docs: targets.cpu_by_container.docs,
    spec: grafana.graphPanel.new(
      'CPU',
      description='Cpu time consumed in seconds by container.',
      span=6,
      datasource='$prometheus_datasource',
    ) +
    g.queryPanel(
      [targets.cpu_by_container.spec.expr],
      ['{{name}}'],
    ) +
    g.stack +
    stackstyle +
    {
      yaxes: g.yaxes('percentunit'),
    },
  },

  mem_by_container: {
    docs: targets.mem_by_container.docs,
    spec: grafana.graphPanel.new(
      'Memory',
      description='Current memory usage in bytes, including all memory regardless of when it was accessed by container.',
      span=6,
      datasource='$prometheus_datasource',
    ) +
    g.queryPanel(
      [targets.mem_by_container.spec.expr],
      ['{{name}}'],
    ) +
    g.stack +
    stackstyle +
    { yaxes: g.yaxes('bytes') },
  },

  net_throughput: {
    docs: 'Overall net throughput',
    spec: grafana.graphPanel.new(
      'Bandwidth',
      description='Cumulative count of bytes transmitted.',
      span=6,
      datasource='$prometheus_datasource',
    ) +
    g.queryPanel(
      [targets.net_rx_by_container.spec.expr, targets.net_tx_by_container.spec.expr],
      ['{{name}} rx', '{{name}} tx'],
    ) +
    g.stack +
    stackstyle +
    {
      yaxes: g.yaxes({ format: 'binBps', min: null }),
    } + {
      seriesOverrides: [{ alias: '/.*tx/', transform: 'negative-Y' }],
    },
  },

  tcp_socket_by_state: {
    docs: 'TCP sockets by state',
    spec: grafana.graphPanel.new(
      'TCP Sockets By State',
      description='TCP sockets on containers by state.',
      datasource='$prometheus_datasource',
      span=6,
    ) +
    g.queryPanel(
      [targets.tcp_socket_by_state.spec.expr],
      ['{{tcp_state}}'],
    ) +
    stackstyle,
  },

  disk_usage: {
    docs: 'Disk usage (bytes and inodes)',
    spec: g.tablePanel(
      [targets.fs_usage_by_device.spec.expr, targets.fs_inode_usage_by_device.spec.expr],
      {
        instance: { alias: 'Instance' },
        device: { alias: 'Device' },
        'Value #A': { alias: 'Disk Usage', unit: 'percentunit' },
        'Value #B': { alias: 'Inode Usage', unit: 'percentunit' },
      }
    ) + { span: 12, datasource: '$prometheus_datasource' },
  },
}