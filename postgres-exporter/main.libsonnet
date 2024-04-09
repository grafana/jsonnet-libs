local k = import 'ksonnet-util/kausal.libsonnet';

{
  new(
    name,
    data_source_uri='$(HOSTNAME):$(PORT)/postgres',
    data_source_name='',
    ssl=true,
    image='quay.io/prometheuscommunity/postgres-exporter:v0.10.0',
  ):: {
    local this = self,

    local container = k.core.v1.container,
    local containerPort = k.core.v1.containerPort,
    container::
      container.new('postgres-exporter', image)
      + container.withPorts(containerPort.new('http-metrics', 9187))
    ,

    local ssl_suffix =
      if ssl
      then ''
      else '?sslmode=disable',

    local deployment = k.apps.v1.deployment,
    deployment:
      deployment.new(
        name,
        1,
        [
          this.container
          // If data_source_name is not empty, use it instead of data_source_uri
          // with variable name DATA_SOURCE_NAME
          // Otherwise, use data_source_uri with variable name DATA_SOURCE_URI
          + (
            if data_source_name != ''
            then container.withEnvMap({
              DATA_SOURCE_NAME: data_source_name + ssl_suffix,
            })
            else container.withEnvMap({
              DATA_SOURCE_URI: data_source_uri + ssl_suffix,
            })
          ),
        ]
      ),
  },

  // withEnv is used to declare env vars for:
  // DATA_SOURCE_USER
  // DATA_SOURCE_PASS
  // HOSTNAME
  // PORT
  // Argument `env` is an array with k.core.v1.envVar objects
  withEnv(env):: {
    container+:
      k.core.v1.container.withEnv(env),
  },

  withImage(image):: {
    container+:: k.core.v1.container.withImage(image),
  },

  withAutoDiscover():: {
    container+:
      k.core.v1.container.withEnvMixin([
        k.core.v1.envVar.new(
          'PG_EXPORTER_AUTO_DISCOVER_DATABASES',
          'true',
        ),
      ]),
  },

  withExcludeDatabases(databases):: {
    container+:
      k.core.v1.container.withEnvMixin([
        k.core.v1.envVar.new(
          'PG_EXPORTER_EXCLUDE_DATABASES',
          std.join(',', databases),
        ),
      ]),
  },

  withQueriesYaml(content):: {
    container+:
      k.core.v1.container.withVolumeMounts([
        k.core.v1.volumeMount.new(
          'queries-yaml',
          '/etc/pg_exporter/queries.yaml',
        ),
      ])
      + k.core.v1.configMap.new('queries-yaml', {
        'queries.yaml': content,
      })
      + k.core.v1.container.withEnvMixin([
        envVar.new('PG_EXPORTER_EXTEND_QUERY_PATH', '/etc/pg_exporter/queries.yaml'),
      ]),
  },
}
