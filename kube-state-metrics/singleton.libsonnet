local shared_config = import './shared_config.libsonnet';
local kausal = import 'github.com/grafana/jsonnet-libs/ksonnet-util/kausal.libsonnet';

{
  local container = kausal.core.v1.container,
  local containerPort = kausal.core.v1.containerPort,
  container+:: container.withArgs([
    '--port=%s' % shared_config.server_info.port,
    '--telemetry-host=%s' % shared_config.server_info.telemetry_host,
    '--telemetry-port=%s' % shared_config.server_info.telemetry_port,
  ]),

  local deployment = kausal.apps.v1.deployment,
  deployment:
    deployment.new('kube-state-metrics', 1, [self.container])
    + deployment.mixin.spec.template.spec.withServiceAccountName(self.rbac.service_account.metadata.name)
    + deployment.mixin.spec.template.spec.securityContext.withRunAsUser(65534)
    + deployment.mixin.spec.template.spec.securityContext.withRunAsGroup(65534),

  rbac:: shared_config.rbac,
}
