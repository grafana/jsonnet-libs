local node_exporter = import 'github.com/grafana/jsonnet-libs/node-exporter/main.libsonnet';

{
  local exporter =
    node_exporter.new($._images.nodeExporter)
    + (if $._config.node_exporter_mount_root
       then node_exporter.mountRoot()
       else {}),

  node_exporter_container:: exporter.container,

  node_exporter_daemonset:
    (exporter { container:: $.node_exporter_container }).daemonset
    + $.util.podPriority('critical'),

  prometheus_config+:: {
    scrape_configs+: [
      node_exporter.scrape_config($._config.node_exporter_namespace),
    ],
  },
}
