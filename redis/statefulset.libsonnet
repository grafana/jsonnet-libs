local k = import 'ksonnet-util/kausal.libsonnet';

{
  local statefulset = k.apps.v1.statefulSet,
  local tolerations = k.core.v1.toleration,
  local container = k.core.v1.container,
  local containerPort = k.core.v1.containerPort,
  local mount = k.core.v1.volumeMount,
  local pvc = k.core.v1.persistentVolumeClaim,
  local storageClass = k.storage.v1.storageClass,
  local envVar = k.core.v1.envVar,

  redis_pvc::
    pvc.new('redis-server-data') +
    pvc.mixin.spec.resources.withRequests({ storage: $._config.redis.diskSize }) +
    pvc.mixin.spec.withAccessModes(['ReadWriteOnce']) +
    pvc.mixin.spec.withStorageClassName('fast'),

  redis_antiaffinity:: {
    weight: 100,
    podAffinityTerm: {
      topologyKey: 'kubernetes.io/hostname',
      labelSelector: {
        matchExpressions: [{
          key: 'app',
          operator: 'In',
          values: ['redis'],
        }],
      },
    },
  },

  local get_sentinel_id(i) =
    local hash = std.md5('%s\nindex: %d' % ['redis-master.' + $._config.namespace + '.svc.cluster.local', i]);
    std.substr(hash + hash, 0, 40),

  redis_init_container::
    container.new('init', $._images.redis) +
    container.withImagePullPolicy('Always') +
    container.withVolumeMounts(
      [
        mount.new('config', '/config-init/init.sh') + mount.withSubPath('init.sh'),
        mount.new('config', '/config-init/redis.conf') + mount.withSubPath('redis.conf'),
        mount.new('config', '/config-init/sentinel.conf') + mount.withSubPath('sentinel.conf'),
        mount.new('etcredis', '/etc/redis'),
        mount.new('kubectl', '/k8s'),
      ]
    ) +
    container.withEnvMixin(
      std.makeArray(
        $._config.redis.replicas,
        function(i) { name: 'SENTINEL_ID_' + i, value: get_sentinel_id(i) }
      )
    ) +
    container.withEnvMixin([
      envVar.fromSecretRef('REDIS_PASSWORD', $.redis_secrets_name, $.redis_secrets_key),
    ]) +
    container.withCommand([
      '/bin/bash',
      '-c',
      '/config-init/init.sh',
    ]) +
    container.mixin.securityContext.withPrivileged(true),

  redis_server_container::
    container.new('redis-server', $._images.redis) +
    container.withVolumeMounts(
      [
        mount.new('redis-server-data', '/data'),
        mount.new('etcredis', '/etc/redis'),
      ]
    ) +
    container.withImagePullPolicy('Always') +
    container.withPorts([
      {
        name: 'redis-server',
        containerPort: $._config.redis.port,
      },
    ]) +
    container.withEnvMixin([
      envVar.fromSecretRef('REDIS_PASSWORD', $.redis_secrets_name, $.redis_secrets_key),
    ]) +
    container.withCommand(['redis-server', '/etc/redis/redis.conf']) +
    container.mixin.livenessProbe.exec.withCommand([
      '/bin/sh',
      '-c',
      'redis-cli -p %(port)d ping' % $._config.redis,
    ]) +
    container.mixin.readinessProbe.exec.withCommand([
      '/bin/sh',
      '-c',
      'redis-cli -p %(port)d ping' % $._config.redis,
    ]) +
    container.mixin.resources.withLimitsMixin({
      memory: '2Gi',
      cpu: '500m',
    }) +
    container.mixin.resources.withRequestsMixin({
      memory: '1Gi',
      cpu: '100m',
    }),

  redis_sentinel_container::
    container.new('redis-sentinel', $._images.redis) +
    container.withVolumeMounts(
      [
        mount.new('etcredis', '/etc/redis'),
        mount.new('config', '/label.sh') + mount.withSubPath('label.sh'),
        mount.new('kubectl', '/k8s'),
      ]
    ) +
    container.withImagePullPolicy('IfNotPresent') +
    container.withPorts([
      {
        name: 'redis-sentinel',
        containerPort: $._config.redis.sentinel_port,
      },
    ]) +
    container.withEnvMixin([
      envVar.fromSecretRef('REDIS_PASSWORD', $.redis_secrets_name, $.redis_secrets_key),
    ]) +
    container.withCommand(['redis-server', '/etc/redis/sentinel.conf', '--sentinel']) +
    container.mixin.livenessProbe.exec.withCommand([
      '/bin/sh',
      '-c',
      'redis-cli -p %(sentinel_port)d ping' % $._config.redis,
    ]) +
    container.mixin.readinessProbe.exec.withCommand([
      '/bin/sh',
      '-c',
      'redis-cli -p %(sentinel_port)d ping' % $._config.redis,
    ]) +
    container.mixin.resources.withLimitsMixin({
      memory: '500Mi',
      cpu: '500m',
    }) +
    container.mixin.resources.withRequestsMixin({
      memory: '100Mi',
      cpu: '100m',
    }),

  redis_server_exporter_container::
    container.new('redis-server-exporter', $._images.redis_exporter) +
    container.withEnvMixin([
      envVar.fromSecretRef('REDIS_PASSWORD', $.redis_secrets_name, $.redis_secrets_key),
    ]) +
    container.withImagePullPolicy('Always') +
    container.withPorts([
      containerPort.new('http-metrics', 9121),
    ]) +
    container.mixin.resources.withLimitsMixin({
      memory: '200Mi',
      cpu: '200m',
    }) +
    container.mixin.resources.withRequestsMixin({
      memory: '100Mi',
      cpu: '100m',
    }),

  redis_sentinel_exporter_container::
    container.new('redis-sentinel-exporter', $._images.redis_exporter) +
    container.withEnvMap({
      REDIS_ADDR: 'localhost:' + $._config.redis.sentinel_port,
      REDIS_EXPORTER_WEB_LISTEN_ADDRESS: '0.0.0.0:9122',
    }) +
    container.withImagePullPolicy('Always') +
    container.withPorts([
      containerPort.new('http-metrics', 9122),
    ]) +
    container.mixin.resources.withLimitsMixin({
      memory: '200Mi',
      cpu: '200m',
    }) +
    container.mixin.resources.withRequestsMixin({
      memory: '100Mi',
      cpu: '100m',
    }),

  redis_statefulset:
    local sfsVolumes = [
      {
        name: 'config',
        configMap: {
          name: 'redis-config',
          defaultMode: 365,  // 0555
        },
      },
      {
        name: 'etcredis',
        emptyDir: {},
      },
      {
        name: 'kubectl',
        emptyDir: {},
      },
    ];

    statefulset.new(
      'redis',
      $._config.redis.replicas,
      [
        $.redis_server_container,
        $.redis_sentinel_container,
        $.redis_server_exporter_container,
        $.redis_sentinel_exporter_container,
      ],
      [$.redis_pvc],
      {
        app: 'redis',
      },
    ) +
    statefulset.mixin.spec.template.spec.withTolerations(
      tolerations.withKey('type') +
      tolerations.withOperator('Equal') +
      tolerations.withValue('data-node') +
      tolerations.withEffect('NoSchedule')
    ) +
    statefulset.mixin.metadata.withNamespace($._config.namespace) +
    statefulset.mixin.spec.updateStrategy.withType('OnDelete') +
    statefulset.mixin.spec.template.spec.withVolumes(sfsVolumes) +
    statefulset.mixin.spec.withServiceName('redis') +
    statefulset.mixin.spec.template.spec.withServiceAccountName('redis') +
    statefulset.mixin.spec.template.spec.securityContext.withFsGroup(2000) +
    statefulset.mixin.spec.template.spec.affinity.podAntiAffinity.withPreferredDuringSchedulingIgnoredDuringExecution($.redis_antiaffinity) +
    // This label is only necessary while migrating from the old deployment (separate redis-sentinel pods).
    // It is used so that the redis-sentinel service can point to the old sentinel pods, and the
    // new combined pods. It can be removed once the migration is complete.
    statefulset.mixin.spec.template.metadata.withLabelsMixin({ 'redis-sentinel': 'yes' }) +
    statefulset.mixin.metadata.withLabels({ app: 'redis' }) +
    statefulset.mixin.spec.template.spec.withInitContainers($.redis_init_container) +
    statefulset.mixin.spec.template.spec.withTerminationGracePeriodSeconds(30),
}
