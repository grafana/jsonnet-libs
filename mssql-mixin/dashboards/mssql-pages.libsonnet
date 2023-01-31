local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'mssql-pages';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local pageFileMemoryPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'mssql_os_page_file{instance=~"$instance", job=~"$job"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{state}}',
    ),
  ],
  type: 'timeseries',
  title: 'Page file memory',
  description: 'Memory used for the OS page file.',
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
        fillOpacity: 50,
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
          mode: 'normal',
        },
        thresholdsStyle: {
          mode: 'off',
        },
      },
      mappings: [],
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

local bufferCacheHitPercentagePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'mssql_buffer_cache_hit_ratio{instance=~"$instance", job=~"$job"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Buffer cache hit percentage',
  description: 'Percentage of page found and read from the SQL Server buffer cache.',
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

local pageCheckpointsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'mssql_checkpoint_pages_sec{instance=~"$instance", job=~"$job"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Page checkpoints',
  description: 'Rate of page checkpoints per second.',
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
      unit: 'checkpoints/s',
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

local pageFaultsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(mssql_page_fault_count_total{instance=~"$instance", job=~"$job"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Page faults',
  description: 'The number of page faults that were incurred by the SQL Server process.',
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
      unit: 'faults',
    },
    overrides: [],
  },
  interval: '1m',
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
    'mssql-pages.json':
      dashboard.new(
        'MSSQL pages',
        time_from='%s' % $._config.dashboardPeriod,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        description='An overview of MSSQL paging metrics.',
        uid=dashboardUid,
      )
      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Other MSSQL dashboards',
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
            'label_values(mssql_build_info{}, job)',
            label='Job',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.+',
            sort=0
          ),
          template.new(
            'instance',
            promDatasource,
            'label_values(mssql_build_info{job=~"$job"}, instance)',
            label='Instance',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.+',
            sort=0
          ),
        ]
      )
      .addPanels(
        [
          pageFileMemoryPanel { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
          bufferCacheHitPercentagePanel { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
          pageCheckpointsPanel { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
          pageFaultsPanel { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
        ]
      ),

  },
}
