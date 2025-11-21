local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this):
    {
      local signals = this.signals,

      // Client panels
      clientRequests:
        g.panel.timeSeries.new('Client requests')
        + g.panel.timeSeries.panelOptions.withDescription('The request rate of client.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.overview.clientHTTPRequests.asTarget()
          + g.query.prometheus.withInterval('2m')
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineInterpolation('smooth')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never')
        + g.panel.timeSeries.standardOptions.withUnit('reqps'),

      clientRequestErrors:
        g.panel.timeSeries.new('Client request errors')
        + g.panel.timeSeries.panelOptions.withDescription('The number of client HTTP errors.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.overview.clientHTTPErrors.asTarget()
          + g.query.prometheus.withInterval('2m')
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineInterpolation('smooth')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never')
        + g.panel.timeSeries.standardOptions.withUnit('errors/s'),

      clientCacheHitRatio:
        g.panel.timeSeries.new('Client cache hit ratio')
        + g.panel.timeSeries.panelOptions.withDescription('The client cache hit ratio.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.overview.clientCacheHitRatio.asTarget()
          + g.query.prometheus.withInterval('2m')
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineInterpolation('smooth')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never')
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      clientRequestSentThroughput:
        g.panel.timeSeries.new('Client request sent throughput')
        + g.panel.timeSeries.panelOptions.withDescription('The throughput of client HTTP data sent.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.overview.clientHTTPSentThroughput.asTarget()
          + g.query.prometheus.withInterval('2m')
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineInterpolation('smooth')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never')
        + g.panel.timeSeries.standardOptions.withUnit('KBs'),

      clientHTTPReceivedThroughput:
        g.panel.timeSeries.new('Client HTTP received throughput')
        + g.panel.timeSeries.panelOptions.withDescription('The throughput of client HTTP data received.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.overview.clientHTTPReceivedThroughput.asTarget()
          + g.query.prometheus.withInterval('2m')
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineInterpolation('smooth')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never')
        + g.panel.timeSeries.standardOptions.withUnit('KBs'),

      clientCacheHitThroughput:
        g.panel.timeSeries.new('Client cache hit throughput')
        + g.panel.timeSeries.panelOptions.withDescription('The throughput of client cache hit.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.overview.clientCacheHitThroughput.asTarget()
          + g.query.prometheus.withInterval('2m')
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineInterpolation('smooth')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never')
        + g.panel.timeSeries.standardOptions.withUnit('KBs'),

      httpRequestServiceTime:
        g.panel.timeSeries.new('HTTP request service time')
        + g.panel.timeSeries.panelOptions.withDescription('HTTP request service time percentiles.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.overview.httpRequestsAll50.asTarget(),
          signals.overview.httpRequestsAll75.asTarget(),
          signals.overview.httpRequestsAll95.asTarget(),
        ])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineInterpolation('smooth')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never')
        + g.panel.timeSeries.standardOptions.withUnit('s'),

      cacheHitServiceTime:
        g.panel.timeSeries.new('Cache hit service time')
        + g.panel.timeSeries.panelOptions.withDescription('Cache hits service time percentiles.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.overview.cacheHits50.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
          signals.overview.cacheHits75.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
          signals.overview.cacheHits95.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineInterpolation('smooth')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never')
        + g.panel.timeSeries.standardOptions.withUnit('s'),

      cacheMissesServiceTime:
        g.panel.timeSeries.new('Cache misses service time')
        + g.panel.timeSeries.panelOptions.withDescription('Cache misses service time percentiles.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.overview.cacheMisses50.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
          signals.overview.cacheMisses75.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
          signals.overview.cacheMisses95.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineInterpolation('smooth')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never')
        + g.panel.timeSeries.standardOptions.withUnit('s'),

      // Server panels
      serverRequests:
        g.panel.timeSeries.new('Server requests')
        + g.panel.timeSeries.panelOptions.withDescription('The number of HTTP, FTP, and other server requests.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.overview.serverFTPRequests.asTarget()
          + g.query.prometheus.withInterval('2m')
          + g.query.prometheus.withIntervalFactor(2),
          signals.overview.serverHTTPRequests.asTarget()
          + g.query.prometheus.withInterval('2m')
          + g.query.prometheus.withIntervalFactor(2),
          signals.overview.serverOtherRequests.asTarget()
          + g.query.prometheus.withInterval('2m')
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineInterpolation('smooth')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never')
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

      serverRequestErrors:
        g.panel.timeSeries.new('Server request errors')
        + g.panel.timeSeries.panelOptions.withDescription('The number of HTTP, FTP, and other server request errors.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.overview.serverFTPErrors.asTarget()
          + g.query.prometheus.withInterval('2m')
          + g.query.prometheus.withIntervalFactor(2),
          signals.overview.serverHTTPErrors.asTarget()
          + g.query.prometheus.withInterval('2m')
          + g.query.prometheus.withIntervalFactor(2),
          signals.overview.serverOtherErrors.asTarget()
          + g.query.prometheus.withInterval('2m')
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineInterpolation('smooth')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never')
        + g.panel.timeSeries.standardOptions.withUnit('errors/s')
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

      serverRequestSentThroughput:
        g.panel.timeSeries.new('Server request sent throughput')
        + g.panel.timeSeries.panelOptions.withDescription('The number of HTTP, FTP, and other server sent throughput.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.overview.serverFTPSentThroughput.asTarget()
          + g.query.prometheus.withInterval('2m')
          + g.query.prometheus.withIntervalFactor(2),
          signals.overview.serverHTTPSentThroughput.asTarget()
          + g.query.prometheus.withInterval('2m')
          + g.query.prometheus.withIntervalFactor(2),
          signals.overview.serverOtherSentThroughput.asTarget()
          + g.query.prometheus.withInterval('2m')
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineInterpolation('smooth')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never')
        + g.panel.timeSeries.standardOptions.withUnit('KBs')
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

      serverObjectSwap:
        g.panel.timeSeries.new('Server object swap')
        + g.panel.timeSeries.panelOptions.withDescription('The number of objects read from disk and the number of objects saved to disk.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.overview.swapIns.asTarget()
          + g.query.prometheus.withInterval('2m')
          + g.query.prometheus.withIntervalFactor(2),
          signals.overview.swapOuts.asTarget()
          + g.query.prometheus.withInterval('2m')
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineInterpolation('smooth')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never')
        + g.panel.timeSeries.standardOptions.withUnit('cps')
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

      dnsLookupServiceTime:
        g.panel.timeSeries.new('DNS lookup service time')
        + g.panel.timeSeries.panelOptions.withDescription('DNS lookup service time percentiles')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.overview.dnsLookups50.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
          signals.overview.dnsLookups75.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
          signals.overview.dnsLookups95.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineInterpolation('smooth')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never')
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

      serverReceivedThroughput:
        g.panel.timeSeries.new('Server received throughput')
        + g.panel.timeSeries.panelOptions.withDescription('The number of HTTP, FTP, and other server throughput.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.overview.serverFTPReceivedThroughput.asTarget()
          + g.query.prometheus.withInterval('2m')
          + g.query.prometheus.withIntervalFactor(2),
          signals.overview.serverHTTPReceivedThroughput.asTarget()
          + g.query.prometheus.withInterval('2m')
          + g.query.prometheus.withIntervalFactor(2),
          signals.overview.serverOtherReceivedThroughput.asTarget()
          + g.query.prometheus.withInterval('2m')
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineInterpolation('smooth')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never')
        + g.panel.timeSeries.standardOptions.withUnit('KBs')
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),
    },
}
