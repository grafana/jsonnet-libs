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
      legendFormat='{{pool}} - {{instance}}',
      intervalFactor=2,
      instant=true,
      format='table',
    ),
  ],
  type: 'table',
  title: 'Availability status',
  description: 'The availability status of the pool.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'fixed',
      },
      custom: {
        align: 'left',
        cellOptions: {
          type: 'color-text',
        },
        inspect: false,
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
    overrides: [
      {
        matcher: {
          id: 'byName',
          options: 'Time',
        },
        properties: [
          {
            id: 'custom.hidden',
            value: true,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'job',
        },
        properties: [
          {
            id: 'custom.hidden',
            value: true,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: '__name__',
        },
        properties: [
          {
            id: 'custom.hidden',
            value: true,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'partition',
        },
        properties: [
          {
            id: 'custom.hidden',
            value: true,
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'instance',
        },
        properties: [
          {
            id: 'displayName',
            value: 'Instance',
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'pool',
        },
        properties: [
          {
            id: 'displayName',
            value: 'Pool',
          },
        ],
      },
      {
        matcher: {
          id: 'byName',
          options: 'Value',
        },
        properties: [
          {
            id: 'displayName',
            value: 'Status',
          },
        ],
      },
    ],
  },
  options: {
    cellHeight: 'sm',
    footer: {
      countRows: false,
      fields: [],
      reducer: [
        'sum',
      ],
      show: false,
    },
    showHeader: true,
  },
  pluginVersion: '10.2.0-60139',
};

local requests__intervalPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(bigip_pool_tot_requests{job=~"$job", instance=~"$instance", pool=~"$bigip_pool"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{pool}} - {{instance}}',
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

local membersPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'bigip_pool_active_member_cnt{job=~"$job", instance=~"$instance", pool=~"$bigip_pool"}',
      datasource=promDatasource,
      legendFormat='{{pool}} - {{instance}} - active',
      format='time_series',
    ),
    prometheus.target(
      'bigip_pool_min_active_members{job=~"$job", instance=~"$instance", pool=~"$bigip_pool"}',
      datasource=promDatasource,
      legendFormat='{{pool}} - {{instance}} - minimum',
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
      unit: 'none',
    },
    overrides: [],
  },
  options: {
    legend: {
      calcs: [
        'min',
        'mean',
        'max',
      ],
      displayMode: 'table',
      placement: 'right',
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
      legendFormat='{{pool}} - {{instance}} - current',
      format='time_series',
    ),
    prometheus.target(
      'bigip_pool_serverside_max_conns{job=~"$job", instance=~"$instance", pool=~"$bigip_pool"}',
      datasource=promDatasource,
      legendFormat='{{pool}} - {{instance}} - maximum',
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
      calcs: [
        'min',
        'mean',
        'max',
      ],
      displayMode: 'table',
      placement: 'right',
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
      legendFormat='{{pool}} - {{instance}}',
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
      legendFormat='{{pool}} - {{instance}}',
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

local trafficInboundPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(bigip_pool_serverside_bytes_in{job=~"$job", instance=~"$instance", pool=~"$bigip_pool"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{pool}} - {{instance}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Traffic inbound',
  description: 'The rate of date received from virtual servers by the pool.',
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

local trafficOutboundPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(bigip_pool_serverside_bytes_out{job=~"$job", instance=~"$instance", pool=~"$bigip_pool"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{pool}} - {{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Traffic outbound',
  description: 'The rate of date sent from virtual servers by the pool.',
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

local packetsInboundIntervalPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(bigip_pool_serverside_pkts_out{job=~"$job", instance=~"$instance", pool=~"$bigip_pool"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{pool}} - {{instance}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Packets inbound / $__interval',
  description: 'The number of packets received from virtual servers by the pool.',
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

local packetsOutboundIntervalPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(bigip_pool_serverside_pkts_out{job=~"$job", instance=~"$instance", pool=~"$bigip_pool"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{pool}} - {{instance}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Packets outbound / $__interval',
  description: 'The number of packets sent from virtual servers by the pool.',
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
        'BIG-IP pool overview',
        time_from='%s' % $._config.dashboardPeriod,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        description='',
        uid=dashboardUid,
      )
      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Other BIG-IP dashboards',
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
              label='BIG-IP pool',
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
            availabilityStatusPanel { gridPos: { h: 5, w: 12, x: 0, y: 0 } },
            requests__intervalPanel { gridPos: { h: 5, w: 12, x: 12, y: 0 } },
            membersPanel { gridPos: { h: 5, w: 24, x: 0, y: 5 } },
            connectionsPanel { gridPos: { h: 5, w: 24, x: 0, y: 10 } },
            connectionQueueDepthPanel { gridPos: { h: 5, w: 12, x: 0, y: 15 } },
            connectionQueueServiced__intervalPanel { gridPos: { h: 5, w: 12, x: 12, y: 15 } },
            trafficInboundPanel { gridPos: { h: 5, w: 12, x: 0, y: 20 } },
            trafficOutboundPanel { gridPos: { h: 5, w: 12, x: 12, y: 20 } },
            packetsInboundIntervalPanel { gridPos: { h: 5, w: 12, x: 0, y: 25 } },
            packetsOutboundIntervalPanel { gridPos: { h: 5, w: 12, x: 12, y: 25 } },
          ],
        ])
      ),
  },
}
