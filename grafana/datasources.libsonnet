local k = import 'ksonnet-util/kausal.libsonnet';
local configMap = k.core.v1.configMap;
{

  addDatasource(name, datasource):: {
    grafanaDatasources+:: {
      [name]: datasource,
    },
  },

  grafanaDatasources+:: {},
  grafanaDatasourceLabels+:: {},

  datasource+:: {
    new(name, url, type, default=false):: {
      name: name,
      type: type,
      access: 'proxy',
      url: url,
      isDefault: default,
      version: 1,
      editable: false,
    },
    withBasicAuth(username, password):: {
      basicAuth: true,
      basicAuthUser: username,
      basicAuthPassword: password,
    },
    withJsonData(data):: {
      jsonData+: data,
    },
    withHttpMethod(httpMethod):: self.withJsonData({ httpMethod: httpMethod }),
  },

  grafana_datasource_config_map:
    configMap.new('grafana-datasources') +
    configMap.withDataMixin({
      ['%s.yml' % name]: k.util.manifestYaml({
        apiVersion: 1,
        datasources: [$.grafanaDatasources[name]],
      })
      for name in std.objectFields($.grafanaDatasources)
    })
    + configMap.mixin.metadata.withLabels($.grafanaDatasourceLabels),
}
