local g = import './g.libsonnet';
local prometheusQuery = g.query.prometheus;
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this): {
    local variables = this.grafana.variables,
    local panel = g.panel,

    uptimeQuery:: 'openldap_monitored_object{%(queriesSelector)s, dn="cn=Uptime,cn=Time,cn=Monitor"}' % variables,
    referralsQuery:: 'openldap_monitor_counter_object{%(queriesSelector)s, dn="cn=Referrals,cn=Statistics,cn=Monitor"}' % variables,
    directoryEntriesQuery(interval):: 'increase(openldap_monitor_counter_object{%(queriesSelector)s, dn="cn=Entries,cn=Statistics,cn=Monitor"}[$%s:])' % [variables.queriesSelector, interval],
    connectionsQuery(interval):: 'increase(openldap_monitor_counter_object{%(queriesSelector)s, dn="cn=Current,cn=Connections,cn=Monitor"}[$%s:])' % [variables.queriesSelector, interval],
    waitersQuery(type):: 'openldap_monitor_counter_object{%(queriesSelector)s, dn="cn=%s,cn=Waiters,cn=Monitor"}' % [variables.queriesSelector, type],
    networkConnectivityQuery(interval):: 'increase(openldap_dial{%(queriesSelector)s}[$%s:])' % [variables.queriesSelector, interval],
    pduProcessedQuery(interval):: 'increase(openldap_monitor_counter_object{%(queriesSelector)s, dn="cn=PDU,cn=Statistics,cn=Monitor"}[$%s:])' % [variables.queriesSelector, interval],
    authenticationAttemptsQuery(interval):: 'increase(openldap_bind{%(queriesSelector)s}[$%s:])' % [variables.queriesSelector, interval],
    coreOperationsQuery(operation, interval):: 'increase(openldap_monitor_operation{%(queriesSelector)s, dn="cn=%s,cn=Operations,cn=Monitor"}[$%s:])' % [variables.queriesSelector, operation, interval],
    auxiliaryOperationsQuery(operation, interval):: 'increase(openldap_monitor_operation{%(queriesSelector)s, dn="cn=%s,cn=Operations,cn=Monitor"}[$%s:])' % [variables.queriesSelector, operation, interval],
    primaryThreadActivityQuery(type):: 'openldap_monitored_object{%(queriesSelector)s, dn="cn=%s,cn=Threads,cn=Monitor"}' % [variables.queriesSelector, type],
    threadQueueManagementQuery(type):: 'openldap_monitored_object{%(queriesSelector)s, dn="cn=%s,cn=Threads,cn=Monitor"}' % [variables.queriesSelector, type],

    uptime:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        self.uptimeQuery
      )
      + prometheusQuery.withLegendFormat('%s' % commonlib.utils.labelsToPanelLegend(this.config.instanceLabels)),
    referrals:
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        self.referralsQuery
      )
      + prometheusQuery.withLegendFormat('%s' % commonlib.utils.labelsToPanelLegend(this.config.instanceLabels)),
    directoryEntries(interval):
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        self.directoryEntriesQuery(interval)
      )
      + prometheusQuery.withLegendFormat('%s' % commonlib.utils.labelsToPanelLegend(this.config.instanceLabels))
      + panel.timeSeries.queryOptions.withInterval('1m'),
    connections(interval):
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        self.connectionsQuery(interval)
      )
      + prometheusQuery.withLegendFormat('%s' % commonlib.utils.labelsToPanelLegend(this.config.instanceLabels))
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
      + prometheusQuery.withLegendFormat('%s' % commonlib.utils.labelsToPanelLegend(this.config.instanceLabels))
      + panel.timeSeries.queryOptions.withInterval('1m'),
    pduProcessed(interval):
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        self.pduProcessedQuery(interval)
      )
      + prometheusQuery.withLegendFormat('%s' % commonlib.utils.labelsToPanelLegend(this.config.instanceLabels))
      + panel.timeSeries.queryOptions.withInterval('1m'),
    authenticationAttempts(interval):
      prometheusQuery.new(
        '${' + variables.datasources.prometheus.name + '}',
        self.authenticationAttemptsQuery(interval)
      )
      + prometheusQuery.withLegendFormat('%s' % commonlib.utils.labelsToPanelLegend(this.config.instanceLabels))
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
