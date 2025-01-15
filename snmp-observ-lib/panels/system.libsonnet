local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(signals, this):: {
    uptime:
      signals.system.uptime.asStat()
      + commonlib.panels.system.stat.uptime.stylize(),
    sysName:
      signals.system.sysName.asStat(),
    version:
      signals.system.version.asStat(),
  },
}
