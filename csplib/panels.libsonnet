local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(this): {
    objectCountTotal:
      this.signals.blobstore.objectCountTotal.asStat()
      + commonlib.panels.generic.stat.base.stylize(),
    totalBytesTotal:
      this.signals.blobstore.totalBytesTotal.asStat()
      + commonlib.panels.generic.stat.base.stylize(),
  }
}