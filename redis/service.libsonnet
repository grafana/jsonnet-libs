local k = import 'ksonnet-util/kausal.libsonnet';

{
  local service = k.core.v1.service,
  local servicePort = k.core.v1.servicePort,

  redis_master_service:
    service.new(
      'redis-master',
      {
        app: 'redis',
      },
      [
        servicePort.newNamed('redis', $._config.redis.port, $._config.redis.port) + servicePort.withProtocol('TCP'),
      ]
    ) +
    service.mixin.spec.withType('ClusterIP') +
    service.mixin.metadata.withNamespace($._config.namespace) +
    service.mixin.metadata.withLabels({ app: 'redis' }) +
    service.mixin.spec.withSelector({
      app: 'redis',
      'redis-role': 'master',
    }),

  redis_slave_service:
    service.new(
      'redis-slave',
      {
        app: 'redis',
      },
      [
        servicePort.newNamed('redis', $._config.redis.port, $._config.redis.port) + servicePort.withProtocol('TCP'),
      ]
    ) +
    service.mixin.spec.withType('ClusterIP') +
    service.mixin.metadata.withNamespace($._config.namespace) +
    service.mixin.metadata.withLabels({ app: 'redis' }) +
    service.mixin.spec.withSelector({
      app: 'redis',
      'redis-role': 'slave',
    }),

  redis_sentinel_service:
    service.new(
      'redis-sentinel',
      {
        app: 'redis',
      },
      [
        servicePort.newNamed('redis-sentinel', $._config.redis.sentinel_port, $._config.redis.sentinel_port) + servicePort.withProtocol('TCP'),
      ]
    ) +
    service.mixin.spec.withType('ClusterIP') +
    service.mixin.metadata.withNamespace($._config.namespace) +
    service.mixin.metadata.withLabels({ app: 'redis' }) +
    service.mixin.spec.withSelector({
      app: 'redis',
      // This label can be removed once existing redis deployments are migrated
      // to this new config (server and sentinel in same pod).
      'redis-sentinel': 'yes',
    }),
}
