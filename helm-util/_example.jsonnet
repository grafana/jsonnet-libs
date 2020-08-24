local helm = import 'github.com/grafana/jsonnet-libs/helm-util/helm.libsonnet';

{
  // render the Grafana Chart at version 5.5.5
  grafana: helm.template('grafana', 'grafana', {
    values: {
      persistence: { enabled: true },
      plugins: ['grafana-clock-panel'],
    },
    flags: ['--version=5.5.5'],
  }),
}
