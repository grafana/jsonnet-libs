local k = import 'ksonnet-util/kausal.libsonnet';
local container = k.core.v1.container;
local containerPort = k.core.v1.containerPort;
local deployment = k.apps.v1.deployment;

local secrets = import 'secrets.libsonnet';


secrets {
  image:: 'prom/mysqld-exporter:v0.12.1',

  _config:: {
    mysql_user: error 'must specify mysql user',
    mysql_password: '',
    mysql_fqdn:: '%s.%s.svc.cluster.local' % [
      $._config.deployment_name,
      $._config.namespace,
    ],
    deployment_name: '',
    namespace: '',
  },

  mysqld_exporter_env:: {
    MYSQL_USER: $._config.mysql_user,
    MYSQL_PASSWORD: $._config.mysql_password,
    MYSQL_HOST: $._config.mysql_fqdn,
  },

  mysqld_exporter_container::
    container.new('mysqld-exporter', $.image) +
    container.withPorts(k.core.v1.containerPort.new('http-metrics', 9104)) +
    container.withArgsMixin([
      '--collect.info_schema.innodb_metrics',
    ]) +
    container.withEnvMap($.mysqld_exporter_env) +
    // Force DATA_SOURCE_NAME to be declared after the variables it references
    container.withEnvMap({
      DATA_SOURCE_NAME: '$(MYSQL_USER):$(MYSQL_PASSWORD)@tcp($(MYSQL_HOST):3306)/',
    }),

  mysql_exporter_deployment:
    deployment.new('%s-mysql-exporter' % $._config.deployment_name, 1, [$.mysqld_exporter_container]),

  mysql_exporter_deployment_service:
    k.util.serviceFor($.mysql_exporter_deployment),
}
