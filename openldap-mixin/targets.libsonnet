local g = import './g.libsonnet';
local prometheusQuery = g.query.prometheus;

{
  new(this): {
    local variables = this.grafana.variables,
    local panel = g.panel,

    uptimeQuery:: 'openldap_monitored_object{job=~"$job", instance=~"$instance", dn="cn=Uptime,cn=Time,cn=Monitor"}',
    referralsQuery:: 'openldap_monitor_counter_object{job=~"$job", instance=~"$instance", dn="cn=Referrals,cn=Statistics,cn=Monitor"}',
    directoryEntriesQuery(interval):: 'increase(openldap_monitor_counter_object{job=~"$job", instance=~"$instance", dn="cn=Entries,cn=Statistics,cn=Monitor"}[$%s:])' % interval,
    connectionsQuery(interval):: 'increase(openldap_monitor_counter_object{job=~"$job", instance=~"$instance", dn="cn=Current,cn=Connections,cn=Monitor"}[$%s:])' % interval,
    waitersQuery(type):: 'openldap_monitor_counter_object{job=~"$job", instance=~"$instance", dn="cn=%s,cn=Waiters,cn=Monitor"}' % type,
    networkConnectivityQuery(interval):: 'increase(openldap_dial{job=~"$job", instance=~"$instance"}[$%s:])' % interval,
    pduProcessedQuery(interval):: 'increase(openldap_monitor_counter_object{job=~"$job", instance=~"$instance", dn="cn=PDU,cn=Statistics,cn=Monitor"}[$%s:])' % interval,
    authenticationAttemptsQuery(interval):: 'increase(openldap_bind{job=~"$job", instance=~"$instance"}[$%s:])' % interval,
    coreOperationsQuery(operation, interval):: 'increase(openldap_monitor_operation{job=~"$job", instance=~"$instance", dn="cn=%s,cn=Operations,cn=Monitor"}[$%s:])' % [operation, interval],
    auxiliaryOperationsQuery(operation, interval):: 'increase(openldap_monitor_operation{job=~"$job", instance=~"$instance", dn="cn=%s,cn=Operations,cn=Monitor"}[$%s:])' % [operation, interval],
    primaryThreadActivityQuery(type):: 'openldap_monitored_object{job=~"$job", instance=~"$instance", dn="cn=%s,cn=Threads,cn=Monitor"}' % type,
    threadQueueManagementQuery(type):: 'openldap_monitored_object{job=~"$job", instance=~"$instance", dn="cn=%s,cn=Threads,cn=Monitor"}' % type,

    uptime:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        self.uptimeQuery
      )
      + prometheusQuery.withLegendFormat('{{instance}}'),
    referrals:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        self.referralsQuery
      )
      + prometheusQuery.withLegendFormat('{{instance}}'),
    directoryEntries(interval):
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        self.directoryEntriesQuery(interval)
      )
      + prometheusQuery.withLegendFormat('{{instance}}')
      + panel.timeSeries.queryOptions.withInterval('1m'),
    connections(interval):
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        self.connectionsQuery(interval)
      )
      + prometheusQuery.withLegendFormat('{{instance}}')
      + panel.timeSeries.queryOptions.withInterval('1m'),
    waiters(type):
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        self.waitersQuery(type)
      )
      + prometheusQuery.withLegendFormat('{{instance}} - ' + type),
    networkConnectivity(interval):
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        self.networkConnectivityQuery(interval)
      )
      + prometheusQuery.withLegendFormat('{{instance}}')
      + panel.timeSeries.queryOptions.withInterval('1m'),
    pduProcessed(interval):
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        self.pduProcessedQuery(interval)
      )
      + prometheusQuery.withLegendFormat('{{instance}}')
      + panel.timeSeries.queryOptions.withInterval('1m'),
    authenticationAttempts(interval):
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        self.authenticationAttemptsQuery(interval)
      )
      + prometheusQuery.withLegendFormat('{{instance}}')
      + panel.timeSeries.queryOptions.withInterval('1m'),
    coreOperations(operation, interval):
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        self.coreOperationsQuery(operation, interval)
      )
      + prometheusQuery.withLegendFormat('{{instance}} - ' + operation)
      + panel.timeSeries.queryOptions.withInterval('1m'),
    auxiliaryOperations(operation, interval):
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        self.auxiliaryOperationsQuery(operation, interval)
      )
      + prometheusQuery.withLegendFormat('{{instance}} - ' + operation)
      + panel.timeSeries.queryOptions.withInterval('1m'),
    primaryThreadActivity(type):
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        self.primaryThreadActivityQuery(type)
      )
      + prometheusQuery.withLegendFormat('{{instance}} - open'),
    threadQueueManagement(type):
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        self.threadQueueManagementQuery(type)
      )
      + prometheusQuery.withLegendFormat('{{instance}} - ' + type),
  },
}
