// this file is provided for the reference. Import main.libsonnet instead into your mixin like below:

local proclib = import './main.libsonnet';

local proc =
  proclib.new()
  + proclib.withConfigMixin(
    {
      filteringSelector: 'job!=""',
      metricsSource: 'java_otel',
    }
  );

// populate monitoring-mixin:
proc.asMonitoringMixin()
