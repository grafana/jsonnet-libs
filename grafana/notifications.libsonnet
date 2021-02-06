local k = import 'k.libsonnet';

{
  local configMap = k.core.v1.configMap,

  grafanaNotificationChannels+:: {},
  grafanaNotificationChannelLabels+:: {},

  notificationChannel: {
    new(name, type, uid, org_id, settings, is_default=false, send_reminders=true, frequency='1h', disable_resolve_message=false):: {
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
    withLabel(name, value):: {
      [name]: value,
    },
  },

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
