// Run tk eval test.jsonnet to see how the mixin works.
//TODO: Add tests to the CI similar to the ones in jsonnet-libs/common-lib/common/signal/test_histogram.libsonnet

local lib = (import './jaeger.libsonnet') {
  _config+: {
    cluster: 'CLUSTER',
    namespace: 'NAMESPACE',
    jaeger_agent_host: 'JAEGER_AGENT_HOST',
    with_otel_resource_attrs: true,
  },
};

local container = {
  name: 'nginx',
  image: 'nginx:1.14.2',
  ports: [{ containerPort: 80 }],
};

{
  _config: lib._config,
  _mixin: lib.jaeger_mixin,

  container: container + lib.jaeger_mixin,
}
