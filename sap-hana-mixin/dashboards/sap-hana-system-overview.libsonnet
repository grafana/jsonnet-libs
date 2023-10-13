local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'sap-hana-system-overview';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local replicaStatusPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hanadb_sr_replication{job=~"$job", sid=~"$sid"}',
      datasource=promDatasource,
      legendFormat='{{secondary_site_name}}',
    ),
  ],
  type: 'stat',
  title: 'Replica status',
  description: 'State of the replicas in the SAP HANA system',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      mappings: [
        {
          options: {
            '0': {
              color: 'green',
              index: 0,
              text: 'ACTIVE',
            },
            '1': {
              color: 'yellow',
              index: 1,
              text: 'INITIALIZING',
            },
            '2': {
              color: 'yellow',
              index: 2,
              text: 'SYNCING',
            },
            '3': {
              color: 'red',
              index: 3,
              text: 'UNKNOWN',
            },
            '4': {
              color: 'red',
              index: 4,
              text: 'ERROR',
            },
            '99': {
              color: 'red',
              index: 5,
              text: 'UNMAPPED',
            },
          },
          type: 'value',
        },
      ],
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
            color: 'yellow',
            value: 1,
          },
          {
            color: 'red',
            value: 3,
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

local averageReplicationShipDelayPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by (job, sid, secondary_site_name) (hanadb_sr_ship_delay{job=~"$job", sid=~"$sid"})',
      datasource=promDatasource,
      legendFormat='{{secondary_site_name}}',
    ),
  ],
  type: 'timeseries',
  title: 'Average replication ship delay',
  description: 'Average system replication log shipping delay in the SAP HANA system ',
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
            value: 1,
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

local cpuUsagePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (job, sid, host, core) (hanadb_cpu_busy_percent{job=~"$job", sid=~"$sid"})',
      datasource=promDatasource,
      legendFormat='{{host}} - core {{core}}',
    ),
  ],
  type: 'timeseries',
  title: 'CPU usage',
  description: 'CPU usage percentage of the SAP HANA system',
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
        lineStyle: {
          fill: 'solid',
        },
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
      '100 * sum by (job, sid, host) (hanadb_disk_total_used_size_mb{job=~"$job", sid=~"$sid"}) / sum by (job, sid, host) (hanadb_disk_total_size_mb{job=~"$job", sid=~"$sid"})',
      datasource=promDatasource,
      legendFormat='{{host}}',
    ),
  ],
  type: 'timeseries',
  title: 'Disk usage',
  description: 'Disk utilization percentage of the SAP HANA system',
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
      '100 * sum by (job, sid, host) (hanadb_host_memory_resident_mb{job=~"$job", sid=~"$sid"}) / sum by (job, sid, host) (hanadb_host_memory_physical_total_mb{job=~"$job", sid=~"$sid"})',
      datasource=promDatasource,
      legendFormat='{{host}} - resident',
    ),
    prometheus.target(
      '100 * sum by (job, sid, host) (hanadb_host_memory_swap_used_mb{job=~"$job", sid=~"$sid"}) / clamp_min(sum by (job, sid, host) (hanadb_host_memory_swap_used_mb{job=~"$job", sid=~"$sid"} + hanadb_host_memory_swap_free_mb{job=~"$job", sid=~"$sid"}), 1)',
      datasource=promDatasource,
      legendFormat='{{host}} - swap',
    ),
  ],
  type: 'timeseries',
  title: 'Physical memory usage',
  description: 'Physical memory utilization percentage of the SAP HANA system',
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

local sapHANAMemoryUsagePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '100 * sum by (job, sid, host) (hanadb_host_memory_used_total_mb{job=~"$job", sid=~"$sid"}) / sum by (job, sid, host) (hanadb_host_memory_alloc_limit_mb{job=~"$job", sid=~"$sid"})',
      datasource=promDatasource,
      legendFormat='{{host}}',
    ),
  ],
  type: 'timeseries',
  title: 'SAP HANA memory usage',
  description: 'Total amount of used memory by processes in the SAP HANA system',
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

local networkIOThroughputPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (job, sid, host) (hanadb_network_receive_rate_kb_per_seconds{job=~"$job", sid=~"$sid"})',
      datasource=promDatasource,
      legendFormat='{{host}} - receive',
    ),
    prometheus.target(
      'sum by (job, sid, host) (hanadb_network_transmission_rate_kb_per_seconds{job=~"$job", sid=~"$sid"})',
      datasource=promDatasource,
      legendFormat='{{host}} - transmit',
    ),
  ],
  type: 'timeseries',
  title: 'Network I/O throughput',
  description: 'Network I/O throughput in the SAP HANA system',
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
      'sum by (job, sid, host) (hanadb_disk_io_throughput_kb_second{job=~"$job", sid=~"$sid"})',
      datasource=promDatasource,
      legendFormat='{{host}}',
    ),
  ],
  type: 'timeseries',
  title: 'Disk I/O throughput',
  description: 'Disk throughput for the SAP HANA system',
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

local averageQueryExecutionTimePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'avg by (job, sid, host, service, sql_type) (hanadb_sql_service_elap_per_exec_avg_ms{job=~"$job", sid=~"$sid"})',
      datasource=promDatasource,
      legendFormat='{{host}} - service: {{service}} - type: {{sql_type}}',
    ),
  ],
  type: 'timeseries',
  title: 'Average query execution time',
  description: 'Average elapsed time per execution across the SAP HANA system',
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
};

local activeConnectionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (job, sid, host) (hanadb_connections_total_count{job=~"$job", sid=~"$sid", connection_status=~"RUNNING|QUEUING"})',
      datasource=promDatasource,
      legendFormat='{{host}}',
    ),
  ],
  type: 'stat',
  title: 'Active connections',
  description: 'Number of connections in active states across the SAP HANA system',
  fieldConfig: {
    defaults: {
      color: {
        fixedColor: 'blue',
        mode: 'fixed',
      },
      mappings: [],
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
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

local idleConnectionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by (job, sid, host) (hanadb_connections_total_count{job=~"$job", sid=~"$sid", connection_status=~"IDLE"})',
      datasource=promDatasource,
      legendFormat='{{host}}',
    ),
  ],
  type: 'stat',
  title: 'Idle connections',
  description: 'Number of connections in the idle state across the SAP HANA system',
  fieldConfig: {
    defaults: {
      color: {
        fixedColor: 'blue',
        mode: 'fixed',
      },
      mappings: [],
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
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
      'sum by (job, sid, host) (hanadb_alerts_current_rating{job=~"$job", sid=~"$sid"})',
      datasource=promDatasource,
      legendFormat='{{host}}',
    ),
  ],
  type: 'stat',
  title: 'Alerts',
  description: 'Count of the SAP HANA current alerts in the SAP HANA system',
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
      'hanadb_alerts_current_rating{job=~"$job", sid=~"$sid"}',
      datasource=promDatasource,
      format='table',
    ),
  ],
  type: 'table',
  title: 'Recent alerts',
  description: 'Table of the recent SAP HANA current alerts in the SAP HANA system',
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
        filterable: false,
        inspect: false,
      },
      mappings: [],
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
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
      enablePagination: false,
      fields: '',
      reducer: [
        'sum',
      ],
      show: false,
    },
    frameIndex: 4,
    showHeader: true,
  },
  pluginVersion: '9.5.2-cloud.2.0cb5a501',
  transformations: [
    {
      id: 'organize',
      options: {
        excludeByName: {
          Time: false,
          Value: true,
          __name__: true,
          alert_details: false,
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
          __name__: 4,
          alert_details: 0,
          alert_timestamp: 3,
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
          alert_details: 'Details',
          alert_timestamp: '',
          alert_useraction: 'Action',
          database_name: '',
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
          Action: '',
          'Time (lastNotNull)': 'Time (last fired)',
        },
      },
    },
  ],
};

{
  grafanaDashboards+:: {
    'sap-hana-system-overview.json':
      dashboard.new(
        'SAP HANA system overview',
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
        ]
      )
      .addPanels(
        [
          replicaStatusPanel { gridPos: { h: 6, w: 9, x: 0, y: 0 } },
          averageReplicationShipDelayPanel { gridPos: { h: 6, w: 15, x: 9, y: 0 } },
          cpuUsagePanel { gridPos: { h: 6, w: 12, x: 0, y: 6 } },
          diskUsagePanel { gridPos: { h: 6, w: 12, x: 12, y: 6 } },
          physicalMemoryUsagePanel { gridPos: { h: 6, w: 12, x: 0, y: 12 } },
          sapHANAMemoryUsagePanel { gridPos: { h: 6, w: 12, x: 12, y: 12 } },
          networkIOThroughputPanel { gridPos: { h: 6, w: 12, x: 0, y: 18 } },
          diskIOThroughputPanel { gridPos: { h: 6, w: 12, x: 12, y: 18 } },
          averageQueryExecutionTimePanel { gridPos: { h: 6, w: 12, x: 0, y: 24 } },
          activeConnectionsPanel { gridPos: { h: 6, w: 6, x: 12, y: 24 } },
          idleConnectionsPanel { gridPos: { h: 6, w: 6, x: 18, y: 24 } },
          alertsRow { gridPos: { h: 1, w: 24, x: 0, y: 30 } },
          alertsPanel { gridPos: { h: 6, w: 6, x: 0, y: 31 } },
          recentAlertsPanel { gridPos: { h: 6, w: 18, x: 6, y: 31 } },
        ]
      ),

  },
}
