local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this):
    {
      local signals = this.signals,

      masterUptimePanel:
        g.panel.stat.new('Master uptime')
        + g.panel.stat.queryOptions.withTargets(
          signals.master.masterUptime.asTarget()
        )
        + g.panel.stat.standardOptions.withUnit('s')
        + g.panel.stat.standardOptions.color.withMode('fixed')
        + g.panel.stat.standardOptions.color.withFixedColor('light-green')
        + g.panel.stat.options.withGraphMode('none')
        + g.panel.stat.panelOptions.withDescription('Master uptime in seconds'),
      cpusAvailablePanel:
        g.panel.stat.new('CPUS available')
        + g.panel.stat.queryOptions.withTargets(
          signals.master.cpusAvailable.asTarget()
        )
        + g.panel.stat.standardOptions.withUnit('none')
        + g.panel.stat.standardOptions.color.withMode('fixed')
        + g.panel.stat.standardOptions.color.withFixedColor('light-green')
        + g.panel.stat.options.withGraphMode('none')
        + g.panel.stat.panelOptions.withDescription('CPUs available in the cluster'),
      memoryAvailablePanel:
        g.panel.stat.new('Memory available')
        + g.panel.stat.queryOptions.withTargets(
          signals.master.memoryAvailable.asTarget()
        )
        + g.panel.stat.standardOptions.withUnit('bytes')
        + g.panel.stat.standardOptions.color.withMode('fixed')
        + g.panel.stat.standardOptions.color.withFixedColor('light-green')
        + g.panel.stat.options.withGraphMode('none')
        + g.panel.stat.panelOptions.withDescription('Memory available in the cluster'),
      gpusAvailablePanel:
        g.panel.stat.new('GPUs available')
        + g.panel.stat.queryOptions.withTargets(
          signals.master.gpusAvailable.asTarget()
        )
        + g.panel.stat.standardOptions.withUnit('none')
        + g.panel.stat.standardOptions.color.withMode('fixed')
        + g.panel.stat.standardOptions.color.withFixedColor('light-green')
        + g.panel.stat.options.withGraphMode('none')
        + g.panel.stat.panelOptions.withDescription('GPUs available in the cluster'),

      diskAvailablePanel:
        g.panel.stat.new('Disk available')
        + g.panel.stat.queryOptions.withTargets(
          signals.master.diskAvailable.asTarget()
        )
        + g.panel.stat.standardOptions.withUnit('bytes')
        + g.panel.stat.standardOptions.color.withMode('fixed')
        + g.panel.stat.standardOptions.color.withFixedColor('light-green')
        + g.panel.stat.options.withGraphMode('none')
        + g.panel.stat.panelOptions.withDescription('Disk available in the cluster'),

      memoryUtilizationPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Memory utilization',
          targets=[
            signals.master.memoryUtilization.asTarget(),
          ]
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.panelOptions.withDescription('Memory utilization in the cluster'),

      diskUtilizationPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Disk utilization',
          targets=[
            signals.master.diskUtilization.asTarget(),
          ]
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.panelOptions.withDescription('Disk utilization in the cluster'),

      eventsInQueuePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Events in queue',
          targets=[
            signals.master.eventsInQueue.asTarget(),
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Events in queue in the cluster'),

      messagesPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Messages',
          targets=[
            signals.master.messages.asTarget() { interval: '2m' },
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Messages in the cluster'),

      registrarStatePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Registrar state',
          targets=[
            signals.master.registrarStateStore.asTarget(),
            signals.master.registrarStateFetch.asTarget(),
          ]
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.panelOptions.withDescription('Registrar state store and fetch in the cluster'),

      registrarLogRecoveredPanel:
        g.panel.stat.new('Registrar log recovered')
        + g.panel.stat.queryOptions.withTargets(
          signals.master.registrarLogRecovered.asTarget()
        )
        + g.panel.stat.panelOptions.withDescription('Registrar log recovered in the cluster'),

      allocationRunsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Allocation runs',
          targets=[
            signals.master.allocationRuns.asTarget() { interval: '2m' },
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Allocation runs in the cluster'),

      allocationDurationPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Allocation duration',
          targets=[
            signals.master.allocationDuration.asTarget(),
          ]
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.panelOptions.withDescription('Allocation duration in the cluster'),

      allocationLatencyPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Allocation latency',
          targets=[
            signals.master.allocationLatency.asTarget(),
          ]
        )
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.panelOptions.withDescription('Allocation latency in the cluster'),

      eventQueueDispatchesPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Event queue dispatches',
          targets=[
            signals.master.eventQueueDispatches.asTarget(),
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Event queue dispatches in the cluster'),

      // Agent panels
      agentMemoryUtilizationPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Agent memory utilization',
          targets=[
            signals.agent.memoryUtilization.asTarget(),
          ]
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.panelOptions.withDescription('Memory utilization in the cluster'),

      agentDiskUtilizationPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Agent disk utilization',
          targets=[
            signals.agent.diskUtilization.asTarget(),
          ]
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.panelOptions.withDescription('The percentage of allocated disk storage in use by the agent.'),

    },
}
