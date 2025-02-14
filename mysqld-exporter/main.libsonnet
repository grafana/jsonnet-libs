local k = import 'ksonnet-util/kausal.libsonnet';
local configMap = k.core.v1.configMap;
local configVolumeMount = k.util.configVolumeMount;
local container = k.core.v1.container;

{
  local root = self,

  new(
    name,
    user,
    host,
    port=3306,
    image='prom/mysqld-exporter:v0.16.0',
    tlsMode='preferred',
    configMapName='%s-cfg' % [name],
  ):: {
    local this = self,
    local versionParts = std.split(std.split(image, ':')[1], '.'),
    local majorVersion = std.parseInt(std.strReplace(versionParts[0], 'v', '')),
    local minorVersion = std.parseInt(versionParts[1]),
    // Ref: https://github.com/prometheus/mysqld_exporter/releases/tag/v0.15.0
    local needsConfigFile = majorVersion > 0 || minorVersion > 14,
    envMap:: {
      MYSQL_USER: user,
      MYSQL_HOST: host,
      MYSQL_PORT: std.toString(port),
      MYSQL_TLS_MODE: tlsMode,
    },

    local containerPort = k.core.v1.containerPort,
    container::
      container.new('mysqld-exporter', image)
      + container.withPorts(k.core.v1.containerPort.new('http-metrics', 9104))
      + container.withArgsMixin(
        [
          '--collect.info_schema.innodb_metrics',
        ] + (if needsConfigFile then [
               '--config.my-cnf=/conf/config.cnf',
             ] else [])
      )
      + container.withEnvMap(this.envMap)
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
            DATA_SOURCE_NAME: '$(MYSQL_USER):$(MYSQL_PASSWORD)@tcp($(MYSQL_HOST):$(MYSQL_PORT))/?tls=$(MYSQL_TLS_MODE)',
          }),
        ]
      ) + (if needsConfigFile then configVolumeMount(configMapName, '/conf') else {}),

    service:
      k.util.serviceFor(this.deployment),

    configMap: (if needsConfigFile then configMap.new(configMapName)
                                        + configMap.withData({
                                          'config.cnf': std.manifestIni({
                                            sections: {
                                              client: {
                                                host: '${MYSQL_HOST}',
                                                port: '${MYSQL_PORT}',
                                                user: '${MYSQL_USER}',
                                                password: '${MYSQL_PASSWORD}',
                                                tls: '${MYSQL_TLS_MODE}',
                                              },
                                            },
                                          }),
                                        }) else {}),
  },

  withPassword(password):: {
    secret:
      k.core.v1.secret.new(
        super.name + '-password',
        {
          password: std.base64(password),
        },
        'Opaque',
      ),

    container+:: root.withPasswordSecretRef(self.secret.metadata.name).container,
  },

  withPasswordSecretRef(secretRefName, key='password'):: {
    local envVar = k.core.v1.envVar,
    container+:: container.withEnvMixin([
      envVar.fromSecretRef('MYSQL_PASSWORD', secretRefName, key),
    ]),
  },

  withImage(image):: {
    container+:: container.withImage(image),
  },

  withTLSMode(mode):: {
    local envVar = k.core.v1.envVar,
    container+:: container.withEnvMixin([
      envVar.new('MYSQL_TLS_MODE', mode),
    ]),
  },

  args:: {
    lockWaitTimeout(timeout):: {
      container+::
        container.withArgsMixin([
          '--exporter.lock_wait_timeout=' + timeout,
        ]),
    },
    collect:: {
      perfSchema(value):: {
        container+::
          container.withArgsMixin([
            '--collect.perf_schema.' + value,
          ]),
      },
      tablelocks:: self.perfSchema('tablelocks'),
      memoryEvents:: self.perfSchema('memory_events'),
    },
  },
}
