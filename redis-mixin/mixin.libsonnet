local dashboard = import './dashboards/overview.libsonnet';

{
  _config:: {
    datasource: 'default',
  },

  grafanaDashboardFolder:: 'Redis',

  grafanaDashboards+:: {
    redis_overview: dashboard.new($._config.datasource),
  },
}
