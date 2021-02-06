local k = import 'ksonnet-util/kausal.libsonnet';
local configMap = k.core.v1.configMap;
{
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

  notification_channel_config_map:
    configMap.new('grafana-notification-channels') +
    configMap.withDataMixin({
      [name]: $.util.manifestYaml({
        notifiers: [
          $.grafanaNotificationChannels[name],
        ],
      })
      for name in std.objectFields($.grafanaNotificationChannels)
    }) +
    configMap.mixin.metadata.withLabels($.grafanaNotificationChannelLabels),
}