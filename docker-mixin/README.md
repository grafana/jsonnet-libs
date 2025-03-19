# Docker mixin

Docker mixin is a set of configurable Grafana dashboards and alerts based on docker observability lib.

Metrics are gathered from cadvisor, logs are gathered using promtail.

## promtail configuration

In order to scrape logs from docker containers, use the following promtail scrape snippet:

```yaml
  - job_name: docker_scrape
    docker_sd_configs:
      - host: unix:///var/run/docker.sock
        refresh_interval: 5s
    relabel_configs:
      - source_labels: ["__meta_docker_container_name"]
        regex: "/(.*)"
        target_label: "container"
      - source_labels: ["__meta_docker_container_log_stream"]
        regex: "(.*)"
        target_label: "stream"
    # pipeline_stages: ...

```
