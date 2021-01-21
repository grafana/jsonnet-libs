local k = import 'github.com/grafana/jsonnet-libs/ksonnet-util/kausal.libsonnet';
local container = k.core.v1.container;
local service = k.core.v1.service;
local containerPort = k.core.v1.containerPort;
local deployment = k.apps.v1.deployment;
local envVar = k.core.v1.envVar;
local volumeMount = k.core.v1.volumeMount;

{
  image:: 'prom/mysqld-exporter:v0.12.1',
  mysql_fqdn:: '',

  _config:: {
    mysql_user: error 'must specify mysql user',
    mysql_password: '',
    mysql_password_secret: '',
    deployment_name: error 'must specify deployment name',
    namespace: error 'must specify namespace',
  },

<<<<<<< HEAD
  image:: 'prom/mysqld-exporter:v0.12.1',
  mysql_fqdn:: '',

  mysqld_exporter_container::
    container.new('mysqld-exporter', $.image) +
    container.withEnvMap(if std.length($.mysql_fqdn) > 0 then {
      DATA_SOURCE_NAME: '%s:%s@tcp(%s:3306)/' % [
        $._config.mysql_user,
        $._config.mysql_password,
        $.mysql_fqdn,
      ],
    } else {
      DATA_SOURCE_NAME: '%s:%s@tcp(%s.%s.svc.cluster.local:3306)/' % [
        $._config.mysql_user,
        $._config.mysql_password,
=======
  init_container::
    container.new('init', 'busybox') +
    container.withEnvMap(if std.length($.mysql_fqdn) > 0 then {
      MYSQL_HOST: $.mysql_fqdn,
    } else {
      MYSQL_HOST: '%s.%s.svc.cluster.local' % [
>>>>>>> Add init container which creates my.cnf
        $._config.deployment_name,
        $._config.namespace,
      ],
    }) +
    container.withEnvMixin(
      [
        { name: 'MYSQL_USER', value: $._config.mysql_user },
        // use mysql_password or mysql_password_secret
      ] + if std.length($._config.mysql_password) > 0 then [
        { name: 'MYSQL_PASSWORD', value: $._config.mysql_password },
      ] else if std.length($._config.mysql_password_secret) > 0 then [
        envVar.fromSecretRef('MYSQL_PASSWORD', $._config.mysql_password_secret, 'password'),
      ] else error 'must define either _config.mysql_password or _config.mysql_password_secret'
    ) +
    container.withCommand([
      '/bin/sh',
      '-c',
      |||
        cat << EOF | tee /init-dir/my.cnf > /dev/null
        [client]
        user = $(MYSQL_USER)
        password = $(MYSQL_PASSWORD)
        host = $(MYSQL_HOST)
        EOF
      |||,
    ],) +
    container.withVolumeMounts([
      volumeMount.new('init-dir', '/init-dir'),
    ]),

  mysqld_exporter_container::
    container.new('mysqld-exporter', $.image) +
    container.withPorts(k.core.v1.containerPort.new('http-metrics', 9104)) +
    container.withArgsMixin([
      '--collect.info_schema.innodb_metrics',
      '--config.my-cnf=/etc/mysql/my.cnf',
    ]) +
    container.withVolumeMounts([
      volumeMount.new('init-dir', '/etc/mysql'),
    ]),

  local volume = k.core.v1.volume,
  mysql_exporter_deployment:
    deployment.new('%s-mysql-exporter' % $._config.deployment_name, 1, [$.mysqld_exporter_container]) +
    deployment.spec.template.spec.withInitContainers($.init_container) +
    deployment.spec.template.spec.withVolumes(volume.fromEmptyDir('init-dir')),

  mysql_exporter_deployment_service:
    k.util.serviceFor($.mysql_exporter_deployment),
}
