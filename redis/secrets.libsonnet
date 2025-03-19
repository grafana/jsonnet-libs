local k = import 'ksonnet-util/kausal.libsonnet';

{
  local secret = k.core.v1.secret,
  redis_secrets_name:: 'redis-secrets',
  redis_secrets_key:: 'auth',
  redis_secrets:
    secret.new(
      $.redis_secrets_name,
      {
        [$.redis_secrets_key]: std.base64($._config.redis.password),
      },
      'Opaque',
    ) +
    secret.mixin.metadata.withNamespace($._config.namespace),
}
