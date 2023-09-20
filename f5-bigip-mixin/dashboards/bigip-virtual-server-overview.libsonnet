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
      legendFormat='{{vs}} - {{partition}} - {{instance}}',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'Availability status',
  description: 'The availability state of the virtual server.',
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

local requests__intervalPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(bigip_vs_tot_requests{job=~"$job", instance=~"$instance", vs=~"$bigip_virtual_server"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{vs}} - {{partition}} - {{instance}}',
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
      legendFormat='{{vs}} - {{partition}} - {{instance}} - current',
      format='time_series',
    ),
    prometheus.target(
      'bigip_vs_clientside_max_conns{job=~"$job", instance=~"$instance", vs=~"$bigip_virtual_server"}',
      datasource=promDatasource,
      legendFormat='{{vs}} - {{partition}} - {{instance}} - maximum',
      format='time_series',
    ),
    prometheus.target(
      'bigip_vs_ephemeral_cur_conns{job=~"$job", instance=~"$instance", vs=~"$bigip_virtual_server"}',
      datasource=promDatasource,
      legendFormat='{{vs}} - {{partition}} - {{instance}} - ephemeral current',
    ),
    prometheus.target(
      'bigip_vs_ephemeral_max_conns{job=~"$job", instance=~"$instance", vs=~"$bigip_virtual_server"}',
      datasource=promDatasource,
      legendFormat='{{vs}} - {{partition}} - {{instance}} - ephemeral maximum',
    ),
    prometheus.target(
      'bigip_vs_clientside_evicted_conns{job=~"$job", instance=~"$instance", vs=~"$bigip_virtual_server"}',
      datasource=promDatasource,
      legendFormat='{{vs}} - {{partition}} - {{instance}} - evicted',
    ),
    prometheus.target(
      'bigip_vs_ephemeral_evicted_conns{job=~"$job", instance=~"$instance", vs=~"$bigip_virtual_server"}',
      datasource=promDatasource,
      legendFormat='{{vs}} - {{partition}} - {{instance}} - ephemeral evicted',
    ),
  ],
  type: 'timeseries',
  title: 'Connections',
  description: 'The ephemeral, evicted, and current client-side connections within the virtual server.',
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
      legendFormat='{{vs}} - {{partition}} - {{instance}}',
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

local trafficPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(bigip_vs_clientside_bytes_in{job=~"$job", instance=~"$instance", vs=~"$bigip_virtual_server"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{vs}} - {{partition}} - {{instance}} - received',
      format='time_series',
    ),
    prometheus.target(
      'rate(bigip_vs_ephemeral_bytes_in{job=~"$job", instance=~"$instance", vs=~"$bigip_virtual_server"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{vs}} - {{partition}} - {{instance}} - ephemeral received',
      format='time_series',
    ),
    prometheus.target(
      'rate(bigip_vs_clientside_bytes_out{job=~"$job", instance=~"$instance", vs=~"$bigip_virtual_server"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{vs}} - {{partition}} - {{instance}} - sent',
    ),
    prometheus.target(
      'rate(bigip_vs_ephemeral_bytes_out{job=~"$job", instance=~"$instance", vs=~"$bigip_virtual_server"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{vs}} - {{partition}} - {{instance}} - ephemeral sent',
    ),
  ],
  type: 'timeseries',
  title: 'Traffic',
  description: 'The rate of data sent and received from clients by the virtual server.',
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

local packets__intervalPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(bigip_vs_clientside_pkts_in{job=~"$job", instance=~"$instance", vs=~"$bigip_virtual_server"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{vs}} - {{partition}} - {{instance}} - received',
      format='time_series',
      interval='1m',
    ),
    prometheus.target(
      'increase(bigip_vs_ephemeral_pkts_in{job=~"$job", instance=~"$instance", vs=~"$bigip_virtual_server"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{vs}} - {{partition}} - {{instance}} - ephemeral received',
      format='time_series',
      interval='1m',
    ),
    prometheus.target(
      'increase(bigip_vs_clientside_pkts_out{job=~"$job", instance=~"$instance", vs=~"$bigip_virtual_server"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{vs}} - {{partition}} - {{instance}} - sent',
      interval='1m',
    ),
    prometheus.target(
      'increase(bigip_vs_ephemeral_pkts_out{job=~"$job", instance=~"$instance", vs=~"$bigip_virtual_server"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{vs}} - {{partition}} - {{instance}} - ephemeral sent',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Packets / $__interval',
  description: 'The number of packets sent and received by the virtual server.',
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
            availabilityStatusPanel { gridPos: { h: 6, w: 12, x: 0, y: 0 } },
            requests__intervalPanel { gridPos: { h: 6, w: 12, x: 12, y: 0 } },
            connectionsPanel { gridPos: { h: 6, w: 12, x: 0, y: 6 } },
            averageConnectionDurationPanel { gridPos: { h: 6, w: 12, x: 12, y: 6 } },
            trafficPanel { gridPos: { h: 6, w: 24, x: 0, y: 12 } },
            packets__intervalPanel { gridPos: { h: 6, w: 24, x: 0, y: 18 } },
          ],
        ])
      ),
  },
}
