local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');

local host_matcher = 'job=~"$job"';
local container_matcher = host_matcher + ', container=~"$container"';

local queries = {
  total_log_lines: 'sum(count_over_time({' + container_matcher + '}[$__interval]))',
  total_log_warnings: 'sum(count_over_time({' + container_matcher + '} |= "WARNING" [$__interval]))',
  total_log_errors: 'sum(count_over_time({' + container_matcher + '} |= "ERROR" [$__interval]))',
  error_percentage: 'sum( count_over_time({' + container_matcher + '} |= "ERROR" [$__interval]) ) / sum( count_over_time({' + container_matcher + '} [$__interval]) )',
  total_bytes: 'sum(bytes_over_time({' + container_matcher +  '} [$__interval]))',
};

local stackstyle = {
  line: 1,
  fill: 5,
  fillGradient: 10,
};

// Templates
local ds_template = {
  current: {
    text: 'default',
    value: 'default',
  },
  hide: 0,
  label: 'Data Source',
  name: 'loki_datasource',
  options: [],
  query: 'loki',
  refresh: 1,
  regex: '',
  type: 'datasource',
};

local job_template = grafana.template.new(
  'job',
  '$loki_datasource',
  'label_values(job)',
  label='Job',
  refresh='load',
  multi=true,
  includeAll=true,
  allValues='.+',
  sort=1,
  regex='.*docker.+'
);

local container_template = grafana.template.new(
  'container',
  '$loki_datasource',
  'label_values({job=~"$job"}, container)',
  label='Container',
  refresh='load',
  multi=true,
  includeAll=true,
  allValues='.+',
  sort=1,
);

// Panels
local integration_status_panel = grafana.statPanel.new(
  'Integration Status',
  datasource='$loki_datasource',
  colorMode='background',
  graphMode='none',
  noValue='No Data',
  reducerFunction='lastNotNull'
).addMappings(
  [
    {
      options: {
        from: 1,
        result: {
          color: 'green',
          index: 0,
          text: 'Agent Configured - Sending Metrics',
        },
        to: 10000000000000,
      },
      type: 'range',
    },
    {
      options: {
        from: 0,
        result: {
          color: 'red',
          index: 1,
          text: 'No Data',
        },
        to: 0,
      },
      type: 'range',
    },
  ]
)
                                 .addTarget(
  grafana.loki.target(queries.total_log_lines)
);

local latest_metric_panel = grafana.statPanel.new(
  'Latest Metric Received',
  datasource='$loki_datasource',
  colorMode='background',
  fields='Time',
  graphMode='none',
  noValue='No Data',
  reducerFunction='lastNotNull'
)
                            .addTarget(
  grafana.loki.target(queries.total_log_lines)
);

local total_log_lines_panel = grafana.statPanel.new(
  'Total Log Lines',
  datasource='$loki_datasource',
  graphMode='none',
  reducerFunction='lastNotNull',
  unit='short',
)                              .addThreshold({ color: 'rgb(192, 216, 255)', value: 0 })
                               .addTarget(
  grafana.loki.target(queries.total_log_lines)
);

local total_log_warnings_panel = grafana.statPanel.new(
  'Warnings',
  datasource='$loki_datasource',
  graphMode='none',
  reducerFunction='lastNotNull',
  unit='short',
)                              .addThreshold({ color: 'rgb(255, 152, 48)', value: 0 })
                               .addTarget(
  grafana.loki.target(queries.total_log_warnings)
);

local total_log_errors_panel = grafana.statPanel.new(
  'Errors',
  datasource='$loki_datasource',
  graphMode='none',
  reducerFunction='lastNotNull',
  unit='short',
)                              .addThreshold({ color: 'rgb(242, 73, 92)', value: 0 })
                               .addTarget(
  grafana.loki.target(queries.total_log_errors)
);

local error_percentage_panel = grafana.statPanel.new(
  'Error Percentage',
  datasource='$loki_datasource',
  graphMode='none',
  reducerFunction='lastNotNull',
  unit='percent',
)                              .addThresholds([
                                    { color: 'rgb(255, 166, 176)', value: 0 },
                                    { color: 'rgb(255, 115, 131)', value: 25 },
                                    { color: 'rgb(196, 22, 42)', value: 50 },
                                ])
                               .addTarget(
  grafana.loki.target(queries.error_percentage)
);

local total_bytes_panel = grafana.statPanel.new(
  'Bytes Used',
  datasource='$loki_datasource',
  graphMode='none',
  reducerFunction='lastNotNull',
  unit='bytes',
)                              .addThreshold({ color: 'rgb(184, 119, 217)', value: 0 })
                               .addTarget(
  grafana.loki.target(queries.total_bytes)
);

// Manifested stuff starts here
{
  grafanaDashboards+:: {
    'docker.json':
      grafana.dashboard.new('Docker Logs',  uid='RwmMppyP4')
      .addTemplates([
        ds_template,
        job_template,
        container_template,
      ])

      // Status Row
      .addPanel(grafana.row.new(title='Integration Status'), gridPos={ x: 0, y: 0, w: 0, h: 0 })
      // Integration status
      .addPanel(integration_status_panel, gridPos={ x: 0, y: 0, w: 8, h: 2 })
      // Latest metric received
      .addPanel(latest_metric_panel, gridPos={ x: 8, y: 0, w: 8, h: 2 })

      // Overview Row
      .addPanel(grafana.row.new(title='Overview'), gridPos={ x: 0, y: 2, w: 0, h: 0 })
      // Total Log Lines
      .addPanel(total_log_lines_panel, gridPos={ x: 0, y: 2, w: 4, h: 6 })
      // Warnings
      .addPanel(total_log_warnings_panel, gridPos={ x: 4, y: 2, w: 4, h: 6 })
      // Errors
      .addPanel(total_log_errors_panel, gridPos={ x: 8, y: 2, w: 4, h: 6 })
      // Error Percentage
      .addPanel(error_percentage_panel, gridPos={ x: 12, y: 2, w: 4, h: 6 })
      // Bytes Used
      .addPanel(total_bytes_panel, gridPos={ x: 16, y: 2, w: 4, h: 6 })

    //   // Compute Row
    //   .addPanel(grafana.row.new(title='Compute'), gridPos={ x: 0, y: 8, w: 0, h: 0 })
    //   // CPU by container
    //   .addPanel(cpu_by_container_panel, gridPos={ x: 0, y: 8, w: 12, h: 8 })
    //   // Memory by container
    //   .addPanel(mem_by_container_panel, gridPos={ x: 12, y: 8, w: 12, h: 8 })

    //   // Network Row
    //   .addPanel(grafana.row.new(title='Network'), gridPos={ x: 0, y: 16, w: 0, h: 0 })
    //   // Network throughput
    //   .addPanel(net_throughput_panel, gridPos={ x: 0, y: 16, w: 12, h: 8 })
    //   // TCP Socket by state
    //   .addPanel(tcp_socket_by_state_panel, gridPos={ x: 12, y: 16, w: 12, h: 8 })

    //   // Storage Row
    //   .addPanel(grafana.row.new(title='Storage'), gridPos={ x: 0, y: 24, w: 0, h: 0 })
    //   // Disk
    //   .addPanel(disk_usage_panel, gridPos={ x: 0, y: 24, w: 24, h: 8 }),
  },
}
