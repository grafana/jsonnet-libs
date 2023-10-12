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

local GeoMetricByCountryPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '$geo_metric{job=~"$job", instance=~"$instance", zone=~"$zone"}',
      datasource=promDatasource,
      format='table',
    ),
  ],
  type: 'geomap',
  title: '$geo_metric by country',
  description: 'GeoMap panel currently showing $geo_metric for the zone.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
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
              fixed: 5,
              max: 15,
              min: 2,
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
        filterData: {
          id: 'byRefId',
          options: 'A',
        },
        location: {
          gazetteer: 'public/gazetteer/countries.json',
          lookup: 'country',
          mode: 'lookup',
        },
        name: 'Country',
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
  pluginVersion: '10.2.0-61719',
};

{
  grafanaDashboards+:: {
    'cloudflare-geomap-overview.json':
      dashboard.new(
        'Cloudflare GeoMap overview',
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
            refresh=1,
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
            refresh=1,
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
            refresh=1,
            includeAll=true,
            multi=true,
            allValues='.+',
            sort=0
          ),
          template.custom(
            'geo_metric',
            query='cloudflare_zone_requests_country,cloudflare_zone_bandwidth_country,cloudflare_zone_threats_country,cloudflare_zone_requests_origin_status_country_host,cloudflare_zone_requests_status_country_host',
            current='Requests',
            refresh='never',
            label='GeoMap metric',
            valuelabels={ cloudflare_zone_requests_country: 'Requests', cloudflare_zone_bandwidth_country: 'Bandwidth', cloudflare_zone_threats_country: 'Threats', cloudflare_zone_requests_origin_status_country_host: 'Non-cache requests', cloudflare_zone_requests_status_country_host: 'Edge requests' },
            includeAll=false,
            multi=false,
            allValues='',
          ),
        ]
      )
      .addPanels(
        [
          GeoMetricByCountryPanel { gridPos: { h: 24, w: 24, x: 0, y: 0 } },
        ]
      ),
  },
}
