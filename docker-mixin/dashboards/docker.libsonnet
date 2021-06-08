local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');

local host_matcher = 'job=~"$job", instance=~"$instance"';
local container_matcher = host_matcher + ', name=~"$container"';

local queries = {
  total_containers: 'count(container_last_seen{' + container_matcher + '})',
  total_images: 'count (sum by (image) (container_last_seen{' + container_matcher + ', image=~".+"}))',
  host_mem_reserved: '100 * sum(container_spec_memory_reservation_limit_bytes{' + container_matcher + '}) / avg(machine_memory_bytes{' + host_matcher + '})',
  host_mem_consumed: '100 * sum(container_memory_usage_bytes{' + container_matcher + '}) / avg(machine_memory_bytes{' + host_matcher + '})',
  cpu_usage: '100 * sum (rate(container_cpu_usage_seconds_total{' + container_matcher + '}[$__rate_interval]))',
  cpu_by_container: '100 * avg by (name) (rate(container_cpu_usage_seconds_total{' + container_matcher + '}[$__rate_interval]))',
  mem_by_container: 'sum by (name) (container_memory_usage_bytes{' + container_matcher + '})',
  net_rx_by_container: 'sum by (name) (rate(container_network_receive_bytes_total{' + container_matcher + '}[$__rate_interval]))',
  net_tx_by_container: 'sum by (name) (rate(container_network_transmit_bytes_total{' + container_matcher + '}[$__rate_interval]))',
  net_rx_error_rate: 'sum(rate(container_network_receive_errors_total{' + container_matcher + '}[$__rate_interval]))',
  net_tx_error_rate: 'sum(rate(container_network_transmit_errors_total{' + container_matcher + '}[$__rate_interval]))',
  tcp_socket_by_state: 'sum(container_network_tcp_usage_total{' + container_matcher + '}) by (tcp_state) > 0',
  fs_usage_by_device: '100 * sum by (device) (container_fs_usage_bytes{' + host_matcher + ', id="/", device=~"/dev/.+"} / container_fs_limit_bytes{' + host_matcher + ', id="/", device=~"/dev/.+"})',
  fs_inode_usage_by_device: '100 - 100 * sum by (device) (container_fs_inodes_free{' + host_matcher + ', id="/", device=~"/dev/.+"} / container_fs_inodes_total{' + host_matcher + ', id="/", device=~"/dev/.+"})',
};

local stackstyle = {
  line: 1,
  fill: 5,
  fillGradient: 10,
};

local dstemplate = {
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

local jobtemplate = grafana.template.new(
  'job',
  '$datasource',
  'label_values(machine_scrape_error, job)',
  refresh='load',
  multi=true,
  includeAll=true,
  allValues='.+',
  sort=1,
);

local instancetemplate = grafana.template.new(
  'instance',
  '$datasource',
  'label_values(machine_scrape_error{job=~"$job"}, instance)',
  refresh='load',
  multi=true,
  includeAll=true,
  allValues='.+',
  sort=1,
);

local containertemplate = grafana.template.new(
  'container',
  '$datasource',
  'label_values(container_last_seen{job=~"$job", instance=~"$instance"}, name)',
  refresh='load',
  multi=true,
  includeAll=true,
  allValues='.+',
  sort=1,
);

{
  grafanaDashboards+:: {
    'docker.json':
      grafana.dashboard.new('Docker', uid='RwmMppyP3')
      .addTemplate(dstemplate)
      .addTemplate(jobtemplate)
      .addTemplate(instancetemplate)
      .addTemplate(containertemplate)
      .addRow(
        grafana.row.new('Overview')
        # Total containers
        .addPanel(
          grafana.singlestat.new(
            'Total Containers',
            span=2,
            datasource='$datasource',
          )
          .addTarget(
            grafana.prometheus.target(queries.total_containers)
          )
        )

        # Total images
        .addPanel(
          grafana.singlestat.new(
            'Total Images',
            span=2,
            datasource='$datasource',
          )
          .addTarget(
            grafana.prometheus.target(queries.total_images)
          )
        )

        # Host CPU used by containers
        .addPanel(
          grafana.singlestat.new(
            'CPU used by Containers',
            format='percent',
            gaugeShow=true,
            thresholds='80,90',
            span=2,
            datasource='$datasource',
          )
          .addTarget(
            grafana.prometheus.target(queries.cpu_usage)
          )
        )

        # Host memory reserved by containers
        .addPanel(
          grafana.singlestat.new(
            'Memory Reserved by Containers',
            format='percent',
            gaugeShow=true,
            thresholds='80,90',
            span=2,
            datasource='$datasource',
          )
          .addTarget(
            grafana.prometheus.target(queries.host_mem_reserved)
          )
        )

        # Host memory utilization by containers
        .addPanel(
          grafana.singlestat.new(
            'Memory Utilization by Containers',
            format='percent',
            gaugeShow=true,
            thresholds='80,90',
            span=2,
            datasource='$datasource',
          )
          .addTarget(
            grafana.prometheus.target(queries.host_mem_consumed)
          )
        )
      )
      .addRow(
        grafana.row.new('Compute')
        # CPU by container
        .addPanel(
          grafana.graphPanel.new(
            'CPU',
            span=6,
            format='percent',
            datasource='$datasource',
          ) +
          g.queryPanel(
            [queries.cpu_by_container],
            ['{{name}}'],
          ) +
          g.stack +
          stackstyle +
          {
            yaxes: g.yaxes('percent'),
          }
        )

        # Memory by container
        .addPanel(
          grafana.graphPanel.new(
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
          { yaxes: g.yaxes('bytes') }
        )
      )

      .addRow(
        grafana.row.new('Network')

        # Network throughput
        .addPanel(
          grafana.graphPanel.new(
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
          }
        )

        # TCP Socket by state
        .addPanel(
          grafana.graphPanel.new(
            'TCP Sockets By State',
            datasource='$datasource',
            span=6,
          ) +
          g.queryPanel(
            [queries.tcp_socket_by_state],
            ['{{tcp_state}}'],
          ) +
          g.stack +
          stackstyle
        )
      )

      .addRow(
        grafana.row.new('Storage')

        /*.addPanel(
          grafana.statPanel.new(
            'Usage by device',
            graphMode='none',
            colorMode='background',
            orientation='horizontal',
          )
          .addThreshold({color: "green"})
          .addThreshold({color: "orange", value: 70})
          .addThreshold({color: "red", value: 90})
          .addTargets([
            grafana.prometheus.target(queries['fs_usage_by_device'], legendFormat='{{device}} Disk Space'),
            grafana.prometheus.target(queries['fs_inode_usage_by_device'], legendFormat='{{device}} Inodes'),
          ]) + { span: 12 }
        )*/

        .addPanel(
          g.tablePanel(
            [queries.fs_usage_by_device, queries.fs_inode_usage_by_device],
            {
              device: { alias: 'Device' },
              'Value #A': { alias: 'Disk Usage', unit: 'percent' },
              'Value #B': { alias: 'Inode Usage', unit: 'percent' },
            }
          ) + { span: 12 }
        )
      ) +
      { graphTooltip: 2 },
  },
}
