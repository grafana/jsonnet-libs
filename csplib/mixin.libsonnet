local csplib = import './main.libsonnet';

local gcp =
  csplib.new() +
  csplib.withConfigMixin((import './gcpconfig.libsonnet')._config);

gcp.asMonitoringMixin()