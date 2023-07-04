local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local resource = import '../../lib/resource.libsonnet';

local stackstyle = {
  line: 1,
  fill: 5,
  fillGradient: 10,
};

local kind = 'Target';

function(targets) {
  total_containers: resource.new(kind, 'total_containers')
    + resource.withDocs(targets.total_containers.docs)
    + resource.withSpec(grafana.statPanel.new(
        'Total Containers',
        description='Total number of running containers last seen by the exporter.',
        datasource='$prometheus_datasource',
        graphMode='none',
        reducerFunction='lastNotNull',
        unit='short',
      )
      .addTarget(targets.total_containers.spec)
    ),

  total_images: resource.new(kind, 'total_images')
    + resource.withDocs(targets.total_images.docs)
    + resource.withSpec(grafana.statPanel.new(
          'Total Images',
          description='Total number of distinct images found across running containers',
          datasource='$prometheus_datasource',
          graphMode='none',
          reducerFunction='lastNotNull',
          unit='short'
        )
        .addTarget(targets.total_images.spec),
    ),

  cpu_usage: resource.new(kind, 'cpu_usage')
    + resource.withDocs(targets.cpu_usage.docs)
    + resource.withSpec(grafana.singlestat.new(
        'CPU Utilization by Containers',
        description='Cumulative cpu time consumed in seconds.',
        format='percentunit',
        gaugeShow=true,
        thresholds='.80,.90',
        span=2,
        datasource='$prometheus_datasource',
        gaugeMaxValue=1
      )
      .addTarget(targets.cpu_usage.spec)
    ),

  mem_reserved: resource.new(kind, 'mem_reserved')
    + resource.withDocs(targets.host_mem_reserved.docs)
    + resource.withSpec(grafana.singlestat.new(
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
    ),

  mem_usage: resource.new(kind, 'mem_usage')
    + resource.withDocs(targets.host_mem_consumed.docs)
    + resource.withSpec(grafana.singlestat.new(
        'Memory Utilization by Containers',
        description='Current memory usage in bytes, including all memory regardless of when it was accessed.',
        format='percentunit',
        gaugeShow=true,
        thresholds='.80,.90',
        span=2,
        datasource='$prometheus_datasource',
        gaugeMaxValue=1,
      )
      .addTarget(targets.host_mem_consumed.spec)
    ),

  cpu_by_container: resource.new(kind, 'cpu_by_container')
    + resource.withDocs(targets.cpu_by_container.docs)
    + resource.withSpec(grafana.graphPanel.new(
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
      }
    ),

  mem_by_container: resource.new(kind, 'mem_by_container')
    + resource.withDocs(targets.mem_by_container.docs)
    + resource.withSpec(grafana.graphPanel.new(
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
    ),

  net_throughput: resource.new(kind, 'net_throughput')
    + resource.withDocs('Overall net throughput')
    + resource.withSpec(grafana.graphPanel.new(
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
    ),

  tcp_socket_by_state: resource.new(kind, 'tcp_socket_by_state')
    + resource.withDocs('TCP sockets by state')
    + resource.withSpec(grafana.graphPanel.new(
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
    ),

  disk_usage: resource.new(kind, 'disk_usage')
    + resource.withDocs('Disk usage (bytes and inodes)')
    + resource.withSpec(g.tablePanel(
        [targets.fs_usage_by_device.spec.expr, targets.fs_inode_usage_by_device.spec.expr],
        {
          instance: { alias: 'Instance' },
          device: { alias: 'Device' },
          'Value #A': { alias: 'Disk Usage', unit: 'percentunit' },
          'Value #B': { alias: 'Inode Usage', unit: 'percentunit' },
        }
      ) + { span: 12, datasource: '$prometheus_datasource' },
    ),
}