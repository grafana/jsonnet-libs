local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this): {
    local signals = this.signals.instance,

    instanceCountStat:
      signals.instanceCount.asStat()
      + commonlib.panels.generic.stat.info.stylize(),

    cpuUsage:
      signals.cpuUsage.asTimeSeries()
      + commonlib.panels.cpu.timeSeries.utilization.stylize(),

    diskOperations:
      commonlib.panels.generic.timeSeries.base.new('Disk operations', targets=[])
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.queryOptions.withDatasource('prometheus', '${datasource}')
      + signals.diskReadOps.asPanelMixin()
      + signals.diskWriteOps.asPanelMixin()
      + g.panel.timeSeries.fieldConfig.defaults.custom.withAxisLabel('write(-) | read(+)')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withAxisCenteredZero(true)
      + g.panel.timeSeries.standardOptions.withOverrides(
        g.panel.timeSeries.fieldOverride.byRegexp.new('/write/')
        + g.panel.timeSeries.fieldOverride.byRegexp.withPropertiesFromOptions(
          g.panel.timeSeries.fieldConfig.defaults.custom.withTransform('negative-Y')
        )
      )
      + g.panel.timeSeries.panelOptions.withDescription('Disk read and write operations per second. Writes are shown on the negative y-axis.'),

    networkTraffic:
      commonlib.panels.network.timeSeries.traffic.new(
        'Network traffic',
        targets=[],
        description='Network receive and transmit rates. Transmit is shown on the negative y-axis.',
      )
      + g.panel.timeSeries.queryOptions.withDatasource('prometheus', '${datasource}')
      + signals.networkReceive.asPanelMixin()
      + signals.networkTransmit.asPanelMixin()
      + g.panel.timeSeries.standardOptions.withUnit('Bps'),

    bandwidthUsageStat:
      signals.bandwidthUsage.asStat()
      + commonlib.panels.generic.stat.percentage.stylize(),

    bandwidthUsed:
      commonlib.panels.generic.timeSeries.base.new('Bandwidth this billing period', targets=[])
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.queryOptions.withDatasource('prometheus', '${datasource}')
      + signals.bandwidthTransmitted.asPanelMixin()
      + signals.bandwidthReceived.asPanelMixin()
      + signals.bandwidthAllowed.asPanelMixin()
      + g.panel.timeSeries.panelOptions.withDescription('Bandwidth used in the current billing period compared with the allowance. The totals reset at the start of each billing period.'),

    gpuUtilization:
      signals.gpuUtilization.asTimeSeries()
      + commonlib.panels.generic.timeSeries.percentage.stylize(),

    gpuMemoryUsed:
      signals.gpuMemoryUsed.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),

    gpuTemperature:
      signals.gpuTemperature.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),

    gpuPower:
      signals.gpuPower.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),
  },
}
