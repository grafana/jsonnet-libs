// variables.libsonnet
local g = import './g.libsonnet';
local var = g.dashboard.variable;
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;
local utils = commonlib.utils {
  labelsToPromQLPodSelector(labels): std.join(',', ['pod=~"$%s"' % [label] for label in labels]),
  labelsToPromQLClientServiceSelector(namespace, service, serverService): 'source_workload_namespace=~"$%s",source_canonical_service=~"$%s",destination_canonical_service=~"$%s"' % [namespace, service, serverService],
  labelsToPromQLServerServiceSelector(namespace, service, clientService): 'destination_workload_namespace=~"$%s",destination_canonical_service=~"$%s",source_canonical_service=~"$%s"' % [namespace, service, clientService],
  labelsToPromQLSourceServiceSelector(namespace, service): 'source_workload_namespace=~"$%s",source_canonical_service=~"$%s"' % [namespace, service],
  labelsToPromQLDestinationServiceSelector(namespace, service): 'destination_workload_namespace=~"$%s",destination_canonical_service=~"$%s"' % [namespace, service],
};

{
  new(this):
    {
      local groupLabels = this.config.groupLabels,
      local istiodLabel = this.config.istiodLabel,
      local gatewayLabel = this.config.gatewayLabel,
      local proxyLabel = this.config.proxyLabel,
      local namespaceLabel = this.config.namespaceLabel,
      local namespaceQuery = this.config.namespaceQuery,
      local namespaceRegex = this.config.namespaceRegex,
      local serviceLabel = this.config.serviceLabel,
      local serviceQuery = this.config.serviceQuery,
      local serviceRegex = this.config.serviceRegex,
      local clientServiceLabel = this.config.clientServiceLabel,
      local clientServiceQuery = this.config.clientServiceQuery,
      local clientServiceRegex = this.config.clientServiceRegex,
      local serverServiceLabel = this.config.serverServiceLabel,
      local serverServiceQuery = this.config.serverServiceQuery,
      local serverServiceRegex = this.config.serverServiceRegex,
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
      local createOverviewVariable(name, displayName, metric, selector) =
        local variable = var.query.new(name)
        + var.query.withDatasourceFromVariable(root.datasources.prometheus)
        + var.query.queryTypes.withLabelValues(
          'pod',
          '%s{%s}' % [metric, selector],
        )
        + var.query.generalOptions.withLabel(displayName)
        + var.query.selectionOptions.withIncludeAll(
          value=true,
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
        [variable],
      local createQueryVariable(name, displayName, query, regex, includeAll) =
        local variable = var.query.new(name, query)
        + var.query.generalOptions.withLabel(displayName)
        + var.query.withDatasourceFromVariable(root.datasources.prometheus)
        + var.query.withRegex(regex)
        + var.query.selectionOptions.withIncludeAll(
          value=if (!includeAll) then false else true,
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
        [variable],
      overviewVariables:
        [root.datasources.prometheus]
        + groupVariablesFromLabels(groupLabels)
        + createOverviewVariable(istiodLabel, 'Istiod', 'pilot_info', 'job=~"$job", cluster=~"$cluster"')
        + createOverviewVariable(gatewayLabel, 'Gateway', 'istio_agent_process_cpu_seconds_total', 'job=~"$job", cluster=~"$cluster", pod=~"istio-egress.*|istio-ingress.*"')
        + createOverviewVariable(proxyLabel, 'Proxy', 'istio_agent_process_cpu_seconds_total', 'job=~"$job", cluster=~"$cluster", pod!~"istio-egress.*|istio-ingress.*"'),
      serviceOverviewVariables:
        [root.datasources.prometheus]
        + groupVariablesFromLabels(groupLabels)
        + createQueryVariable(namespaceLabel, 'Namespace', namespaceQuery, namespaceRegex, true)
        + createQueryVariable(serviceLabel, 'Service', serviceQuery, serviceRegex, false)
        + createQueryVariable(clientServiceLabel, 'Client service', clientServiceQuery, clientServiceRegex, true)
        + createQueryVariable(serverServiceLabel, 'Server service', serverServiceQuery, serverServiceRegex, true),

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
      queriesGroupClientServiceSelector:
        '%s,%s' % [
          utils.labelsToPromQLSelector(groupLabels),
          utils.labelsToPromQLClientServiceSelector(namespaceLabel, serviceLabel, serverServiceLabel),
        ],
      queriesGroupServerServiceSelector:
        '%s,%s' % [
          utils.labelsToPromQLSelector(groupLabels),
          utils.labelsToPromQLServerServiceSelector(namespaceLabel, serviceLabel, clientServiceLabel),
        ],
      queriesGroupSourceServiceSelector:
        '%s,%s' % [
          utils.labelsToPromQLSelector(groupLabels),
          utils.labelsToPromQLSourceServiceSelector(namespaceLabel, serviceLabel),
        ],
      queriesGroupDestinationServiceSelector:
        '%s,%s' % [
          utils.labelsToPromQLSelector(groupLabels),
          utils.labelsToPromQLDestinationServiceSelector(namespaceLabel, serviceLabel),
        ],
    }
}
