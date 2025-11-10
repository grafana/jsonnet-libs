local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this): {
    local signals = this.signals,

    // Overview dashboard panels
    trafficByResponseCode:
      commonlib.panels.network.timeSeries.traffic.new(
        'Traffic by response code',
        targets=[signals.overview.httpRequests.asTarget()]
      )
      + g.panel.timeSeries.panelOptions.withDescription('Rate of HTTP traffic over time for the entire application. Grouped by response code.')
      + g.panel.timeSeries.standardOptions.withUnit('reqps'),

    activeRequests:
      commonlib.panels.network.timeSeries.traffic.new(
        'Active requests',
        targets=[signals.overview.activeRequests.asTarget()]
      )
      + g.panel.timeSeries.panelOptions.withDescription('Active web requests for the entire application')
      + g.panel.timeSeries.standardOptions.withUnit('reqps'),

    queuedRequests:
      commonlib.panels.network.timeSeries.traffic.new(
        'Queued requests',
        targets=[signals.overview.queuedRequests.asTarget()]
      )
      + g.panel.timeSeries.panelOptions.withDescription('Queued web requests for the entire application.')
      + g.panel.timeSeries.standardOptions.withUnit('reqps'),

    pageViews:
      commonlib.panels.network.timeSeries.traffic.new(
        'Page views',
        targets=[signals.overview.pageViews.asTarget()]
      )
      + g.panel.timeSeries.panelOptions.withDescription('Rate of pageviews for the entire application. Grouped by type and service.')
      + g.panel.timeSeries.standardOptions.withUnit('none'),

    latestMedianRequestTime:
      commonlib.panels.network.timeSeries.base.new('Latest median request time', targets=[signals.overview.latestMedianRequestTime.asTarget()])
      + g.panel.timeSeries.panelOptions.withDescription('The median amount of time for "latest" page requests for the selected site.')
      + g.panel.timeSeries.standardOptions.withUnit('s'),

    topicMedianRequestTime:
      commonlib.panels.network.timeSeries.base.new('Topic show median request time', targets=[signals.overview.topicMedianRequestTime.asTarget()])
      + g.panel.timeSeries.panelOptions.withDescription('The median amount of time for "topics show" requests for the selected site.')
      + g.panel.timeSeries.standardOptions.withUnit('s'),

    latest99thPercentileRequestTime:
      commonlib.panels.network.timeSeries.base.new('Latest 99th percentile request time', targets=[signals.overview.latest99thPercentileRequestTime.asTarget()])
      + g.panel.timeSeries.panelOptions.withDescription('The 99th percentile amount of time for "latest" page requests for the selected site.')
      + g.panel.timeSeries.standardOptions.withUnit('s'),

    topic99thPercentileRequestTime:
      commonlib.panels.network.timeSeries.base.new('Topic show 99th percentile request time', targets=[signals.overview.topic99thPercentileRequestTime.asTarget()])
      + g.panel.timeSeries.panelOptions.withDescription('The 99th percentile amount of time for "topics show" requests for the selected site.')
      + g.panel.timeSeries.standardOptions.withUnit('s'),

    // Jobs dashboard panels
    sidekiqJobDuration:
      commonlib.panels.generic.stat.base.new('Sidekiq job duration', targets=[signals.jobs.sidekiqJobDuration.asTarget()])
      + g.panel.stat.panelOptions.withDescription('Time spent in Sidekiq jobs broken out by job name.')
      + g.panel.stat.standardOptions.withUnit('s'),

    scheduledJobDuration:
      commonlib.panels.generic.stat.base.new('Scheduled job duration', targets=[signals.jobs.scheduledJobDuration.asTarget()])
      + g.panel.stat.panelOptions.withDescription('Time spent in scheduled jobs broken out by job name.')
      + g.panel.stat.standardOptions.withUnit('s'),

    sidekiqJobCount:
      commonlib.panels.generic.stat.info.new('Sidekiq jobs', targets=[signals.jobs.sidekiqJobCount.asTarget()])
      + g.panel.stat.panelOptions.withDescription('The amount of sidekiq jobs ran over an interval.')
      + g.panel.stat.standardOptions.withUnit('none'),

    scheduledJobCount:
      commonlib.panels.generic.timeSeries.base.new('Scheduled jobs', targets=[signals.jobs.scheduledJobCount.asTarget()])
      + g.panel.stat.panelOptions.withDescription('The number of scheduled jobs ran over an interval.')
      + g.panel.timeSeries.standardOptions.withUnit('none'),

    usedRSSMemory:
      commonlib.panels.generic.timeSeries.base.new('Used RSS memory', targets=[signals.jobs.rssMemory.asTarget()])
      + g.panel.timeSeries.panelOptions.withDescription('Total RSS Memory used by process. Broken up by pid.')
      + g.panel.timeSeries.standardOptions.withUnit('bytes'),

    v8HeapSize:
      commonlib.panels.generic.timeSeries.base.new('V8 heap size', targets=[signals.jobs.v8HeapSize.asTarget()])
      + g.panel.timeSeries.panelOptions.withDescription('Current heap size of V8 engine. Broken up by process type')
      + g.panel.timeSeries.standardOptions.withUnit('bytes'),

    sidekiqWorkers:
      commonlib.panels.generic.stat.base.new('Sidekiq workers', targets=[signals.jobs.sidekiqWorkerCount.asTarget()])
      + g.panel.stat.panelOptions.withDescription('Current number of Sidekiq Workers.')
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
      commonlib.panels.generic.stat.base.new('Web workers', targets=[signals.jobs.webWorkerCount.asTarget()])
      + g.panel.stat.panelOptions.withDescription('Current number of Web Workers.')
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
      commonlib.panels.generic.stat.base.new('Sidekiq queued', targets=[signals.jobs.sidekiqJobsEnqueued.asTarget()])
      + g.panel.stat.panelOptions.withDescription('Current number of jobs in Sidekiq queue.')
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
