local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;

{
  new(this)::
    {
      local signals = this.signals,

      // Shared transformations for geomap panels
      local geoTransformations = [
        {
          id: 'groupBy',
          options: {
            fields: {
              Value: {
                aggregations: ['sum', 'mean', 'lastNotNull'],
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

      // Zone panels

      alertsPanel: {
        datasource: {
          uid: 'prometheus',
        },
        targets: [],
        type: 'alertlist',
        title: 'Alerts',
        options: {
          alertInstanceLabelFilter: '{job=~"${job:regex}", instance=~"${instance:regex}"}',
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
      },

      requestsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Request rate',
          targets=[signals.zone.requestsTotal.asTarget()],
          description='The rate at which requests to the zone occur.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      cachedRequestsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Cached requests / $__interval',
          targets=[
            signals.zone.requestsCached.asTarget()
            + g.query.prometheus.withInterval('1m')
            + g.query.prometheus.withIntervalFactor(2),
          ],
          description='The percentage of requests to the zone that are cached.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percentunit')
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withMax(1)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false)
        + g.panel.timeSeries.fieldConfig.defaults.custom.thresholdsStyle.withMode('area')
        + g.panel.timeSeries.standardOptions.thresholds.withMode('percentage')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          { color: 'red', value: null },
          { color: '#EAB839', value: 50 },
          { color: 'green', value: 80 },
        ]),

      threatsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Threats / $__interval',
          targets=[
            signals.zone.threatsTotal.asTarget()
            + g.query.prometheus.withInterval('1m')
            + g.query.prometheus.withIntervalFactor(2),
          ],
          description='The number of threats that have targeted the zone.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('short')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      bandwidthPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Bandwidth rate',
          targets=[signals.zone.bandwidthTotal.asTarget()],
          description='The rate at which all bandwidth in the zone occurs.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('Bps')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      sslBandwidthPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Bandwidth type / $__interval',
          targets=[
            signals.zone.bandwidthSslEncrypted.asTarget()
            + g.query.prometheus.withInterval('1m')
            + g.query.prometheus.withIntervalFactor(2),
            signals.zone.bandwidthCached.asTarget()
            + g.query.prometheus.withInterval('1m')
            + g.query.prometheus.withIntervalFactor(2),
          ],
          description='The amount of cached and encrypted bandwidth that occurs in the zone.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withDrawStyle('bars'),

      bandwidthContentTypePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Bandwidth content type / $__interval',
          targets=[
            signals.zone.bandwidthContentType.asTarget()
            + g.query.prometheus.withInterval('1m')
            + g.query.prometheus.withIntervalFactor(2),
          ],
          description='The content types that bandwidth is being used for in the zone.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withDrawStyle('bars')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('auto'),

      uniqueVisitorsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Unique page views / $__interval',
          targets=[
            signals.zone.uniquesTotal.asTarget()
            + g.query.prometheus.withInterval('1m')
            + g.query.prometheus.withIntervalFactor(2),
            signals.zone.repeatVisitors.asTarget()
            + g.query.prometheus.withInterval('1m')
            + g.query.prometheus.withIntervalFactor(2),
          ],
          description='The number of unique and total page views.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('short')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false)
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

      requestsStatusPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Request HTTP status / $__interval',
          targets=[
            signals.zone.requestsStatus.asTarget()
            + g.query.prometheus.withInterval('1m')
            + g.query.prometheus.withIntervalFactor(2),
          ],
          description='The number of different HTTP status codes used for requests in the zone.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('short')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false)
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
        + g.panel.timeSeries.options.legend.withCalcs(['min', 'max', 'mean'])
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      browserMapPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Browser page views / $__interval',
          targets=[
            signals.zone.requestsBrowserMap.asTarget()
            + g.query.prometheus.withInterval('1m')
            + g.query.prometheus.withIntervalFactor(2),
          ],
          description='The number of zone views by browser family.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('short')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      colocationRequestsPanel:
        commonlib.panels.generic.table.base.new(
          'Colocation requests',
          targets=[
            signals.zone.colocationRequests.asTarget()
            + g.query.prometheus.withFormat('time_series')
            + g.query.prometheus.withIntervalFactor(2)
            + g.query.prometheus.withLegendFormat(''),
          ],
          description='The different colocations being used by the zone and their request rates.'
        )
        + g.panel.table.standardOptions.withUnit('reqps')
        + g.panel.table.fieldConfig.defaults.custom.withAlign('left')
        + g.panel.table.fieldConfig.defaults.custom.withCellOptions({ type: 'auto' })
        + g.panel.table.fieldConfig.defaults.custom.withInspect(false)
        + g.panel.table.queryOptions.withTransformations([
          {
            id: 'reduce',
            options: {
              reducers: ['lastNotNull'],
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
                cluster: true,
                host: true,
                instance: true,
                job: true,
                script_name: true,
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
        ])
        + g.panel.table.options.withCellHeight('sm')
        + g.panel.table.options.footer.withCountRows(false)
        + g.panel.table.options.footer.withFields('')
        + g.panel.table.options.footer.withReducer(['sum'])
        + g.panel.table.options.footer.withShow(false)
        + g.panel.table.options.withShowHeader(true)
        + g.panel.table.options.withSortBy([
          { desc: true, displayName: 'Requests' },
        ]),

      // Pool panels
      poolStatusPanel:
        commonlib.panels.generic.table.base.new(
          'Pool status',
          targets=[
            signals.pool.poolStatus.asTarget()
            + g.query.prometheus.withRefId('A')
            + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withIntervalFactor(2)
            + g.query.prometheus.withLegendFormat(''),
            signals.pool.requests.asTarget()
            + g.query.prometheus.withRefId('B')
            + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withIntervalFactor(2)
            + g.query.prometheus.withLegendFormat(''),
          ],
          description='A table view of the pools in your zone showing their health and rate of requests.'
        )
        + g.panel.table.standardOptions.withUnit('reqps')
        + g.panel.table.standardOptions.withMappings([
          {
            type: 'value',
            options: {
              'Health=1': {
                index: 0,
                text: 'Healthy',
              },
            },
          },
        ])
        + g.panel.table.queryOptions.withTransformations([
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
                pool_name: 0,
                'load_balancer_name 2': 1,
                origin_name: 2,
                'zone 2': 3,
                'Value #B': 4,
                'Value #A': 5,
              },
              renameByName: {
                pool_name: 'Pool',
                'load_balancer_name 2': 'Load balancer',
                origin_name: 'Origin',
                'zone 2': 'Zone',
                'Value #B': 'Requests',
                'Value #A': 'Health',
              },
            },
          },
        ])
        + g.panel.table.standardOptions.withOverrides([
          g.panel.table.fieldOverride.byName.new('Health')
          + g.panel.table.fieldOverride.byName.withProperty(
            'custom.cellOptions',
            {
              type: 'color-text',
            }
          )
          + g.panel.table.fieldOverride.byName.withProperty(
            'mappings',
            [
              {
                type: 'value',
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
              },
            ]
          ),
          g.panel.table.fieldOverride.byName.new('Requests')
          + g.panel.table.fieldOverride.byName.withProperty('decimals', 4),
        ]),

      poolRequestsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Pool requests',
          targets=[signals.pool.requests.asTarget()],
          description='Rate of requests to the pool.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      // Worker panels
      workerCpuTimePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Worker CPU time quantiles',
          targets=[signals.worker.cpuTime.asTarget()],
          description='CPU time consumed by the worker.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false)
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      workerDurationPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Worker duration quantiles',
          targets=[signals.worker.duration.asTarget()],
          description='Duration of worker execution.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false)
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      workerRequestsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Worker requests',
          targets=[signals.worker.requestsCount.asTarget()],
          description='Rate of requests to the worker.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      workerErrorsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Worker errors / $__interval',
          targets=[
            signals.worker.errorsCount.asTarget()
            + g.query.prometheus.withInterval('1m')
            + g.query.prometheus.withIntervalFactor(2),
          ],
          description='Number of errors from the worker.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('short')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      geoMetricByCountryGeomapPanel:
        g.panel.geomap.new('Geographic distribution')
        + g.panel.geomap.panelOptions.withDescription('Geomap panel currently showing $geo_metric for the zone.')
        + g.panel.geomap.queryOptions.withTargets([
          signals.geomap.geoMapByCountry.asTarget()
          + g.query.prometheus.withFormat('table')
          + g.query.prometheus.withInterval('2m')
          + g.query.prometheus.withIntervalFactor(2)
          + g.query.prometheus.withLegendFormat(''),
        ])
        + g.panel.geomap.standardOptions.color.withMode('continuous-BlPu')
        + g.panel.geomap.queryOptions.withTransformations(geoTransformations)
        + g.panel.geomap.options.withBasemap({ type: 'default', name: 'Layer 0', config: {} })
        + g.panel.geomap.options.withView({ id: 'zero', lat: 0, lon: 0, zoom: 1, allLayers: true })
        + g.panel.geomap.options.withTooltip({ mode: 'multi' })
        + g.panel.geomap.options.withControls({
          mouseWheelZoom: true,
          showAttribution: true,
          showDebug: false,
          showMeasure: false,
          showScale: false,
          showZoom: true,
        })
        + g.panel.geomap.options.withLayers([
          {
            type: 'markers',
            name: 'Total',
            tooltip: true,
            location: {
              mode: 'lookup',
              lookup: 'country',
              gazetteer: 'public/gazetteer/countries.json',
            },
            config: {
              showLegend: true,
              style: {
                color: {
                  field: 'Total',
                  fixed: 'dark-green',
                },
                opacity: 0.4,
                size: {
                  field: 'Total',
                  fixed: 5,
                  min: 7,
                  max: 15,
                },
                symbol: {
                  mode: 'fixed',
                  fixed: 'img/icons/marker/circle.svg',
                },
                symbolAlign: {
                  horizontal: 'center',
                  vertical: 'center',
                },
                rotation: {
                  mode: 'mod',
                  fixed: 0,
                  min: -360,
                  max: 360,
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
          },
        ]),
      geoMetricsByCountryTablePanel:
        commonlib.panels.generic.table.base.new(
          'Geographic distribution',
          targets=[
            signals.geomap.geoMapByCountry.asTarget()
            + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withInterval('2m')
            + g.query.prometheus.withIntervalFactor(2)
            + g.query.prometheus.withLegendFormat(''),
          ],
          description='Table currently showing $geo_metric for the zone.'
        )
        + g.panel.table.queryOptions.withTransformations(geoTransformations)
        + g.panel.table.standardOptions.withOverrides([
          g.panel.table.fieldOverride.byRegexp.new('/Total|Mean|Last/')
          + g.panel.table.fieldOverride.byRegexp.withProperty(
            'custom.cellOptions',
            {
              mode: 'basic',
              type: 'gauge',
              valueDisplayMode: 'text',
            }
          )
          + g.panel.table.fieldOverride.byRegexp.withProperty(
            'color',
            {
              mode: 'continuous-BlPu',
            }
          ),
        ])
        + g.panel.table.options.withSortBy([
          { desc: true, displayName: 'Total' },
        ]),
    },
}
