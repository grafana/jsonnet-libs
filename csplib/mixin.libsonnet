local csplib = import './main.libsonnet';

local gcp =
  csplib.new() +
  csplib.withConfigMixin((import './gcpconfig.libsonnet')._config);

local azure =
  csplib.new() +
  csplib.withConfigMixin((import './azureconfig.libsonnet')._config);

gcp.asMonitoringMixin()
+ azure.asMonitoringMixin()
