local k = import 'ksonnet-util/kausal.libsonnet';
local container = k.core.v1.container;
local service = k.core.v1.service;
local containerPort = k.core.v1.containerPort;
local deployment = k.apps.v1.deployment;

{
  _config:: {
    mysql_user: error 'must specify mysql user',
    mysql_password: error 'must specify mysql password',
    deployment_name: error 'must specify deployment name',
    namespace: error 'must specify namespace',
  },

  image:: 'prom/mysqld-exporter:v0.12.1',

  mysqld_exporter_container::
    container.new('mysqld-exporter', $.image) +
    container.withEnvMap({
      DATA_SOURCE_NAME: '%s:%s@tcp(%s.%s.svc.cluster.local:3306)/' % [
        $._config.mysql_user,
        $._config.mysql_password,
        $._config.deployment_name,
        $._config.namespace,
      ],
    }) +
    container.withPorts(k.core.v1.containerPort.new('http-metrics', 9104)) +
    container.withArgsMixin([
      '--collect.info_schema.innodb_metrics',
    ]),

  mysql_exporter_deployment:
    deployment.new('%s-mysql-exporter' % $._config.deployment_name, 1, [$.mysqld_exporter_container]),

  mysql_exporter_deployment_service:
    k.util.serviceFor($.mysql_exporter_deployment),
}
