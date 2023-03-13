local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'hosts';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local sessionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(increase(tomcat_session_sessioncounter_total{job=~"$job", instance=~"$instance", host=~"$host", context=~"$context"}[$__interval:])) by (job, instance)',
      datasource=promDatasource,
      legendFormat='{{job}} - {{instance}} - total sessions',
    ),
    prometheus.target(
      'sum(increase(tomcat_session_rejectedsessions_total{job=~"$job", instance=~"$instance", host=~"$host", context=~"$context"}[$__interval:])) by (job, instance)',
      datasource=promDatasource,
      legendFormat='{{job}} - {{instance}} - rejected',
    ),
    prometheus.target(
      'sum(increase(tomcat_session_expiredsessions_total{job=~"$job", instance=~"$instance", host=~"$host", context=~"$context"}[$__interval:])) by (job, instance)',
      datasource=promDatasource,
      legendFormat='{{job}} - {{instance}} - expired',
    ),
    prometheus.target(
      'increase(tomcat_session_sessioncounter_total{job=~"$job", instance=~"$instance", host=~"$host", context=~"$context"}[$__rate_interval:])',
      datasource=promDatasource,
      legendFormat='{{job}} - {{instance}} - {{host}}{{context}} - sessions',
    ),
    prometheus.target(
      'increase(tomcat_session_rejectedsessions_total{job=~"$job", instance=~"$instance", host=~"$host", context=~"$context"}[$__rate_interval:])',
      datasource=promDatasource,
      legendFormat='{{job}} - {{instance}} - {{host}}{{context}}  - rejected',
    ),
    prometheus.target(
      'increase(tomcat_session_expiredsessions_total{job=~"$job", instance=~"$instance", host=~"$host", context=~"$context"}[$__rate_interval:])',
      datasource=promDatasource,
      legendFormat='{{job}} - {{instance}} - {{host}}{{context}}  - expired',
    ),
  ],
  type: 'timeseries',
  title: 'Sessions',
  description: 'The number of different types of sessions created for a Tomcat host',
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

local sessionProcessingTimePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(increase(tomcat_session_processingtime_total{job=~"$job", instance=~"$instance", host=~"$host", context=~"$context"}[$__interval:]) / clamp_min(increase(tomcat_session_sessioncounter_total{job=~"$job", instance=~"$instance", host=~"$host", context=~"$context"}[$__interval:]), 1)) by (job, instance)',
      datasource=promDatasource,
      legendFormat='{{job}} - {{instance}} - total',
    ),
    prometheus.target(
      'increase(tomcat_session_processingtime_total{job=~"$job", instance=~"$instance", host=~"$host", context=~"$context"}[$__rate_interval:]) / clamp_min(increase(tomcat_session_sessioncounter_total{job=~"$job", instance=~"$instance", host=~"$host", context=~"$context"}[$__rate_interval:]), 1)',
      datasource=promDatasource,
      legendFormat='{{job}} - {{instance}} - {{host}}{{context}}',
    ),
  ],
  type: 'timeseries',
  title: 'Session processing time',
  description: 'The average time taken to process recent sessions for a Tomcat host',
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
      mode: 'single',
      sort: 'none',
    },
  },
};

local servletRowRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Servlet row',
  collapsed: false,
};

local servletRequestsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(increase(tomcat_servlet_requestcount_total{instance=~"$instance", job=~"$job", module=~"$host$context", servlet=~"$servlet"}[$__interval:])) by (job, instance)',
      datasource=promDatasource,
      legendFormat='{{job}} - {{instance}} - total requests',
    ),
    prometheus.target(
      'sum(increase(tomcat_servlet_errorcount_total{instance=~"$instance", job=~"$job", module=~"$host$context", servlet=~"$servlet"}[$__interval:])) by (job, instance)',
      datasource=promDatasource,
      legendFormat='{{job}} - {{instance}} - total errors',
    ),
    prometheus.target(
      'increase(tomcat_servlet_requestcount_total{instance=~"$instance", job=~"$job", module=~"$host$context", servlet=~"$servlet"}[$__rate_interval:])',
      datasource=promDatasource,
      legendFormat='{{job}} - {{instance}} - {{module}} - {{servlet}} - requests',
    ),
    prometheus.target(
      'increase(tomcat_servlet_errorcount_total{instance=~"$instance", job=~"$job", module=~"$host$context", servlet=~"$servlet"}[$__rate_interval:])',
      datasource=promDatasource,
      legendFormat='{{job}} - {{instance}} - {{module}} - {{servlet}} - errors',
    ),
  ],
  type: 'timeseries',
  title: 'Servlet requests',
  description: 'The total requests and errors for a Tomcat servlet',
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

local servletProcessingTimePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(increase(tomcat_servlet_processingtime_total{instance=~"$instance", job=~"$job", module=~"$host$context", servlet=~"$servlet"}[$__interval:]) / clamp_min(increase(tomcat_servlet_requestcount_total{instance=~"$instance", job=~"$job", module=~"$host$context", servlet=~"$servlet"}[$__interval:]), 1)) by (job, instance)',
      datasource=promDatasource,
      legendFormat='{{job}} - {{instance}} - total',
    ),
    prometheus.target(
      'increase(tomcat_servlet_processingtime_total{instance=~"$instance", job=~"$job", module=~"$host$context", servlet=~"$servlet"}[$__rate_interval:]) / clamp_min(increase(tomcat_servlet_requestcount_total{instance=~"$instance", job=~"$job", module=~"$host$context", servlet=~"$servlet"}[$__rate_interval:]), 1)',
      datasource=promDatasource,
      legendFormat='{{job}} - {{instance}} - {{module}} - {{servlet}}',
    ),
  ],
  type: 'timeseries',
  title: 'Servlet processing time',
  description: 'The average time taken to process recent requests in a Tomcat servlet',
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
      mode: 'single',
      sort: 'none',
    },
  },
};

{
  grafanaDashboards+:: {
    'hosts.json':
      dashboard.new(
        'Hosts',
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
            'host',
            promDatasource,
            'label_values(tomcat_session_sessioncounter_total{instance=~"$instance"}, host)',
            label='Host',
            refresh=1,
            includeAll=true,
            multi=true,
            allValues='',
            sort=0
          ),
          template.new(
            'context',
            promDatasource,
            'label_values(tomcat_session_sessioncounter_total{host=~"$host"}, context)',
            label='Context',
            refresh=1,
            includeAll=true,
            multi=true,
            allValues='',
            sort=0
          ),
          template.new(
            'servlet',
            promDatasource,
            'label_values(tomcat_servlet_requestcount_total{servlet=~"$servlet"}, servlet)',
            label='Servlet',
            refresh=1,
            includeAll=true,
            multi=true,
            allValues='',
            sort=0
          ),
        ]
      )
      .addPanels(
        [
          sessionsPanel { gridPos: { h: 9, w: 12, x: 0, y: 0 } },
          sessionProcessingTimePanel { gridPos: { h: 9, w: 12, x: 12, y: 0 } },
          servletRowRow { gridPos: { h: 1, w: 24, x: 0, y: 9 } },
          servletRequestsPanel { gridPos: { h: 9, w: 12, x: 0, y: 10 } },
          servletProcessingTimePanel { gridPos: { h: 9, w: 12, x: 12, y: 10 } },
        ]
      ),

  },
}
