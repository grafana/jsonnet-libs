local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this):
    {
      overview: {
        asString(): '/d/' + this.config.uid + '-overview',
        asDashboardLink(): g.dashboard.link.link.new('Squid overview', self.asString())
                           + g.dashboard.link.link.options.withKeepTime(true),
      },
    },
}
