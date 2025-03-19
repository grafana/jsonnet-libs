local config = import './config.libsonnet';
local jvmlib = import 'jvm-observ-lib/main.libsonnet';
local jvm =
  jvmlib.new()
  + jvmlib.withConfigMixin(config);
jvm.asMonitoringMixin()
