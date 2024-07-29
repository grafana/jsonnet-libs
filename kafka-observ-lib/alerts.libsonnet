{
  new(this): {
    groups+: [
      {
        name: this.config.uid + '-kafka-alerts',
        rules:
          [
            {
              alert: 'KafkaLagKeepsIncreasing',
              expr: 'sum without (partition) (delta(%s[5m]) > 0)' %
                    [
                      this.signals.consumerGroup.consumerGroupLag.asRuleExpression(),
                    ],
              'for': '15m',
              keep_firing_for: '10m',
              labels: {
                severity: 'warning',
              },
              annotations: {
                summary: 'Kafka lag keeps increasing.',
                description: 'Kafka lag keeps increasing over the last 15 minutes for consumer group: {{$labels.consumergroup}}, topic: {{$labels.topic}}.',
              },
            },
            {
              alert: 'KafkaLagIsTooHigh',
              expr: 'sum without (partition) (%s) > %s' %
                    [
                      this.signals.consumerGroup.consumerGroupLag.asRuleExpression(),
                      this.config.alertKafkaLagTooHighThreshold,
                    ],
              'for': '15m',
              keep_firing_for: '5m',
              labels: {
                severity: this.config.alertKafkaLagTooHighSeverity,
              },
              annotations: {
                summary: 'Kafka lag is too high.',
                description: 'Total kafka lag across all partitions is too high ({{ printf "%.0f" $value }}) for consumer group: {{$labels.consumergroup}}, topic: {{$labels.topic}}.',
              },
            },
          ],
      },
    ],
  },
}
