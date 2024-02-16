// variables.libsonnet
local g = import './g.libsonnet';
local var = g.dashboard.variable;
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;

{
  new(this):
    {
      local groupLabels = this.config.groupLabels,
      local istiodLabel = 'istiod',
      local gatewayLabel = 'gateway',
      local proxyLabel = 'proxy',
      local namespaceLabel = 'namespace',
      local namespaceQuery = 'query_result(sum(istio_requests_total{job=~"$job", cluster=~"$cluster"}) by (destination_workload_namespace, source_workload_namespace) or sum(istio_tcp_sent_bytes_total{job=~"$job", cluster=~"$cluster"}) by (destination_workload_namespace, source_workload_namespace))',
      local namespaceRegex = '/(?:destination|source)_workload_namespace="([^"]*)/g',
      local serviceLabel = 'service',
      local serviceQuery = 'query_result(sum(istio_requests_total{job=~"$job", cluster=~"$cluster", source_workload_namespace=~"$namespace"}) by (source_canonical_service) or sum(istio_requests_total{job=~"$job", cluster=~"$cluster", destination_workload_namespace=~"$namespace"}) by (destination_canonical_service) or sum(istio_tcp_sent_bytes_total{job=~"$job", cluster=~"$cluster", source_workload_namespace=~"$namespace"}) by (source_canonical_service) or sum(istio_tcp_sent_bytes_total{job=~"$job", cluster=~"$cluster", destination_workload_namespace=~"$namespace"}) by (destination_canonical_service))',
      local serviceRegex = '/(?:source_canonical_service|destination_canonical_service)="([^"]*)/g',
      local workloadLabel = 'workload',
      local workloadQuery = 'query_result(sum by(source_workload) (istio_requests_total{job=~"$job", cluster=~"$cluster", source_workload_namespace=~"$namespace", source_canonical_service=~"$service"}) or sum by(destination_workload) (istio_requests_total{job=~"$job", cluster=~"$cluster", destination_workload_namespace=~"$namespace", destination_service_name=~"$service"}) or sum by(source_workload) (istio_tcp_sent_bytes_total{job=~"$job", cluster=~"$cluster", source_workload_namespace=~"$namespace", source_canonical_service=~"$service"}) or sum by(destination_workload) (istio_tcp_sent_bytes_total{job=~"$job", cluster=~"$cluster", destination_workload_namespace=~"$namespace", destination_service_name=~"$service"}))',
      local workloadRegex = '/(?:source|destination)_workload="([^"]*)/g',
      local clientServiceLabel = 'client_service',
      local clientServiceQuery = 'query_result(sum(istio_requests_total{job=~"$job", cluster=~"$cluster", destination_canonical_service=~"$service"}) by (destination_canonical_service, source_canonical_service) or sum(istio_tcp_received_bytes_total{job=~"$job", cluster=~"$cluster", destination_canonical_service=~"$service"}) by (destination_canonical_service, source_canonical_service))',
      local clientServiceRegex = '/source_canonical_service="([^"]*)/',
      local serverServiceLabel = 'server_service',
      local serverServiceQuery = 'query_result(sum(istio_requests_total{job=~"$job", cluster=~"$cluster", source_canonical_service=~"$service"}) by (destination_canonical_service, source_canonical_service) or sum(istio_tcp_received_bytes_total{job=~"$job", cluster=~"$cluster", source_canonical_service=~"$service"}) by (destination_canonical_service, source_canonical_service))',
      local serverServiceRegex = '/destination_canonical_service="([^"]*)/',
      local clientWorkloadLabel = 'client_workload',
      local clientWorkloadQuery = 'query_result(sum(istio_requests_total{job=~"$job", cluster=~"$cluster", destination_workload=~"$workload"}) by (source_workload) or sum(istio_tcp_received_bytes_total{job=~"$job", cluster=~"$cluster", destination_workload=~"$workload"}) by (source_workload))',
      local clientWorkloadRegex = '/source_workload="([^"]*)/',
      local serverWorkloadLabel = 'server_workload',
      local serverWorkloadQuery = 'query_result(sum(istio_requests_total{job=~"$job", cluster=~"$cluster", source_workload=~"$workload"}) by (destination_workload) or sum(istio_tcp_received_bytes_total{job=~"$job", cluster=~"$cluster", source_workload=~"$workload"}) by (destination_workload))',
      local serverWorkloadRegex = '/destination_workload="([^"]*)/',
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
      workloadOverviewVariables:
        [root.datasources.prometheus]
        + groupVariablesFromLabels(groupLabels)
        + createQueryVariable(namespaceLabel, 'Namespace', namespaceQuery, namespaceRegex, true)
        + createQueryVariable(serviceLabel, 'Service', serviceQuery, serviceRegex, false)
        + createQueryVariable(workloadLabel, 'Workload', workloadQuery, workloadRegex, true)
        + createQueryVariable(clientWorkloadLabel, 'Client workload', clientWorkloadQuery, clientWorkloadRegex, true)
        + createQueryVariable(serverWorkloadLabel, 'Server workload', serverWorkloadQuery, serverWorkloadRegex, true),

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
          'pod=~"$' + istiodLabel + '"',
        ],
      queriesGroupGatewaySelector:
        '%s,%s' % [
          utils.labelsToPromQLSelector(groupLabels),
          'pod=~"$' + gatewayLabel + '"',
        ],
      queriesGroupProxySelector:
        '%s,%s' % [
          utils.labelsToPromQLSelector(groupLabels),
          'pod=~"$' + proxyLabel + '"',
        ],
      queriesGroupClientServiceSelector:
        '%s,%s' % [
          utils.labelsToPromQLSelector(groupLabels),
          'source_workload_namespace=~"$' + namespaceLabel + '",source_canonical_service=~"$' + serviceLabel + '",destination_canonical_service=~"$' + serverServiceLabel + '"',
        ],
      queriesGroupServerServiceSelector:
        '%s,%s' % [
          utils.labelsToPromQLSelector(groupLabels),
          'destination_workload_namespace=~"$' + namespaceLabel + '",destination_canonical_service=~"$' + serviceLabel + '",source_canonical_service=~"$' + clientServiceLabel + '"',
        ],
      queriesGroupSourceServiceSelector:
        '%s,%s' % [
          utils.labelsToPromQLSelector(groupLabels),
          'source_workload_namespace=~"$' + namespaceLabel + '",source_canonical_service=~"$' + serviceLabel + '"'
        ],
      queriesGroupDestinationServiceSelector:
        '%s,%s' % [
          utils.labelsToPromQLSelector(groupLabels),
          'destination_workload_namespace=~"$' + namespaceLabel + '",destination_canonical_service=~"$' + serviceLabel + '"',
        ],
      queriesGroupClientWorkloadSelector:
        '%s,%s' % [
          utils.labelsToPromQLSelector(groupLabels),
          'source_workload_namespace=~"$' + namespaceLabel + '",source_workload=~"$' + workloadLabel + '",destination_workload=~"$' + serverWorkloadLabel + '"'
        ],
      queriesGroupServerWorkloadSelector:
        '%s,%s' % [
          utils.labelsToPromQLSelector(groupLabels),
          'destination_workload_namespace=~"$' + namespaceLabel + '",destination_workload=~"$' + workloadLabel + '",source_workload=~"$' + clientWorkloadLabel + '"',
        ],
      queriesGroupSourceWorkloadSelector:
        '%s,%s' % [
          utils.labelsToPromQLSelector(groupLabels),
          'source_workload_namespace=~"$' + namespaceLabel + '",source_workload=~"$' + workloadLabel + '"',
        ],
      queriesGroupDestinationWorkloadSelector:
        '%s,%s' % [
          utils.labelsToPromQLSelector(groupLabels),
          'destination_workload_namespace=~"$' + namespaceLabel + '",destination_workload=~"$' + workloadLabel + '"',
        ],
    }
}
