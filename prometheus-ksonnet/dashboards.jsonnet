local grafanalib = import "lib/grafana.libsonnet";

{
  "k8s-nodes.json": std.toString(
    grafanalib.dashboard("K8s Node Resources") +
    grafanalib.addRow(
      grafanalib.row("Resources") +
      grafanalib.addPanel(
        grafanalib.panel("CPU", 1) +
        grafanalib.queryPanel("1 - sum by (node) (irate(node_cpu{mode=\"idle\"}[1m])) / sum by (node) (irate(node_cpu[1m]))", "{{node}}") +
        { yaxes: grafanalib.yaxes("percentunit") },
      ) +
      grafanalib.addPanel(
        grafanalib.panel("Memory", 2) +
        grafanalib.queryPanel("1 - (node_memory_MemFree + node_memory_Cached + node_memory_Buffers) / node_memory_MemTotal", "{{node}}") +
        { yaxes: grafanalib.yaxes("percentunit") },
      )
    ) +
    grafanalib.addRow(
      grafanalib.row("Resources") +
      grafanalib.addPanel(
        grafanalib.panel("Disk", 3) +
        grafanalib.queryPanel("1 - max by (device, node) (node_filesystem_free{fstype=~\"ext[24]\"}) / max by (device, node) (node_filesystem_size{fstype=~\"ext[24]\"})", "{{node}} - {{device}}") +
        { yaxes: grafanalib.yaxes("percentunit") },
      ),
    ),
  ),

  "k8s-services.json": std.toString(
    grafanalib.dashboard("K8s Service Resources") +
    grafanalib.template("namespace", "kube_service_info", "exported_namespace") +
    grafanalib.addRow(
      grafanalib.row("Resources (by namespace)") +
      grafanalib.addPanel(
        grafanalib.panel("CPU", 1) +
        grafanalib.queryPanel("namespace:container_cpu_usage_seconds_total:sum_rate", "{{namespace}}") +
        grafanalib.stack,
      ) +
      grafanalib.addPanel(
        grafanalib.panel("Memory", 2) +
        grafanalib.queryPanel("namespace:container_memory_usage_bytes:sum", "{{namespace}}") +
        grafanalib.stack +
        { yaxes: grafanalib.yaxes("bytes") },
      )
    ) +
    grafanalib.addRow(
      grafanalib.row("Resources (by service)") +
      grafanalib.addPanel(
        grafanalib.panel("CPU", 3) +
        grafanalib.queryPanel("namespace_name:container_cpu_usage_seconds_total:sum_rate{namespace=\"$namespace\"}", "{{namespace}}/{{label_name}}") +
        grafanalib.stack,
      ) +
      grafanalib.addPanel(
        grafanalib.panel("Memory", 4) +
        grafanalib.queryPanel("namespace_name:container_memory_usage_bytes:sum{namespace=\"$namespace\"}", "{{namespace}}/{{label_name}}") +
        grafanalib.stack +
        { yaxes: grafanalib.yaxes("bytes") },
      ),
    ),
  ),
}
