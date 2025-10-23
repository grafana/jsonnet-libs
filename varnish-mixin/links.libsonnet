local g = import './g.libsonnet';

{
  new(this):: {
    varnishOverview:
      g.dashboard.link.link.new('Varnish overview', '/d/' + this.grafana.dashboards['varnish-overview.json'].uid)
      + g.dashboard.link.link.options.withTargetBlank(true),
  } + if this.config.enableLokiLogs then {
    logs:
      g.dashboard.link.link.new('Varnish logs', '/d/' + this.grafana.dashboards['varnish-logs.json'].uid)
      + g.dashboard.link.link.options.withTargetBlank(true),
  } else {},
}
