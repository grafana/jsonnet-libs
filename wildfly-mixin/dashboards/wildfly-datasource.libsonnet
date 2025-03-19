local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'wildfly-datasource';

local promDatasourceName = 'prometheus_datasource';
local getMatcher(cfg) = '%(wildflySelector)s, instance=~"$instance"' % cfg;

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local activeConnectionsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'wildfly_datasources_pool_in_use_count{' + matcher + ', data_source=~"$datasource"}',
      datasource=promDatasource,
      legendFormat='{{data_source}}',
    ),
  ],
  type: 'timeseries',
  title: 'Active connections',
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

local idleConnectionsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'wildfly_datasources_pool_idle_count{' + matcher + ', data_source=~"$datasource"}',
      datasource=promDatasource,
      legendFormat='{{data_source}}',
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

local createdTransactionsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(wildfly_transactions_number_of_transactions_total{' + matcher + '}[$__interval])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      interval='1m',
      intervalFactor=2,
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

local inflightTransactionsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'wildfly_transactions_number_of_inflight_transactions{' + matcher + '}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
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

local abortedTransactionsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(wildfly_transactions_number_of_aborted_transactions_total{' + matcher + '}[$__interval])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      interval='1m',
      intervalFactor=2,
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
        'Wildfly datasource',
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
            'datasource',
            promDatasource,
            'label_values(wildfly_datasources_pool_idle_count{%(wildflySelector)s}, data_source)' % $._config,
            label='Wildfly datasource',
            refresh=2,
            includeAll=false,
            multi=true,
            allValues='.+',
            sort=0
          ),
        ]
      )

      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Wildfly Dashboards',
        includeVars=true,
        keepTime=true,
        tags=($._config.dashboardTags),
      ))

      .addPanels(
        [
          activeConnectionsPanel(getMatcher($._config)) { gridPos: { h: 7, w: 12, x: 0, y: 1 } },
          idleConnectionsPanel(getMatcher($._config)) { gridPos: { h: 7, w: 12, x: 12, y: 1 } },
          createdTransactionsPanel(getMatcher($._config)) { gridPos: { h: 7, w: 12, x: 0, y: 8 } },
          inflightTransactionsPanel(getMatcher($._config)) { gridPos: { h: 7, w: 12, x: 12, y: 8 } },
          abortedTransactionsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 24, x: 0, y: 15 } },
        ]
      ),
  },
}
