{
  local podSecurityPolicy = $.policy.v1beta1.podSecurityPolicy,
  local ranges = podSecurityPolicy.mixin.spec.runAsUser.rangesType,

  cainjector_psp:
    podSecurityPolicy.new() +
    podSecurityPolicy.mixin.metadata
    .withName('cert-manager-cainjector')
    .withLabels({}/* TODO: labels */,)
    .withAnnotations({
      'seccomp.security.alpha.kubernetes.io/allowedProfileNames': 'docker/default',
      'seccomp.security.alpha.kubernetes.io/defaultProfileName': 'docker/default',

      // If apparmor is enabled
      /*
      apparmor.security.beta.kubernetes.io/allowedProfileNames: 'runtime/default',
      apparmor.security.beta.kubernetes.io/defaultProfileName:  'runtime/default',
      */
    },) +
    podSecurityPolicy.mixin.spec
    .withPrivileged(false)
    .withAllowPrivilegeEscalation(false)
    .withAllowedCapabilities([])
    .withVolumes([
      'configMap',
      'emptyDir',
      'projected',
      'secret',
      'downwardAPI',
    ],)
    .withHostNetwork(false)
    .withHostIpc(false)
    .withHostPid(false) +
    podSecurityPolicy.mixin.spec.runAsUser
    .withRule('MustRunAs')
    .withRanges(ranges.new() + ranges.withMin(1000) + ranges.withMax(1000)) +
    podSecurityPolicy.mixin.spec.seLinux.withRule('RunAsAny') +
    podSecurityPolicy.mixin.spec.supplementalGroups
    .withRule('MustRunAs')
    .withRanges(ranges.new() + ranges.withMin(1000) + ranges.withMax(1000)) +
    podSecurityPolicy.mixin.spec.fsGroup
    .withRule('MustRunAs')
    .withRanges(ranges.new() + ranges.withMin(1000) + ranges.withMax(1000)),
}
