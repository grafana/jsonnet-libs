local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this):
    {
      local signals = this.signals,

      // Client panels
      clientRequests:
        commonlib.panels.generic.timeSeries.base.new(
          'Client requests',
          targets=[signals.overview.clientHTTPRequests.asTarget() { interval: '2m', intervalFactor: 2 }],
          description='The request rate of client.'
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.standardOptions.withUnit('reqps'),

      clientRequestErrors:
        commonlib.panels.generic.timeSeries.base.new(
          'Client request errors',
          targets=[signals.overview.clientHTTPErrors.asTarget() { interval: '2m', intervalFactor: 2 }],
          description='The number of client HTTP errors.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('errors/s'),

      clientCacheHitRatio:
        commonlib.panels.generic.timeSeries.base.new(
          'Client cache hit ratio',
          targets=[signals.overview.clientCacheHitRatio.asTarget() { interval: '2m', intervalFactor: 2 }],
          description='The client cache hit ratio.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      clientRequestSentThroughput:
        commonlib.panels.generic.timeSeries.base.new(
          'Client request sent throughput',
          targets=[signals.overview.clientHTTPSentThroughput.asTarget() { interval: '2m', intervalFactor: 2 }],
          description='The throughput of client HTTP data sent.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('KBs'),

      clientHTTPReceivedThroughput:
        commonlib.panels.generic.timeSeries.base.new(
          'Client HTTP received throughput',
          targets=[signals.overview.clientHTTPReceivedThroughput.asTarget() { interval: '2m', intervalFactor: 2 }],
          description='The throughput of client HTTP data received.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('KBs'),

      clientCacheHitThroughput:
        commonlib.panels.generic.timeSeries.base.new(
          'Client cache hit throughput',
          targets=[signals.overview.clientCacheHitThroughput.asTarget() { interval: '2m', intervalFactor: 2 }],
          description='The throughput of client cache hit.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('KBs'),

      httpRequestServiceTime:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP request service time',
          targets=[
            signals.overview.httpRequestsAll50.asTarget(),
            signals.overview.httpRequestsAll75.asTarget(),
            signals.overview.httpRequestsAll95.asTarget(),
          ],
          description='HTTP request service time percentiles.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('s'),

      cacheHitServiceTime:
        commonlib.panels.generic.timeSeries.base.new(
          'Cache hit service time',
          targets=[
            signals.overview.cacheHits50.asTarget() { intervalFactor: 2 },
            signals.overview.cacheHits75.asTarget() { intervalFactor: 2 },
            signals.overview.cacheHits95.asTarget() { intervalFactor: 2 },
          ],
          description='Cache hits service time percentiles.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('s'),

      cacheMissesServiceTime:
        commonlib.panels.generic.timeSeries.base.new(
          'Cache misses service time',
          targets=[
            signals.overview.cacheMisses50.asTarget() { intervalFactor: 2 },
            signals.overview.cacheMisses75.asTarget() { intervalFactor: 2 },
            signals.overview.cacheMisses95.asTarget() { intervalFactor: 2 },
          ],
          description='Cache misses service time percentiles.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('s'),

      // Server panels
      serverRequests:
        commonlib.panels.generic.timeSeries.base.new(
          'Server requests',
          targets=[
            signals.overview.serverFTPRequests.asTarget() { interval: '2m', intervalFactor: 2 },
            signals.overview.serverHTTPRequests.asTarget() { interval: '2m', intervalFactor: 2 },
            signals.overview.serverOtherRequests.asTarget() { interval: '2m', intervalFactor: 2 },
          ],
          description='The number of HTTP, FTP, and other server requests.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

      serverRequestErrors:
        commonlib.panels.generic.timeSeries.base.new(
          'Server request errors',
          targets=[
            signals.overview.serverFTPErrors.asTarget() { interval: '2m', intervalFactor: 2 },
            signals.overview.serverHTTPErrors.asTarget() { interval: '2m', intervalFactor: 2 },
            signals.overview.serverOtherErrors.asTarget() { interval: '2m', intervalFactor: 2 },
          ],
          description='The number of HTTP, FTP, and other server request errors.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('errors/s')
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

      serverRequestSentThroughput:
        commonlib.panels.generic.timeSeries.base.new(
          'Server request sent throughput',
          targets=[
            signals.overview.serverFTPSentThroughput.asTarget() { interval: '2m', intervalFactor: 2 },
            signals.overview.serverHTTPSentThroughput.asTarget() { interval: '2m', intervalFactor: 2 },
            signals.overview.serverOtherSentThroughput.asTarget() { interval: '2m', intervalFactor: 2 },
          ],
          description='The number of HTTP, FTP, and other server sent throughput.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('KBs')
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

      serverObjectSwap:
        commonlib.panels.generic.timeSeries.base.new(
          'Server object swap',
          targets=[
            signals.overview.swapIns.asTarget() { interval: '2m', intervalFactor: 2 },
            signals.overview.swapOuts.asTarget() { interval: '2m', intervalFactor: 2 },
          ],
          description='The number of objects read from disk and the number of objects saved to disk.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('cps')
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

      dnsLookupServiceTime:
        commonlib.panels.generic.timeSeries.base.new(
          'DNS lookup service time',
          targets=[
            signals.overview.dnsLookups50.asTarget() { intervalFactor: 2 },
            signals.overview.dnsLookups75.asTarget() { intervalFactor: 2 },
            signals.overview.dnsLookups95.asTarget() { intervalFactor: 2 },
          ],
          description='DNS lookup service time percentiles'
        )
        + g.panel.timeSeries.standardOptions.withUnit('s'),
      // NOTE: Removed stacking.withMode('normal') - percentiles should not be stacked!

      serverReceivedThroughput:
        commonlib.panels.generic.timeSeries.base.new(
          'Server received throughput',
          targets=[
            signals.overview.serverFTPReceivedThroughput.asTarget() { interval: '2m', intervalFactor: 2 },
            signals.overview.serverHTTPReceivedThroughput.asTarget() { interval: '2m', intervalFactor: 2 },
            signals.overview.serverOtherReceivedThroughput.asTarget() { interval: '2m', intervalFactor: 2 },
          ],
          description='The number of HTTP, FTP, and other server throughput.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('KBs')
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),
    },
}
