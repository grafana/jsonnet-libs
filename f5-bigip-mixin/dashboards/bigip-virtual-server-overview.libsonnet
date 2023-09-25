local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;
local dashboardUid = 'bigip-virtual-server-overview';

local promDatasourceName = 'datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local availabilityStatusPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'bigip_vs_status_availability_state{job=~"$job", instance=~"$instance", vs=~"$bigip_virtual_server"}',
      datasource=promDatasource,
      legendFormat='{{vs}} - {{instance}}',
      intervalFactor=2,
      instant=true,
      format='table',
    ),
  ],
  type: 'table',
  title: 'Availability status',
  description: 'The availability status of the virtual server.',
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
          options: 'vs',
        },
        properties: [
          {
            id: 'displayName',
            value: 'Virtual server',
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
      'increase(bigip_vs_tot_requests{job=~"$job", instance=~"$instance", vs=~"$bigip_virtual_server"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{vs}} - {{instance}}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Requests / $__interval',
  description: 'The number of requests made to the virtual server.',
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
      'bigip_vs_clientside_cur_conns{job=~"$job", instance=~"$instance", vs=~"$bigip_virtual_server"}',
      datasource=promDatasource,
      legendFormat='{{vs}} - {{instance}} - current',
      format='time_series',
    ),
    prometheus.target(
      'bigip_vs_clientside_max_conns{job=~"$job", instance=~"$instance", vs=~"$bigip_virtual_server"}',
      datasource=promDatasource,
      legendFormat='{{vs}} - {{instance}} - maximum',
      format='time_series',
    ),
    prometheus.target(
      'bigip_vs_clientside_evicted_conns{job=~"$job", instance=~"$instance", vs=~"$bigip_virtual_server"}',
      datasource=promDatasource,
      legendFormat='{{vs}} - {{instance}} - evicted',
    ),
  ],
  type: 'timeseries',
  title: 'Connections',
  description: 'The evicted and current client-side connections within the virtual server.',
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

local ephemeralConnectionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'bigip_vs_ephemeral_cur_conns{job=~"$job", instance=~"$instance", vs=~"$bigip_virtual_server"}',
      datasource=promDatasource,
      legendFormat='{{vs}} - {{instance}} - current',
    ),
    prometheus.target(
      'bigip_vs_ephemeral_max_conns{job=~"$job", instance=~"$instance", vs=~"$bigip_virtual_server"}',
      datasource=promDatasource,
      legendFormat='{{vs}} - {{instance}} - maximum',
    ),
    prometheus.target(
      'bigip_vs_ephemeral_evicted_conns{job=~"$job", instance=~"$instance", vs=~"$bigip_virtual_server"}',
      datasource=promDatasource,
      legendFormat='{{vs}} - {{instance}} - evicted',
    ),
  ],
  type: 'timeseries',
  title: 'Ephemeral connections',
  description: 'The ephemeral evicted and current client-side connections within the virtual server.',
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

local averageConnectionDurationPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'bigip_vs_cs_mean_conn_dur{job=~"$job", instance=~"$instance", vs=~"$bigip_virtual_server"}',
      datasource=promDatasource,
      legendFormat='{{vs}} - {{instance}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Average connection duration',
  description: 'The average connection duration within the virtual server.',
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local trafficInboundPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(bigip_vs_clientside_bytes_in{job=~"$job", instance=~"$instance", vs=~"$bigip_virtual_server"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{vs}} - {{instance}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Traffic inbound',
  description: 'The rate of data received from clients by the virtual server.',
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
      'rate(bigip_vs_clientside_bytes_out{job=~"$job", instance=~"$instance", vs=~"$bigip_virtual_server"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{vs}} - {{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Traffic outbound',
  description: 'The rate of data sent from clients by the virtual server.',
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

local trafficInboundEphemeralPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(bigip_vs_ephemeral_bytes_in{job=~"$job", instance=~"$instance", vs=~"$bigip_virtual_server"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{vs}} - {{instance}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Ephemeral traffic inbound',
  description: 'The rate of ephemeral data received from clients by the virtual server.',
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

local trafficOutboundEphemeralPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(bigip_vs_ephemeral_bytes_out{job=~"$job", instance=~"$instance", vs=~"$bigip_virtual_server"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{vs}} - {{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Ephemeral traffic outbound',
  description: 'The rate of ephemeral data sent from clients by the virtual server.',
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
      'increase(bigip_vs_clientside_pkts_in{job=~"$job", instance=~"$instance", vs=~"$bigip_virtual_server"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{vs}} - {{instance}}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Packets inbound / $__interval',
  description: 'The number of packets received by the virtual server.',
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
      'increase(bigip_vs_clientside_pkts_out{job=~"$job", instance=~"$instance", vs=~"$bigip_virtual_server"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{vs}} - {{instance}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Packets outbound / $__interval',
  description: 'The number of packets sent by the virtual server.',
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

local packetsEphemeralInboundntervalPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(bigip_vs_ephemeral_pkts_in{job=~"$job", instance=~"$instance", vs=~"$bigip_virtual_server"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{vs}} - {{instance}}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Ephemeral packets inbound / $__interval',
  description: 'The number of ephemeral packets received by the virtual server.',
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

local packetsEphemeralOutboundIntervalPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(bigip_vs_ephemeral_pkts_out{job=~"$job", instance=~"$instance", vs=~"$bigip_virtual_server"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{vs}} - {{instance}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Ephemeral packets outbound / $__interval',
  description: 'The number of ephemeral packets sent by the virtual server.',
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
    'bigip-virtual-server-overview.json':
      dashboard.new(
        'BIG-IP virtual server overview',
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
              'label_values(bigip_vs_status_availability_state,job)',
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
              'label_values(bigip_vs_status_availability_state{job=~"$job"}, instance)',
              label='Instance',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=1
            ),
            template.new(
              'bigip_virtual_server',
              promDatasource,
              'label_values(bigip_vs_status_availability_state{job=~"$job", instance=~"$instance"},vs)',
              label='BIG-IP virtual server',
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
            averageConnectionDurationPanel { gridPos: { h: 5, w: 8, x: 16, y: 0 } },
            connectionsPanel { gridPos: { h: 5, w: 24, x: 0, y: 5 } },
            ephemeralConnectionsPanel { gridPos: { h: 5, w: 24, x: 0, y: 10 } },
            trafficInboundPanel { gridPos: { h: 5, w: 12, x: 0, y: 15 } },
            trafficOutboundPanel { gridPos: { h: 5, w: 12, x: 12, y: 15 } },
            trafficInboundEphemeralPanel { gridPos: { h: 5, w: 12, x: 0, y: 20 } },
            trafficOutboundEphemeralPanel { gridPos: { h: 5, w: 12, x: 12, y: 20 } },
            packetsInboundIntervalPanel { gridPos: { h: 5, w: 12, x: 0, y: 25 } },
            packetsOutboundIntervalPanel { gridPos: { h: 5, w: 12, x: 12, y: 25 } },
            packetsEphemeralInboundntervalPanel { gridPos: { h: 5, w: 12, x: 0, y: 30 } },
            packetsEphemeralOutboundIntervalPanel { gridPos: { h: 5, w: 12, x: 12, y: 30 } },
          ],
        ])
      ),
  },
}
