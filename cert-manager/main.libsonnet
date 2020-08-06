local generated = import 'generated.libsonnet';
generated {
  _config+:: {
    name: 'cert-manager',
    namespace: error 'must provide namespace',
    chartPrefix: 'cert-manager',
  },
  // Add permanent patches here
}
