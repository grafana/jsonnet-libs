local grafana = import 'grafana/grafana.libsonnet';

{
  prometheus:
    grafana.datasource.new(
      'Prometheus',
      'http://prometheus-server.prometheus',
      'prometheus',
      true,
    ) +
    grafana.datasource.withHttpMethod('POST'),
}
