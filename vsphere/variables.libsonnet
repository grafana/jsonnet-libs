local g = import './g.libsonnet';
local var = g.dashboard.variable;
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;

// Generates chained variables to use on on all dashboards
{
  new(this, varMetric):
    {
      local filteringSelector = this.config.filteringSelector,
      local groupLabels = this.config.groupLabels,
      local instanceLabels = this.config.instanceLabels,
      local hostLabels = this.config.hostLabels,
      local resourcePoolLabels = this.config.resourcePoolLabels,
      local virtualMachineLabels = this.config.virtualMachineLabels,
      local varMetric = 'vcenter_vm_network_throughput_bytes_per_sec',
      local topClusterSelector =
        var.custom.new(
          'top_cluster_count',
          values=[2, 4, 6, 8, 10],
        )
        + var.custom.generalOptions.withDescription(
          'This variable allows for modification of top cluster value.'
        )
        + var.custom.generalOptions.withLabel('Top cluster count'),
      local root = self,
      local variablesFromLabels(groupLabels, instanceLabels, filteringSelector, multiInstance=true) =
        local chainVarProto(index, chainVar) =
          var.query.new(chainVar.label)
          + var.query.withDatasourceFromVariable(root.datasources.prometheus)
          + var.query.queryTypes.withLabelValues(
            chainVar.label,
            '%s{%s}' % [varMetric, chainVar.chainSelector],
          )
          + var.query.generalOptions.withLabel(utils.toSentenceCase(chainVar.label))
          + var.query.selectionOptions.withIncludeAll(
            value=if (!multiInstance && std.member(instanceLabels, chainVar.label)) then false else true,
            customAllValue='.+'
          )
          + var.query.selectionOptions.withMulti(
            if (!multiInstance && std.member(instanceLabels, chainVar.label)) then false else true,
          )
          + var.query.refresh.onTime()
          + var.query.withSort(
            i=1,
            type='alphabetical',
            asc=true,
            caseInsensitive=false
          );
        std.mapWithIndex(chainVarProto, utils.chainLabels(groupLabels + instanceLabels, [filteringSelector])),
      datasources: {
        prometheus:
          var.datasource.new('prometheus_datasource', 'prometheus')
          + var.datasource.generalOptions.withLabel('Data source')
          + var.datasource.withRegex(''),
        loki:
          var.datasource.new('loki_datasource', 'loki')
          + var.datasource.generalOptions.withLabel('Loki data source')
          + var.datasource.withRegex('(?!grafanacloud.+usage-insights|grafanacloud.+alert-state-history).+')
          + var.datasource.generalOptions.showOnDashboard.withNothing(),
      },

      // Use on dashboards where multiple entities can be selected, like fleet dashboards
      multiInstance:
        [root.datasources.prometheus]
        + variablesFromLabels(groupLabels, instanceLabels, filteringSelector),
      // Use on dashboards where only single entity can be selected, like drill-down dashboards
      singleInstance:
        [root.datasources.prometheus]
        + variablesFromLabels(groupLabels, instanceLabels, filteringSelector, multiInstance=false),
      // Use on dashboards where multiple entities can be selected, like fleet dashboards
      clusterVariables:
        [root.datasources.prometheus]
        + variablesFromLabels(groupLabels, [], filteringSelector),
      // Use on dashboards where only single entity can be selected, like drill-down dashboards
      overviewVariables:
        [root.datasources.prometheus]
        + variablesFromLabels(groupLabels, [], filteringSelector, multiInstance=true) + [topClusterSelector],
      hostsVariable:
        [root.datasources.prometheus]
        + variablesFromLabels(groupLabels, hostLabels, filteringSelector, multiInstance=true),
      virtualMachinesVariables:
        [root.datasources.prometheus]
        + variablesFromLabels(groupLabels, hostLabels + resourcePoolLabels + virtualMachineLabels, filteringSelector, multiInstance=true),

      queriesSelector:
        '%s' % [
          utils.labelsToPromQLSelector(groupLabels),
        ],
      clusterQueriesSelector:
        '%s' % [
          utils.labelsToPromQLSelector(groupLabels),
        ],
      hostQueriesSelector:
        '%s' % [
          utils.labelsToPromQLSelector(groupLabels + hostLabels),
        ],
      virtualMachinesQueriesSelector:
        '%s' % [
          utils.labelsToPromQLSelector(groupLabels + hostLabels + resourcePoolLabels + virtualMachineLabels),
        ],
      queriesGroupSelectorAdvanced:
        '%s' % [
          utils.labelsToPromQLSelectorAdvanced(groupLabels),
        ],
    }
    + if this.config.enableLokiLogs then self.withLokiLogs(this) else {},
  withLokiLogs(this): {
    multiInstance+: [this.grafana.variables.datasources.loki],
    singleInstance+: [this.grafana.variables.datasources.loki],
  },
}
