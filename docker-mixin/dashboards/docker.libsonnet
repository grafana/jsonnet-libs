local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');

local host_matcher = 'job=~"$job", instance=~"$instance"';
local container_matcher = host_matcher + ', name=~"$container"';

local queries = {
  total_containers: 'count(container_last_seen{' + container_matcher + '})',
  total_images: 'count (sum by (image) (container_last_seen{' + container_matcher + ', image=~".+"}))',
  host_mem_reserved: 'sum(container_spec_memory_reservation_limit_bytes{' + container_matcher + '}) / avg(machine_memory_bytes{' + host_matcher + '})',
  host_mem_consumed: 'sum(container_memory_usage_bytes{' + container_matcher + '}) / avg(machine_memory_bytes{' + host_matcher + '})',
  cpu_usage: 'sum (rate(container_cpu_usage_seconds_total{' + container_matcher + '}[$__rate_interval]))',
  cpu_by_container: 'avg by (name) (rate(container_cpu_usage_seconds_total{' + container_matcher + '}[$__rate_interval]))',
  mem_by_container: 'sum by (name) (container_memory_usage_bytes{' + container_matcher + '})',
  net_rx_by_container: 'sum by (name) (rate(container_network_receive_bytes_total{' + container_matcher + '}[$__rate_interval]))',
  net_tx_by_container: 'sum by (name) (rate(container_network_transmit_bytes_total{' + container_matcher + '}[$__rate_interval]))',
  net_rx_error_rate: 'sum(rate(container_network_receive_errors_total{' + container_matcher + '}[$__rate_interval]))',
  net_tx_error_rate: 'sum(rate(container_network_transmit_errors_total{' + container_matcher + '}[$__rate_interval]))',
  tcp_socket_by_state: 'sum(container_network_tcp_usage_total{' + container_matcher + '}) by (tcp_state) > 0',
  fs_usage_by_device: 'sum by (device) (container_fs_usage_bytes{' + host_matcher + ', id="/", device=~"/dev/.+"} / container_fs_limit_bytes{' + host_matcher + ', id="/", device=~"/dev/.+"})',
  fs_inode_usage_by_device: '1 - sum by (device) (container_fs_inodes_free{' + host_matcher + ', id="/", device=~"/dev/.+"} / container_fs_inodes_total{' + host_matcher + ', id="/", device=~"/dev/.+"})',
};

local stackstyle = {
  line: 1,
  fill: 5,
  fillGradient: 10,
};

# Templates
local ds_template = {
  current: {
    text: 'default',
    value: 'default',
  },
  hide: 0,
  label: null,
  name: 'datasource',
  options: [],
  query: 'prometheus',
  refresh: 1,
  regex: '',
  type: 'datasource',
};

local job_template = grafana.template.new(
  'job',
  '$datasource',
  'label_values(machine_scrape_error, job)',
  refresh='load',
  multi=true,
  includeAll=true,
  allValues='.+',
  sort=1,
);

local instance_template = grafana.template.new(
  'instance',
  '$datasource',
  'label_values(machine_scrape_error{job=~"$job"}, instance)',
  refresh='load',
  multi=true,
  includeAll=true,
  allValues='.+',
  sort=1,
);

local container_template = grafana.template.new(
  'container',
  '$datasource',
  'label_values(container_last_seen{job=~"$job", instance=~"$instance"}, name)',
  refresh='load',
  multi=true,
  includeAll=true,
  allValues='.+',
  sort=1,
);

# Panels
local total_containers_panel = grafana.singlestat.new(
  'Total Containers',
  span=2,
  datasource='$datasource',
)
.addTarget(
  grafana.prometheus.target(queries.total_containers)
);

local total_images_panel = grafana.singlestat.new(
  'Total Images',
  span=2,
  datasource='$datasource',
)
.addTarget(
  grafana.prometheus.target(queries.total_images)
);

local cpu_usage_panel = grafana.singlestat.new(
  'CPU Utilization by Containers',
  format='percentunit',
  gaugeShow=true,
  thresholds='.80,.90',
  span=2,
  datasource='$datasource',
  gaugeMaxValue=1,
)
.addTarget(
  grafana.prometheus.target(queries.cpu_usage)
);

