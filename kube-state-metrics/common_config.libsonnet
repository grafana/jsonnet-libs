local kausal = import 'github.com/grafana/jsonnet-libs/ksonnet-util/kausal.libsonnet';

{
  local this = self,

  image:: error 'image is required',

  server_info:: {
    port: 8080,
    telemetry_host: '0.0.0.0',
    telemetry_port: 8081,
  },

  local container = kausal.core.v1.container,
  local containerPort = kausal.core.v1.containerPort,
  container:: container.new('kube-state-metrics', this.image)
              + container.withPorts([
                containerPort.new('ksm', 8080),
                containerPort.new('self-metrics', 8081),
              ])
              + kausal.util.resourcesRequests('50m', '50Mi')
              + kausal.util.resourcesLimits('250m', '150Mi'),

  local policyRule = kausal.rbac.v1.policyRule,
  rbac:
    kausal.util.rbac('kube-state-metrics', [
      policyRule.new()
      + policyRule.withApiGroups([''])
      + policyRule.withResources([
        'configmaps',
        'secrets',
        'nodes',
        'pods',
        'services',
        'resourcequotas',
        'replicationcontrollers',
        'limitranges',
        'persistentvolumeclaims',
        'persistentvolumes',
        'namespaces',
        'endpoints',
      ])
      + policyRule.withVerbs(['list', 'watch']),

      policyRule.new()
      + policyRule.withApiGroups(['extensions'])
      + policyRule.withResources([
        'daemonsets',
        'deployments',
        'replicasets',
        'ingresses',
      ])
      + policyRule.withVerbs(['list', 'watch']),

      policyRule.new()
      + policyRule.withApiGroups(['apps'])
      + policyRule.withResources([
        'daemonsets',
        'deployments',
        'replicasets',
        'statefulsets',
      ])
      + policyRule.withVerbs(['list', 'watch']),

      policyRule.new()
      + policyRule.withApiGroups(['batch'])
      + policyRule.withResources([
        'cronjobs',
        'jobs',
      ])
      + policyRule.withVerbs(['list', 'watch']),

      policyRule.new()
      + policyRule.withApiGroups(['autoscaling'])
      + policyRule.withResources([
        'horizontalpodautoscalers',
      ])
      + policyRule.withVerbs(['list', 'watch']),

      policyRule.new()
      + policyRule.withApiGroups(['authorization.k8s.io'])
      + policyRule.withResources(['subjectaccessreviews'])
      + policyRule.withVerbs(['create']),

      policyRule.new()
      + policyRule.withApiGroups(['ingresses'])
      + policyRule.withResources(['ingress'])
      + policyRule.withVerbs(['list', 'watch']),

      policyRule.new()
      + policyRule.withApiGroups(['policy'])
      + policyRule.withResources(['poddisruptionbudgets'])
      + policyRule.withVerbs(['list', 'watch']),

      policyRule.new()
      + policyRule.withApiGroups(['certificates.k8s.io'])
      + policyRule.withResources(['certificatesigningrequests'])
      + policyRule.withVerbs(['list', 'watch']),

      policyRule.new()
      + policyRule.withApiGroups(['storage.k8s.io'])
      + policyRule.withResources([
        'storageclasses',
        'volumeattachments',
      ])
      + policyRule.withVerbs(['list', 'watch']),

      policyRule.new()
      + policyRule.withApiGroups(['admissionregistration.k8s.io'])
      + policyRule.withResources([
        'mutatingwebhookconfigurations',
        'validatingwebhookconfigurations',
      ])
      + policyRule.withVerbs(['list', 'watch']),

      policyRule.new()
      + policyRule.withApiGroups(['networking.k8s.io'])
      + policyRule.withResources([
        'networkpolicies',
        'ingresses',
      ])
      + policyRule.withVerbs(['list', 'watch']),

      policyRule.new()
      + policyRule.withApiGroups(['coordination.k8s.io'])
      + policyRule.withResources(['leases'])
      + policyRule.withVerbs(['list', 'watch']),
    ]),
}
