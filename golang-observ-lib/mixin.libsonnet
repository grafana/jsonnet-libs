local golanglib = import './main.libsonnet';

local golang =
  golanglib.new()
  + golanglib.withConfigMixin(
    {
      filteringSelector: 'job!=""',
    }
  );

// populate monitoring-mixin:
golang.asMonitoringMixin()
