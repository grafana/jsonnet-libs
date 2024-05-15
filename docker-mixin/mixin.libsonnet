local dockerlib = import './main.libsonnet';


local docker =
  dockerlib.new() +
  dockerlib.withConfigMixin((import './config.libsonnet')._config);

docker.asMonitoringMixin()
