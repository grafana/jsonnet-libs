// Retrofit hidden types from ksonnet-lib
// This list is likely to be incomplete.
{
  core+: {
    v1+: {
      container:: $.apps.v1.deployment.mixin.spec.template.spec.containersType,
      containerPort:: $.core.v1.container.portsType,
      envVar:: $.core.v1.container.envType,
      envFromSource:: $.core.v1.container.envFromType,
      servicePort:: $.core.v1.service.mixin.spec.portsType,
      toleration:: $.apps.v1.deployment.mixin.spec.template.spec.tolerationsType,
      volume:: $.core.v1.pod.mixin.spec.volumesType,
      volumeMount:: $.core.v1.container.volumeMountsType,
    },
  },
  rbac+: {
    v1beta1+: {
      policyRule:: $.rbac.v1beta1.clusterRole.rulesType,
      subject:: $.rbac.v1beta1.clusterRoleBinding.subjectsType,
    },
  },
}
