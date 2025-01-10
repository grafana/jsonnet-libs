local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(signals):: {
    uptime:
      signals.system.uptime.asStat()
      + commonlib.panels.system.stat.uptime.stylize(),
    sysName:
      signals.system.sysName.asStat(),
  },
}
