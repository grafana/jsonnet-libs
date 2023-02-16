local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'wildfly-overview';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};


local requestPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(wildfly_undertow_request_count_total{server="$server", job="$job", instance="$instance"}[$__interval])',
      datasource=promDatasource,
    ),
  ],
  type: 'timeseries',
  title: 'Request',
  description: 'Requests rate over time',
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
      mode: 'single',
      sort: 'none',
    },
  },
};

local requestErrorsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(wildfly_undertow_error_count_total{server="$server", job="$job", instance="$instance"}[$__rate_interval])',
      datasource=promDatasource,
    ),
  ],
  type: 'timeseries',
  title: 'Request Errors',
  description: 'Rate of requests that result in 500 over time',
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
      mode: 'single',
      sort: 'none',
    },
  },
};

local networkReceivedThroughputPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(wildfly_undertow_bytes_received_total_bytes{server="$server", job="$job", instance="$instance"}[$__rate_interval])',
      datasource=promDatasource,
    ),
  ],
  type: 'timeseries',
  title: 'Network Received Throughput',
  description: 'Throughput rate of data received over time',
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
      unit: 'binBps',
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
      mode: 'single',
      sort: 'none',
    },
  },
};

local networkSentThroughputPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(wildfly_undertow_bytes_sent_total_bytes{server="$server", job="$job", instance="$instance"}[$__rate_interval])',
      datasource=promDatasource,
    ),
  ],
  type: 'timeseries',
  title: 'Network Sent Throughput',
  description: 'Throughput rate of data sent over time',
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
      unit: 'binBps',
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
      mode: 'single',
      sort: 'none',
    },
  },
};

local serverLogsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '{job="integration/wildfly"} |= ``',
      datasource=promDatasource,
      legendFormat='',
    ),
  ],
  type: 'table',
  title: 'Server logs',
  description: 'Recent logs from server log file',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      custom: {
        align: 'auto',
        displayMode: 'auto',
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
    overrides: [
      {
        matcher: {
          id: 'byName',
          options: 'labels',
        },
        properties: [
          {
            id: 'custom.width',
            value: 339,
          },
        ],
      },
    ],
  },
  options: {
    footer: {
      fields: '',
      reducer: [
        'sum',
      ],
      show: false,
    },
    showHeader: true,
    sortBy: [],
  },
  pluginVersion: '9.1.7',
};

local sessionsRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Sessions',
  collapsed: false,
};

local activeSessionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'wildfly_undertow_active_sessions{deployment="$deployment", job="$job", instance="$instance"}',
      datasource=promDatasource,
    ),
  ],
  type: 'timeseries',
  title: 'Active Sessions',
  description: 'Number of active sessions to deployment over time',
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
      unit: 'Sessions',
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
      mode: 'single',
      sort: 'none',
    },
  },
};

local expiredSessionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(wildfly_undertow_expired_sessions_total{deployment="$deployment", job="$job", instance="$instance"}[$__rate_interval])',
      datasource=promDatasource,
    ),
  ],
  type: 'timeseries',
  title: 'Expired Sessions',
  description: 'Number of sessions that have expired for a deployment over time',
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
      decimals: 0,
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
      unit: 'Sessions',
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
      mode: 'single',
      sort: 'none',
    },
  },
};

local rejectedSessionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(wildfly_undertow_rejected_sessions_total{deployment="$deployment", job="$job", instance="$instance"}[$__rate_interval])',
      datasource=promDatasource,
    ),
  ],
  type: 'timeseries',
  title: 'Rejected Sessions',
  description: 'Number of sessions that have been rejected from a deployment over time',
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
      decimals: 0,
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
      unit: 'Sessions',
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
      mode: 'single',
      sort: 'none',
    },
  },
};


{
  grafanaDashboards+:: {
    'wildfly-overview.json':
      dashboard.new(
        'wildfly-overview',
        time_from='%s' % $._config.dashboardPeriod,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        description='',
        uid=dashboardUid,
      )

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
            'label_values(wildfly_batch_jberet_active_count{}, job)',
            label='Job',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.+',
            sort=1
          ),
          template.new(
            'instance',
            promDatasource,
            'label_values(wildfly_batch_jberet_active_count{job=~"$job"}, instance)',
            label='Instance',
            refresh=2,
            includeAll=false,
            multi=false,
            allValues='',
            sort=0
          ),
          template.new(
            'server',
            promDatasource,
            'label_values(wildfly_undertow_request_count_total{}, server)',
            label='Server',
            refresh=2,
            includeAll=false,
            multi=false,
            allValues='',
            sort=0
          ),
          template.new(
            'deployment',
            promDatasource,
            'label_values(wildfly_undertow_active_sessions{}, deployment)',
            label='Deployment',
            refresh=2,
            includeAll=false,
            multi=false,
            allValues='',
            sort=0
          ),
        ]
      )
      .addPanels(
        [
          requestPanel { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
          requestErrorsPanel { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
          networkReceivedThroughputPanel { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
          networkSentThroughputPanel { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
          serverLogsPanel { gridPos: { h: 9, w: 24, x: 0, y: 16 } },
          sessionsRow { gridPos: { h: 1, w: 24, x: 0, y: 25 } },
          activeSessionsPanel { gridPos: { h: 8, w: 24, x: 0, y: 26 } },
          expiredSessionsPanel { gridPos: { h: 8, w: 12, x: 0, y: 34 } },
          rejectedSessionsPanel { gridPos: { h: 8, w: 12, x: 12, y: 34 } },
        ]
      ),

  },
}
