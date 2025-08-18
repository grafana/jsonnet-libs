local g = import './g.libsonnet';

{
  local link = g.dashboard.link,
  new(this): {
    cloudflareZone:
      link.link.new('Zone overview', '/d/' + this.grafana.dashboards['cloudflare-zone-overview.json'].uid)
      + link.link.options.withKeepTime(true),
    cloudflareWorker:
      link.link.new('Worker overview', '/d/' + this.grafana.dashboards['cloudflare-worker-overview.json'].uid)
      + link.link.options.withKeepTime(true),
    cloudflareGeomap:
      link.link.new('Geographic overview', '/d/' + this.grafana.dashboards['cloudflare-geomap-overview.json'].uid)
      + link.link.options.withKeepTime(true),
    otherDashboards:
      link.dashboards.new('All dashboards', this.config.dashboardTags)
      + link.dashboards.options.withIncludeVars(true)
      + link.dashboards.options.withKeepTime(true)
      + link.dashboards.options.withAsDropdown(true),
  },
}
