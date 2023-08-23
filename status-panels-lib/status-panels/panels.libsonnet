local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

local stat = g.panel.stat;
function(
  statusPanelsTarget
)

  {
    local this = self,

    integrationStatusInit(targets, title='Integration Status')::
      stat.new(title)
      + stat.withTargets(targets),

    latestMetricReceivedInit(targets, title='Latest Metric Received')::
      stat.new(title)
      + stat.withTargets(targets),

    integrationVersionInit(targets, title='Integration Version')::
      stat.new(title)
      + stat.withTargets(targets),

    integrationStatusPanel: self.integrationStatusInit(statusPanelsTarget),
    latestMetricReceivedPanel: self.latestMetricReceivedInit(statusPanelsTarget),
    integrationVersionPanel: self.integrationVersionInit(statusPanelsTarget),

  }
