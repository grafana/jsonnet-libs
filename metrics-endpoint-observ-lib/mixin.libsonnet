local observlib = import './main.libsonnet';

local metricsEndpoint =
  observlib.new()
  + observlib.withConfigMixin({});

// populate monitoring-mixin:
metricsEndpoint.asMonitoringMixin()
