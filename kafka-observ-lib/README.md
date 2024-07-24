# Kafka observability library

This lib can be used to generate dashboards, rows, panels for Kafka signals.

The library supports two metricsSources:

- `prometheus`: JMX configs from [prometheus/jmx_exporter](https://github.com/prometheus/jmx_exporter/blob/main/example_configs/kafka-2_0_0.yml) and [kafka_exporter](https://github.com/danielqsj/kafka_exporter)
- `grafanacloud`: JMX configs from [kafka-mixin](../kafka-mixin/jmx) and [kafka_exporter fork](https://github.com/grafana/kafka_exporter) (used in grafana-agent/alloy)

## Import

```sh
jb init
jb install https://github.com/grafana/jsonnet-libs/kafka-observ-lib
```



## Example

Kafka topic overview dashboard:
![image](https://github.com/user-attachments/assets/2396de66-f782-4efc-9edf-66af5d836f3e)