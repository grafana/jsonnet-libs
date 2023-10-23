local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'cloudflare-geomap-overview';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local GeoMetricByCountryGeomapPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase($geo_metric{job=~"$job", instance=~"$instance", zone=~"$zone"}[$__interval:] offset -$__interval)',
      datasource=promDatasource,
      legendFormat='',
      format='table',
      interval='1m',
    ),
  ],
  type: 'geomap',
  title: '$geo_metric by country',
  id: 3,
  description: 'Geomap panel currently showing $geo_metric for the zone.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'continuous-BlPu',
      },
      custom: {
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
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
    basemap: {
      config: {},
      name: 'Layer 0',
      type: 'default',
    },
    controls: {
      mouseWheelZoom: true,
      showAttribution: true,
      showDebug: false,
      showMeasure: false,
      showScale: false,
      showZoom: true,
    },
    layers: [
      {
        config: {
          showLegend: true,
          style: {
            color: {
              field: 'Total',
              fixed: 'dark-green',
            },
            opacity: 0.4,
            rotation: {
              fixed: 0,
              max: 360,
              min: -360,
              mode: 'mod',
            },
            size: {
              field: 'Total',
              fixed: 5,
              max: 15,
              min: 7,
            },
            symbol: {
              fixed: 'img/icons/marker/circle.svg',
              mode: 'fixed',
            },
            symbolAlign: {
              horizontal: 'center',
              vertical: 'center',
            },
            textConfig: {
              fontSize: 12,
              offsetX: 0,
              offsetY: 0,
              textAlign: 'center',
              textBaseline: 'middle',
            },
          },
        },
        location: {
          gazetteer: 'public/gazetteer/countries.json',
          lookup: 'country',
          mode: 'lookup',
        },
        name: 'Total',
        tooltip: true,
        type: 'markers',
      },
    ],
    tooltip: {
      mode: 'multi',
    },

    view: {
      allLayers: true,
      id: 'zero',
      lat: 0,
      lon: 0,
      zoom: 1,
    },
  },
  pluginVersion: '10.2.0-62263',
  transformations: [
    {
      id: 'groupBy',
      options: {
        fields: {
          Value: {
            aggregations: [
              'sum',
              'mean',
              'lastNotNull',
            ],
            operation: 'aggregate',
          },
          country: {
            aggregations: [],
            operation: 'groupby',
          },
          host: {
            aggregations: [],
          },
          instance: {
            aggregations: [],
            operation: 'groupby',
          },
          job: {
            aggregations: [],
            operation: 'groupby',
          },
          region: {
            aggregations: [],
            operation: 'groupby',
          },
          status: {
            aggregations: [],
            operation: 'groupby',
          },
          zone: {
            aggregations: [],
          },
        },
      },
    },
    {
      id: 'organize',
      options: {
        excludeByName: {},
        indexByName: {},
        renameByName: {
          'Value (lastNotNull)': 'Last',
          'Value (mean)': 'Mean',
          'Value (sum)': 'Total',
          country: 'Country',
          instance: 'Instance',
          job: 'Job',
          region: 'Region',
          status: 'Status',
          zone: 'Zone',
        },
      },
    },
  ],
};

local GeoMetricByCountryTablePanel = {
  datasource: {
    type: 'datasource',
    uid: '-- Dashboard --',
  },
  targets: [
    {
      datasource: {
        type: 'datasource',
        uid: '-- Dashboard --',
      },
      panelId: GeoMetricByCountryGeomapPanel.id,
      refId: 'A',
      withTransforms: true,
    },
  ],
  type: 'table',
  title: '$geo_metric by country',
  description: 'Table currently showing $geo_metric for the zone.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      custom: {
        align: 'auto',
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
          {
            color: 'red',
            value: 80,
          },
        ],
      },
    },
    overrides: [
      {
        matcher: {
          id: 'byRegexp',
          options: '/Total|Mean|Last/',
        },
        properties: [
          {
            id: 'custom.cellOptions',
            value: {
              mode: 'basic',
              type: 'gauge',
              valueDisplayMode: 'text',
            },
          },
          {
            id: 'color',
            value: {
              mode: 'continuous-BlPu',
            },
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
    showHeader: true,
    sortBy: [
      {
        desc: true,
        displayName: 'Total',
      },
    ],
  },
  pluginVersion: '10.2.0-62263',
};

{
  grafanaDashboards+:: {
    'cloudflare-geomap-overview.json':
      dashboard.new(
        'Cloudflare Geomap overview',
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
            includeAll=false,
            multi=false,
            allValues='',
            sort=0
          ),
          template.new(
            'instance',
            promDatasource,
            'label_values(cloudflare_zone_requests_total{job="$job"},instance)',
            label='Instance',
            refresh=2,
            includeAll=false,
            multi=true,
            allValues='',
            sort=0
          ),
          template.new(
            'zone',
            promDatasource,
            'label_values(cloudflare_zone_requests_total{job=~"$job", instance=~"$instance"},zone)',
            label='Zone',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.+',
            sort=0
          ),
          template.custom(
            'geo_metric',
            query='cloudflare_zone_requests_country,cloudflare_zone_bandwidth_country,cloudflare_zone_threats_country',
            current='Requests',
            refresh='never',
            label='Geomap metric',
            valuelabels={},
            includeAll=false,
            multi=false,
            allValues='',
          ),
        ]
      )
      .addPanels(
        [
          GeoMetricByCountryTablePanel { gridPos: { h: 7, w: 24, x: 0, y: 0 } },
          GeoMetricByCountryGeomapPanel { gridPos: { h: 24, w: 24, x: 0, y: 7 } },
        ]
      ),
  },
}
