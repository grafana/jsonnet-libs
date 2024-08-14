local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'apache-tomcat-overview';

local promDatasourceName = 'prometheus_datasource';
local lokiDatasourceName = 'loki_datasource';

local filenameLogFilter = 'filename=~"/var/log/tomcat.*/catalina.out|/opt/tomcat/logs/catalina.out|/Program Files/Apache Software Foundation/Tomcat .*..*/logs/catalina.out"';

local getMatcher(cfg) = '%(tomcatSelector)s, instance=~"$instance"' % cfg;

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local lokiDatasource = {
  uid: '${%s}' % lokiDatasourceName,
};

local memoryUsagePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'jvm_memory_usage_used_bytes{' + matcher + '}',
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

local cpuUsagePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'jvm_process_cpu_load{' + matcher + '}',
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
      mode: 'single',
      sort: 'none',
    },
  },
};

local trafficSentPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(rate(tomcat_bytessent_total{' + matcher + ', protocol=~"$protocol", port=~"$port"}[$__rate_interval])) by (job, instance)',
      datasource=promDatasource,
      legendFormat='{{instance}} - total',
    ),
    prometheus.target(
      'rate(tomcat_bytessent_total{' + matcher + ', protocol=~"$protocol", port=~"$port"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{protocol}}-{{port}}',
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

local trafficReceivedPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(rate(tomcat_bytesreceived_total{' + matcher + ', protocol=~"$protocol", port=~"$port"}[$__rate_interval])) by (job, instance)',
      datasource=promDatasource,
      legendFormat='{{instance}} - total',
    ),
    prometheus.target(
      'rate(tomcat_bytesreceived_total{' + matcher + ', protocol=~"$protocol", port=~"$port"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{protocol}}-{{port}}',
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

local requestsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(rate(tomcat_requestcount_total{' + matcher + ', protocol=~"$protocol", port=~"$port"}[$__rate_interval])) by (job, instance)',
      datasource=promDatasource,
      legendFormat='{{instance}} - total requests',
    ),
    prometheus.target(
      'sum(rate(tomcat_errorcount_total{' + matcher + ', protocol=~"$protocol", port=~"$port"}[$__rate_interval])) by (job, instance)',
      datasource=promDatasource,
      legendFormat='{{instance}} - total errors',
    ),
    prometheus.target(
      'rate(tomcat_requestcount_total{' + matcher + ', protocol=~"$protocol", port=~"$port"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{protocol}}-{{port}} - requests',
    ),
    prometheus.target(
      'rate(tomcat_errorcount_total{' + matcher + ', protocol=~"$protocol", port=~"$port"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{protocol}}-{{port}} - errors',
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

local processingTimePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(increase(tomcat_processingtime_total{' + matcher + ', protocol=~"$protocol", port=~"$port"}[$__interval:] offset -$__interval) / clamp_min(increase(tomcat_requestcount_total{' + matcher + ', protocol=~"$protocol", port=~"$port"}[$__interval:] offset -$__interval), 1)) by (job, instance)',
      datasource=promDatasource,
      legendFormat='{{instance}} - total',
      interval='1m',
    ),
    prometheus.target(
      'increase(tomcat_processingtime_total{' + matcher + ', protocol=~"$protocol", port=~"$port"}[$__interval:] offset -$__interval) / clamp_min(increase(tomcat_requestcount_total{' + matcher + ', protocol=~"$protocol", port=~"$port"}[$__interval:] offset -$__interval), 1)',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{protocol}}-{{port}}',
      interval='1m',
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

local threadsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(tomcat_threadpool_connectioncount{' + matcher + ', protocol=~"$protocol", port=~"$port"}) by (job, instance)',
      datasource=promDatasource,
      legendFormat='{{instance}} - total connections',
    ),
    prometheus.target(
      'sum(tomcat_threadpool_pollerthreadcount{' + matcher + ', protocol=~"$protocol", port=~"$port"}) by (job, instance)',
      datasource=promDatasource,
      legendFormat='{{instance}} - poller total',
    ),
    prometheus.target(
      'sum(tomcat_threadpool_keepalivecount{' + matcher + ', protocol=~"$protocol", port=~"$port"}) by (job, instance)',
      datasource=promDatasource,
      legendFormat='{{instance}} - idle total',
    ),
    prometheus.target(
      'sum(tomcat_threadpool_currentthreadcount{' + matcher + ', protocol=~"$protocol", port=~"$port"}) by (job, instance)',
      datasource=promDatasource,
      legendFormat='{{instance}} - active total',
    ),
    prometheus.target(
      'tomcat_threadpool_connectioncount{' + matcher + ', protocol=~"$protocol", port=~"$port"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{protocol}}-{{port}} - connections',
    ),
    prometheus.target(
      'tomcat_threadpool_pollerthreadcount{' + matcher + ', protocol=~"$protocol", port=~"$port"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{protocol}}-{{port}} - poller',
    ),
    prometheus.target(
      'tomcat_threadpool_keepalivecount{' + matcher + ', protocol=~"$protocol", port=~"$port"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{protocol}}-{{port}} - idle',
    ),
    prometheus.target(
      'tomcat_threadpool_currentthreadcount{' + matcher + ', protocol=~"$protocol", port=~"$port"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{protocol}}-{{port}} - active',
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
      placement: 'right',
      showLegend: true,
    },
    tooltip: {
      mode: 'single',
      sort: 'none',
    },
  },
};

local logsPanel(matcher) = {
  datasource: lokiDatasource,
  targets: [
    {
      datasource: lokiDatasource,
      editorMode: 'code',
      expr: '{' + matcher + '} |= `` | (' + filenameLogFilter + ' or log_type="catalina.out")',
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
    'apache-tomcat-overview.json':
      dashboard.new(
        'Apache Tomcat Overview',
        time_from='%s' % $._config.dashboardPeriod,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        description='',
        uid=dashboardUid,
      )

      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Other Apache Tomcat dashboards',
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
              'label_values(tomcat_bytesreceived_total, job)',
              label='Job',
              refresh=1,
              includeAll=false,
              multi=false,
              allValues='',
              sort=0
            ),
            template.new(
              'cluster',
              promDatasource,
              'label_values(tomcat_bytesreceived_total{%(multiclusterSelector)s}, cluster)' % $._config,
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
              'label_values(tomcat_bytesreceived_total{%(tomcatSelector)s}, instance)' % $._config,
              label='Instance',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=1
            ),
            template.new(
              'protocol',
              promDatasource,
              'label_values(tomcat_bytesreceived_total{%(tomcatSelector)s}, protocol)' % $._config,
              label='Protocol',
              refresh=1,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=0
            ),
            template.new(
              'port',
              promDatasource,
              'label_values(tomcat_bytesreceived_total{%(tomcatSelector)s}, port)' % $._config,
              label='Port',
              refresh=1,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=0
            ),
          ],
        ])
      )
      .addPanels(
        std.flattenArrays([
          [
            memoryUsagePanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 0 } },
            cpuUsagePanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 0 } },
            trafficSentPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 6 } },
            trafficReceivedPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 6 } },
            requestsPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 12 } },
            processingTimePanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 12 } },
            threadsPanel(getMatcher($._config)) { gridPos: { h: 6, w: 24, x: 0, y: 18 } },
          ],
          if $._config.enableLokiLogs then [
            logsPanel(getMatcher($._config)) { gridPos: { h: 6, w: 24, x: 0, y: 24 } },
          ] else [],
          [
          ],
        ])
      ),

  },
}
