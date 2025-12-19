# Pinecone Mixin

The Pinecone mixin is a set of configurable Grafana dashboards and alerts based on the metrics exported by the [Pinecone Prometheus exporter](https://docs.pinecone.io/guides/production/monitoring#monitor-with-prometheus).

## Dashboards

- **Pinecone Overview** - Provides details on index capacity, operation metrics (upsert, query, fetch, delete), operation durations, and resource usage (read/write units).

## Alerts

| Alert | Summary |
| ----- | ------- |
| PineconeHighQueryLatency | Query latency exceeds baseline thresholds, indicating performance degradation in query operations. |
| PineconeHighUpsertLatency | Upsert latency exceeds baseline thresholds, indicating performance degradation in upsert operations. |
| PineconeHighErrorRate | Error rate exceeds configured thresholds, indicating increased request failures. |
| PineconeHighStorageUsage | Index storage usage is high, risking degraded performance. |
| PineconeHighUnitConsumption | Read or write unit consumption is increasing rapidly or nearing allocated limits. |

Alert thresholds can be configured in `config.libsonnet`. See the generated `prometheus_alerts.yaml` for default values.

## Configuration

This mixin is designed to work with Pinecone's built-in Prometheus exporter, which is available on Standard and Enterprise plans. 

### Alloy

To monitor all serverless indexes in a project using Alloy, add the following to your Alloy configuration:

```alloy
prometheus.scrape "pinecone" {
  targets = discovery.http "pinecone" {
    url = "https://api.pinecone.io/prometheus/projects/PROJECT_ID/metrics/discovery"
    refresh_interval = "1m"
    authorization {
      type = "Bearer"
      credentials = "API_KEY"
    }
  }.targets
  forward_to = [prometheus.remote_write.metrics.receiver]
}

prometheus.remote_write "metrics" {
  endpoint {
    url = "YOUR_PROMETHEUS_REMOTE_WRITE_ENDPOINT"
  }
}
```

Replace `PROJECT_ID` and `API_KEY` with your Pinecone project ID and API key. For more details, see the [Pinecone monitoring documentation](https://docs.pinecone.io/guides/production/monitoring#monitor-with-prometheus).

**Note:** If you have more than one Pinecone project, you need to add separate scrape configurations for each project with different project IDs and targets. It is recommended to add a `project_id` label via relabeling to distinguish metrics from different projects.

#### Alloy (Multiple Projects)

```alloy
discovery.http "pinecone_project_1" {
  url = "https://api.pinecone.io/prometheus/projects/PROJECT_ID_1/metrics/discovery"
  refresh_interval = "1m"
  authorization {
    type = "Bearer"
    credentials = "API_KEY_1"
  }
}

prometheus.scrape "pinecone_project_1" {
  targets = discovery.http.pinecone_project_1.targets
  forward_to = [prometheus.remote_write.metrics.receiver]
  
  relabel {
    source_labels = ["__meta_http_sd_url"]
    regex = ".*/projects/([^/]+)/.*"
    target_label = "project_id"
    replacement = "${1}"
  }
}

discovery.http "pinecone_project_2" {
  url = "https://api.pinecone.io/prometheus/projects/PROJECT_ID_2/metrics/discovery"
  refresh_interval = "1m"
  authorization {
    type = "Bearer"
    credentials = "API_KEY_2"
  }
}

prometheus.scrape "pinecone_project_2" {
  targets = discovery.http.pinecone_project_2.targets
  forward_to = [prometheus.remote_write.metrics.receiver]
  
  relabel {
    source_labels = ["__meta_http_sd_url"]
    regex = ".*/projects/([^/]+)/.*"
    target_label = "project_id"
    replacement = "${1}"
  }
}

prometheus.remote_write "metrics" {
  endpoint {
    url = "YOUR_PROMETHEUS_REMOTE_WRITE_ENDPOINT"
  }
}
```

## Install Tools

To use this mixin, a working Golang toolchain is required, alongside having `mixtool` and `jsonnetfmt` installed. 
To do so, run the following:

```bash
go install github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@latest
go install github.com/monitoring-mixins/mixtool/cmd/mixtool@latest
go install github.com/google/go-jsonnet/cmd/jsonnetfmt@latest
```

## Generate Dashboards and Alerts

Edit `config.libsonnet` if required and then build JSON dashboard files for Grafana:

```bash
make
```

The files in `dashboards_out` need to be imported into your Grafana server. The `prometheus_alerts.yaml` file needs to be imported into Prometheus.

For more advanced uses of mixins, see [Prometheus Monitoring Mixins docs](https://github.com/monitoring-mixins/docs).
