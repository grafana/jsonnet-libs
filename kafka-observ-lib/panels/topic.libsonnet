local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(signals):: {
    topicBytesInPerSec:
      commonlib.panels.network.timeSeries.traffic.stylize()
      + signals.topic.topicBytesInPerSec.asTimeSeries(),
    topicBytesOutPerSec:
      commonlib.panels.network.timeSeries.traffic.stylize()
      + signals.topic.topicBytesOutPerSec.asTimeSeries(),
    topicMessagesPerSec:
      commonlib.panels.generic.timeSeries.base.stylize()
      + signals.topic.topicMessagesPerSec.asTimeSeries(),

    // Requirements for this table's data
    topicTable:
      signals.topic.topicLogStartOffset.asTable(name='Topic overview', format='time_series')
      + signals.topic.topicLogEndOffset.asTableColumn(format='time_series')
      + signals.topic.topicMessagesPerSecByPartition.asTableColumn(format='time_series')
      + signals.topic.topicLogSize.asTableColumn(format='time_series')
      + g.panel.table.queryOptions.withTransformationsMixin(
        [
          g.panel.table.queryOptions.transformation.withId('filterByValue')
          + g.panel.table.queryOptions.transformation.withOptions(
            {
              filters: [
                {
                  config: {
                    id: 'isNull',
                    options: {},
                  },
                  fieldName: 'Messages in per second',
                },
              ],
              match: 'all',
              type: 'exclude',
            }
          ),

        ]
      ),
  },
}
