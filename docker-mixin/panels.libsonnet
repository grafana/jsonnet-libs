local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(this): {

    _totalReduceMixin::

      g.panel.timeSeries.queryOptions.transformation.withId('calculateField')
      + g.panel.timeSeries.queryOptions.transformation.withOptions(
        {
          mode: 'reduceRow',
          reduce: {
            reducer: 'sum',
          },
          replaceFields: true,
        }
      ),


    //overview
    containersCount:
      this.signals.machine.containersCount.asStat()
      + commonlib.panels.generic.stat.base.stylize(),
    imagesCount:
      this.signals.machine.imagesCount.asStat()
      + commonlib.panels.generic.stat.base.stylize(),

    cpuTotal:
      commonlib.panels.cpu.stat.usage.new('CPU usage', targets=[])
      + this.signals.machine.cpuUsage.asPanelMixin()
      + g.panel.timeSeries.queryOptions.withTransformations(self._totalReduceMixin),

    memoryUtilization:
      this.signals.machine.memoryUtilization.asStat()
      + commonlib.panels.memory.stat.usage.stylize()
      + g.panel.timeSeries.queryOptions.withTransformations(self._totalReduceMixin),
    memoryReserved:
      this.signals.machine.memoryReserved.asStat()
      + commonlib.panels.generic.stat.percentage.stylize()
      + g.panel.timeSeries.queryOptions.withTransformations(self._totalReduceMixin),

    // compute
    cpu:
      this.signals.container.cpuUsage.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withAxisSoftMax(1)
      + g.panel.timeSeries.standardOptions.withMin(0),

    memory:
      this.signals.container.memoryUsage.asTimeSeries()
      + commonlib.panels.memory.timeSeries.usageBytes.stylize()
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    network:
      commonlib.panels.network.timeSeries.traffic.new('Network traffic', targets=[])
      + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets()
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
      + this.signals.container.networkReceive.asPanelMixin()
      + this.signals.container.networkTransmit.asPanelMixin(),
    networkErrsAndDrops:
      commonlib.panels.network.timeSeries.errors.new(
        'Network errors and drops',
        targets=[]
      )
      + this.signals.container.networkDropsReceive.asPanelMixin()
      + this.signals.container.networkDropsTransmit.asPanelMixin()
      + this.signals.container.networkErrorsReceive.asPanelMixin()
      + this.signals.container.networkErrorsTransmit.asPanelMixin()
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),


    diskUsageBytes:
      commonlib.panels.disk.timeSeries.usage.new('Disk usage', targets=[])
      + this.signals.container.diskUsageBytes.asPanelMixin(),

    diskIO:
      commonlib.panels.generic.timeSeries.base.new(
        'Disk I/O',
        targets=[],
        description='The number of I/O requests per second for the device/volume.'
      )
      + this.signals.container.diskIO.asPanelMixin(),
  },
}
