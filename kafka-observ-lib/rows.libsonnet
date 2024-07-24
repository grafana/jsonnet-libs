local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(panels, type):: {
    topic: [
      g.panel.row.new('Topics'),
      panels.topic.topicTable { gridPos+: { w: 24, h: 8 } },
      panels.topic.topicMessagesPerSec { gridPos+: { w: 24, h: 8 } },
      panels.topic.topicBytesInPerSec { gridPos+: { w: 12, h: 6 } },
      panels.topic.topicBytesOutPerSec { gridPos+: { w: 12, h: 6 } },
    ],
    consumerGroup:
      [
        g.panel.row.new('Consumer groups'),
        panels.consumerGroup.consumerGroupTable { gridPos+: { w: 24, h: 8 } },
      ]
      +
      if type == 'prometheus' then
        [
          panels.consumerGroup.consumerGroupConsumeRate { gridPos+: { w: 12, h: 8 } },
          panels.consumerGroup.consumerGroupLag { gridPos+: { w: 12, h: 8 } },
        ]
      else if type == 'grafanacloud' then
        [
          panels.consumerGroup.consumerGroupConsumeRate { gridPos+: { w: 8, h: 8 } },
          panels.consumerGroup.consumerGroupLag { gridPos+: { w: 8, h: 8 } },
          panels.consumerGroup.consumerGroupLagTime { gridPos+: { w: 8, h: 8 } },
        ],
  },
}
