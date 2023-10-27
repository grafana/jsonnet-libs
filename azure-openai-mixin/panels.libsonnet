local g = import './g.libsonnet';
local commonlib = import 'github.com/grafana/jsonnet-libs/common-lib/common/main.libsonnet';
local utils = commonlib.utils;
{
  new(this):
    {
      local t = this.grafana.targets,
      totalCalls: commonlib.panels.generic.stat.base.new(
        'Total calls',
        targets=[t.totalCalls]
      ),
      successCalls: commonlib.panels.generic.stat.base.new(
        'Successful calls',
        targets=[t.successfulCalls]
      ),
      successRate: commonlib.panels.generic.stat.base.new(
        'Average success rate',
        targets=[t.successRate]
      ),
      totalErrors: commonlib.panels.generic.stat.base.new(
        'Total errors',
        targets=[t.totalErrors]
      ),
      errorsRate: commonlib.panels.generic.stat.base.new(
        'Errors rate',
        targets=[t.errorsRate]
      ),
      generatedTokens: commonlib.panels.generic.stat.base.new(
        'Generated tokens',
        targets=[t.generatedTokens]
      ),
      processedPromptTokens: commonlib.panels.generic.stat.base.new(
        'Processed prompt tokens',
        targets=[t.processedPromptTokens]
      ),
      tokenTransactions: commonlib.panels.generic.stat.base.new(
        'Token transactions',
        targets=[t.processedPromptTokens]
      ),
      processedInferenceTokens: commonlib.panels.generic.stat.base.new(
        'Processed inference tokens',
        targets=[t.processedInferenceTokens]
      ),
      rateLimitedCalls: commonlib.panels.generic.stat.base.new(
        'Rate limited calls',
        targets=[t.rateLimitedCalls]
      ),
      blockedCalls: commonlib.panels.generic.stat.base.new(
        'Blocked calls',
        targets=[t.blockedCalls]
      ),
      clientErrors: commonlib.panels.generic.stat.base.new(
        'Client errors',
        targets=[t.clientErrors]
      ),
      fineTunedTrainingHours: commonlib.panels.generic.stat.base.new(
        'Fine-tuned training hours',
        targets=[t.clientErrors]
      ),
      dataIn: commonlib.panels.generic.stat.base.new(
        'Data in',
        targets=[t.clientErrors]
      ),
      dataOut: commonlib.panels.generic.stat.base.new(
        'Data out',
        targets=[t.clientErrors]
      ),
      // create ts panel using commonlib
      timeSeriesPanel1:
        commonlib.panels.generic.timeSeries.base.new(
          'TS panel 1',
          targets=[
            t.metric2,
          ],
          description=|||
            Panel 1 description
          |||
        ),
      // create panel using grafonnet directly
      // https://grafana.github.io/grafonnet/API/panel/index.html
      timeSeriesPanel2:
        g.panel.timeSeries.new(
          title='TS Panel 2',
        )
        + g.panel.timeSeries.queryOptions.withTargets(t.metric3)
        + g.panel.timeSeries.standardOptions.withUnit('seconds'),

      overviewTable1:
        g.panel.table.new(
          title='Table 1'
        ),
    },
}
