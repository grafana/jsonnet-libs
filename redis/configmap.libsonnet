local k = import 'ksonnet-util/kausal.libsonnet';

{
  local configMap = k.core.v1.configMap,

  local parallel_syncs = std.floor($._config.redis.replicas / 2),
  local quorum = std.ceil($._config.redis.replicas / 2),
  local master_group = 'redis-master.' + $._config.namespace + '.svc.cluster.local',
  local bufferLimits = $._config.redis.clientOutputBufferLimits,
  local formatBufferLimits(limits) = std.join(' ', [limits.hardLimit, limits.softLimit, std.toString(limits.softSeconds)]),

  redis_config_map:
    configMap.new('redis-config')
    + configMap.mixin.metadata.withNamespace($._config.namespace)
    + configMap.withData({
      'label.sh': importstr 'files/label.sh',
      'init.sh': std.format(
        importstr 'files/init.sh',
        {
          quorum: quorum,
          redis_port: $._config.redis.port,
          sentinel_port: $._config.redis.sentinel_port,
          master_group: master_group,
        }
      ),
      'redis.conf': std.format(
        importstr 'files/redis.conf',
        {
          redis_port: $._config.redis.port,
          master_group: master_group,
          sentinel_port: $._config.redis.sentinel_port,
          timeout: $._config.redis.timeout,
          clientOutputBufferLimitsNormal: formatBufferLimits(bufferLimits.normal),
          clientOutputBufferLimitsSlave: formatBufferLimits(bufferLimits.slave),
          clientOutputBufferLimitsPubsub: formatBufferLimits(bufferLimits.pubsub),
          extraConfig: $._config.redis.extra_config,
        },
      ),
      'sentinel.conf': std.format(
        importstr 'files/sentinel.conf',
        {
          master_group: master_group,
          down_after_milliseconds: $._config.redis.down_after_milliseconds,
          parallel_syncs: parallel_syncs,
          sentinel_port: $._config.redis.sentinel_port,
        },
      ),
    }),
}
