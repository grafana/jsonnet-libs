local cfg = import '../../config.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

commonlib.variables.new(
  filteringSelector=cfg._config.filteringSelector,
  groupLabels=cfg._config.groupLabels,
  instanceLabels=cfg._config.instanceLabels,
  varMetric='otelcol_process_uptime',
  enableLokiLogs=false,
  customAllValue='.*',
  prometheusDatasourceName='datasource',
  prometheusDatasourceLabel='Data source',
  adHocEnabled=false,
)
