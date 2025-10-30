local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this): {
    local signals = this.signals,

    // Overview dashboard panels
    trafficByResponseCode:
      g.panel.timeSeries.new('Traffic by Response Code')
      + g.panel.timeSeries.panelOptions.withDescription('Rate of HTTP traffic over time for the entire application. Grouped by response code.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.http.httpRequests.asTarget(),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('reqps'),

    activeRequests:
      g.panel.timeSeries.new('Active Requests')
      + g.panel.timeSeries.panelOptions.withDescription('Active web requests for the entire application')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.requests.activeRequests.asTarget(),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('reqps'),

    queuedRequests:
      g.panel.timeSeries.new('Queued Requests')
      + g.panel.timeSeries.panelOptions.withDescription('Queued web requests for the entire application.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.requests.queuedRequests.asTarget(),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('reqps'),

    pageViews:
      g.panel.timeSeries.new('Page Views')
      + g.panel.timeSeries.panelOptions.withDescription('Rate of pageviews for the entire application. Grouped by type and service.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.requests.pageViews.asTarget(),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('views/sec')
      + g.panel.timeSeries.standardOptions.withMappings([
        g.panel.timeSeries.standardOptions.mapping.SpecialValueMap.withType()
        + g.panel.timeSeries.standardOptions.mapping.SpecialValueMap.withOptions({
          match: 'null',
          result: { text: 'N/A' },
        }),
      ]),

    latestMedianRequestTime:
      g.panel.timeSeries.new('Latest Median Request Time')
      + g.panel.timeSeries.panelOptions.withDescription('The median amount of time for "latest" page requests for the selected site.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.http.latestMedianRequestTime.asTarget(),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('s'),

    topicMedianRequestTime:
      g.panel.timeSeries.new('Topic Show Median Request Time')
      + g.panel.timeSeries.panelOptions.withDescription('The median amount of time for "topics show" requests for the selected site.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.http.topicMedianRequestTime.asTarget(),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('s'),

    latest99thPercentileRequestTime:
      g.panel.timeSeries.new('Latest 99th percentile Request Time')
      + g.panel.timeSeries.panelOptions.withDescription('The 99th percentile amount of time for "latest" page requests for the selected site.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.http.latest99thPercentileRequestTime.asTarget(),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('s'),

    topic99thPercentileRequestTime:
      g.panel.timeSeries.new('Topic Show 99th percentile Request Time')
      + g.panel.timeSeries.panelOptions.withDescription('The 99th percentile amount of time for "topics show" requests for the selected site.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.http.topic99thPercentileRequestTime.asTarget(),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('s'),

    // Jobs dashboard panels
    sidekiqJobDuration:
      g.panel.timeSeries.new('Sidekiq Job Duration')
      + g.panel.timeSeries.panelOptions.withDescription('Time spent in Sidekiq jobs broken out by job name.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.jobs.sidekiqJobDuration.asTarget(),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('s')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(30)
      + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    scheduledJobDuration:
      g.panel.timeSeries.new('Scheduled Job Duration')
      + g.panel.timeSeries.panelOptions.withDescription('Time spent in scheduled jobs broken out by job name.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.jobs.scheduledJobDuration.asTarget(),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('s')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(30)
      + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    scheduledJobCount:
      g.panel.timeSeries.new('Scheduled Jobs')
      + g.panel.timeSeries.panelOptions.withDescription('The number of scheduled jobs ran over an interval.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.jobs.scheduledJobCount.asTarget(),
      ]),

    sidekiqJobCount:
      g.panel.timeSeries.new('Sidekiq Jobs')
      + g.panel.timeSeries.panelOptions.withDescription('The amount of sidekiq jobs ran over an interval.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.jobs.sidekiqJobCount.asTarget(),
      ]),

    usedRSSMemory:
      g.panel.timeSeries.new('Used RSS Memory')
      + g.panel.timeSeries.panelOptions.withDescription('Total RSS Memory used by process. Broken up by pid.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.memory.rssMemory.asTarget(),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('bytes'),

    v8HeapSize:
      g.panel.timeSeries.new('V8 Heap Size')
      + g.panel.timeSeries.panelOptions.withDescription('Current heap size of V8 engine. Broken up by process type')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.memory.v8HeapSize.asTarget(),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('bytes'),

    sidekiqWorkers:
      g.panel.stat.new('Sidekiq Workers')
      + g.panel.stat.panelOptions.withDescription('Current number of Sidekiq Workers.')
      + g.panel.stat.queryOptions.withTargets([
        signals.jobs.sidekiqWorkerCount.asTarget(),
      ])
      + g.panel.stat.standardOptions.withUnit('none')
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.standardOptions.withMappings([
        g.panel.stat.standardOptions.mapping.SpecialValueMap.withType()
        + g.panel.stat.standardOptions.mapping.SpecialValueMap.withOptions({
          match: 'null',
          result: { text: 'N/A' },
        }),
      ])
      + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
      + g.panel.stat.options.withGraphMode('none')
      + g.panel.stat.options.withTextMode('auto'),

    webWorkers:
      g.panel.stat.new('Web Workers')
      + g.panel.stat.panelOptions.withDescription('Current number of Web Workers.')
      + g.panel.stat.queryOptions.withTargets([
        signals.jobs.webWorkerCount.asTarget(),
      ])
      + g.panel.stat.standardOptions.withUnit('none')
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.standardOptions.withMappings([
        g.panel.stat.standardOptions.mapping.SpecialValueMap.withType()
        + g.panel.stat.standardOptions.mapping.SpecialValueMap.withOptions({
          match: 'null',
          result: { text: 'N/A' },
        }),
      ])
      + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
      + g.panel.stat.options.withGraphMode('none')
      + g.panel.stat.options.withTextMode('auto'),

    sidekiqQueued:
      g.panel.stat.new('Sidekiq Queued')
      + g.panel.stat.panelOptions.withDescription('Current number of jobs in Sidekiq queue.')
      + g.panel.stat.queryOptions.withTargets([
        signals.jobs.sidekiqJobsEnqueued.asTarget(),
      ])
      + g.panel.stat.standardOptions.withUnit('none')
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.standardOptions.withMappings([
        g.panel.stat.standardOptions.mapping.SpecialValueMap.withType()
        + g.panel.stat.standardOptions.mapping.SpecialValueMap.withOptions({
          match: 'null',
          result: { text: 'N/A' },
        }),
      ])
      + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
      + g.panel.stat.options.withGraphMode('none')
      + g.panel.stat.options.withTextMode('auto'),
  },
}
