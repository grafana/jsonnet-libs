local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this)::
    {
      local signals = this.signals,

      trafficByResponseCodePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Traffic by Response Code',
          targets=[signals.http.requestsByStatus.asTarget() { interval: '1m' }],
          description='Rate of HTTP traffic over time, grouped by status.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      userSessionsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'User Sessions',
          targets=[signals.users.sessionLogins.asTarget() { interval: '1m' }],
          description='The rate of user logins.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('sessions/s')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      avgRequestLatencyPanel:
        g.panel.timeSeries.new('Average Request Latency')
        + g.panel.timeSeries.panelOptions.withDescription('Average latency of inbound HTTP requests.')
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false)
        + g.panel.timeSeries.queryOptions.withDatasource('prometheus', '${' + this.grafana.variables.datasources.prometheus.name + '}')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.http.averageRequestLatency.asTarget() { interval: '1m' },
        ]),

      topRequestsPanel:
        g.panel.table.new('Top 5 Request Types')
        + g.panel.table.panelOptions.withDescription('Top 5 types of requests to the server.')
        + g.panel.table.queryOptions.withDatasource('prometheus', '${' + this.grafana.variables.datasources.prometheus.name + '}')
        + g.panel.table.queryOptions.withTargets([
          signals.http.topRequests.asTableTarget() { interval: '2m' },
        ])
        + g.panel.table.queryOptions.withTransformations([
          g.panel.table.transformation.withId('groupBy')
          + g.panel.table.transformation.withOptions({
            fields: {
              Value: {
                aggregations: ['lastNotNull'],
                operation: 'aggregate',
              },
              feature_category: {
                aggregations: ['lastNotNull'],
                operation: 'groupby',
              },
            },
          }),
          g.panel.table.transformation.withId('organize')
          + g.panel.table.transformation.withOptions({
            excludeByName: {},
            indexByName: {},
            renameByName: {
              'Value (lastNotNull)': 'Request rate',
              feature_category: 'Feature category',
            },
          }),
          g.panel.table.transformation.withId('sortBy')
          + g.panel.table.transformation.withOptions({
            fields: {},
            sort: [
              {
                desc: true,
                field: 'Request rate',
              },
            ],
          }),
          g.panel.table.transformation.withId('limit')
          + g.panel.table.transformation.withOptions({
            limitField: 5,
          }),
        ])
        + g.panel.table.standardOptions.withUnit('reqps'),

      jobActivationsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Job Activations',
          targets=[signals.ci.activeJobs.asTarget() { interval: '1m' }],
          description='The number of jobs activated per second.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('activations/s')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      pipelinesCreatedPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Pipelines Created',
          targets=[signals.ci.pipelinesCreated.asTarget() { interval: '1m' }],
          description='Rate of pipeline instances created.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('pipelines/s')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      pipelineBuildsCreatedPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Pipeline Builds Created',
          targets=[signals.ci.pipelineBuildsCreated.asTarget() { interval: '1m' }],
          description='The number of builds created within a pipeline per second, grouped by source.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('builds/s')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      buildTraceOperationsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Build Trace Operations',
          targets=[signals.ci.traceOperations.asTarget() { interval: '1m' }],
          description='The rate of build trace operations performed, grouped by source.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('ops')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),
    },
}
