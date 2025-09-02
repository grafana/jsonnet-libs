local cfg = import '../../config.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

// Create variables using common-lib - clean and simple!
commonlib.variables.new(
  filteringSelector=cfg._config.filteringSelector,
  groupLabels=cfg._config.groupLabels,
  instanceLabels=cfg._config.instanceLabels,
  varMetric='{__name__=~"otelcol_process_uptime.*"}',
  enableLokiLogs=false,
  customAllValue='.*',
  prometheusDatasourceName='datasource',
  prometheusDatasourceLabel='Data source',
  adHocEnabled=false,
)
