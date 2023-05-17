local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'sap-hana-instance-overview';

local promDatasourceName = 'prometheus_datasource';
local lokiDatasourceName = 'loki_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local lokiDatasource = {
  uid: '${%s}' % lokiDatasourceName,
};

local cpuUsagePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (job, sid, host, core) (hanadb_cpu_busy_percent{job=~"$job", sid=~"$sid", host=~"$host"})',
      datasource=promDatasource,
      legendFormat='{{host}} - core {{core}}',
    ),
  ],
  type: 'timeseries',
  title: 'CPU usage',
  description: 'CPU usage percentage of the SAP HANA instance',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 0,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'auto',
        spanNulls: false,
        stacking: {
          group: 'A',
          mode: 'none',
        },
        thresholdsStyle: {
          mode: 'line',
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

local diskUsagePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '100 * sum by (job, sid, host) (hanadb_disk_total_used_size_mb{job=~"$job", sid=~"$sid", host=~"$host"}) / sum by (job, sid, host) (hanadb_disk_total_size_mb{job=~"$job", sid=~"$sid", host=~"$host"})',
      datasource=promDatasource,
      legendFormat='{{host}}',
    ),
  ],
  type: 'timeseries',
  title: 'Disk usage',
  description: 'Disk utilization percentage of the SAP HANA instance',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 0,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'auto',
        spanNulls: false,
        stacking: {
          group: 'A',
          mode: 'none',
        },
        thresholdsStyle: {
          mode: 'line',
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

local physicalMemoryUsagePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '100 * sum by (job, sid, host) (hanadb_host_memory_resident_mb{job=~"$job", sid=~"$sid", host=~"$host"}) / sum by (job, sid, host) (hanadb_host_memory_physical_total_mb{job=~"$job", sid=~"$sid", host=~"$host"})',
      datasource=promDatasource,
      legendFormat='{{host}} - resident',
    ),
    prometheus.target(
      '100 * sum by (job, sid, host) (hanadb_host_memory_swap_used_mb{job=~"$job", sid=~"$sid", host=~"$host"}) / clamp_min(sum by (job, sid, host) (hanadb_host_memory_swap_used_mb{job=~"$job", sid=~"$sid", host=~"$host"} + hanadb_host_memory_swap_free_mb{job=~"$job", sid=~"$sid", host=~"$host"}), 1)',
      datasource=promDatasource,
      legendFormat='{{host}} - swap',
    ),
  ],
  type: 'timeseries',
  title: 'Physical memory usage',
  description: 'Physical memory utilization percentage of the SAP HANA instance',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 0,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'auto',
        spanNulls: false,
        stacking: {
          group: 'A',
          mode: 'none',
        },
        thresholdsStyle: {
          mode: 'line',
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

local schemaMemoryUsagePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (job, sid, host, database_name, schema_name) (hanadb_schema_used_memory_mb{job=~"$job", sid=~"$sid", host=~"$host"})',
      datasource=promDatasource,
      legendFormat='{{host}} - {{database_name}} - {{schema_name}}',
    ),
  ],
  type: 'timeseries',
  title: 'Schema memory usage',
  description: 'Total used memory by schema in the SAP HANA instance',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 0,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'auto',
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
      unit: 'decmbytes',
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

local networkIOThroughputPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (job, sid, host, interface) (hanadb_network_receive_rate_kb_per_seconds{job=~"$job", sid=~"$sid", host=~"$host"})',
      datasource=promDatasource,
      legendFormat='{{host}} - {{interface}} - receive',
    ),
    prometheus.target(
      'sum by (job, sid, host, interface) (hanadb_network_transmission_rate_kb_per_seconds{job=~"$job", sid=~"$sid", host=~"$host"})',
      datasource=promDatasource,
      legendFormat='{{host}} - {{interface}} - transmit',
    ),
  ],
  type: 'timeseries',
  title: 'Network I/O throughput',
  description: 'Network I/O throughput for the SAP HANA instance',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 0,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'auto',
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
      unit: 'KBs',
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

local diskIOThroughputPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (job, sid, host, disk) (hanadb_disk_io_throughput_kb_second{job=~"$job", sid=~"$sid", host=~"$host"})',
      datasource=promDatasource,
      legendFormat='{{host}} - {{disk}}',
    ),
  ],
  type: 'timeseries',
  title: 'Disk I/O throughput',
  description: 'Disk throughput for the SAP HANA instance',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 0,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'auto',
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
      unit: 'KBs',
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

local connectionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (job, sid, host, connection_type, connection_status)(hanadb_connections_total_count{job=~"$job", sid=~"$sid", host=~"$host"})',
      datasource=promDatasource,
      legendFormat='{{host}} - {{connection_type}} - {{connection_status}}',
    ),
  ],
  type: 'timeseries',
  title: 'Connections',
  description: 'Number of connections grouped by type and status in the SAP HANA instance',
  fieldConfig: {
    defaults: {
      color: {
        fixedColor: 'blue',
        mode: 'palette-classic',
      },
      custom: {
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 0,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'auto',
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
  pluginVersion: '9.5.2-cloud.1.f9fd074b',
};

local averageQueryExecutionTimePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by (job, sid, host, service, sql_type) ( hanadb_sql_service_elap_per_exec_avg_ms{job=~"$job", sid=~"$sid", host=~"$host"})',
      datasource=promDatasource,
      legendFormat='{{host}} - {{service}} - {{sql_type}}',
    ),
  ],
  type: 'timeseries',
  title: 'Average query execution time',
  description: 'Average elapsed time per execution by service and SQL type in the SAP HANA instance',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 0,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'auto',
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
      unit: 'ms',
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
      sort: 'none',
    },
  },
  pluginVersion: '9.5.0-cloud.5.a016665c',
};

local averageLockWaitExecutionTimePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (job, sid, host, service, sql_type) (hanadb_sql_service_lock_per_exec_ms{job=~"$job", sid=~"$sid", host=~"$host"})',
      datasource=promDatasource,
      legendFormat='{{host}} - {{service}} - {{sql_type}}',
    ),
  ],
  type: 'timeseries',
  title: 'Average lock wait execution time',
  description: 'Average lock wait time per execution by service and SQL type in the SAP HANA instance',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 0,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'auto',
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
      unit: 'ms',
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
  pluginVersion: '9.5.0-cloud.5.a016665c',
};

local alertsRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Alerts',
  collapsed: false,
};

local alertsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (job, sid, host) (hanadb_alerts_current_rating{job=~"$job", sid=~"$sid", host=~"$host"})',
      datasource=promDatasource,
      legendFormat='{{host}}',
    ),
  ],
  type: 'stat',
  title: 'Alerts',
  description: 'Count of the SAP HANA instance’s current alerts',
  fieldConfig: {
    defaults: {
      color: {
        fixedColor: 'yellow',
        mode: 'thresholds',
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
            color: 'green',
            value: 0,
          },
          {
            color: '#EAB839',
            value: 1,
          },
        ],
      },
    },
    overrides: [],
  },
  options: {
    colorMode: 'value',
    graphMode: 'none',
    justifyMode: 'center',
    orientation: 'auto',
    reduceOptions: {
      calcs: [
        'lastNotNull',
      ],
      fields: '',
      values: false,
    },
    textMode: 'auto',
  },
  pluginVersion: '9.5.2-cloud.2.0cb5a501',
};

local recentAlertsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hanadb_alerts_current_rating{job=~"$job", sid=~"$sid", host=~"$host"}',
      datasource=promDatasource,
      legendFormat='{{alert_details}} {{alert_useraction}}',
      format='table',
    ),
  ],
  type: 'table',
  title: 'Recent alerts',
  description: 'Table of the recent SAP HANA current alerts in the SAP HANA instance',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        align: 'center',
        cellOptions: {
          type: 'auto',
        },
        inspect: false,
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
    },
    overrides: [],
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
  pluginVersion: '9.5.2-cloud.2.0cb5a501',
  transformations: [
    {
      id: 'organize',
      options: {
        excludeByName: {
          Value: true,
          __name__: true,
          alert_timestamp: true,
          database_name: true,
          host: true,
          insnr: true,
          instance: true,
          job: true,
          port: true,
          sid: true,
        },
        indexByName: {
          Time: 2,
          Value: 12,
          __name__: 3,
          alert_details: 0,
          alert_timestamp: 4,
          alert_useraction: 1,
          database_name: 5,
          host: 6,
          insnr: 7,
          instance: 8,
          job: 9,
          port: 10,
          sid: 11,
        },
        renameByName: {
          Time: '',
          alert_details: 'Details',
          alert_useraction: 'Action',
          port: '',
        },
      },
    },
    {
      id: 'groupBy',
      options: {
        fields: {
          Action: {
            aggregations: [],
            operation: 'groupby',
          },
          Details: {
            aggregations: [],
            operation: 'groupby',
          },
          Time: {
            aggregations: [
              'lastNotNull',
            ],
            operation: 'aggregate',
          },
        },
      },
    },
    {
      id: 'organize',
      options: {
        excludeByName: {},
        indexByName: {},
        renameByName: {
          'Time (lastNotNull)': 'Time (last fired)',
        },
      },
    },
  ],
};

local outliersRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Outliers',
  collapsed: false,
};

local topTablesByMemoryPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (job, sid, host, database_name, table_name, schema_name)(topk(5, hanadb_table_cs_top_mem_total_mb{job=~"$job", sid=~"$sid", host=~"$host"}))',
      datasource=promDatasource,
      legendFormat='{{host}} - {{database_name}} - {{schema_name}} - {{table_name}}',
    ),
  ],
  type: 'timeseries',
  title: 'Top tables by memory',
  description: 'Top tables by the sum of memory size in the main, delta, and history parts for the SAP HANA instance',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 0,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'auto',
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
      unit: 'decmbytes',
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
  pluginVersion: '9.5.0-cloud.5.a016665c',
};

local topSQLQueriesByAverageTimePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (job, sid, host, sql_hash) (hanadb_sql_top_time_consumers_mu{job=~"$job", sid=~"$sid", host=~"$host"})',
      datasource=promDatasource,
      legendFormat='{{host}} - hash: {{sql_hash}}',
    ),
  ],
  type: 'timeseries',
  title: 'Top SQL queries by average time',
  description: 'Top statements by time consumed over all executions for the SAP HANA instance',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 0,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'auto',
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
      unit: 'µs',
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
  pluginVersion: '9.5.0-cloud.5.a016665c',
};

local traceLogsPanel = {
  datasource: lokiDatasource,
  targets: [
    {
      datasource: lokiDatasource,
      editorMode: 'code',
      expr: '{filename=~"/opt/hana/shared/.*/HDB.*/.*/trace/.*.trc"} |=``',
      queryType: 'range',
      refId: 'A',
    },
  ],
  type: 'logs',
  title: 'Trace logs',
  description: 'Recent trace logs as collected from SAP HANA.',
  options: {
    dedupStrategy: 'none',
    enableLogDetails: true,
    prettifyLogMessage: false,
    showCommonLabels: false,
    showLabels: false,
    showTime: false,
    sortOrder: 'Descending',
    wrapLogMessage: false,
  },
  pluginVersion: '9.5.0-cloud.5.a016665c',
};

{
  grafanaDashboards+:: {
    'sap-hana-instance-overview.json':
      dashboard.new(
        'SAP HANA instance overview',
        time_from='%s' % $._config.dashboardPeriod,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        description='',
        uid=dashboardUid,
      )

      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Other SAP HANA dashboards',
        includeVars=true,
        keepTime=true,
        tags=($._config.dashboardTags),
      ))

      .addTemplates(
        std.flattenArrays([
          [
            template.datasource(
              promDatasourceName,
              'prometheus',
              null,
              label='Data Source',
              refresh='load'
            ),
          ],
          if $._config.enableLokiLogs then [
            template.datasource(
              lokiDatasourceName,
              'loki',
              null,
              label='Loki Datasource',
              refresh='load'
            ),
          ] else [],
          [
            template.new(
              'job',
              promDatasource,
              'label_values(hanadb_cpu_busy_percent,job)',
              label='Job',
              refresh=1,
              includeAll=false,
              multi=false,
              allValues='',
              sort=0
            ),
            template.new(
              'sid',
              promDatasource,
              'label_values(hanadb_cpu_busy_percent,sid)',
              label='SAP HANA system',
              refresh=1,
              includeAll=false,
              multi=false,
              allValues='',
              sort=0
            ),
            template.new(
              'host',
              promDatasource,
              'label_values(hanadb_cpu_busy_percent,host)',
              label='SAP HANA instance',
              refresh=1,
              includeAll=true,
              multi=false,
              allValues='',
              sort=0
            ),
          ],
        ])
      )
      .addPanels(
        std.flattenArrays([
          [
            cpuUsagePanel { gridPos: { h: 6, w: 12, x: 0, y: 0 } },
            diskUsagePanel { gridPos: { h: 6, w: 12, x: 12, y: 0 } },
            physicalMemoryUsagePanel { gridPos: { h: 6, w: 12, x: 0, y: 6 } },
            schemaMemoryUsagePanel { gridPos: { h: 6, w: 12, x: 12, y: 6 } },
            networkIOThroughputPanel { gridPos: { h: 6, w: 12, x: 0, y: 12 } },
            diskIOThroughputPanel { gridPos: { h: 6, w: 12, x: 12, y: 12 } },
            connectionsPanel { gridPos: { h: 6, w: 8, x: 0, y: 18 } },
            averageQueryExecutionTimePanel { gridPos: { h: 6, w: 8, x: 8, y: 18 } },
            averageLockWaitExecutionTimePanel { gridPos: { h: 6, w: 8, x: 16, y: 18 } },
            alertsRow { gridPos: { h: 1, w: 24, x: 0, y: 24 } },
            alertsPanel { gridPos: { h: 6, w: 7, x: 0, y: 25 } },
            recentAlertsPanel { gridPos: { h: 6, w: 17, x: 7, y: 25 } },
            outliersRow { gridPos: { h: 1, w: 24, x: 0, y: 31 } },
            topTablesByMemoryPanel { gridPos: { h: 6, w: 12, x: 0, y: 32 } },
            topSQLQueriesByAverageTimePanel { gridPos: { h: 6, w: 12, x: 12, y: 32 } },
          ],
          if $._config.enableLokiLogs then [
            traceLogsPanel { gridPos: { h: 6, w: 24, x: 0, y: 38 } },
          ] else [],
          [
          ],
        ])
      ),

  },
}
