// variables.libsonnet
local g = import './g.libsonnet';
local var = g.dashboard.variable;
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;
local utils = commonlib.utils {
  labelsToPromQLPodSelector(labels): std.join(',', ['pod=~"$%s"' % [label] for label in labels]),
};

{
  new(this):
    {
      local groupLabels = this.config.groupLabels,
      local istiodLabel = this.config.istiodLabel,
      local gatewayLabel = this.config.gatewayLabel,
      local proxyLabel = this.config.proxyLabel,
      local instanceLabels = this.config.instanceLabels,
      local groupVarMetric = 'istiod_uptime_seconds',
      local root = self,
      // Generates chained variables to use on on all dashboards
      local groupVariablesFromLabels(groupLabels) =
        local chainVarProto(index, chainVar) =
          var.query.new(chainVar.label)
          + var.query.withDatasourceFromVariable(root.datasources.prometheus)
          + var.query.queryTypes.withLabelValues(
            chainVar.label,
            '%s{%s}' % [groupVarMetric, chainVar.chainSelector],
          )
          + var.query.generalOptions.withLabel(
            if (chainVar.label == 'cluster') then 'K8s cluster' else utils.toSentenceCase(chainVar.label)
          )
          + var.query.selectionOptions.withIncludeAll(
            value=true,
            customAllValue='.+'
          )
          + var.query.selectionOptions.withMulti(
            true,
          )
          + var.query.refresh.onTime()
          + var.query.withSort(
            i=1,
            type='alphabetical',
            asc=true,
            caseInsensitive=false
          );
        std.mapWithIndex(chainVarProto, utils.chainLabels(groupLabels, [])),
      local createVariable(name, displayName, metric, label, selector, includeAll, multiSelect) =
        local variable = var.query.new(name)
        + var.query.withDatasourceFromVariable(root.datasources.prometheus)
        + var.query.queryTypes.withLabelValues(
          label,
          '%s{%s}' % [metric, selector],
        )
        + var.query.generalOptions.withLabel(displayName)
        + var.query.selectionOptions.withIncludeAll(
          value=if (!includeAll) then false else true,
        )
        + var.query.selectionOptions.withMulti(
          if (!multiSelect) then false else true,
        )
        + var.query.refresh.onTime()
        + var.query.withSort(
          i=1,
          type='alphabetical',
          asc=true,
          caseInsensitive=false
        );
        [variable],
      datasources: {
        prometheus:
          var.datasource.new('datasource', 'prometheus')
          + var.datasource.generalOptions.withLabel('Data source')
          + var.datasource.withRegex(''),
        loki:
          var.datasource.new('loki_datasource', 'loki')
          + var.datasource.generalOptions.withLabel('Loki data source')
          + var.datasource.withRegex('')
          // hide by default (used for annotations)
          + var.datasource.generalOptions.showOnDashboard.withNothing(),
      },
      overviewVariables:
        [root.datasources.prometheus]
        + groupVariablesFromLabels(groupLabels)
        + createVariable(istiodLabel, 'Istiod', 'pilot_info', 'pod', 'job="integrations/istio", cluster=~"$cluster"', true, true)
        + createVariable(gatewayLabel, 'Gateway', 'istio_agent_process_cpu_seconds_total', 'pod', 'job=~"integrations/istio", cluster=~"$cluster", pod=~"istio-egress.*|istio-ingress.*"', true, true)
        + createVariable(proxyLabel, 'Proxy', 'istio_agent_process_cpu_seconds_total', 'pod', 'job=~"integrations/istio", cluster=~"$cluster", pod!~"istio-egress.*|istio-ingress.*"', true, true),
      
      queriesGroupSelectorAdvanced:
         '%s' % [
           utils.labelsToPromQLSelectorAdvanced(groupLabels),
         ],

      queriesGroupSelector:
        '%s' % [
          utils.labelsToPromQLSelector(groupLabels),
        ],

      queriesGroupIstiodSelector:
        '%s,%s' % [
          utils.labelsToPromQLSelector(groupLabels),
          utils.labelsToPromQLPodSelector([istiodLabel]),
        ],

      queriesGroupGatewaySelector:
        '%s,%s' % [
          utils.labelsToPromQLSelector(groupLabels),
          utils.labelsToPromQLPodSelector([gatewayLabel]),
        ],

      queriesGroupProxySelector:
        '%s,%s' % [
          utils.labelsToPromQLSelector(groupLabels),
          utils.labelsToPromQLPodSelector([proxyLabel]),
        ],
    }
}
