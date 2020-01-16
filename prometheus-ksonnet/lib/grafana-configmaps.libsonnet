{
  local configMap = $.core.v1.configMap,

  // Extension point for you to add your own dashboards.
  dashboards+:: {},
  grafana_dashboards+:: {},
  grafanaDashboards+:: $.dashboards + $.grafana_dashboards,

  dashboards_config_map:
    if $._config.dashboard_config_maps > 0
    then {}
    else
      configMap.new('dashboards') +
      configMap.withDataMixin({
        [name]: std.toString($.grafanaDashboards[name])
        for name in std.objectFields($.grafanaDashboards)
      }) +
      configMap.mixin.metadata.withLabels($._config.grafana_dashboard_labels),

  dashboards_config_maps: {
    ['dashboard-%d' % shard]:
      configMap.new('dashboards-%d' % shard) +
      configMap.withDataMixin({
        [name]: std.toString($.grafanaDashboards[name])
        for name in std.objectFields($.grafanaDashboards)
        if std.codepoint(std.md5(name)[1]) % $._config.dashboard_config_maps == shard
      }) +
      configMap.mixin.metadata.withLabels($._config.grafana_dashboard_labels)
    for shard in std.range(0, $._config.dashboard_config_maps - 1)
  },

  grafanaDatasources+:: {},

  grafana_add_datasource(name, url, default=false, method='GET')::
    configMap.withDataMixin({
      ['%s.yml' % name]: $.util.manifestYaml({
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
    }),

  grafana_add_datasource_with_basicauth(name, url, username, password, default=false, method='GET')::
    configMap.withDataMixin({
      ['%s.yml' % name]: $.util.manifestYaml({
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
    }),

  grafana_datasource_config_map:
    configMap.new('grafana-datasources') +
    configMap.withDataMixin({
      [name]: std.toString($.grafanaDatasources[name])
      for name in std.objectFields($.grafanaDatasources)
    }) +
    configMap.mixin.metadata.withLabels($._config.grafana_datasource_labels),

  grafanaNotificationChannels+:: {},

  /*
    to add a notification channel:

    grafanaNotificationChannels+:: {
      'my-notification-channel.yml': grafana_add_notification_channel('my-email', 'email', 'my-email', 1, true, true, '1h', false, {addresses: 'me@example.com'}),
    }
    See https://grafana.com/docs/administration/provisioning/#alert-notification-channels
  */

  grafana_add_notification_channel(name, type, uid, org_id, settings, is_default=false, send_reminders=true, frequency='1h', disable_resolve_message=false)::
    $.util.manifestYaml({
      notifiers: [
        {
          name: name,
          type: type,
          uid: uid,
          org_id: org_id,
          is_default: is_default,
          send_reminders: send_reminders,
          frequency: frequency,
          disable_resolve_message: disable_resolve_message,
          settings: settings,
        },
      ],
    }),

  notification_channel_config_map:
    configMap.new('grafana-notification-channels') +
    configMap.withDataMixin({
      [name]: std.toString($.grafanaNotificationChannels[name])
      for name in std.objectFields($.grafanaNotificationChannels)
    }) +
    configMap.mixin.metadata.withLabels($._config.grafana_notification_channel_labels),

  grafana_plugins+:: [],
}
