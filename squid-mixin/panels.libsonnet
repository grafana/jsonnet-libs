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
          signals.client.clientHTTPRequests.asTarget()
          + g.query.prometheus.withInterval('2m')
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('reqps'),

      clientRequestErrors:
        g.panel.timeSeries.new('Client request errors')
        + g.panel.timeSeries.panelOptions.withDescription('The number of client HTTP errors.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.client.clientHTTPErrors.asTarget()
          + g.query.prometheus.withInterval('2m')
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('errors/s'),

      clientCacheHitRatio:
        g.panel.timeSeries.new('Client cache hit ratio')
        + g.panel.timeSeries.panelOptions.withDescription('The client cache hit ratio.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.client.clientCacheHitRatio.asTarget()
          + g.query.prometheus.withInterval('2m')
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      clientRequestSentThroughput:
        g.panel.timeSeries.new('Client request sent throughput')
        + g.panel.timeSeries.panelOptions.withDescription('The throughput of client HTTP data sent.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.client.clientHTTPSentThroughput.asTarget()
          + g.query.prometheus.withInterval('2m')
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('KBs'),

      clientHTTPReceivedThroughput:
        g.panel.timeSeries.new('Client HTTP received throughput')
        + g.panel.timeSeries.panelOptions.withDescription('The throughput of client HTTP data received.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.client.clientHTTPReceivedThroughput.asTarget()
          + g.query.prometheus.withInterval('2m')
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('KBs'),

      clientCacheHitThroughput:
        g.panel.timeSeries.new('Client cache hit throughput')
        + g.panel.timeSeries.panelOptions.withDescription('The throughput of client cache hit.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.client.clientCacheHitThroughput.asTarget()
          + g.query.prometheus.withInterval('2m')
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('KBs'),

      httpRequestServiceTime:
        g.panel.timeSeries.new('HTTP request service time')
        + g.panel.timeSeries.panelOptions.withDescription('HTTP request service time percentiles.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.client.httpRequestsAll50.asTarget(),
          signals.client.httpRequestsAll75.asTarget(),
          signals.client.httpRequestsAll95.asTarget(),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('s'),

      cacheHitServiceTime:
        g.panel.timeSeries.new('Cache hit service time')
        + g.panel.timeSeries.panelOptions.withDescription('Cache hits service time percentiles.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.client.cacheHits50.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
          signals.client.cacheHits75.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
          signals.client.cacheHits95.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('s'),

      cacheMissesServiceTime:
        g.panel.timeSeries.new('Cache misses service time')
        + g.panel.timeSeries.panelOptions.withDescription('Cache misses service time percentiles.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.client.cacheMisses50.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
          signals.client.cacheMisses75.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
          signals.client.cacheMisses95.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('s'),

      // Server panels
      serverRequests:
        g.panel.timeSeries.new('Server requests')
        + g.panel.timeSeries.panelOptions.withDescription('The number of HTTP, FTP, and other server requests.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.client.serverFTPRequests.asTarget()
          + g.query.prometheus.withInterval('2m')
          + g.query.prometheus.withIntervalFactor(2),
          signals.client.serverHTTPRequests.asTarget()
          + g.query.prometheus.withInterval('2m')
          + g.query.prometheus.withIntervalFactor(2),
          signals.client.serverOtherRequests.asTarget()
          + g.query.prometheus.withInterval('2m')
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

      serverRequestErrors:
        g.panel.timeSeries.new('Server request errors')
        + g.panel.timeSeries.panelOptions.withDescription('The number of HTTP, FTP, and other server request errors.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.client.serverFTPErrors.asTarget(),
          signals.client.serverHTTPErrors.asTarget(),
          signals.client.serverOtherErrors.asTarget(),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('errors/s')
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

      serverRequestSentThroughput:
        g.panel.timeSeries.new('Server request sent throughput')
        + g.panel.timeSeries.panelOptions.withDescription('The number of HTTP, FTP, and other server sent throughput.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.client.serverFTPSentThroughput.asTarget()
          + g.query.prometheus.withInterval('2m')
          + g.query.prometheus.withIntervalFactor(2),
          signals.client.serverHTTPSentThroughput.asTarget()
          + g.query.prometheus.withInterval('2m')
          + g.query.prometheus.withIntervalFactor(2),
          signals.client.serverOtherSentThroughput.asTarget()
          + g.query.prometheus.withInterval('2m')
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('KBs')
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

      serverObjectSwap:
        g.panel.timeSeries.new('Server object swap')
        + g.panel.timeSeries.panelOptions.withDescription('The number of objects read from disk and the number of objects saved to disk.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.client.swapIns.asTarget()
          + g.query.prometheus.withInterval('2m')
          + g.query.prometheus.withIntervalFactor(2),
          signals.client.swapOuts.asTarget()
          + g.query.prometheus.withInterval('2m')
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('cps')
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

      dnsLookupServiceTime:
        g.panel.timeSeries.new('DNS lookup service time')
        + g.panel.timeSeries.panelOptions.withDescription('DNS lookup service time percentiles')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.client.dnsLookups50.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
          signals.client.dnsLookups75.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
          signals.client.dnsLookups95.asTarget()
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

      serverReceivedThroughput:
        g.panel.timeSeries.new('Server received throughput')
        + g.panel.timeSeries.panelOptions.withDescription('The number of HTTP, FTP, and other server throughput.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.client.serverFTPReceivedThroughput.asTarget()
          + g.query.prometheus.withInterval('2m')
          + g.query.prometheus.withIntervalFactor(2),
          signals.client.serverHTTPReceivedThroughput.asTarget()
          + g.query.prometheus.withInterval('2m')
          + g.query.prometheus.withIntervalFactor(2),
          signals.client.serverOtherReceivedThroughput.asTarget()
          + g.query.prometheus.withInterval('2m')
          + g.query.prometheus.withIntervalFactor(2),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('KBs')
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

      // Logs panels
      // cacheLogs:
      //   g.panel.logs.new('Cache logs')
      //   + g.panel.logs.panelOptions.withDescription('The log file that contains the debug and error messages that Squid generates.')
      //   + g.panel.logs.queryOptions.withTargets([
      //     g.query.loki.new(
      //       '${loki_datasource}',
      //       '{' + this.config.filteringSelector + '} |= `` | (filename="/var/log/squid/cache.log" or log_type="cache")'
      //     ),
      //   ])
      //   + g.panel.logs.options.withEnableLogDetails(true)
      //   + g.panel.logs.options.withShowCommonLabels(false)
      //   + g.panel.logs.options.withShowTime(false)
      //   + g.panel.logs.options.withWrapLogMessage(false),

      // accessLogs:
      //   g.panel.logs.new('Access logs')
      //   + g.panel.logs.panelOptions.withDescription('The log file that contains a record of all HTTP requests and responses processed by the Squid proxy server.')
      //   + g.panel.logs.queryOptions.withTargets([
      //     g.query.loki.new(
      //       '${loki_datasource}',
      //       '{' + this.config.filteringSelector + '} |= `` | (filename="/var/log/squid/access.log" or log_type="access")'
      //     ),
      //   ])
      //   + g.panel.logs.options.withEnableLogDetails(true)
      //   + g.panel.logs.options.withShowCommonLabels(false)
      //   + g.panel.logs.options.withShowTime(false)
      //   + g.panel.logs.options.withWrapLogMessage(false),
    },
}
