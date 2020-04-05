{
  local configMap = $.core.v1.configMap,

  /*
    to add datasources:

    grafanaDatasources+:: {
      'my-datasource.yml': $.grafana_datasource(name, url, default, method),
      'secure-datasource.yml': $.grafana_datasource_with_basicauth(name, url, username, password, default, method),
    },
  */
  grafanaDatasources+:: {},

  // Generates yaml string containing datasource config
  grafana_datasource(name, url, default=false, method='GET')::
    $.util.manifestYaml({
      apiVersion: 1,
      datasources: [{
        name: name,
        type: 'prometheus',
        access: 'proxy',
        url: url,
        isDefault: default,
        version: 1,
        editable: false,
        jsonData: {
          httpMethod: method,
        },
      }],
    }),

  /*
    helper to allow adding datasources directly to the datasource_config_map
    eg:

    grafana_datasource_config_map+:
      $.grafana_add_datasource(name, url, default, method),
  */
  grafana_add_datasource(name, url, default=false, method='GET')::
    configMap.withDataMixin({
      ['%s.yml' % name]: $.grafana_datasource(name, url, default, method),
    }),

  // Generates yaml string containing datasource config
  grafana_datasource_with_basicauth(name, url, username, password, default=false, method='GET')::
    $.util.manifestYaml({
      apiVersion: 1,
      datasources: [{
        name: name,
        type: 'prometheus',
        access: 'proxy',
        url: url,
        isDefault: default,
        version: 1,
        editable: false,
        basicAuth: true,
        basicAuthUser: username,
        basicAuthPassword: password,
        jsonData: {
          httpMethod: method,
        },
      }],
    }),

  /*
   helper to allow adding datasources directly to the datasource_config_map
   eg:

   grafana_datasource_config_map+:
     $.grafana_add_datasource_with_basicauth(name, url, username, password, default, method),
  */
  grafana_add_datasource_with_basicauth(name, url, username, password, default=false, method='GET')::
    configMap.withDataMixin({
      ['%s.yml' % name]: $.grafana_datasource_with_basicauth(name, url, username, password, default, method),
    }),

  grafana_datasource_config_map:
    configMap.new('grafana-datasources') +
    configMap.withDataMixin({
      [name]: std.toString($.grafanaDatasources[name])
      for name in std.objectFields($.grafanaDatasources)
    }) +
    configMap.mixin.metadata.withLabels($._config.grafana_datasource_labels),
}
