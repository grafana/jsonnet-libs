local g = import './g.libsonnet';

{
  local link = g.dashboard.link,

  new(this):
    {
      overview:
        link.link.new(this.config.dashboardNamePrefix + 'distributed cluster metrics', '/d/' + this.grafana.dashboards['minio-dashboardv1.json'].uid)
        + link.link.options.withKeepTime(true)
        + link.link.options.withIncludeVars(true),
    },
}
