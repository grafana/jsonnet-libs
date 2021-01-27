local k = import 'ksonnet-util/kausal.libsonnet';
local container = k.core.v1.container;
local containerPort = k.core.v1.containerPort;
local envVar = k.core.v1.envVar;
local deployment = k.apps.v1.deployment;

{
  image:: 'prom/mysqld-exporter:v0.12.1',
  mysql_fqdn:: '%s.%s.svc.cluster.local' % [
    $._config.deployment_name,
    $._config.namespace,
  ],

  _config:: {
    mysql_user: error 'must specify mysql user',
    mysql_password: '',
    deployment_name: error 'must specify deployment name',
    namespace: error 'must specify namespace',
  },

  mysqld_exporter_env:: {
    MYSQL_USER: $._config.mysql_user,
    MYSQL_PASSWORD: $._config.mysql_password,
    MYSQL_HOST: $.mysql_fqdn,
  },

  // optionally define additional variables before DATA_SOURCE_NAME
  mysql_additional_env_list:: [],

  mysqld_exporter_container::
    container.new('mysqld-exporter', $.image) +
    container.withPorts(k.core.v1.containerPort.new('http-metrics', 9104)) +
    container.withArgsMixin([
      '--collect.info_schema.innodb_metrics',
    ]) +
    container.withEnvMap($.mysqld_exporter_env) +
    container.withEnvMixin($.mysql_additional_env_list) +
    // Force DATA_SOURCE_NAME to be declared after the variables it references
    container.withEnvMap({
      DATA_SOURCE_NAME: '$(MYSQL_USER):$(MYSQL_PASSWORD)@tcp($(MYSQL_HOST):3306)/',
    }),

  mysql_exporter_deployment:
    deployment.new('%s-mysql-exporter' % $._config.deployment_name, 1, [$.mysqld_exporter_container]),

  mysql_exporter_deployment_service:
    k.util.serviceFor($.mysql_exporter_deployment),

  withSecretPassword(name, key='password'):: {
    mysqld_exporter_env+:: {
      MYSQL_PASSWORD:: '',
    },

    mysql_additional_env_list:: [
      envVar.fromSecretRef('MYSQL_PASSWORD', name, key),
    ],
  },
}
