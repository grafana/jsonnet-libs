local g = import './g.libsonnet';
local logslib = import 'logs-lib/logs/main.libsonnet';

{
  local root = self,
  new(this)::
    local prefix = this.config.dashboardNamePrefix;
    local links = this.grafana.links;
    local tags = this.config.dashboardTags;
    local uid = g.util.string.slugify(this.config.uid);
    local vars = this.grafana.variables;
    local annotations = this.grafana.annotations;
    local refresh = this.config.dashboardRefresh;
    local period = this.config.dashboardPeriod;
    local timezone = this.config.dashboardTimezone;

    {
      // Apache Airflow overview dashboard
      'apache-airflow-overview.json':
        g.dashboard.new(prefix + ' overview')
        + g.dashboard.withDescription('Dashboard providing an overview of Apache Airflow DAGs, tasks, and scheduler performance.')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.apacheAirflowOverview,
                this.grafana.rows.apacheAirflowSchedulerDetails,
              ]
            )
          )
        )
        + root.applyCommon(
          vars.multiInstance + [
            g.dashboard.variable.query.new('dag_id')
            + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.prometheus)
            + g.dashboard.variable.query.queryTypes.withLabelValues('dag_id', 'airflow_dagrun_duration_success_sum{job=~"$job", instance=~"$instance"}')
            + g.dashboard.variable.query.generalOptions.withLabel('DAG ID')
            + g.dashboard.variable.query.selectionOptions.withMulti(true)
            + g.dashboard.variable.query.selectionOptions.withIncludeAll(true, '.+')
            + g.dashboard.variable.query.refresh.onLoad()
            + g.dashboard.variable.query.refresh.onTime(),

            g.dashboard.variable.query.new('task_id')
            + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.prometheus)
            + g.dashboard.variable.query.queryTypes.withLabelValues('task_id', 'airflow_ti_failures{job=~"$job", instance=~"$instance"}')
            + g.dashboard.variable.query.generalOptions.withLabel('Task ID')
            + g.dashboard.variable.query.selectionOptions.withMulti(true)
            + g.dashboard.variable.query.selectionOptions.withIncludeAll(true, '.+')
            + g.dashboard.variable.query.refresh.onLoad()
            + g.dashboard.variable.query.refresh.onTime(),

            g.dashboard.variable.query.new('state')
            + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.prometheus)
            + g.dashboard.variable.query.queryTypes.withLabelValues('state', 'airflow_task_finish_total{job=~"$job", instance=~"$instance"}')
            + g.dashboard.variable.query.generalOptions.withLabel('State')
            + g.dashboard.variable.query.selectionOptions.withMulti(true)
            + g.dashboard.variable.query.selectionOptions.withIncludeAll(true, '.+')
            + g.dashboard.variable.query.refresh.onLoad()
            + g.dashboard.variable.query.refresh.onTime(),

            g.dashboard.variable.query.new('pool_name')
            + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.prometheus)
            + g.dashboard.variable.query.queryTypes.withLabelValues('pool_name', 'airflow_pool_running_slots{job=~"$job", instance=~"$instance"}')
            + g.dashboard.variable.query.generalOptions.withLabel('Pool name')
            + g.dashboard.variable.query.selectionOptions.withMulti(true)
            + g.dashboard.variable.query.selectionOptions.withIncludeAll(true, '.+')
            + g.dashboard.variable.query.refresh.onLoad()
            + g.dashboard.variable.query.refresh.onTime(),
          ],
          uid + '_overview',
          tags,
          links { apacheAirflowOverview+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),
    }
    +
    if this.config.enableLokiLogs then
      {
        'apache-airflow-logs.json':
          logslib.new(
            prefix + ' logs',
            datasourceName=vars.datasources.loki.name,
            datasourceRegex=vars.datasources.loki.regex,
            filterSelector=this.config.filteringSelector,
            labels=this.config.logLabels + this.config.extraLogLabels,
            formatParser=null,
            showLogsVolume=this.config.showLogsVolume,
            logsVolumeGroupBy=this.config.logsVolumeGroupBy,
            extraFilters=[]
          )
          {
            dashboards+:
              {
                logs+:
                  g.dashboard.withPanels(
                    g.util.panel.resolveCollapsedFlagOnRows(
                      g.util.grid.wrapPanels(
                        [
                          this.grafana.rows.apacheAirflowLogs,
                        ]
                      )
                    )
                  )
                  + root.applyCommon(
                    [],
                    uid + '_logs',
                    tags,
                    links { logs+:: {} },
                    annotations,
                    timezone,
                    refresh,
                    period
                  ),
              },
            variables+: {
              toArray+: [
                g.dashboard.variable.query.new('dag_file')
                + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.loki)
                + g.dashboard.variable.query.queryTypes.withLabelValues('filename', '{job=~"$job", instance=~"$instance"}')
                + g.dashboard.variable.query.generalOptions.withLabel('DAG file')
                + g.dashboard.variable.query.selectionOptions.withMulti(true)
                + g.dashboard.variable.query.selectionOptions.withIncludeAll(true, '.+')
                + g.dashboard.variable.query.refresh.onLoad()
                + g.dashboard.variable.query.refresh.onTime(),
              ],
            },
          }.dashboards.logs,
      } else {},

  applyCommon(vars, uid, tags, links, annotations, timezone, refresh, period):
    g.dashboard.withTags(tags)
    + g.dashboard.withUid(uid)
    + g.dashboard.withLinks(std.objectValues(links))
    + g.dashboard.withTimezone(timezone)
    + g.dashboard.withRefresh(refresh)
    + g.dashboard.time.withFrom(period)
    + g.dashboard.withVariables(vars)
    + g.dashboard.withAnnotations(std.objectValues(annotations)),
}
