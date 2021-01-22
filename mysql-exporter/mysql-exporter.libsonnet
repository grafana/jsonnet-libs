local k = import 'ksonnet-util/kausal.libsonnet';
local container = k.core.v1.container;
local service = k.core.v1.service;
local containerPort = k.core.v1.containerPort;
local deployment = k.apps.v1.deployment;
local envVar = k.core.v1.envVar;


local mysql_credential(config) =
  if std.length(config.mysql_password) > 0 then
    [{ name: 'MYSQL_PASSWORD', value: config.mysql_password }]
  else [envVar.fromSecretRef('MYSQL_PASSWORD', config.mysql_password_secret, config.mysql_password_secret_key)];


local mysql_host(config, fqdn) =
  if std.length(fqdn) > 0 then
    '%s' % fqdn
  else
    '%s.%s.svc.cluster.local' % [
      config.deployment_name,
      config.namespace,
    ];

{
  image:: 'prom/mysqld-exporter:v0.12.1',
  mysql_fqdn:: '',

  _config:: {
    mysql_user: error 'must specify mysql user',
    mysql_password: '',
    mysql_password_secret: '',
    mysql_password_secret_key: 'password',
    deployment_name: '',
    namespace: '',
  },

  assert (
    !(std.length($._config.mysql_password) == 0 && std.length($._config.mysql_password_secret) == 0) &&
    !(std.length($._config.mysql_password) > 0 && std.length($._config.mysql_password_secret) > 0)
  ) : 'mysql-exporter: exactly one of _config.mysql_password and _config.mysql_password_secret must be defined.',

  assert (
    (!(std.length($.mysql_fqdn) == 0 && (std.length($._config.deployment_name) == 0 || std.length($._config.namespace) == 0))) &&
    (!(std.length($.mysql_fqdn) > 0 && !(std.length($._config.deployment_name) == 0 && std.length($._config.namespace) == 0)))
  ) : 'mysql-exporter: exactly one of (_config.deployment_name and _config.namespace) or mysql_fqdn must be specified.',

  mysqld_exporter_container::
    container.new('mysqld-exporter', $.image) +
    container.withPorts(k.core.v1.containerPort.new('http-metrics', 9104)) +
    container.withArgsMixin([
      '--collect.info_schema.innodb_metrics',
    ]) +
    container.withEnvMixin(
      mysql_credential($._config) +
      [
        { name: 'MYSQL_USER', value: $._config.mysql_user },
        { name: 'DATA_SOURCE_NAME', value: '$(MYSQL_USER):$(MYSQL_PASSWORD)@tcp(%s:3306)/' % mysql_host($._config, $.mysql_fqdn) },
      ]
    ),


  mysql_exporter_deployment:
    deployment.new('%s-mysql-exporter' % $._config.deployment_name, 1, [$.mysqld_exporter_container]),

  mysql_exporter_deployment_service:
    k.util.serviceFor($.mysql_exporter_deployment),
}
