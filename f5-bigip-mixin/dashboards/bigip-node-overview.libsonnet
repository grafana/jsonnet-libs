local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'bigip-node-overview';

local promDatasourceName = 'datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local availabilityStatusPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'bigip_node_status_availability_state{job=~"$job", instance=~"$instance", node=~"$bigip_node"}',
      datasource=promDatasource,
      intervalFactor=2,
      instant=true,
      legendFormat='{{node}} - {{instance}}',
      format='table',
    ),
  ],
  type: 'table',
  title: 'Availability status',
  description: 'The availability status of the node.',
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
          options: 'node',
        },
        properties: [
          {
            id: 'displayName',
            value: 'Node',
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

local activeSessionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'bigip_node_cur_sessions{job=~"$job", instance=~"$instance", node=~"$bigip_node"}',
      datasource=promDatasource,
      legendFormat='{{node}} - {{instance}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Active sessions',
  description: 'The current number of active sessions to the node.',
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

local requests__intervalPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(bigip_node_tot_requests{job=~"$job", instance=~"$instance", node=~"$bigip_node"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{node}} - {{instance}}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Requests / $__interval',
  description: 'The number of requests made to the node.',
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
      'bigip_node_serverside_cur_conns{job=~"$job", instance=~"$instance", node=~"$bigip_node"}',
      datasource=promDatasource,
      legendFormat='{{node}} - {{instance}} - current',
      format='time_series',
    ),
    prometheus.target(
      'bigip_node_serverside_max_conns{job=~"$job", instance=~"$instance", node=~"$bigip_node"}',
      datasource=promDatasource,
      legendFormat='{{node}} - {{instance}} - max',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Connections',
  description: 'The current active server-side connections to the node in comparison to the maximum connection capacity.',
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

local trafficInboundPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(bigip_node_serverside_bytes_in{job=~"$job", instance=~"$instance", node=~"$bigip_node"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{node}} - {{instance}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Traffic inbound',
  description: 'The rate of data received from the pool by the node.',
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
      'rate(bigip_node_serverside_bytes_out{job=~"$job", instance=~"$instance", node=~"$bigip_node"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{node}} - {{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Traffic ountbound',
  description: 'The rate of data sent from the pool by the node.',
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
      'increase(bigip_node_serverside_pkts_in{job=~"$job", instance=~"$instance", node=~"$bigip_node"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{node}} - {{instance}}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Packets inbound / $__interval',
  description: 'The number of packets received by the node from the pool.',
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
      'increase(bigip_node_serverside_pkts_out{job=~"$job", instance=~"$instance", node=~"$bigip_node"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{node}} - {{instance}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Packets outbound / $__interval',
  description: 'The number of packets sent by the node from the pool.',
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
    'bigip-node-overview.json':
      dashboard.new(
        'BIG-IP node overview',
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
              'label_values(bigip_node_status_availability_state,job)',
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
              'label_values(bigip_node_status_availability_state{job=~"$job"}, instance)',
              label='Instance',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=1
            ),
            template.new(
              'bigip_node',
              promDatasource,
              'label_values(bigip_node_status_availability_state{job=~"$job", instance=~"$instance"},node)',
              label='BIG-IP node',
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
            availabilityStatusPanel { gridPos: { h: 5, w: 8, x: 0, y: 0 } },
            requests__intervalPanel { gridPos: { h: 5, w: 8, x: 8, y: 0 } },
            activeSessionsPanel { gridPos: { h: 5, w: 8, x: 16, y: 0 } },
            connectionsPanel { gridPos: { h: 5, w: 24, x: 0, y: 5 } },
            trafficInboundPanel { gridPos: { h: 5, w: 12, x: 0, y: 10 } },
            trafficOutboundPanel { gridPos: { h: 5, w: 12, x: 12, y: 10 } },
            packetsInboundIntervalPanel { gridPos: { h: 5, w: 12, x: 0, y: 15 } },
            packetsOutboundIntervalPanel { gridPos: { h: 5, w: 12, x: 12, y: 15 } },
          ],
        ])
      ),
  },
}
