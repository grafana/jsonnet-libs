// add dashboards from kafka-observ-lib(topic and consumer group overview dashboard):
local kafkalib = import 'kafka-observ-lib/main.libsonnet';
local config = (import 'config.libsonnet')._config;
local kafka =
  kafkalib.new()
  + kafkalib.withConfigMixin(
    {
      filteringSelector: config.kafkaFilteringSelector,
      zookeeperfilteringSelector: config.zookeeperFilteringSelector,
      groupLabels: config.groupLabels,
      instanceLabels: config.instanceLabels,
      dashboardTags: config.dashboardTags,
      metricsSource: 'grafanacloud',
    }
  );

// generate monitoring-mixin format from kafka-observ-lib
kafka.asMonitoringMixin() +
// json dashboards and alerts:
(import 'dashboards/dashboards.libsonnet') +
(import 'config.libsonnet')
