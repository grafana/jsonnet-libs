local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'overview';

local promDatasourceName = 'prometheus_datasource';
local lokiDatasourceName = 'loki_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local lokiDatasource = {
  uid: '${%s}' % lokiDatasourceName,
};

local memoryUsagePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'jvm_memory_usage_used_bytes{job=~"$job", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{area}}',
    ),
  ],
  type: 'timeseries',
  title: 'Memory usage',
  description: 'The memory usage of the JVM of the instance',
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
      unit: 'bytes',
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

local cpuUsagePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'jvm_process_cpu_load{job=~"$job", instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'CPU usage',
  description: 'The CPU usage of the JVM process',
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
      mode: 'single',
      sort: 'none',
    },
  },
};

local trafficSentPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(increase(tomcat_bytessent_total{job=~"$job", instance=~"$instance", protocol=~"$protocol", port=~"$port"}[$__interval:])) by (job, instance)',
      datasource=promDatasource,
      legendFormat='{{job}} - {{instance}} - total',
    ),
    prometheus.target(
      'increase(tomcat_bytessent_total{job=~"$job", instance=~"$instance", protocol=~"$protocol", port=~"$port"}[$__rate_interval:])',
      datasource=promDatasource,
      legendFormat='{{job}} - {{instance}} - {{protocol}}-{{port}}',
    ),
  ],
  type: 'timeseries',
  title: 'Traffic sent',
  description: 'The sent traffic for a Tomcat connector',
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
      unit: 'Bps',
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

local trafficReceivedPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(increase(tomcat_bytesreceived_total{job=~"$job", instance=~"$instance", protocol=~"$protocol", port=~"$port"}[$__interval:])) by (job, instance)',
      datasource=promDatasource,
      legendFormat='{{job}} - {{instance}} - total',
    ),
    prometheus.target(
      'increase(tomcat_bytesreceived_total{job=~"$job", instance=~"$instance", protocol=~"$protocol", port=~"$port"}[$__rate_interval:])',
      datasource=promDatasource,
      legendFormat='{{job}} - {{instance}} - {{protocol}}-{{port}}',
    ),
  ],
  type: 'timeseries',
  title: 'Traffic received',
  description: 'The received traffic for a Tomcat connector',
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
      unit: 'Bps',
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

local requestsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(increase(tomcat_requestcount_total{job=~"$job", instance=~"$instance", protocol=~"$protocol", port=~"$port"}[$__interval:])) by (job, instance)',
      datasource=promDatasource,
      legendFormat='{{job}} - {{instance}} - total requests',
    ),
    prometheus.target(
      'sum(increase(tomcat_errorcount_total{job=~"$job", instance=~"$instance", protocol=~"$protocol", port=~"$port"}[$__interval:])) by (job, instance)',
      datasource=promDatasource,
      legendFormat='{{job}} - {{instance}} - total errors',
    ),
    prometheus.target(
      'increase(tomcat_requestcount_total{job=~"$job", instance=~"$instance", protocol=~"$protocol", port=~"$port"}[$__rate_interval:])',
      datasource=promDatasource,
      legendFormat='{{job}} - {{instance}} - {{protocol}}-{{port}} - requests',
    ),
    prometheus.target(
      'increase(tomcat_errorcount_total{job=~"$job", instance=~"$instance", protocol=~"$protocol", port=~"$port"}[$__rate_interval:])',
      datasource=promDatasource,
      legendFormat='{{job}} - {{instance}} - {{protocol}}-{{port}} - errors',
    ),
  ],
  type: 'timeseries',
  title: 'Requests',
  description: 'The total requests and errors for a Tomcat connector',
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
      unit: 'r/s',
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

local processingTimePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(increase(tomcat_processingtime_total{job=~"$job", instance=~"$instance", protocol=~"$protocol", port=~"$port"}[$__interval:]) / clamp_min(increase(tomcat_requestcount_total{job=~"$job", instance=~"$instance", protocol=~"$protocol", port=~"$port"}[$__interval:]), 1)) by (job, instance)',
      datasource=promDatasource,
      legendFormat='{{job}} - {{instance}} - total',
    ),
    prometheus.target(
      'increase(tomcat_processingtime_total{job=~"$job", instance=~"$instance", protocol=~"$protocol", port=~"$port"}[$__rate_interval:]) / clamp_min(increase(tomcat_requestcount_total{job=~"$job", instance=~"$instance", protocol=~"$protocol", port=~"$port"}[$__rate_interval:]), 1)',
      datasource=promDatasource,
      legendFormat='{{job}} - {{instance}} - {{protocol}}-{{port}}',
    ),
  ],
  type: 'timeseries',
  title: 'Processing time',
  description: 'The average time taken to process recent requests for a Tomcat connector',
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
        axisSoftMin: 0,
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
            value: 300,
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
      mode: 'single',
      sort: 'none',
    },
  },
};

local threadsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(tomcat_threadpool_connectioncount{job=~"$job", instance=~"$instance", protocol=~"$protocol", port=~"$port"}) by (job, instance)',
      datasource=promDatasource,
      legendFormat='{{job}} - {{instance}} - total connections',
    ),
    prometheus.target(
      'sum(tomcat_threadpool_pollerthreadcount{job=~"$job", instance=~"$instance", protocol=~"$protocol", port=~"$port"}) by (job, instance)',
      datasource=promDatasource,
      legendFormat='{{job}} - {{instance}} - poller total',
    ),
    prometheus.target(
      'sum(tomcat_threadpool_keepalivecount{job=~"$job", instance=~"$instance", protocol=~"$protocol", port=~"$port"}) by (job, instance)',
      datasource=promDatasource,
      legendFormat='{{job}} - {{instance}} - idle total',
    ),
    prometheus.target(
      'sum(tomcat_threadpool_currentthreadcount{job=~"$job", instance=~"$instance", protocol=~"$protocol", port=~"$port"}) by (job, instance)',
      datasource=promDatasource,
      legendFormat='{{job}} - {{instance}} - active total',
    ),
    prometheus.target(
      'tomcat_threadpool_connectioncount{job=~"$job", instance=~"$instance", protocol=~"$protocol", port=~"$port"}',
      datasource=promDatasource,
      legendFormat='{{job}} - {{instance}} - {{protocol}}-{{port}} - connections',
    ),
    prometheus.target(
      'tomcat_threadpool_pollerthreadcount{job=~"$job", instance=~"$instance", protocol=~"$protocol", port=~"$port"}',
      datasource=promDatasource,
      legendFormat='{{job}} - {{instance}} - {{protocol}}-{{port}} - poller',
    ),
    prometheus.target(
      'tomcat_threadpool_keepalivecount{job=~"$job", instance=~"$instance", protocol=~"$protocol", port=~"$port"}',
      datasource=promDatasource,
      legendFormat='{{job}} - {{instance}} - {{protocol}}-{{port}} - idle',
    ),
    prometheus.target(
      'tomcat_threadpool_currentthreadcount{job=~"$job", instance=~"$instance", protocol=~"$protocol", port=~"$port"}',
      datasource=promDatasource,
      legendFormat='{{job}} - {{instance}} - {{protocol}}-{{port}} - active',
    ),
  ],
  type: 'timeseries',
  title: 'Threads',
  description: 'The number of various threads being used by a Tomcat connector',
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
      mode: 'single',
      sort: 'none',
    },
  },
};

local logsPanel = {
  datasource: lokiDatasource,
  targets: [
    {
      datasource: lokiDatasource,
      editorMode: 'code',
      expr: '{filename="/var/log/tomcat9/catalina.out", job=~"$job", instance=~"$instance"} |= ``',
      queryType: 'range',
      refId: 'A',
    },
  ],
  type: 'logs',
  title: 'Logs',
  description: 'Recent logs from the Catalina.out logs file\n',
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
};

{
  grafanaDashboards+:: {
    'overview.json':
      dashboard.new(
        'Overview',
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
              'label_values(tomcat_bytesreceived_total, job)',
              label='Job',
              refresh=1,
              includeAll=false,
              multi=false,
              allValues='',
              sort=0
            ),
            template.new(
              'instance',
              promDatasource,
              'label_values(tomcat_bytesreceived_total, instance)',
              label='Instance',
              refresh=1,
              includeAll=false,
              multi=false,
              allValues='',
              sort=0
            ),
            template.new(
              'protocol',
              promDatasource,
              'label_values(tomcat_bytesreceived_total, protocol)',
              label='Protocol',
              refresh=1,
              includeAll=true,
              multi=true,
              allValues='',
              sort=0
            ),
            template.new(
              'port',
              promDatasource,
              'label_values(tomcat_bytesreceived_total, port)',
              label='Port',
              refresh=1,
              includeAll=true,
              multi=true,
              allValues='',
              sort=0
            ),
          ],
        ])
      )
      .addPanels(
        std.flattenArrays([
          [
            memoryUsagePanel { gridPos: { h: 9, w: 12, x: 0, y: 0 } },
            cpuUsagePanel { gridPos: { h: 9, w: 12, x: 12, y: 0 } },
            trafficSentPanel { gridPos: { h: 9, w: 12, x: 0, y: 9 } },
            trafficReceivedPanel { gridPos: { h: 9, w: 12, x: 12, y: 9 } },
            requestsPanel { gridPos: { h: 9, w: 12, x: 0, y: 18 } },
            processingTimePanel { gridPos: { h: 9, w: 12, x: 12, y: 18 } },
            threadsPanel { gridPos: { h: 9, w: 24, x: 0, y: 27 } },
          ],
          if $._config.enableLokiLogs then [
            logsPanel { gridPos: { h: 9, w: 24, x: 0, y: 36 } },
          ] else [],
          [
          ],
        ])
      ),

  },
}
