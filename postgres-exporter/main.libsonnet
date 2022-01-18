local k = import 'ksonnet-util/kausal.libsonnet';

{
  new(
    name,
    data_source_name='$(USER):$(PASSWORD)@tcp($(HOST):$(PORT))/',
    image='quay.io/prometheuscommunity/postgres-exporter:v0.10.0',
  ):: {
    local this = self,

    local container = k.core.v1.container,
    local containerPort = k.core.v1.containerPort,
    container::
      container.new('postgres-exporter', image)
      + container.withPorts(containerPort.new('http-metrics', 9187))
    ,

    local deployment = k.apps.v1.deployment,
    deployment:
      deployment.new(
        name,
        1,
        [
          this.container
          // Force DATA_SOURCE_NAME to be declared after the variables it references
          + container.withEnvMap({
            DATA_SOURCE_NAME: data_source_name,
          }),
        ]
      ),
  },

  // withEnv is used to declare env vars for USER, PASSWORD, HOST and PORT
  // env is an array with k.core.v1.envVar objects
  withEnv(env):: {
    container+:
      k.core.v1.container.withEnv(env),
  },

  withImage(image):: {
    container+:: k.core.v1.container.withImage(image),
  },
}
