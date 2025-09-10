local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this)::
    {
      local signals = this.signals,

      //
      // Serving Overview Dashboard Panels
      //

      serving_modelRequestRatePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Model request rate',
          targets=[
            signals.serving.requestCount.asTarget(),
          ],
          description='Rate of requests over time for the selected model. Grouped by statuses.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      serving_modelPredictRequestLatencyPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Model predict request latency',
          targets=[
            signals.serving.requestLatency.asTarget(),
          ],
          description='Average request latency of predict requests for the selected model.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('µs')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      serving_modelPredictRuntimeLatencyPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Model predict runtime latency',
          targets=[
            signals.serving.runtimeLatency.asTarget(),
          ],
          description='Average runtime latency to fulfill a predict request for the selected model.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('µs')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      serving_batchQueuingLatencyPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Batch queuing latency',
          targets=[
            signals.serving.batchQueuingLatency.asTarget(),
          ],
          description='Average batch queuing latency for the selected model.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('µs')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      serving_batchQueueThroughputPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Batch queue throughput',
          targets=[
            signals.serving.batchQueuingRate.asTarget(),
          ],
          description='Rate of batch queuing operations.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('batches/s')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      core_graphBuildCallsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Graph build calls',
          targets=[
            signals.core.graphBuildCalls.asTarget(),
          ],
          description='Number of graph build calls over time.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('calls')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      core_graphRunsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Graph runs',
          targets=[
            signals.core.graphRuns.asTarget(),
          ],
          description='Number of graph runs over time.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('runs')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      core_graphBuildTimePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Average graph build time',
          targets=[
            signals.core.graphBuildTime.asTarget(),
          ],
          description='Average time taken to build graphs.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('µs')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      core_graphRunTimePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Average graph run time',
          targets=[
            signals.core.graphRunTime.asTarget(),
          ],
          description='Average time taken to run graphs.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('µs')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),
    },
}
