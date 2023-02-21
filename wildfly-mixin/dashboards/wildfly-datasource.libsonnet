local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'wildfly-datasource';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};


local rowTitleRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Row title',
};

local connectionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'wildfly_datasources_pool_in_use_count{job="$job", instance="$instance", data_source="$datasource"}',
      datasource=promDatasource,
    ),
  ],
  type: 'timeseries',
  title: 'Connections',
  description: 'Connections to the datasource over time',
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
    overrides: [
      {
        __systemRef: 'hideSeriesFrom',
        matcher: {
          id: 'byNames',
          options: {
            mode: 'exclude',
            names: [
              '{__name__="wildfly_datasources_pool_in_use_count", cluster="my-cluster", data_source="KitchensinkQuickstartDS", instance="wildfly.sample-apps.svc.cluster.local:9990", job="integrations/wildfly"}',
            ],
            prefix: 'All except:',
            readOnly: true,
          },
        },
        properties: [
          {
            id: 'custom.hideFrom',
            value: {
              legend: false,
              tooltip: false,
              viz: true,
            },
          },
        ],
      },
    ],
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

local idleConnectionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'wildfly_datasources_pool_idle_count{job="$job", instance="$instance", data_source="$datasource"}',
      datasource=promDatasource,
    ),
  ],
  type: 'timeseries',
  title: 'Idle connections',
  description: 'Connections to the datasource over time',
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

local createdTransactionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(wildfly_transactions_number_of_transactions_total{job="$job", instance="$instance"}[$__rate_interval])',
      datasource=promDatasource,
    ),
  ],
  type: 'timeseries',
  title: 'Created transactions',
  description: 'Number of transactions that were created over time',
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

local inflightTransactionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'wildfly_transactions_number_of_inflight_transactions{job="$job", instance="$instance"}',
      datasource=promDatasource,
    ),
  ],
  type: 'timeseries',
  title: 'In-flight transactions',
  description: 'Number of transactions that are in-flight over time',
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
    overrides: [
      {
        __systemRef: 'hideSeriesFrom',
        matcher: {
          id: 'byNames',
          options: {
            mode: 'exclude',
            names: [
              '{__name__="wildfly_transactions_number_of_inflight_transactions", cluster="my-cluster", instance="wildfly.sample-apps.svc.cluster.local:9990", job="integrations/wildfly"}',
            ],
            prefix: 'All except:',
            readOnly: true,
          },
        },
        properties: [
          {
            id: 'custom.hideFrom',
            value: {
              legend: false,
              tooltip: false,
              viz: true,
            },
          },
        ],
      },
    ],
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

local abortedTransactionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(wildfly_transactions_number_of_aborted_transactions_total{job="$job", instance="$instance"}[$__rate_interval])',
      datasource=promDatasource,
    ),
  ],
  type: 'timeseries',
  title: 'Aborted transactions',
  description: 'Number of transactions that have been aborted over time',
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


{
  grafanaDashboards+:: {
    'wildfly-datasource.json':
      dashboard.new(
        'wildfly-datasource',
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
            label='job',
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
            'datasource',
            promDatasource,
            'label_values(wildfly_datasources_pool_idle_count{}, data_source)',
            label='DataSource',
            refresh=2,
            includeAll=false,
            multi=true,
            allValues='.+',
            sort=0
          ),
        ]
      )
      .addPanels(
        [
          rowTitleRow { gridPos: { h: 1, w: 24, x: 0, y: 0 } },
          connectionsPanel { gridPos: { h: 7, w: 12, x: 0, y: 1 } },
          idleConnectionsPanel { gridPos: { h: 7, w: 12, x: 12, y: 1 } },
          createdTransactionsPanel { gridPos: { h: 7, w: 12, x: 0, y: 8 } },
          inflightTransactionsPanel { gridPos: { h: 7, w: 12, x: 12, y: 8 } },
          abortedTransactionsPanel { gridPos: { h: 8, w: 24, x: 0, y: 15 } },
        ]
      ),

  },
}
