local shared_config = import './shared_config.libsonnet';
local kausal = import 'github.com/grafana/jsonnet-libs/ksonnet-util/kausal.libsonnet';

{
  local this = self,

  replicas:: error 'replicas are required',
  name:: error 'name is required',
  namespace:: error 'namespace is required',

  config_file:: '$(POD_NAME).yml',
  config_path:: '/etc/kube-state-metrics',

  rbac:: shared_config.rbac,
  ksm_config:: {
    port: shared_config.server_info.port,
    telemetry_host: shared_config.server_info.telemetry_host,
    telemetry_port: shared_config.server_info.telemetry_port,
  },

  local configMap = kausal.core.v1.configMap,
  config_map: configMap.new('%s-config' % this.name)
              + configMap.withData({
                ['%s-%s.yml' % [this.name, i]]:
                  kausal.util.manifestYaml(
                    this.ksm_config
                    {
                      total_shards: this.replicas,
                      shard: i,
                    }
                  )
                for i in std.range(0, this.replicas - 1)
              }),

  local container = kausal.core.v1.container,
  local containerPort = kausal.core.v1.containerPort,
  local envVar = kausal.core.v1.envVar,
  container:: shared_config.container
              + container.withArgs([
                '--config=%s' % std.join('/', [self.config_path, self.config_file]),
              ])
              + container.withEnvMixin([
                envVar.fromFieldPath('POD_NAME', 'metadata.name'),
              ]),

  local statefulSet = kausal.apps.v1.statefulSet,
  statefulset:
    statefulSet.new(this.name, this.replicas, [self.container])
    + statefulSet.spec.withServiceName(this.name)
    + statefulSet.mixin.spec.template.spec.withServiceAccountName(self.rbac.service_account.metadata.name)
    + statefulSet.mixin.spec.template.spec.securityContext.withRunAsUser(65534)
    + statefulSet.mixin.spec.template.spec.securityContext.withRunAsGroup(65534)
    + statefulSet.configMapVolumeMount(self.config_map, self.config_path)
    + statefulSet.spec.template.spec.affinity.podAntiAffinity.withRequiredDuringSchedulingIgnoredDuringExecution(
      kausal.core.v1.podAffinityTerm.withTopologyKey('kubernetes.io/hostname')
      + kausal.core.v1.podAffinityTerm.labelSelector.withMatchLabels({
        name: this.name,
      })
    ),

  local podDisruptionBudget = kausal.policy.v1.podDisruptionBudget,
  ksm_pdb:
    podDisruptionBudget.new(this.name) +
    podDisruptionBudget.mixin.metadata.withNamespace(this.namespace) +
    podDisruptionBudget.mixin.metadata.withLabels({ name: '%s-pdb' % this.name }) +
    podDisruptionBudget.mixin.spec.selector.withMatchLabels({ name: this.name }) +
    podDisruptionBudget.mixin.spec.withMaxUnavailable(1),
}
