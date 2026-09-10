local g = import './g.libsonnet';
local var = g.dashboard.variable;
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this):
    commonlib.variables.new(
      filteringSelector=this.config.filteringSelector,
      groupLabels=this.config.groupLabels,
      instanceLabels=this.config.instanceLabels,
      varMetric='istiod_uptime_seconds',
      customAllValue='.+',
      enableLokiLogs=this.config.enableLokiLogs,
      // Istio dashboards and signals reference the Prometheus datasource as
      // ${datasource}, not the ${prometheus_datasource} that enableLokiLogs
      // would otherwise select.
      prometheusDatasourceName='datasource',
      prometheusDatasourceLabel='Data source',
    )
    + {
      local root = self,
      // The job/cluster chain built by commonlib. Taken on its own rather than
      // via multiInstance, because only the logs dashboard carries the Loki
      // datasource variable that multiInstance appends.
      local groupVariables = std.filter(function(v) v.type == 'query', root.multiInstance),

      local namespaceQuery = 'query_result(sum(istio_requests_total{job=~"$job", cluster=~"$cluster"}) by (destination_workload_namespace, source_workload_namespace) or sum(istio_tcp_sent_bytes_total{job=~"$job", cluster=~"$cluster"}) by (destination_workload_namespace, source_workload_namespace))',
      local namespaceRegex = '/(?:destination|source)_workload_namespace="([^"]*)/g',
      local serviceQuery = 'query_result(sum(istio_requests_total{job=~"$job", cluster=~"$cluster", source_workload_namespace=~"$namespace"}) by (source_canonical_service) or sum(istio_requests_total{job=~"$job", cluster=~"$cluster", destination_workload_namespace=~"$namespace"}) by (destination_canonical_service) or sum(istio_tcp_sent_bytes_total{job=~"$job", cluster=~"$cluster", source_workload_namespace=~"$namespace"}) by (source_canonical_service) or sum(istio_tcp_sent_bytes_total{job=~"$job", cluster=~"$cluster", destination_workload_namespace=~"$namespace"}) by (destination_canonical_service))',
      local serviceRegex = '/(?:source_canonical_service|destination_canonical_service)="([^"]*)/g',
      local workloadQuery = 'query_result(sum by(source_workload) (istio_requests_total{job=~"$job", cluster=~"$cluster", source_workload_namespace=~"$namespace", source_canonical_service=~"$service"}) or sum by(destination_workload) (istio_requests_total{job=~"$job", cluster=~"$cluster", destination_workload_namespace=~"$namespace", destination_service_name=~"$service"}) or sum by(source_workload) (istio_tcp_sent_bytes_total{job=~"$job", cluster=~"$cluster", source_workload_namespace=~"$namespace", source_canonical_service=~"$service"}) or sum by(destination_workload) (istio_tcp_sent_bytes_total{job=~"$job", cluster=~"$cluster", destination_workload_namespace=~"$namespace", destination_service_name=~"$service"}))',
      local workloadRegex = '/(?:source|destination)_workload="([^"]*)/g',
      local clientServiceQuery = 'query_result(sum(istio_requests_total{job=~"$job", cluster=~"$cluster", destination_canonical_service=~"$service"}) by (destination_canonical_service, source_canonical_service) or sum(istio_tcp_received_bytes_total{job=~"$job", cluster=~"$cluster", destination_canonical_service=~"$service"}) by (destination_canonical_service, source_canonical_service))',
      local clientServiceRegex = '/source_canonical_service="([^"]*)/',
      local serverServiceQuery = 'query_result(sum(istio_requests_total{job=~"$job", cluster=~"$cluster", source_canonical_service=~"$service"}) by (destination_canonical_service, source_canonical_service) or sum(istio_tcp_received_bytes_total{job=~"$job", cluster=~"$cluster", source_canonical_service=~"$service"}) by (destination_canonical_service, source_canonical_service))',
      local serverServiceRegex = '/destination_canonical_service="([^"]*)/',
      local clientWorkloadQuery = 'query_result(sum(istio_requests_total{job=~"$job", cluster=~"$cluster", destination_workload=~"$workload"}) by (source_workload) or sum(istio_tcp_received_bytes_total{job=~"$job", cluster=~"$cluster", destination_workload=~"$workload"}) by (source_workload))',
      local clientWorkloadRegex = '/source_workload="([^"]*)/',
      local serverWorkloadQuery = 'query_result(sum(istio_requests_total{job=~"$job", cluster=~"$cluster", source_workload=~"$workload"}) by (destination_workload) or sum(istio_tcp_received_bytes_total{job=~"$job", cluster=~"$cluster", source_workload=~"$workload"}) by (destination_workload))',
      local serverWorkloadRegex = '/destination_workload="([^"]*)/',

      // Istio component pods, discovered from a metric that carries a pod label.
      local componentVariable(name, displayName, metric, selector) =
        var.query.new(name)
        + var.query.withDatasourceFromVariable(root.datasources.prometheus)
        + var.query.queryTypes.withLabelValues('pod', '%s{%s}' % [metric, selector])
        + var.query.generalOptions.withLabel(displayName)
        + var.query.selectionOptions.withIncludeAll(value=true)
        + var.query.selectionOptions.withMulti(true)
        + var.query.refresh.onTime()
        + var.query.withSort(i=1, type='alphabetical', asc=true, caseInsensitive=false),

      // Istio topology variables, extracted from a query_result by regex because
      // the source and destination sides of a call live in different labels.
      local topologyVariable(name, displayName, query, regex, includeAll) =
        var.query.new(name, query)
        + var.query.generalOptions.withLabel(displayName)
        + var.query.withDatasourceFromVariable(root.datasources.prometheus)
        + var.query.withRegex(regex)
        + var.query.selectionOptions.withIncludeAll(value=includeAll)
        + var.query.selectionOptions.withMulti(true)
        + var.query.refresh.onTime()
        + var.query.withSort(i=1, type='alphabetical', asc=true, caseInsensitive=false),

      overviewVariables:
        [root.datasources.prometheus]
        + groupVariables
        + [
          componentVariable('istiod', 'Istiod', 'pilot_info', 'job=~"$job", cluster=~"$cluster"'),
          componentVariable('gateway', 'Gateway', 'istio_agent_process_cpu_seconds_total', 'job=~"$job", cluster=~"$cluster", pod=~"istio-egress.*|istio-ingress.*"'),
          componentVariable('proxy', 'Proxy', 'istio_agent_process_cpu_seconds_total', 'job=~"$job", cluster=~"$cluster", pod!~"istio-egress.*|istio-ingress.*"'),
        ],
      serviceOverviewVariables:
        [root.datasources.prometheus]
        + groupVariables
        + [
          topologyVariable('namespace', 'Namespace', namespaceQuery, namespaceRegex, true),
          topologyVariable('service', 'Service', serviceQuery, serviceRegex, false),
          topologyVariable('client_service', 'Client service', clientServiceQuery, clientServiceRegex, true),
          topologyVariable('server_service', 'Server service', serverServiceQuery, serverServiceRegex, true),
        ],
      workloadOverviewVariables:
        [root.datasources.prometheus]
        + groupVariables
        + [
          topologyVariable('namespace', 'Namespace', namespaceQuery, namespaceRegex, true),
          topologyVariable('service', 'Service', serviceQuery, serviceRegex, false),
          topologyVariable('workload', 'Workload', workloadQuery, workloadRegex, true),
          topologyVariable('client_workload', 'Client workload', clientWorkloadQuery, clientWorkloadRegex, true),
          topologyVariable('server_workload', 'Server workload', serverWorkloadQuery, serverWorkloadRegex, true),
        ],
    },
}
