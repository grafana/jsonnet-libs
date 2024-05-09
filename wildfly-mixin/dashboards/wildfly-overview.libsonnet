local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'wildfly-overview';

local promDatasourceName = 'prometheus_datasource';
local lokiDatasourceName = 'loki_datasource';
local getMatcher(cfg) = '%(wildflySelector)s, instance=~"$instance"' % cfg;

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local lokiDatasource = {
  uid: '${%s}' % lokiDatasourceName,
};

local requestsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(wildfly_undertow_request_count_total{server=~"$server",' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{server}} - {{http_listener}}{{https_listener}}',
    ),
  ],
  type: 'timeseries',
  title: 'Requests',
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

local requestErrorsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(wildfly_undertow_error_count_total{server=~"$server",' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{server}} - {{http_listener}}{{https_listener}}',
    ),
  ],
  type: 'timeseries',
  title: 'Request errors',
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

local networkReceivedThroughputPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(wildfly_undertow_bytes_received_total_bytes{server=~"$server",' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{server}} - {{http_listener}}{{https_listener}}',
    ),
  ],
  type: 'timeseries',
  title: 'Network received throughput',
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

local networkSentThroughputPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(wildfly_undertow_bytes_sent_total_bytes{server=~"$server",' + matcher + '}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{server}} - {{http_listener}}{{https_listener}}',
    ),
  ],
  type: 'timeseries',
  title: 'Network sent throughput',
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

local serverLogsPanel(matcher) = {
  datasource: lokiDatasource,
  targets: [
    {
      datasource: lokiDatasource,
      editorMode: 'code',
      expr: '{filename=~"/opt/wildfly/.*/server.log",' + matcher + '}',
      queryType: 'range',
      refId: 'A',
    },
  ],
  type: 'logs',
  title: 'Server logs',
  description: 'Recent logs from server log file',
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
  pluginVersion: '9.1.7',
};

local sessionsRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Sessions',
  collapsed: false,
};

local activeSessionsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'wildfly_undertow_active_sessions{deployment=~"$deployment",' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{deployment}}',
    ),
  ],
  type: 'timeseries',
  title: 'Active sessions',
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

local expiredSessionsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(wildfly_undertow_expired_sessions_total{deployment=~"$deployment",' + matcher + '}[$__interval])',
      datasource=promDatasource,
      legendFormat='{{deployment}}',
      interval='1m',
      intervalFactor=2,
    ),
  ],
  type: 'timeseries',
  title: 'Expired sessions',
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

local rejectedSessionsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(wildfly_undertow_rejected_sessions_total{deployment=~"$deployment", job=~"$job", instance=~"$instance"}[$__interval])',
      datasource=promDatasource,
      legendFormat='{{deployment}}',
      interval='1m',
      intervalFactor=2,
    ),
  ],
  type: 'timeseries',
  title: 'Rejected sessions',
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
        'Wildfly overview',
        time_from='%s' % $._config.dashboardPeriod,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        description='',
        uid=dashboardUid,
      )

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
              'label_values(wildfly_batch_jberet_active_count{}, job)',
              label='Job',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=1
            ),
            template.new(
              'cluster',
              promDatasource,
              'label_values(wildfly_batch_jberet_active_count{%(multiclusterSelector)s}, cluster)' % $._config,
              label='Cluster',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.*',
              hide=if $._config.enableMultiCluster then '' else 'variable',
              sort=0
            ),
            template.new(
              'instance',
              promDatasource,
              'label_values(wildfly_batch_jberet_active_count{%(wildflySelector)s}, instance)' % $._config,
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
              'label_values(wildfly_undertow_request_count_total{%(wildflySelector)s}, server)' % $._config,
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
              'label_values(wildfly_undertow_active_sessions{%(wildflySelector)s}, deployment)' % $._config,
              label='Deployment',
              refresh=2,
              includeAll=false,
              multi=false,
              allValues='',
              sort=0
            ),
          ],
        ])
      )

      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Wildfly Dashboards',
        includeVars=true,
        keepTime=true,
        tags=($._config.dashboardTags),
      ))

      .addPanels(
        std.flattenArrays([
          [
            requestsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
            requestErrorsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
            networkReceivedThroughputPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
            networkSentThroughputPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
          ],
          if $._config.enableLokiLogs then [
            serverLogsPanel(getMatcher($._config)) { gridPos: { h: 9, w: 24, x: 0, y: 16 } },
          ] else [],
          [
            sessionsRow { gridPos: { h: 1, w: 24, x: 0, y: 25 } },
            activeSessionsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 24, x: 0, y: 26 } },
            expiredSessionsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 34 } },
            rejectedSessionsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 34 } },
          ],
        ])
      ),

  },
}
