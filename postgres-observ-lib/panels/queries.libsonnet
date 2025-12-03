// Tier 5: Query Analysis Panels
local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(signals):: {
    // Top queries by total time
    topQueriesByTotalTime:
      signals.queries.topQueriesByTotalTime.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('ms')
      + g.panel.timeSeries.panelOptions.withDescription(
        'Queries consuming most total execution time. Primary optimization targets.'
      ),

    // Slowest queries by mean time
    slowestQueriesByMeanTime:
      signals.queries.slowestQueriesByMeanTime.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('ms')
      + g.panel.timeSeries.panelOptions.withDescription(
        'Queries with highest average execution time.'
      ),

    // Most frequent queries
    mostFrequentQueries:
      signals.queries.mostFrequentQueries.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('ops')
      + g.panel.timeSeries.panelOptions.withDescription(
        'Most frequently executed queries.'
      ),

    // Queries using temp files
    queriesUsingTempFiles:
      signals.queries.queriesUsingTempFiles.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('bytes')
      + g.panel.timeSeries.panelOptions.withDescription(
        'Queries writing to temp files. Consider increasing work_mem.'
      ),

    // Query cache efficiency
    queryCacheEfficiency:
      signals.queries.queryCacheHitRatio.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('percentunit')
      + g.panel.timeSeries.panelOptions.withDescription(
        'Per-query cache hit ratio. Low values indicate queries not benefiting from shared_buffers.'
      ),

    // Combined table view
    queryStatsTable:
      signals.queries.slowestQueriesByMeanTime.asTable(name='Query Statistics', format='table')
      + g.panel.table.queryOptions.withTransformationsMixin([
        {
          id: 'sortBy',
          options: {
            fields: {},
            sort: [{ field: 'Value', desc: true }],
          },
        },
      ])
      + g.panel.table.panelOptions.withDescription(
        'Query performance statistics. Requires pg_stat_statements extension.'
      ),
  },
}

