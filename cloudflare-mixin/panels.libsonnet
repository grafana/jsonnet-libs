local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;

{
  new(this)::
    {
      local signals = this.signals,

      // Zone panels
      requestsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Requests',
          targets=[signals.zone.requestsTotal.asTarget()],
          description='Rate of requests to the zone.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      cachedRequestsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Cached requests',
          targets=[signals.zone.requestsCached.asTarget()],
          description='Percentage of cached requests.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      threatsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Threats',
          targets=[signals.zone.threatsTotal.asTarget()],
          description='Number of threats blocked.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('short')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      bandwidthPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Bandwidth',
          targets=[signals.zone.bandwidthTotal.asTarget()],
          description='Total bandwidth usage.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(54)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      sslBandwidthPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'SSL encrypted bandwidth',
          targets=[
            signals.zone.bandwidthSslEncrypted.asTarget(),
            signals.zone.bandwidthCached.asTarget(),
          ],
          description='SSL encrypted and cached bandwidth.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(54)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      bandwidthContentTypePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Bandwidth by content type',
          targets=[signals.zone.bandwidthContentType.asTarget()],
          description='Bandwidth usage by content type.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(54)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      uniqueVisitorsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Unique visitors',
          targets=[
            signals.zone.uniquesTotal.asTarget(),
            signals.zone.repeatVisitors.asTarget(),
          ],
          description='Unique and repeat visitors.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('short')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(54)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      requestsStatusPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Requests by status',
          targets=[signals.zone.requestsStatus.asTarget()],
          description='Requests broken down by HTTP status code.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('short')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(54)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      browserMapPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Browser map pageviews',
          targets=[signals.zone.requestsBrowserMap.asTarget()],
          description='Browser map pageviews count.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('short')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(54)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      colocationRequestsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Requests by colocation',
          targets=[signals.zone.colocationRequests.asTarget()],
          description='Requests by colocation center.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      // Pool panels
      poolStatusPanel:
        commonlib.panels.generic.stat.base.new(
          'Pool health status',
          targets=[signals.pool.poolStatus.asTarget()],
          description='Health status of the pool (0=unhealthy, 1=healthy).'
        )
        + g.panel.stat.standardOptions.withUnit('short'),

      poolRequestsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Pool requests',
          targets=[signals.pool.requests.asTarget()],
          description='Rate of requests to the pool.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      // Worker panels
      workerCpuTimePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Worker CPU time',
          targets=[signals.worker.cpuTime.asTarget()],
          description='CPU time consumed by the worker.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(54)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      workerDurationPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Worker duration',
          targets=[signals.worker.duration.asTarget()],
          description='Duration of worker execution.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(54)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      workerRequestsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Worker requests',
          targets=[signals.worker.requestsCount.asTarget()],
          description='Rate of requests to the worker.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      workerErrorsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Worker errors',
          targets=[signals.worker.errorsCount.asTarget()],
          description='Number of errors from the worker.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('short')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      geoMetricByCountryGeomapPanel:
        g.panel.geomap.new('Geographic Distribution')
        + g.panel.geomap.panelOptions.withDescription('Geomap panel currently showing $geo_metric for the zone.')
        + g.panel.geomap.queryOptions.withTargets([
          signals.geomap.geoMapByCountry.asTarget() { interval: '1m' }
          + g.query.prometheus.withLegendFormat(''),
        ]),
      geoMetricsByCountryTablePanel:
        g.panel.table.new('Geographic Distribution')
        + g.panel.table.panelOptions.withDescription('Table currently showing $geo_metric for the zone.')
        + g.panel.table.queryOptions.withTargets([
          signals.geomap.geoMetricsByCountryTable.asTarget()
          + g.query.prometheus.withFormat('table')
          + g.query.prometheus.withLegendFormat(''),
        ]),
    },
}
