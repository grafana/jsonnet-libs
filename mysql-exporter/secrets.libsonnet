local k = import 'ksonnet-util/kausal.libsonnet';
local container = k.core.v1.container;
local envVar = k.core.v1.envVar;


{
  withSecretPassword(name, key='password'):: {
    mysqld_exporter_env+:: {
      MYSQL_PASSWORD:: '',
    },
    mysqld_exporter_container+::
      container.withEnvMixin([
        envVar.fromSecretRef('MYSQL_PASSWORD', name, key),
      ]),
  },
}
