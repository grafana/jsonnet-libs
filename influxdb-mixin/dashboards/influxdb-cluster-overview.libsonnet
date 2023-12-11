local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'influxdb-cluster-overview';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local alertsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '',
      datasource=promDatasource,
      legendFormat='',
    ),
  ],
  type: 'alertlist',
  title: 'Alerts',
  description: 'Panel to report on the status of firing alerts.',
  options: {
    alertInstanceLabelFilter: '{job=~"${job:regex}", influxdb_cluster=~"${influxdb_cluster:regex}"}',
    alertName: '',
    dashboardAlerts: false,
    groupBy: [],
    groupMode: 'default',
    maxItems: 20,
    sortOrder: 1,
    stateFilter: {
      'error': true,
      firing: true,
      noData: false,
      normal: false,
      pending: true,
    },
    viewMode: 'list',
  },
};

local serversPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'influxdb_uptime_seconds{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='Uptime',
      format='table',
    ),
    prometheus.target(
      'influxdb_buckets_total{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='Buckets',
      format='table',
    ),
    prometheus.target(
      'influxdb_users_total{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='Users',
      format='table',
    ),
    prometheus.target(
      'influxdb_replications_total{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='Replications',
      format='table',
    ),
    prometheus.target(
      'influxdb_remotes_total{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='Remotes',
      format='table',
    ),
    prometheus.target(
      'influxdb_scrapers_total{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='Scrapers',
      format='table',
    ),
    prometheus.target(
      'influxdb_dashboards_total{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='Dashboards',
      format='table',
    ),
  ],
  type: 'table',
  title: 'Servers',
  description: 'Statistics for each instance in the cluster.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      custom: {
        align: 'left',
        cellOptions: {
          type: 'auto',
        },
        inspect: false,
      },
      links: [],
      mappings: [],
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
        ],
      },
    },
    overrides: [
      {
        matcher: {
          id: 'byName',
          options: 'instance',
        },
        properties: [
          {
            id: 'links',
            value: [
              {
                title: 'Instance overview',
                url: '/d/influxdb-instance-overview?from=${__from}&to=${__to}&var-instance=${__data.fields["Instance"]}',
              },
            ],
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'Uptime',
        },
        properties: [
          {
            id: 'unit',
            value: 's',
          },
        ],
      },
    ],
  },
  options: {
    cellHeight: 'sm',
    footer: {
      countRows: false,
      fields: '',
      reducer: [
        'sum',
      ],
      show: false,
    },
    showHeader: true,
  },
  pluginVersion: '10.3.0-63516',
  transformations: [
    {
      id: 'joinByField',
      options: {
        byField: 'instance',
        mode: 'outer',
      },
    },
    {
      id: 'organize',
      options: {
        excludeByName: {
          Time: true,
          'Time 2': true,
          'Time 3': true,
          'Time 4': true,
          'Time 5': true,
          'Time 6': true,
          'Time 7': true,
          'Value #B': false,
          'Value #H': true,
          __name__: true,
          '__name__ 1': true,
          '__name__ 2': true,
          '__name__ 3': true,
          '__name__ 4': true,
          '__name__ 5': true,
          '__name__ 6': true,
          '__name__ 7': true,
          id: true,
          influxdb_cluster: false,
          'influxdb_cluster 2': true,
          'influxdb_cluster 3': true,
          'influxdb_cluster 4': true,
          'influxdb_cluster 5': true,
          'influxdb_cluster 6': true,
          'influxdb_cluster 7': true,
          job: true,
          'job 2': true,
          'job 3': true,
          'job 4': true,
          'job 5': true,
          'job 6': true,
          'job 7': true,
          'cluster 7': true,
          'cluster 2': true,
          cluster: false,
          'cluster 3': true,
          'cluster 4': true,
          'cluster 5': true,
          'cluster 6': true,
        },
        indexByName: {},
        renameByName: {
          Dashboards: '',
          'Value #A': 'Uptime',
          'Value #B': 'Buckets',
          'Value #C': 'Users',
          'Value #D': 'Replications',
          'Value #E': 'Remotes',
          'Value #F': 'Scrapers',
          'Value #G': 'Dashboards',
          influxdb_cluster: 'InfluxDB cluster',
          instance: 'Instance',
          cluster: 'K8s cluster',
        },
      },
    },
  ],
};

local queriesAndOperationsRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Queries and operations',
  collapsed: false,
};

local topInstancesByHTTPAPIRequestsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk($k, sum by(job, influxdb_cluster, instance) (rate(http_api_requests_total{' + matcher + '}[$__rate_interval])))',
      datasource=promDatasource,
      legendFormat='{{influxdb_cluster}} - {{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Top instances by HTTP API requests',
  description: 'HTTP API request rate for the instances with the most traffic in the cluster.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 20,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
        spanNulls: false,
        stacking: {
          group: 'A',
          mode: 'none',
        },
        thresholdsStyle: {
          mode: 'off',
        },
      },
      mappings: [],
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
          {
            color: 'red',
            value: 80,
          },
        ],
      },
      unit: 'reqps',
    },
    overrides: [],
  },
  options: {
    legend: {
      calcs: [],
      displayMode: 'list',
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local httpAPIRequestDurationPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'histogram_quantile(0.95, sum by(le, job, influxdb_cluster) (rate(http_api_request_duration_seconds_bucket{' + matcher + '}[$__rate_interval])))',
      datasource=promDatasource,
      legendFormat='{{influxdb_cluster}}',
    ),
  ],
  type: 'histogram',
  title: 'HTTP API request duration',
  description: 'Time taken to respond to HTTP API requests for the cluster.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      custom: {
        fillOpacity: 80,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineWidth: 1,
      },
      decimals: 0,
      mappings: [],
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
        ],
      },
      unit: 's',
    },
    overrides: [],
  },
  options: {
    bucketOffset: 0,
    combine: false,
    legend: {
      calcs: [],
      displayMode: 'list',
      placement: 'bottom',
      showLegend: true,
    },
  },
};

local httpAPIResponseCodesPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, influxdb_cluster, response_code) (rate(http_api_requests_total{' + matcher + '}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{influxdb_cluster}} - {{response_code}}',
    ),
  ],
  type: 'piechart',
  title: 'HTTP API response codes',
  description: 'Rate of different HTTP response codes for the entire cluster.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
      },
      mappings: [],
      unit: 'reqps',
    },
    overrides: [],
  },
  options: {
    legend: {
      displayMode: 'list',
      placement: 'right',
      showLegend: true,
    },
    pieType: 'pie',
    reduceOptions: {
      calcs: [
        'lastNotNull',
      ],
      fields: '',
      values: false,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local httpOperationsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, influxdb_cluster, status) (rate(http_query_request_count{' + matcher + '}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{influxdb_cluster}} - query - {{status}}',
    ),
    prometheus.target(
      'sum by(job, influxdb_cluster, status) (rate(http_write_request_count{' + matcher + '}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{influxdb_cluster}} - write - {{status}}',
    ),
  ],
  type: 'timeseries',
  title: 'HTTP operations',
  description: 'Rate of database operations from HTTP for the cluster.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 20,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
        spanNulls: false,
        stacking: {
          group: 'A',
          mode: 'normal',
        },
        thresholdsStyle: {
          mode: 'off',
        },
      },
      mappings: [],
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
        ],
      },
      unit: 'ops',
    },
    overrides: [],
  },
  options: {
    legend: {
      calcs: [],
      displayMode: 'list',
      placement: 'right',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local httpOperationDataPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, influxdb_cluster) (rate(http_query_request_bytes{' + matcher + '}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{influxdb_cluster}} - query - request',
    ),
    prometheus.target(
      'sum by(job, influxdb_cluster) (rate(http_query_response_bytes{' + matcher + '}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{influxdb_cluster}} - query - response',
    ),
    prometheus.target(
      'sum by(job, influxdb_cluster) (rate(http_write_request_bytes{' + matcher + '}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{influxdb_cluster}} - write - request',
    ),
    prometheus.target(
      'sum by(job, influxdb_cluster) (rate(http_write_response_bytes{' + matcher + '}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{influxdb_cluster}} - write - response',
    ),
  ],
  type: 'timeseries',
  title: 'HTTP operation data',
  description: 'Rate of database HTTP operation data for the cluster.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 20,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
        spanNulls: false,
        stacking: {
          group: 'A',
          mode: 'normal',
        },
        thresholdsStyle: {
          mode: 'off',
        },
      },
      mappings: [],
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
        ],
      },
      unit: 'Bps',
    },
    overrides: [],
  },
  options: {
    legend: {
      calcs: [
        'min',
        'mean',
        'max',
      ],
      displayMode: 'table',
      placement: 'right',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local topInstancesByIQLQueryRatePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk($k, sum by(job, influxdb_cluster, instance) (rate(influxql_service_requests_total{' + matcher + '}[$__rate_interval])))',
      datasource=promDatasource,
      legendFormat='{{influxdb_cluster}} - {{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Top instances by IQL query rate',
  description: 'Rate of InfluxQL queries for the instances with the most traffic in the cluster.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 20,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
        spanNulls: false,
        stacking: {
          group: 'A',
          mode: 'none',
        },
        thresholdsStyle: {
          mode: 'off',
        },
      },
      mappings: [],
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
          {
            color: 'red',
            value: 80,
          },
        ],
      },
      unit: 'queries/s',
    },
    overrides: [],
  },
  options: {
    legend: {
      calcs: [],
      displayMode: 'list',
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local iqlQueryResponseTimePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, influxdb_cluster, result) (increase(influxql_service_executing_duration_seconds_sum{' + matcher + '}[$__interval:]))',
      datasource=promDatasource,
      legendFormat='{{influxdb_cluster}} - {{result}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'IQL query response time / $__interval',
  description: 'Response time for recent InfluxQL queries, organized by result.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 20,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
        spanNulls: false,
        stacking: {
          group: 'A',
          mode: 'normal',
        },
        thresholdsStyle: {
          mode: 'off',
        },
      },
      mappings: [],
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
        ],
      },
      unit: 's',
    },
    overrides: [],
  },
  options: {
    legend: {
      calcs: [],
      displayMode: 'list',
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local boltdbOperationsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(boltdb_reads_total{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{influxdb_cluster}} - reads',
    ),
    prometheus.target(
      'rate(boltdb_writes_total{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{influxdb_cluster}} - writes',
    ),
  ],
  type: 'timeseries',
  title: 'BoltDB operations',
  description: 'Rate of reads and writes to the underlying BoltDB storage engine for the entire cluster.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 20,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
        spanNulls: false,
        stacking: {
          group: 'A',
          mode: 'normal',
        },
        thresholdsStyle: {
          mode: 'off',
        },
      },
      mappings: [],
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
        ],
      },
      unit: 'ops',
    },
    overrides: [],
  },
  options: {
    legend: {
      calcs: [],
      displayMode: 'list',
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local taskSchedulerRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Task scheduler',
  collapsed: false,
};

local activeTasksPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, influxdb_cluster) (task_scheduler_current_execution{' + matcher + '})',
      datasource=promDatasource,
      legendFormat='{{influxdb_cluster}}',
    ),
  ],
  type: 'timeseries',
  title: 'Active tasks',
  description: 'Number of tasks currently being executed for the cluster.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 20,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
        spanNulls: false,
        stacking: {
          group: 'A',
          mode: 'none',
        },
        thresholdsStyle: {
          mode: 'off',
        },
      },
      mappings: [],
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
        ],
      },
      unit: 'none',
    },
    overrides: [],
  },
  options: {
    legend: {
      calcs: [],
      displayMode: 'list',
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local activeWorkersPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, influxdb_cluster) (task_executor_total_runs_active{' + matcher + '})',
      datasource=promDatasource,
      legendFormat='{{influxdb_cluster}}',
    ),
  ],
  type: 'timeseries',
  title: 'Active workers',
  description: 'Number of workers currently running tasks on the cluster.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 20,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
        spanNulls: false,
        stacking: {
          group: 'A',
          mode: 'none',
        },
        thresholdsStyle: {
          mode: 'off',
        },
      },
      mappings: [],
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
        ],
      },
      unit: 'none',
    },
    overrides: [],
  },
  options: {
    legend: {
      calcs: [],
      displayMode: 'list',
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local executionsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(task_scheduler_total_execution_calls{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{influxdb_cluster}} - total',
    ),
    prometheus.target(
      'rate(task_scheduler_total_execute_failure{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{influxdb_cluster}} - failed',
    ),
  ],
  type: 'timeseries',
  title: 'Executions',
  description: 'Rate of executions and execution failures for the cluster.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 20,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
        spanNulls: false,
        stacking: {
          group: 'A',
          mode: 'none',
        },
        thresholdsStyle: {
          mode: 'off',
        },
      },
      mappings: [],
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
        ],
      },
      unit: 'ops',
    },
    overrides: [],
  },
  options: {
    legend: {
      calcs: [],
      displayMode: 'list',
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local schedulesPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(task_scheduler_total_schedule_calls{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{influxdb_cluster}} - total',
    ),
    prometheus.target(
      'rate(task_scheduler_total_schedule_fails{' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{influxdb_cluster}} - failed',
    ),
  ],
  type: 'timeseries',
  title: 'Schedules',
  description: 'Rate of schedule operations and schedule operation failures for the cluster.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 20,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
        spanNulls: false,
        stacking: {
          group: 'A',
          mode: 'none',
        },
        thresholdsStyle: {
          mode: 'off',
        },
      },
      mappings: [],
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
        ],
      },
      unit: 'ops',
    },
    overrides: [],
  },
  options: {
    legend: {
      calcs: [],
      displayMode: 'list',
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local goRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Go',
  collapsed: false,
};

local topInstancesByHeapMemoryUsagePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk($k, go_memstats_heap_alloc_bytes{' + matcher + '}/clamp_min(go_memstats_heap_idle_bytes{' + matcher + '} + go_memstats_heap_alloc_bytes{' + matcher + '}, 1))',
      datasource=promDatasource,
      legendFormat='{{influxdb_cluster}} - {{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Top instances by heap memory usage',
  description: 'Heap memory usage for the largest instances in the cluster.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'continuous-BlYlRd',
      },
      custom: {
        axisBorderShow: false,
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 20,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
        spanNulls: false,
        stacking: {
          group: 'A',
          mode: 'none',
        },
        thresholdsStyle: {
          mode: 'off',
        },
      },
      mappings: [],
      max: 1,
      min: 0,
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
        ],
      },
      unit: 'percentunit',
    },
    overrides: [],
  },
  options: {
    legend: {
      calcs: [],
      displayMode: 'list',
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local topInstancesByGCCPUUsagePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'go_memstats_gc_cpu_fraction{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{influxdb_cluster}} - {{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Top instances by GC CPU usage',
  description: 'Fraction of CPU time used for garbage collection for the top instances in the cluster.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'continuous-BlYlRd',
      },
      custom: {
        axisBorderShow: false,
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 20,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'smooth',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
        spanNulls: false,
        stacking: {
          group: 'A',
          mode: 'none',
        },
        thresholdsStyle: {
          mode: 'off',
        },
      },
      mappings: [],
      max: 100,
      min: 0,
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
          },
          {
            color: 'red',
            value: 80,
          },
        ],
      },
      unit: 'percent',
    },
    overrides: [],
  },
  options: {
    legend: {
      calcs: [],
      displayMode: 'list',
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local getMatcher(cfg) = '%(influxdbSelector)s, influxdb_cluster=~"$influxdb_cluster"' % cfg;

{
  grafanaDashboards+:: {
    'influxdb-cluster-overview.json':
      dashboard.new(
        'InfluxDB cluster overview',
        time_from='%s' % $._config.dashboardPeriod,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        description='',
        uid=dashboardUid,
      )
      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Other InfluxDB dashboards',
        includeVars=true,
        keepTime=true,
        tags=($._config.dashboardTags),
      ))
      .addTemplates(
        [
          template.datasource(
            promDatasourceName,
            'prometheus',
            null,
            label='Data Source',
            refresh='load'
          ),
          template.new(
            'job',
            promDatasource,
            'label_values(influxdb_uptime_seconds,job)',
            label='Job',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.+',
            sort=0
          ),
          template.new(
            'cluster',
            promDatasource,
            'label_values(influxdb_uptime_seconds{%(multiclusterSelector)s}, cluster)' % $._config,
            label='Cluster',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.*',
            hide=if $._config.enableMultiCluster then '' else 'variable',
            sort=0
          ),
          template.new(
            'influxdb_cluster',
            promDatasource,
            'label_values(influxdb_uptime_seconds{%(influxdbSelector)s}, influxdb_cluster)' % $._config,
            label='InfluxDB cluster',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='',
            sort=0
          ),
          template.custom(
            'k',
            query='5,10,20,50',
            current='5',
            label='Top node count',
            refresh='never',
            includeAll=false,
            multi=false,
            allValues='',
          ),
        ]
      )
      .addPanels(
        [
          alertsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 7, x: 0, y: 0 } },
          serversPanel(getMatcher($._config)) { gridPos: { h: 8, w: 17, x: 7, y: 0 } },
          queriesAndOperationsRow { gridPos: { h: 1, w: 24, x: 0, y: 17 } },
          topInstancesByHTTPAPIRequestsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 0, y: 18 } },
          httpAPIRequestDurationPanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 8, y: 18 } },
          httpAPIResponseCodesPanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 16, y: 18 } },
          httpOperationsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 26 } },
          httpOperationDataPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 26 } },
          topInstancesByIQLQueryRatePanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 0, y: 34 } },
          iqlQueryResponseTimePanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 8, y: 34 } },
          boltdbOperationsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 16, y: 34 } },
          taskSchedulerRow { gridPos: { h: 1, w: 24, x: 0, y: 42 } },
          activeTasksPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 43 } },
          activeWorkersPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 43 } },
          executionsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 51 } },
          schedulesPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 51 } },
          goRow { gridPos: { h: 1, w: 24, x: 0, y: 8 } },
          topInstancesByHeapMemoryUsagePanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 9 } },
          topInstancesByGCCPUUsagePanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 9 } },
        ]
      ),
  },
}
