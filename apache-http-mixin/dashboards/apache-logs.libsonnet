local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local template = grafana.template;
local dashboardUid = 'apache-http-logs';
local matcher = 'job=~"$job", instance=~"$instance"';

{
  grafanaDashboards+::

    if $._config.enableLokiLogs then {
      'apache-http-logs.json':
        dashboard.new(
          'Apache HTTP server logs',
          time_from='%s' % $._config.dashboardPeriod,
          editable=false,
          tags=($._config.dashboardTags),
          timezone='%s' % $._config.dashboardTimezone,
          refresh='%s' % $._config.dashboardRefresh,
          uid=dashboardUid,
        )
        .addLink(grafana.link.dashboards(
          asDropdown=false,
          title='Other Apache HTTP dashboards',
          includeVars=true,
          keepTime=true,
          tags=($._config.dashboardTags),
        ))
        .addTemplates(
          [
            {
              hide: 0,
              label: 'Data source',
              name: 'prometheus_datasource',
              query: 'prometheus',
              refresh: 1,
              regex: '',
              type: 'datasource',
            },
            template.new(
              name='job',
              label='job',
              datasource='$prometheus_datasource',
              query='label_values(apache_up, job)',
              current='',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=1
            ),
            template.new(
              name='instance',
              label='instance',
              datasource='$prometheus_datasource',
              query='label_values(apache_up{job=~"$job"}, instance)',
              current='',
              refresh=2,
              includeAll=false,
              sort=1
            ),
          ]
        ),
    } else {},
}
