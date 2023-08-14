local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'atlas-election-overview';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local stepupElectionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(mongodb_electionMetrics_stepUpCmd_called{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - called',
      interval='1m',
    ),
    prometheus.target(
      'increase(mongodb_electionMetrics_stepUpCmd_successful{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - successful',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Step-up elections',
  description: 'The number of elections called and elections won by the node when the primary stepped down.',
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
        fillOpacity: 10,
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
        showPoints: 'never',
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
        ],
      },
      unit: 'none',
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

local priorityElectionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(mongodb_electionMetrics_priorityTakeover_called{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - called',
      interval='1m',
    ),
    prometheus.target(
      'increase(mongodb_electionMetrics_priorityTakeover_successful{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - successful',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Priority elections',
  description: 'The number of elections called and elections won by the node when it had a higher priority than the primary node.',
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
        fillOpacity: 10,
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
        showPoints: 'never',
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
        ],
      },
      unit: 'none',
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

local takeoverElectionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(mongodb_electionMetrics_catchUpTakeover_called{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - called',
      interval='1m',
    ),
    prometheus.target(
      'increase(mongodb_electionMetrics_catchUpTakeover_successful{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - successful',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Takeover elections',
  description: 'The number of elections called and elections won by the node when it was more current than the primary node.',
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
        fillOpacity: 10,
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
        showPoints: 'never',
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
        ],
      },
      unit: 'none',
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

local timeoutElectionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(mongodb_electionMetrics_electionTimeout_called{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - called',
      interval='1m',
    ),
    prometheus.target(
      'increase(mongodb_electionMetrics_electionTimeout_successful{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - successful',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Timeout elections',
  description: 'The number of elections called and elections won by the node when the time it took to reach the primary node exceeded the election timeout limit.',
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
        fillOpacity: 10,
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
        showPoints: 'never',
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
        ],
      },
      unit: 'none',
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

local catchupsRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Catch-ups',
};

local catchupsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(mongodb_electionMetrics_numCatchUps{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Catch-ups',
  description: 'The number of times the node had to catch up to the highest known oplog entry.',
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
        fillOpacity: 10,
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
        showPoints: 'never',
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
        ],
      },
      unit: 'none',
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

local catchupsSkippedPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(mongodb_electionMetrics_numCatchUpsSkipped{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Catch-ups skipped',
  description: 'The number of times the node skipped the catch up process when it was the newly elected primary.',
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
        fillOpacity: 10,
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
        showPoints: 'never',
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
        ],
      },
      unit: 'none',
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

local catchupsSucceededPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(mongodb_electionMetrics_numCatchUpsSucceeded{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Catch-ups succeeded',
  description: 'The number of times the node succeeded in catching up when it was the newly elected primary.',
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
        fillOpacity: 10,
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
        showPoints: 'never',
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
        ],
      },
      unit: 'none',
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

local catchupsFailedPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(mongodb_electionMetrics_numCatchUpsFailedWithError{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Catch-ups failed',
  description: 'The number of times the node failed in catching up when it was the newly elected primary.',
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
        fillOpacity: 10,
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
        showPoints: 'never',
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
        ],
      },
      unit: 'none',
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

local catchupTimeoutsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(mongodb_electionMetrics_numCatchUpsTimedOut{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Catch-up timeouts',
  description: 'The number of times the node timed out during the catch-up process when it was the newly elected primary.',
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
        fillOpacity: 10,
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
        showPoints: 'never',
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
        ],
      },
      unit: 'none',
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

local averageCatchupOperationsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'mongodb_electionMetrics_averageCatchUpOps{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Average catch-up operations',
  description: 'The average number of operations done during the catch-up process when this node is the newly elected primary.',
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
        fillOpacity: 10,
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
        showPoints: 'never',
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
        ],
      },
      unit: 'none',
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

{
  grafanaDashboards+:: {
    'atlas-election-overview.json':
      dashboard.new(
        'Atlas election overview',
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
            'label_values(mongodb_network_bytesIn,job)',
            label='Job',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='',
            sort=0
          ),
          template.new(
            'cl_name',
            promDatasource,
            'label_values(mongodb_network_bytesIn{job=~"$job"},cl_name)',
            label='Atlas cluster',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='',
            sort=0
          ),
          template.new(
            'rs',
            promDatasource,
            'label_values(mongodb_network_bytesIn{cl_name=~"$cl_name"},rs_nm)',
            label='Replica set',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='',
            sort=0
          ),
          template.new(
            'instance',
            promDatasource,
            'label_values(mongodb_network_bytesIn{rs_nm=~"$rs"},instance)',
            label='Node',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='',
            sort=0
          ),
        ]
      )
      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Atlas dashboards',
        includeVars=true,
        keepTime=true,
        tags=($._config.dashboardTags),
      ))
      .addPanels(
        [
          stepupElectionsPanel { gridPos: { h: 8, w: 24, x: 0, y: 0 } },
          priorityElectionsPanel { gridPos: { h: 8, w: 24, x: 0, y: 8 } },
          takeoverElectionsPanel { gridPos: { h: 8, w: 24, x: 0, y: 16 } },
          timeoutElectionsPanel { gridPos: { h: 8, w: 24, x: 0, y: 24 } },
          catchupsRow { gridPos: { h: 1, w: 24, x: 0, y: 32 } },
          catchupsPanel { gridPos: { h: 8, w: 12, x: 0, y: 33 } },
          catchupsSkippedPanel { gridPos: { h: 8, w: 12, x: 12, y: 33 } },
          catchupsSucceededPanel { gridPos: { h: 8, w: 12, x: 0, y: 41 } },
          catchupsFailedPanel { gridPos: { h: 8, w: 12, x: 12, y: 41 } },
          catchupTimeoutsPanel { gridPos: { h: 8, w: 12, x: 0, y: 49 } },
          averageCatchupOperationsPanel { gridPos: { h: 8, w: 12, x: 12, y: 49 } },
        ]
      ),
  },
}
