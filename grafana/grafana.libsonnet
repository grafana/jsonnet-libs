(import 'config.libsonnet')
+ (import 'configmaps.libsonnet')
+ (import 'images.libsonnet')
+ (import 'deployment.libsonnet')
+ (import 'dashboards.libsonnet')
+ {

  addDatasource(name, datasource):: {
    grafanaDatasources+:: {
      [name]: datasource,
    },
  },

  addNotificationChannel(name, notifications):: {
    grafanaNotificationChannels+:: {
      [name]: notifications,
    },
  },

  addPlugin(plugin):: {
    plugins+:: [plugin],
  },

  datasource: (import 'datasources.libsonnet'),
  notificationChannel: (import 'notifications.libsonnet'),

  grafanaDashboards+:: {},
  grafanaNotificationChannels+:: {},
  grafanaDatasources+:: {},
  grafanaPlugins+:: [],
}
