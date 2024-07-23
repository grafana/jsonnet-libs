local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(signals):: {
    consumerGroupLag:
      signals.consumerGroup.consumerGroupLag.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),
    consumerGroupLagTime:
      signals.consumerGroup.consumerGroupLagTime.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),
    consumerGroupConsumeRate:
      signals.consumerGroup.consumerGroupConsumeRate.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),
    consumerGroupTable:
      signals.consumerGroup.consumerGroupConsumeRate.asTable(
        name='Consumer group overview',
        format='time_series'
      )
      + signals.consumerGroup.consumerGroupLag.asTableColumn(override='byName', format='time_series')
      + signals.consumerGroup.consumerGroupLagTime.asTableColumn(override='byName', format='time_series')
      + g.panel.table.queryOptions.withTransformationsMixin(
        [
          g.panel.table.queryOptions.transformation.withId('filterByValue')
          + g.panel.table.queryOptions.transformation.withOptions(
            {
              filters: [
                {
                  fieldName: 'Consumer group consume rate',
                  config: {
                    id: 'isNotNull',
                    options: {},
                  },
                },
              ],
              type: 'include',
              match: 'all',
            }
          ),
        ]
      ),

  },
}
