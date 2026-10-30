local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(this, common): {
    local signals = this.signals,
    // The info preset resets reduceOptions, so select the label field after styling.
    local infoStat(signal, label) =
      signal.asStat()
      + commonlib.panels.generic.stat.info.stylize()
      + g.panel.stat.options.reduceOptions.withFields('/^%s$/' % label)
      + common.hostTextSize,

    alerts: common.alertsOverview.grafana.panels.alertsOverview,
    hostname: infoStat(signals.host.hostname, 'host_name'),
    osName: infoStat(signals.host.osName, 'os_name'),
    arch: infoStat(signals.host.arch, 'host_arch'),
    uptime:
      signals.host.uptime.asStat()
      + commonlib.panels.system.stat.uptime.stylize()
      + common.hostTextSize,
    cpuCount:
      signals.host.cpuCount.asStat()
      + commonlib.panels.cpu.stat.count.stylize()
      + common.capacityTextSize,
    cpuPhysicalCount:
      signals.host.cpuPhysicalCount.asStat()
      + commonlib.panels.cpu.stat.count.stylize()
      + common.capacityTextSize,
    processes:
      signals.host.processesRunning.asTimeSeries('Processes')
      + signals.host.processesCreated.asPanelMixin()
      + commonlib.panels.generic.timeSeries.base.stylize(),
    uptimeTs:
      signals.host.uptime.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + common.fleetLegend
      + common.drillDown,
  },
}
