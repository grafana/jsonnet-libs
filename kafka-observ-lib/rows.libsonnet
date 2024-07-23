local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(panels, type):: {
    topic: [
      g.panel.row.new('Topic overview'),
      // + g.panel.row.withCollapsed(false)
      // + g.panel.row.withPanels(
      //   [
      panels.topic.topicTable { gridPos+: { w: 24, h: 8 } },
      panels.topic.topicMessagesPerSec { gridPos+: { w: 24, h: 8 } },
      panels.topic.topicBytesInPerSec { gridPos+: { w: 12, h: 6 } },
      panels.topic.topicBytesOutPerSec { gridPos+: { w: 12, h: 6 } },
      //   ]
      // ),
    ],
    consumerGroup: [
      g.panel.row.new('Consumer group'),
      // + g.panel.row.withCollapsed(false)
      // + g.panel.row.withPanels(
      //   [
      panels.consumerGroup.consumerGroupTable { gridPos+: { w: 24, h: 8 } },
      panels.consumerGroup.consumerGroupConsumeRate { gridPos+: { w: 12, h: 8 } },
      panels.consumerGroup.consumerGroupLag { gridPos+: { w: 12, h: 8 } },
      //   ]
      // ),
    ],
  },
}
