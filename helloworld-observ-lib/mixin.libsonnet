local helloworldlib = import './main.libsonnet';

local helloworld =
  helloworldlib.new()
  + helloworldlib.withConfigMixin(
    {
      filteringSelector: 'job=~"integrations/helloworld"',
      uid: 'myhelloworld',
      groupLabels: ['environment', 'cluster', 'job'],
      instanceLabels: ['instance'],
      // disable loki logs
      enableLokiLogs: false,
    }
  );

// populate monitoring-mixin:
helloworld.asMonitoringMixin()
