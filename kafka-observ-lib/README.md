# Kafka observability library

metricsSources:

- `prometheus`: JMX configs from [prometheus/jmx_exporter](https://github.com/prometheus/jmx_exporter/blob/main/example_configs/kafka-2_0_0.yml)
- `grafanacloud`: JMX configs from [kafka-mixin](../kafka-mixin/jmx)

Both sources also uses metrics from https://github.com/danielqsj/kafka_exporter.