local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'cloudflare-zone-overview';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local alertsPanel = {
  datasource: promDatasource,
  targets: [],
  type: 'alertlist',
  title: 'Alerts',
  options: {
    alertInstanceLabelFilter: '{job=~"integrations/cloudflare"}',
    alertName: '',
    dashboardAlerts: false,
    groupBy: [],
    groupMode: 'default',
    maxItems: 5,
    sortOrder: 1,
    stateFilter: {
      'error': true,
      firing: true,
      noData: true,
      normal: true,
      pending: true,
    },
    viewMode: 'list',
  },
};

local poolStatusPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'cloudflare_zone_pool_health_status{job=~"$job", instance=~"$instance", zone=~"$zone"}',
      datasource=promDatasource,
      format='table',
    ),
    prometheus.target(
      'rate(cloudflare_zone_pool_requests_total{job=~"$job", instance=~"$instance", zone=~"$zone"}[$__rate_interval])',
      datasource=promDatasource,
      format='table',
    ),
  ],
  type: 'table',
  title: 'Pool status',
  description: 'A table view of the pools in your zone showing their health and rate of requests.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      custom: {
        align: 'left',
        cellOptions: {
          type: 'auto',
        },
        inspect: false,
      },
      mappings: [
        {
          options: {
            'Health=1': {
              index: 0,
              text: 'Healthy',
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
      unit: 'reqps',
    },
    overrides: [
      {
        matcher: {
          id: 'byName',
          options: 'Health',
        },
        properties: [
          {
            id: 'custom.cellOptions',
            value: {
              type: 'color-text',
            },
          },
          {
            id: 'mappings',
            value: [
              {
                options: {
                  '0': {
                    color: 'red',
                    index: 1,
                    text: 'Unhealthy',
                  },
                  '1': {
                    color: 'green',
                    index: 0,
                    text: 'Healthy',
                  },
                },
                type: 'value',
              },
            ],
          },
        ],
      },
    ],
  },
  options: {
    cellHeight: 'sm',
    footer: {
      countRows: false,
      fields: '',
      reducer: [
        'sum',
      ],
      show: false,
    },
    frameIndex: 0,
    showHeader: true,
    sortBy: [],
  },
  pluginVersion: '10.2.0-61719',
  transformations: [
    {
      id: 'joinByField',
      options: {
        byField: 'pool_name',
        mode: 'outer',
      },
    },
    {
      id: 'filterFieldsByName',
      options: {
        include: {
          names: [
            'pool_name',
            'Value #A',
            'load_balancer_name 2',
            'origin_name',
            'Value #B',
            'zone 2',
          ],
        },
      },
    },
    {
      id: 'organize',
      options: {
        excludeByName: {},
        indexByName: {
          'Value #A': 5,
          'Value #B': 4,
          'load_balancer_name 2': 1,
          origin_name: 2,
          pool_name: 0,
          'zone 2': 3,
        },
        renameByName: {
          'Value #A': 'Health',
          'Value #B': 'Requests',
          'load_balancer_name 2': 'Load balancer',
          origin_name: 'Origin',
          pool_name: 'Pool',
          'zone 2': 'Zone',
        },
      },
    },
  ],
};

local requestRatePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(cloudflare_zone_requests_total{job=~"$job", instance=~"$instance", zone=~"$zone"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{zone}}',
    ),
  ],
  type: 'timeseries',
  title: 'Request rate',
  description: 'The rate at which requests to the zone occur.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
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
        insertNulls: false,
        lineInterpolation: 'linear',
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
      unit: 'reqps',
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

local cachedRequestsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(cloudflare_zone_requests_cached{job=~"$job", instance=~"$instance", zone=~"$zone"}[$__interval:]) / increase(cloudflare_zone_requests_total{job=~"$job", instance=~"$instance", zone=~"$zone"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{zone}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Cached requests / $__interval',
  description: 'The percentage of requests to the zone that are cached.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
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
        insertNulls: false,
        lineInterpolation: 'linear',
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
          mode: 'area',
        },
      },
      mappings: [],
      max: 1,
      min: 0,
      thresholds: {
        mode: 'percentage',
        steps: [
          {
            color: 'red',
            value: null,
          },
          {
            color: '#EAB839',
            value: 50,
          },
          {
            color: 'green',
            value: 80,
          },
        ],
      },
      unit: 'percentunit',
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

local threatsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(cloudflare_zone_threats_total{job=~"$job", instance=~"$instance", zone=~"$zone"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{zone}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Threats / $__interval',
  description: 'The number of threats that have targeted the zone.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
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
        insertNulls: false,
        lineInterpolation: 'linear',
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

local bandwidthRatePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(cloudflare_zone_bandwidth_total{job=~"$job", instance=~"$instance", zone=~"$zone"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{zone}}',
    ),
  ],
  type: 'timeseries',
  title: 'Bandwidth rate',
  description: 'The rate at which all bandwidth in the zone occurs.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
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
        insertNulls: false,
        lineInterpolation: 'linear',
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

local bandwidthTypePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(cloudflare_zone_bandwidth_ssl_encrypted{job=~"$job", instance=~"$instance", zone=~"$zone"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{zone}} - encrypted',
      interval='1m',
    ),
    prometheus.target(
      'increase(cloudflare_zone_bandwidth_cached{job=~"$job", instance=~"$instance", zone=~"$zone"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{zone}} - cached',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Bandwidth type / $__interval',
  description: 'The amount of cached and encrypted bandwidth that occurs in the zone.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'bars',
        fillOpacity: 10,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'linear',
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local bandwidthContentTypePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(cloudflare_zone_bandwidth_content_type{job=~"$job", instance=~"$instance", zone=~"$zone"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{zone}} - {{content_type}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Bandwidth content type / $__interval',
  description: 'The content types that bandwidth is being used for in the zone.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'bars',
        fillOpacity: 10,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'linear',
        lineWidth: 2,
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local browserPageViewsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(cloudflare_zone_requests_browser_map_page_views_count{job=~"$job", instance=~"$instance", zone=~"$zone"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{zone}} - {{family}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Browser page views / $__interval',
  description: 'The number of zone views by browser family.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
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
        insertNulls: false,
        lineInterpolation: 'linear',
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

local uniquePageViewsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(cloudflare_zone_uniques_total{job=~"$job", instance=~"$instance", zone=~"$zone"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{zone}} - unique',
      interval='1m',
    ),
    prometheus.target(
      'increase(cloudflare_zone_pageviews_total{job=~"$job", instance=~"$instance", zone=~"$zone"}[$__interval:]) - increase(cloudflare_zone_uniques_total{job=~"$job", instance=~"$instance", zone=~"$zone"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{zone}} - non-unique',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Unique page views / $__interval',
  description: 'The number of unique and total page views.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
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
        insertNulls: false,
        lineInterpolation: 'linear',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
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

local requestHTTPStatusPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(cloudflare_zone_requests_status{job=~"$job", instance=~"$instance", zone=~"$zone"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{zone}} - {{status}}',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Request HTTP status / $__interval',
  description: 'The number of different HTTP status codes used for requests in the zone.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
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
        insertNulls: false,
        lineInterpolation: 'linear',
        lineWidth: 2,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
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
        'max',
        'mean',
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

local colocationRequestsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(cloudflare_zone_colocation_requests_total{job=~"$job", instance=~"$instance", zone=~"$zone"}[$__rate_interval])',
      datasource=promDatasource,
    ),
  ],
  type: 'table',
  title: 'Colocation requests',
  description: 'The different colocations being used by the zone and their request rates.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      custom: {
        align: 'left',
        cellOptions: {
          type: 'auto',
        },
        inspect: false,
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
      unit: 'reqps',
    },
    overrides: [],
  },
  options: {
    cellHeight: 'sm',
    footer: {
      countRows: false,
      fields: '',
      reducer: [
        'sum',
      ],
      show: false,
    },
    showHeader: true,
  },
  pluginVersion: '10.2.0-61719',
  transformations: [
    {
      id: 'reduce',
      options: {
        reducers: [
          'lastNotNull',
        ],
      },
    },
    {
      id: 'extractFields',
      options: {
        format: 'auto',
        source: 'Field',
      },
    },
    {
      id: 'organize',
      options: {
        excludeByName: {
          Field: true,
          host: true,
          instance: true,
          job: true,
        },
        indexByName: {
          Field: 3,
          'Last *': 2,
          colocation: 1,
          host: 4,
          instance: 5,
          job: 6,
          zone: 0,
        },
        renameByName: {
          'Last *': 'Requests',
          colocation: 'Colocation',
          zone: 'Zone',
        },
      },
    },
  ],
};

{
  grafanaDashboards+:: {
    'cloudflare-zone-overview.json':
      dashboard.new(
        'Cloudflare zone overview',
        time_from='%s' % $._config.dashboardPeriod,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        description='',
        uid=dashboardUid,
      )

      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Other Cloudflare dashboards',
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
            'label_values(cloudflare_zone_requests_total,job)',
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
            'label_values(cloudflare_zone_requests_total{job="$job"},instance)',
            label='Instance',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.+',
            sort=0
          ),
          template.new(
            'zone',
            promDatasource,
            'label_values(cloudflare_zone_requests_total{instance="$instance"},zone)',
            label='Zone',
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
          alertsPanel { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
          poolStatusPanel { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
          requestRatePanel { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
          cachedRequestsPanel { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
          threatsPanel { gridPos: { h: 8, w: 12, x: 0, y: 16 } },
          bandwidthRatePanel { gridPos: { h: 8, w: 12, x: 12, y: 16 } },
          bandwidthTypePanel { gridPos: { h: 8, w: 12, x: 0, y: 24 } },
          bandwidthContentTypePanel { gridPos: { h: 8, w: 12, x: 12, y: 24 } },
          browserPageViewsPanel { gridPos: { h: 8, w: 12, x: 0, y: 32 } },
          uniquePageViewsPanel { gridPos: { h: 8, w: 12, x: 12, y: 32 } },
          requestHTTPStatusPanel { gridPos: { h: 8, w: 24, x: 0, y: 40 } },
          colocationRequestsPanel { gridPos: { h: 8, w: 24, x: 0, y: 48 } },
        ]
      ),
  },
}
