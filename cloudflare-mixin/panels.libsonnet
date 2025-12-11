local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;

{
  new(this)::
    {
      local signals = this.signals,

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
          targets=[signals.zone.requestsCached.asTarget()],
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
          targets=[signals.zone.threatsTotal.asTarget()],
          description='The number of threats that have targeted the zone.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('none')
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
            signals.zone.bandwidthSslEncrypted.asTarget(),
            signals.zone.bandwidthCached.asTarget(),
          ],
          description='The amount of cached and encrypted bandwidth that occurs in the zone.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withDrawStyle('bars'),

      bandwidthContentTypePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Bandwidth content type / $__interval',
          targets=[signals.zone.bandwidthContentType.asTarget()],
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
            signals.zone.uniquesTotal.asTarget(),
            signals.zone.repeatVisitors.asTarget(),
          ],
          description='The number of unique and total page views.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false)
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

      requestsStatusPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Request HTTP status / $__interval',
          targets=[signals.zone.requestsStatus.asTarget()],
          description='The number of different HTTP status codes used for requests in the zone.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false)
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
        + g.panel.timeSeries.options.legend.withCalcs(['min', 'max', 'mean'])
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      browserMapPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Browser page views / $__interval',
          targets=[signals.zone.requestsBrowserMap.asTarget()],
          description='The number of zone views by browser family.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      colocationRequestsPanel:
        commonlib.panels.generic.table.base.new(
          'Colocation requests',
          targets=[signals.zone.colocationRequests.asTarget()],
          description='The different colocations being used by the zone and their request rates.'
        )
        + g.panel.table.standardOptions.withUnit('reqps'),

      // Pool panels
      poolStatusPanel:
        commonlib.panels.generic.table.base.new(
          'Pool status',
          targets=[
            signals.pool.poolStatus.asTarget() { format: 'table' },
            signals.pool.requests.asTarget() { format: 'table' },
          ],
          description='A table view of the pools in your zone showing their health and rate of requests.'
        ),

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
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      workerDurationPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Worker duration quantiles',
          targets=[signals.worker.duration.asTarget()],
          description='Duration of worker execution.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

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
          'Worker errors',
          targets=[signals.worker.errorsCount.asTarget()],
          description='Number of errors from the worker.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('short')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      geoMetricByCountryGeomapPanel:
        g.panel.geomap.new('Geographic distribution')
        + g.panel.geomap.panelOptions.withDescription('Geomap panel currently showing $geo_metric for the zone.')
        + g.panel.geomap.queryOptions.withTargets([
          signals.geomap.geoMapByCountry.asTarget() { interval: '1m' }
          + g.query.prometheus.withLegendFormat(''),
        ]),
      geoMetricsByCountryTablePanel:
        g.panel.table.new('Geographic distribution')
        + g.panel.table.panelOptions.withDescription('Table currently showing $geo_metric for the zone.')
        + g.panel.table.queryOptions.withTargets([
          signals.geomap.geoMetricsByCountryTable.asTarget()
          + g.query.prometheus.withFormat('table')
          + g.query.prometheus.withLegendFormat(''),
        ]),
    },
}
