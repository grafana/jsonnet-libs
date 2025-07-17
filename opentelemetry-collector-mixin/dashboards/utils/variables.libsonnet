local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local variable = g.dashboard.variable;
local cfg = import '../../config.libsonnet';

{
  datasourceVariable:
    variable.datasource.new('datasource', 'prometheus')
    + variable.datasource.generalOptions.withLabel('Data source')
    + variable.datasource.generalOptions.withCurrent(cfg._config.datasourceName)
    + variable.datasource.generalOptions.showOnDashboard.withLabelAndValue(),

  clusterVariable:
    variable.query.new('cluster')
    + variable.query.generalOptions.withLabel('Cluster')
    + variable.query.withDatasourceFromVariable(self.datasourceVariable)
    + variable.query.refresh.onTime()
    + variable.query.withSort(type='alphabetical', asc=false)
    + variable.query.selectionOptions.withIncludeAll(true, '.*')
    + variable.query.selectionOptions.withMulti(true)
    + variable.query.queryTypes.withLabelValues('cluster', metric='{__name__=~"otelcol_process_uptime.*"}'),

  namespaceVariable:
    variable.query.new('namespace')
    + variable.query.generalOptions.withLabel('Namespace')
    + variable.query.withDatasourceFromVariable(self.datasourceVariable)
    + variable.query.refresh.onTime()
    + variable.query.withSort(type='alphabetical', asc=false)
    + variable.query.selectionOptions.withIncludeAll(true, '.*')
    + variable.query.selectionOptions.withMulti(true)
    + variable.query.queryTypes.withLabelValues('namespace', metric='{__name__=~"otelcol_process_uptime.*"}'),

  jobVariable:
    variable.query.new('job')
    + variable.query.generalOptions.withLabel('Job')
    + variable.query.withDatasourceFromVariable(self.datasourceVariable)
    + variable.query.refresh.onTime()
    + variable.query.withSort(type='alphabetical', asc=false)
    + variable.query.selectionOptions.withIncludeAll(true, '.*')
    + variable.query.selectionOptions.withMulti(true)
    + variable.query.queryTypes.withLabelValues('job', metric='{__name__=~"otelcol_process_uptime.*"}'),

  instanceVariable:
    variable.query.new('instance')
    + variable.query.generalOptions.withLabel('Instance')
    + variable.query.withDatasourceFromVariable(self.datasourceVariable)
    + variable.query.refresh.onTime()
    + variable.query.withSort(type='alphabetical', asc=false)
    + variable.query.selectionOptions.withIncludeAll(true, '.*')
    + variable.query.selectionOptions.withMulti(true)
    + variable.query.queryTypes.withLabelValues('instance', metric='{__name__=~"otelcol_process_uptime.*"}'),
}