local mem_reserved_panel = grafana.singlestat.new(
  'Memory Reserved by Containers',
  format='percentunit',
  gaugeShow=true,
  thresholds='.80,.90',
  span=2,
  datasource='$datasource',
  gaugeMaxValue=1,
)
.addTarget(
  grafana.prometheus.target(queries.host_mem_reserved)
);

local mem_usage_panel = grafana.singlestat.new(
  'Memory Utilization by Containers',
  format='percentunit',
  gaugeShow=true,
  thresholds='.80,.90',
  span=2,
  datasource='$datasource',
  gaugeMaxValue=1,
)
.addTarget(
  grafana.prometheus.target(queries.host_mem_consumed)
);

local cpu_by_container_panel = grafana.graphPanel.new(
  'CPU',
  span=6,
  datasource='$datasource',
) +
g.queryPanel(
  [queries.cpu_by_container],
  ['{{name}}'],
) +
g.stack +
stackstyle +
{
  yaxes: g.yaxes('percentunit'),
};

local mem_by_container_panel = grafana.graphPanel.new(
    'Memory',
    span=6,
    datasource='$datasource',
  ) +
  g.queryPanel(
    [queries.mem_by_container],
    ['{{name}}'],
  ) +
  g.stack +
  stackstyle +
  { yaxes: g.yaxes('bytes') };

local net_throughput_panel = grafana.graphPanel.new(
  'Bandwidth',
  span=6,
  datasource='$datasource',
) +
g.queryPanel(
  [queries.net_rx_by_container, queries.net_tx_by_container],
  ['{{name}} rx', '{{name}} tx'],
) +
g.stack +
stackstyle +
{
  yaxes: g.yaxes({ format: 'binBps', min: null }),
} + {
  seriesOverrides: [{ alias: '/.*tx/', transform: 'negative-Y' }],
};

local tcp_socket_by_state_panel = grafana.graphPanel.new(
  'TCP Sockets By State',
  datasource='$datasource',
  span=6,
) +
g.queryPanel(
  [queries.tcp_socket_by_state],
  ['{{tcp_state}}'],
) +
g.stack +
stackstyle;

local disk_usage_panel = g.tablePanel(
  [queries.fs_usage_by_device, queries.fs_inode_usage_by_device],
  {
    device: { alias: 'Device' },
    'Value #A': { alias: 'Disk Usage', unit: 'percentunit' },
    'Value #B': { alias: 'Inode Usage', unit: 'percentunit' },
  }
) + { span: 12, datasource: '$datasource' };

# Manifested stuff starts here
{
  grafanaDashboards+:: {
    'docker.json':
      grafana.dashboard.new('Docker', uid='RwmMppyP3')
      .addTemplates([
        ds_template,
        job_template,
        instance_template,
        container_template
      ])

      # Overview Row
      .addRow(
        grafana.row.new('Overview')
        # Total containers
        .addPanel(total_containers_panel)

        # Total images
        .addPanel(total_images_panel)

        # Host CPU used by containers
        .addPanel(cpu_usage_panel)

        # Host memory reserved by containers
        .addPanel(mem_reserved_panel)

        # Host memory utilization by containers
        .addPanel(mem_usage_panel)
      )

      # Compute Row
      .addRow(
        grafana.row.new('Compute')
        # CPU by container
        .addPanel(cpu_by_container_panel)

        # Memory by container
        .addPanel(mem_by_container_panel)
      )

      # Network Row
      .addRow(
        grafana.row.new('Network')

        # Network throughput
        .addPanel(net_throughput_panel)

        # TCP Socket by state
        .addPanel(tcp_socket_by_state_panel)
      )

      # Storage Row
      .addRow(
        grafana.row.new('Storage')

        # Disk
        .addPanel(disk_usage_panel)
      ) +
      { graphTooltip: 2 }, # Shared tooltip. When you hover over a graph, the same time is selected on all graphs, and tooltip is shown. Set to 1 to only share crosshair
  },
}
