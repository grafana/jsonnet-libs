local k = import 'ksonnet-util/kausal.libsonnet';

{
  _config+:: {
    cluster: error 'Must define a cluster',
    namespace: error 'Must define a namespace',
    jaeger_agent_host: null,
    with_otel_resource_attrs: false,
  },

  local container = k.core.v1.container,

  jaeger_mixin::
    if $._config.jaeger_agent_host == null
    then {}
    else
      local jaegerTags = if $._config.with_otel_resource_attrs then
        'namespace=%s,service.namespace=%s,cluster=%s' % [$._config.namespace, $._config.namespace, $._config.cluster]
      else
        'namespace=%s,cluster=%s' % [$._config.namespace, $._config.cluster];
      container.withEnvMixin([
        container.envType.new('JAEGER_AGENT_HOST', $._config.jaeger_agent_host),
        container.envType.new('JAEGER_TAGS', jaegerTags),
        container.envType.new('JAEGER_SAMPLER_MANAGER_HOST_PORT', 'http://%s:5778/sampling' % $._config.jaeger_agent_host),
      ]),
}
