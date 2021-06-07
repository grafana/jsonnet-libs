local g = (import './vendor/grafana-builder/grafana.libsonnet');
local grafana = (import './vendor/grafonnet/grafana.libsonnet');

local host_matcher = 'job=~"$job", instance=~"$instance"';
local container_matcher = host_matcher + ', id=~"$container"';

local queries = {
  'total_containers': 'count(container_last_seen{'+container_matcher+'})',
  'host_mem_reserved': '100 * sum(container_spec_memory_reservation_limit_bytes{'+container_matcher+'}) / avg(machine_memory_bytes{'+host_matcher+'})',
  'host_mem_consumed': '100 * sum(container_memory_usage_bytes{'+container_matcher+'}) / avg(machine_memory_bytes{'+host_matcher+'})',
  'cpu_by_container': 'avg by (id) (rate(container_cpu_usage_seconds_total{'+container_matcher+'}[5m])) * 100',
};

{
  grafanaDashboards+:: {
    'docker.json':
      g.dashboard('Docker', 'RwmMppyP3')
      .addMultiTemplate('job', 'machine_scrape_error', 'job')
      .addMultiTemplate('instance', 'machine_scrape_error{job=~"$job"}', 'instance')
      .addMultiTemplate('container', 'container_last_seen{job=~"$job", instance=~"$instance"}', 'id')
      .addRow(
        g.row('Overview')
        # Total containers
        .addPanel(
          grafana.singlestat.new(
            'Total Containers',
          )
          .addTarget(
            grafana.prometheus.target(queries['total_containers'])
          )
        )

        # Host memory reserved by containers
        .addPanel(
          grafana.singlestat.new(
            'Memory Reserved by Containers',
            format='percent',
            gaugeShow=true,
            thresholds='80,90',
          )
          .addTarget(
            grafana.prometheus.target(queries['host_mem_reserved'])
          )
        )

        # Host memory utilization by containers
        .addPanel(
          grafana.singlestat.new(
            'Memory Utilization by Containers',
            format='percent',
            gaugeShow=true,
            thresholds='80,90',
          )
          .addTarget(
            grafana.prometheus.target(queries['host_mem_consumed'])
          )
        )
      )
    .addRow(
      g.row('Compute')
      # CPU by container
      .addPanel(
        g.panel('CPU') +
        g.queryPanel(
          [queries['cpu_by_container']],
          ['{{id}}'],
        ) +
        g.stack +
        {
          yaxes: g.yaxes('percent'),
        }
      )
    ),
  },
}
