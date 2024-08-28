local golanglib = import './main.libsonnet';

local golang =
  golanglib.new()
  + golanglib.withConfigMixin(
    {
      filteringSelector: 'job!=""',
      metricsSource: ['otel', 'prometheus'],
    }
  );

// populate monitoring-mixin:
golang.asMonitoringMixin()
