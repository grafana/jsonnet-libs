local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this)::
    {
      local signals = this.signals,
      local barGauge = g.panel.barGauge,

      //
      // Overview Dashboard Panels
      //

      // Cache hit rate gauge
      cacheHitRatePanel:
        g.panel.gauge.new('Cache hit rate')
        + g.panel.gauge.queryOptions.withTargets([
          signals.cache.cacheHitRate.asTarget(),
        ])
        + g.panel.gauge.standardOptions.withUnit('percent')
        + g.panel.gauge.standardOptions.withMin(0)
        + g.panel.gauge.standardOptions.withMax(100)
        + g.panel.gauge.standardOptions.thresholds.withMode('absolute')
        + g.panel.gauge.standardOptions.thresholds.withSteps([
          g.panel.gauge.standardOptions.threshold.step.withColor('red')
          + g.panel.gauge.standardOptions.threshold.step.withValue(0),
          g.panel.gauge.standardOptions.threshold.step.withColor('#EAB839')
          + g.panel.gauge.standardOptions.threshold.step.withValue(50),
          g.panel.gauge.standardOptions.threshold.step.withColor('green')
          + g.panel.gauge.standardOptions.threshold.step.withValue(80),
        ])
        + g.panel.gauge.options.withOrientation('auto')
        + g.panel.gauge.options.withShowThresholdLabels(false)
        + g.panel.gauge.options.withShowThresholdMarkers(true)
        + g.panel.gauge.panelOptions.withDescription('Rate of cache hits to misses.')
        + g.panel.gauge.panelOptions.withTransparent(true),

      // Frontend requests stat
      frontendRequestsPanel:
        commonlib.panels.generic.stat.base.new(
          'Frontend requests',
          targets=[
            signals.requests.frontendRequests.asTarget(),
          ],
          description='The rate of requests sent to the Varnish Cache frontend.'
        )
        + g.panel.stat.standardOptions.withUnit('reqps')
        + g.panel.stat.panelOptions.withTransparent(true)
        + g.panel.stat.options.withGraphMode('none'),

      // Backend requests stat
      backendRequestsPanel:
        commonlib.panels.generic.stat.base.new(
          'Backend requests',
          targets=[
            signals.requests.backendRequests.asTarget(),
          ],
          description='The rate of requests sent to the Varnish Cache backends.'
        )
        + g.panel.stat.standardOptions.withUnit('reqps')
        + g.panel.stat.panelOptions.withTransparent(true)
        + g.panel.stat.options.withGraphMode('none'),

      // Sessions rate stat
      sessionsRatePanel:
        commonlib.panels.generic.stat.base.new(
          'Sessions rate',
          targets=[
            signals.sessions.sessionsRate.asTarget(),
          ],
          description='The rate of total sessions created in the Varnish Cache instance.'
        )
        + g.panel.stat.standardOptions.withUnit('/ sec')
        + g.panel.stat.panelOptions.withTransparent(true)
        + g.panel.stat.options.withGraphMode('none'),

      // Cache hits stat
      cacheHitsPanel:
        commonlib.panels.generic.stat.base.new(
          'Cache hits',
          targets=[
            signals.cache.cacheHits.asTarget(),
          ],
          description='The rate of cache hits.'
        )
        + g.panel.stat.standardOptions.withUnit('/ sec')
        + g.panel.stat.panelOptions.withTransparent(true)
        + g.panel.stat.options.withGraphMode('none'),

      // Cache hit pass stat
      cacheHitPassPanel:
        commonlib.panels.generic.stat.base.new(
          'Cache hit pass',
          targets=[
            signals.cache.cacheHitPass.asTarget(),
          ],
          description='Rate of cache hits for pass objects (fulfilled requests that are not cached).'
        )
        + g.panel.stat.standardOptions.withUnit('/ sec')
        + g.panel.stat.panelOptions.withTransparent(true),

      // Session queue length stat
      sessionQueueLengthPanel:
        commonlib.panels.generic.stat.base.new(
          'Session queue length',
          targets=[
            signals.sessions.sessionQueueLength.asTarget(),
          ],
          description='Length of session queue waiting for threads.'
        )
        + g.panel.stat.standardOptions.withUnit('none')
        + g.panel.stat.panelOptions.withTransparent(true)
        + g.panel.stat.options.withGraphMode('none'),

      // Thread pools stat
      poolsPanel:
        commonlib.panels.generic.stat.base.new(
          'Pools',
          targets=[
            signals.threads.threadPools.asTarget(),
          ],
          description='Number of thread pools.'
        )
        + g.panel.stat.standardOptions.withUnit('none')
        + g.panel.stat.panelOptions.withTransparent(true)
        + g.panel.stat.options.withGraphMode('none'),

      // Backend connections timeseries
      backendConnectionsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Backend connections',
          targets=[
            signals.backend.backendConnectionsAccepted.asTarget(),
            signals.backend.backendConnectionsRecycled.asTarget(),
            signals.backend.backendConnectionsReused.asTarget(),
            signals.backend.backendConnectionsBusy.asTarget(),
            signals.backend.backendConnectionsUnhealthy.asTarget(),
          ],
          description='Rate of recycled, reused, busy, unhealthy, and accepted backend connections by Varnish Cache.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('conn/s')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(20)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false)
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

      // Sessions timeseries
      sessionsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Sessions',
          targets=[
            signals.sessions.sessionsConnected.asTarget(),
            signals.sessions.sessionsQueued.asTarget(),
            signals.sessions.sessionsDropped.asTarget(),
          ],
          description='Rate of new connected, queued, and dropped sessions.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('sess/s')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(20)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      // Requests timeseries
      requestsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Requests',
          targets=[
            signals.requests.frontendRequestsTimeseries.asTarget(),
            signals.requests.backendRequestsTimeseries.asTarget(),
          ],
          description='Rate of frontend and backend requests received.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(20)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      // Cache hit ratio timeseries
      cacheHitRatioPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Cache hit ratio',
          targets=[
            signals.cache.cacheHitRatio.asTarget(),
          ],
          description='Ratio of cache hits to cache misses.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.standardOptions.withMax(100)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(20)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false)
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
        + g.panel.timeSeries.fieldConfig.defaults.custom.thresholdsStyle.withMode('area')
        + g.panel.timeSeries.standardOptions.thresholds.withMode('percentage')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.thresholdStep.withColor('transparent')
          + g.panel.timeSeries.thresholdStep.withValue(null),
          g.panel.timeSeries.thresholdStep.withColor('red')
          + g.panel.timeSeries.thresholdStep.withValue(0),
          g.panel.timeSeries.thresholdStep.withColor('yellow')
          + g.panel.timeSeries.thresholdStep.withValue(50),
          g.panel.timeSeries.thresholdStep.withColor('green')
          + g.panel.timeSeries.thresholdStep.withValue(80),
        ]),

      // Memory used timeseries
      memoryUsedPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Memory used',
          targets=[
            signals.memory.memoryUsed.asTarget(),
          ],
          description='Bytes allocated from Varnish Cache storage.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('decbytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(20)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false)
        + g.panel.timeSeries.options.legend.withCalcs(['min', 'mean', 'max'])
        + g.panel.timeSeries.options.legend.withDisplayMode('table'),

      // Cache events timeseries
      cacheEventsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Cache events',
          targets=[
            signals.cache.cacheExpired.asTarget(),
            signals.cache.cacheLruNuked.asTarget(),
          ],
          description='Rate of expired and LRU (least recently used) nuked objects.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ops')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(20)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false)
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
        + g.panel.timeSeries.options.legend.withCalcs(['min', 'mean', 'max'])
        + g.panel.timeSeries.options.legend.withDisplayMode('table'),

      // Network timeseries
      networkPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Network',
          targets=[
            signals.network.frontendResponseHeaderBytes.asTarget(),
            signals.network.frontendResponseBodyBytes.asTarget(),
            signals.network.backendResponseHeaderBytes.asTarget(),
            signals.network.backendResponseBodyBytes.asTarget(),
          ],
          description='Rate for the response bytes of header and body for frontend and backends.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('decbytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(20)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false)
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

      // Threads timeseries
      threadsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Threads',
          targets=[
            signals.threads.threadsFailed.asTarget() { interval: '2m' },
            signals.threads.threadsCreated.asTarget() { interval: '2m' },
            signals.threads.threadsLimited.asTarget() { interval: '2m' },
            signals.threads.threadsTotal.asTarget(),
          ],
          description='Number of failed, created, limited, and current threads.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),
    },
}
