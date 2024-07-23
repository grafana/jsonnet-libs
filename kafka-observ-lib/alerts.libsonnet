{
  new(this): {
    groups: [
      {
        name: this.config.uid + '-alerts',
        rules:
          [
            {
              alert: 'KafkaLagKeepsIncreasing',
              expr: 'sum without (partition) (delta(%s[5m]) > 0)' %
                    [
                      this.signals.consumerGroup.consumerGroupLag.asRuleExpression(),
                    ],
              'for': '30m',
              keep_firing_for: '10m',
              labels: {
                severity: 'warning',
              },
              annotations: {
                summary: 'Kafka lag keeps increasing.',
                description: 'Kafka lag keeps increasing over the last 15 minutes for consumer group: {{$labels.consumergroup}}, topic: {{$labels.topic}}.',
              },
            },
          ],
      },
    ],
  },
}
