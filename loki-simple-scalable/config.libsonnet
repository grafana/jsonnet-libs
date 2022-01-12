local k = import 'ksonnet-util/kausal.libsonnet',
      statefulSet = k.apps.v1.statefulSet;

{
  _config+:: {
    loki+: {},
    commonArgs: {
      'config.file': '/etc/loki/config.yaml',
    },
    config_hash_mixin:
      statefulSet.mixin.spec.template.metadata.withAnnotationsMixin({
        config_hash: std.md5(std.toString($._config.loki)),
      }),
  },

  local configMap = k.core.v1.configMap,

  config_file:
    configMap.new('loki') +
    configMap.withData({
      'config.yaml': k.util.manifestYaml($._config.loki),
    }),

  local deployment = k.apps.v1.deployment,

}
