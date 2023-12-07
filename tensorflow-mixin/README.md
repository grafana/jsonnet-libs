# TensorFlow Serving Mixin

The TensorFlow Serving mixin is a set of configurable Grafana dashboards and alerts based on the metrics available from an instance of TensorFlow Serving.

The TensorFlow Serving mixin contains the following dashboards:
- TensorFlow Serving Overview

The TensorFlow Serving mixin contains the following alerts:

- TensorFlowModelRequestHighErrorRate
- TensorFlowHighBatchQueuingLatency

## TensorFlow Serving Overview

The TensorFlow Serving Overview dashboard provides details on model runs, graph builds, graph runs, batch queue, and container logs. To get TensorFlow Serving docker container logs, [Promtail and Loki needs to be installed](https://grafana.com/docs/loki/latest/installation/) and [provisioned for logs with your Grafana instance](https://grafana.com/docs/loki/latest/clients/promtail/configuration/#docker_sd_config). In addition, a label needs to be created in the Promtail config to match the Prometheus `instance` label.

![First screenshot of the overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/tensorflow/screenshots/tensorflow_overview_1.png)
![Second screenshot of the overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/tensorflow/screenshots/tensorflow_overview_2.png)

TensorFlow Serving container logs are enabled by default in the `config.libsonnet` and can be removed by setting `enableLokiLogs` to `false`. Then run `make` again to regenerate the dashboard:

```
{
  _config+:: {
    enableLokiLogs: false,
  },
}
```

## Alerts Overview

| Alert                     | Description                                                                                                                                        |
| ------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| TensorFlowServingModelRequestHighErrorRate | The TensorFlow Serving requests for a model have a large percentage of failures. Could be indicative that the model for the instance is experiencing serious problems. |
| TensorFlowServingHighBatchQueuingLatency | The TensorFlow Serving queued batches are spending a long time in the queue. Could be indicative of problems with the batch queuing for the instance. |

## Generating dashboards and alerts

```bash
make
```

Creates a generated `dashboards_out` directory and `prometheus_alerts.yaml` that can be imported into Grafana and Prometheus, respectively.

For more advanced uses of mixins, see [mixin documentation.](
https://github.com/monitoring-mixins/docs)