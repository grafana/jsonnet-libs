local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'bigip-pool-overview';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local availabilityStatusPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'bigip_pool_status_availability_state{job=~"$job", instance=~"$instance", pool=~"$bigip_pool"}',
      datasource=promDatasource,
      legendFormat='{{pool}} - {{partition}} - {{instance}}',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'Availability status',
  description: 'The availability state of the pool.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      mappings: [
        {
          options: {
            '0': {
              color: 'red',
              index: 1,
              text: 'Unavailable',
            },
            '1': {
              color: 'green',
              index: 0,
              text: 'Available',
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
        ],
      },
      unit: 'none',
    },
    overrides: [],
  },
  options: {
    colorMode: 'value',
    graphMode: 'none',
    justifyMode: 'auto',
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
  pluginVersion: '10.2.0-60139',
};

local membersPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'bigip_pool_active_member_cnt{job=~"$job", instance=~"$instance", pool=~"$bigip_pool"}',
      datasource=promDatasource,
      legendFormat='{{pool}} - {{partition}} - {{instance}} - active',
      format='time_series',
    ),
    prometheus.target(
      'bigip_pool_min_active_members{job=~"$job", instance=~"$instance", pool=~"$bigip_pool"}',
      datasource=promDatasource,
      legendFormat='{{pool}} - {{partition}} - {{instance}} - minimum',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Members',
  description: 'The number of active and minimum required members within the pool.',
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'smooth',
        lineWidth: 2,
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
      unit: 'members',
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

local requests__intervalPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(bigip_pool_tot_requests{job=~"$job", instance=~"$instance", pool=~"$bigip_pool"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{pool}} - {{partition}} - {{instance}}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Requests / $__interval',
  description: 'The number of requests made to the pool.',
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'smooth',
        lineWidth: 2,
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

local connectionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'bigip_pool_serverside_cur_conns{job=~"$job", instance=~"$instance", pool=~"$bigip_pool"}',
      datasource=promDatasource,
      legendFormat='{{pool}} - {{partition}} - {{instance}} - current',
      format='time_series',
    ),
    prometheus.target(
      'bigip_pool_serverside_max_conns{job=~"$job", instance=~"$instance", pool=~"$bigip_pool"}',
      datasource=promDatasource,
      legendFormat='{{pool}} - {{partition}} - {{instance}} - maximum',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Connections',
  description: 'The current and maximum number of node connections within the pool.',
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'smooth',
        lineWidth: 2,
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

local connectionQueueDepthPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'bigip_pool_connq_depth{job=~"$job", instance=~"$instance", pool=~"$bigip_pool"}',
      datasource=promDatasource,
      legendFormat='{{pool}} - {{partition}} - {{instance}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Connection queue depth',
  description: 'The depth of connection queues within the pool, including the current depth.',
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'smooth',
        lineWidth: 2,
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

local connectionQueueServiced__intervalPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(bigip_pool_connq_serviced{job=~"$job", instance=~"$instance", pool=~"$bigip_pool"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{pool}} - {{partition}} - {{instance}}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Connection queue serviced / $__interval',
  description: 'The number of connections that have been serviced within the pool.',
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'smooth',
        lineWidth: 2,
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

local trafficPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(bigip_pool_serverside_bytes_in{job=~"$job", instance=~"$instance", pool=~"$bigip_pool"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{pool}} - {{partition}} - {{instance}} - received',
      format='time_series',
    ),
    prometheus.target(
      'rate(bigip_pool_serverside_bytes_out{job=~"$job", instance=~"$instance", pool=~"$bigip_pool"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{pool}} - {{partition}} - {{instance}} - sent',
    ),
  ],
  type: 'timeseries',
  title: 'Traffic',
  description: 'The rate of date sent and received from virtual servers by the pool.',
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'smooth',
        lineWidth: 2,
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local packets__intervalPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(bigip_pool_serverside_pkts_in{job=~"$job", instance=~"$instance", pool=~"$bigip_pool"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{pool}} - {{partition}} - {{instance}} - received',
      format='time_series',
      interval='1m',
    ),
    prometheus.target(
      'increase(bigip_pool_serverside_pkts_out{job=~"$job", instance=~"$instance", pool=~"$bigip_pool"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{pool}} - {{partition}} - {{instance}} - sent',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Packets / $__interval',
  description: 'The number of packets sent and received from virtual servers by the pool.',
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
        fillOpacity: 30,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'smooth',
        lineWidth: 2,
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

{
  grafanaDashboards+:: {
    'bigip-pool-overview.json':
      dashboard.new(
        'Big IP pool overview',
        time_from='%s' % $._config.dashboardPeriod,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        description='',
        uid=dashboardUid,
      )
      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Other Big IP dashboards',
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
          [
            template.new(
              'job',
              promDatasource,
              'label_values(bigip_pool_status_availability_state,job)',
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
              'label_values(bigip_pool_status_availability_state{job=~"$job"}, instance)',
              label='Instance',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=1
            ),
            template.new(
              'bigip_pool',
              promDatasource,
              'label_values(bigip_pool_status_availability_state{job=~"$job", instance=~"$instance"},pool)',
              label='Big IP pool',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=1
            ),
          ],
        ])
      )
      .addPanels(
        std.flattenArrays([
          [
            availabilityStatusPanel { gridPos: { h: 6, w: 8, x: 0, y: 0 } },
            membersPanel { gridPos: { h: 6, w: 8, x: 8, y: 0 } },
            requests__intervalPanel { gridPos: { h: 6, w: 8, x: 16, y: 0 } },
            connectionsPanel { gridPos: { h: 6, w: 8, x: 0, y: 6 } },
            connectionQueueDepthPanel { gridPos: { h: 6, w: 8, x: 8, y: 6 } },
            connectionQueueServiced__intervalPanel { gridPos: { h: 6, w: 8, x: 16, y: 6 } },
            trafficPanel { gridPos: { h: 6, w: 24, x: 0, y: 12 } },
            packets__intervalPanel { gridPos: { h: 6, w: 24, x: 0, y: 18 } },
          ],
        ])
      ),
  },
}
