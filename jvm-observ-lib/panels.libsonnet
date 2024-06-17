local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(signals):: {

    memoryUsedHeapPercent:
      commonlib.panels.memory.stat.usage.new(
        'Memory used(heap)',
        targets=[
          // use asTarget only for proper datasource:
          signals.memory.memoryUsedHeap.asTarget()
          // actually override with new expression:
          + g.query.prometheus.withExpr(
            '(%s/%s) * 100' %
            [
              signals.memory.memoryUsedHeap.asPanelExpression(),
              signals.memory.memoryMaxHeap.asPanelExpression(),
            ]
          ),
        ]
      ),
    memoryUsedNonHeapPercent:
      commonlib.panels.memory.stat.usage.new(
        'Memory used(nonheap)',
        targets=[
          // use asTarget only for proper datasource:
          signals.memory.memoryUsedNonHeap.asTarget()
          // actually override with new expression:
          + g.query.prometheus.withExpr(
            '(%s/%s) * 100' %
            [
              signals.memory.memoryUsedNonHeap.asPanelExpression(),
              signals.memory.memoryMaxNonHeap.asPanelExpression(),
            ]
          ),
        ]
      ),

    memoryUsedHeap:
      signals.memory.memoryUsedHeap.asTimeSeries()
      + commonlib.panels.memory.timeSeries.usageBytes.stylize(totalRegexp='/.*max.*/')
      + signals.memory.memoryMaxHeap.asPanelMixin()
      + signals.memory.memoryCommittedHeap.asPanelMixin(),
    memoryUsedNonHeap:
      signals.memory.memoryUsedNonHeap.asTimeSeries()
      + commonlib.panels.memory.timeSeries.usageBytes.stylize(totalRegexp='/.*max.*/')
      + signals.memory.memoryMaxNonHeap.asPanelMixin()
      + signals.memory.memoryCommittedNonHeap.asPanelMixin(),

    // GCmem
    memoryUsedEden:
      signals.gc.memoryUsedEden.asTimeSeries()
      + commonlib.panels.memory.timeSeries.usageBytes.stylize(totalRegexp='/.*max.*/')
      + signals.gc.memoryMaxEden.asPanelMixin()
      + signals.gc.memoryCommittedEden.asPanelMixin(),
    memoryUsedSurvival:
      signals.gc.memoryUsedSurvival.asTimeSeries()
      + commonlib.panels.memory.timeSeries.usageBytes.stylize(totalRegexp='/.*max.*/')
      + signals.gc.memoryMaxSurvival.asPanelMixin()
      + signals.gc.memoryCommittedSurvival.asPanelMixin(),
    memoryUsedTenured:
      signals.gc.memoryUsedTenured.asTimeSeries()
      + commonlib.panels.memory.timeSeries.usageBytes.stylize(totalRegexp='/.*max.*/')
      + signals.gc.memoryMaxTenured.asPanelMixin()
      + signals.gc.memoryCommittedTenured.asPanelMixin(),

    // GC
    gc:
      signals.gc.collections.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),

    gcDuration:
      g.panel.timeSeries.new('GC duration')
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
      + signals.gc.collectionsTimeAvg.asPanelMixin()
      + signals.gc.collectionsTimeMax.asPanelMixin()
      + signals.gc.collectionsTimeP95.asPanelMixin(),

    promotedAllocated:
      g.panel.timeSeries.new('Allocated/promoted')
      + commonlib.panels.memory.timeSeries.usageBytes.stylize()
      + signals.gc.memAllocatedBytes.asPanelMixin()
      + signals.gc.memAllocated.asPanelMixin()
      + signals.gc.memPromotedBytes.asPanelMixin(),

    // threads
    threadsOverviewStat:
      signals.threads.threads.asStat()
      + commonlib.panels.generic.stat.base.stylize(),

    threadsOverviewTS:
      signals.threads.threads.asTimeSeries()
      + signals.threads.threadsDaemon.asPanelMixin()
      + signals.threads.threadsPeak.asPanelMixin()
      + commonlib.panels.generic.timeSeries.threshold.stylizeByRegexp('.*peak.*')
      + signals.threads.threadsDeadlocked.asPanelMixin()
      + commonlib.panels.generic.timeSeries.base.stylize(),

    threadStates:
      signals.threads.threadStates.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),


    // classes
    classesLoaded:
      signals.classes.classesLoaded.asStat()
      + commonlib.panels.generic.stat.base.stylize(),

    // buffers
    directBuffer:
      signals.buffers.directBufferUsed.asTimeSeries()
      + signals.buffers.directBufferCapacity.asPanelMixin()
      + commonlib.panels.memory.timeSeries.usageBytes.stylize(totalRegexp='.*capacity.*'),

    mappedBuffer:
      signals.buffers.mappedBufferUsed.asTimeSeries()
      + signals.buffers.mappedBufferCapacity.asPanelMixin()
      + commonlib.panels.memory.timeSeries.usageBytes.stylize(totalRegexp='.*capacity.*'),

    // logback
    logs:
      signals.logback.events.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),

    // hikari
    hikariConnections:
      signals.hikari.connections.asStat()
      + commonlib.panels.generic.stat.base.stylize(),
    hikariTimeouts:
      signals.hikari.timeouts.asStat()
      + commonlib.panels.generic.stat.base.stylize(),
    hikariConnectionsStates:
      signals.hikari.connectionsActive.asTimeSeries()
      + signals.hikari.connectionsIdle.asPanelMixin()
      + signals.hikari.connectionsPending.asPanelMixin()
      + commonlib.panels.generic.timeSeries.base.stylize(),
    hikariConnectionsCreate:
      g.panel.timeSeries.new('Connection create duration')
      + signals.hikari.connectionsCreationDurationP95.asPanelMixin()
      + signals.hikari.connectionsCreationDurationAvg.asPanelMixin()
      + commonlib.panels.requests.timeSeries.duration.stylize(),
    hikariConnectionsUsage:
      g.panel.timeSeries.new('Connection create duration')
      + signals.hikari.connectionsUsageDurationP95.asPanelMixin()
      + signals.hikari.connectionsUsageDurationAvg.asPanelMixin()
      + commonlib.panels.requests.timeSeries.duration.stylize(),
    hikariConnectionsAcquire:
      g.panel.timeSeries.new('Connection acquire duration')
      + signals.hikari.connectionsAcquireDurationP95.asPanelMixin()
      + signals.hikari.connectionsAcquireDurationAvg.asPanelMixin()
      + commonlib.panels.requests.timeSeries.duration.stylize(),
  },
}
