local g = import './g.libsonnet';
{
  local link = g.dashboard.link,
  new(this):
    {
      veleroClusterOverview:
        link.link.new('Velero cluster overview', '/d/' + this.grafana.dashboards.clusterOverview.uid)
        + link.link.options.withKeepTime(true),
		}
		}
