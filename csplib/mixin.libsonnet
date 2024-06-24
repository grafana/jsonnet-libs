local csplib = import './main.libsonnet';
local baseconfig = (import './config.libsonnet')._config;

local gcp =
  csplib.new(baseconfig + (import './gcpconfig.libsonnet')._config);

local azure =
  csplib.new(baseconfig + (import './azureconfig.libsonnet')._config);

azure.asMonitoringMixin() + gcp.asMonitoringMixin()
