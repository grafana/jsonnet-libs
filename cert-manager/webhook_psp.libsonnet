{
  local podSecurityPolicy = $.policy.v1beta1.podSecurityPolicy,
  local idRange = $.policy.v1beta1.idRange,

  webhook_psp:
    podSecurityPolicy.new('cert-manager-webhook') +
    podSecurityPolicty.metadata.withLabels({}/* TODO: labels */) +
    podSecurityPolicty.metadata.withAnnotations(
      {
        'seccomp.security.alpha.kubernetes.io/allowedProfileNames': 'docker/default',
        'seccomp.security.alpha.kubernetes.io/defaultProfileName': 'docker/default',

        /*
        // If apparmor is enabled:
        'apparmor.security.beta.kubernetes.io/allowedProfileNames': 'runtime/default',
        'apparmor.security.beta.kubernetes.io/defaultProfileName':  'runtime/default'
        */
      },
    ) +
    podSecurityPolicy.spec.withPrivileged(false) +
    podSecurityPolicy.spec.withAllowPrivilegeEscalation(false) +
    podSecurityPolicy.spec.withAllowedCapabilities([]) +
    podSecurityPolicy.spec.withVolumes([
      'configMap',
      'emptyDir',
      'projected',
      'secret',
      'downwardAPI',
    ],) +
    podSecurityPolicy.spec.withHostNetwork(false) +
    podSecurityPolicy.spec.withHostIpc(false) +
    podSecurityPolicy.spec.withHostPid(false) +
    podSecurityPolicy.spec.runAsUser.withRule('MustRunAs') +
    podSecurityPolicy.spec.runAsUser.withRanges(idRange.withMin(1000) + idRange.withMax(1000)) +
    podSecurityPolicy.spec.seLinux.withRule('RunAsAny') +
    podSecurityPolicy.spec.supplementalGroups.withRule('MustRunAs') +
    podSecurityPolicy.spec.supplementalGroups.withRanges(idRange.withMin(1000) + idRange.withMax(1000)) +
    podSecurityPolicy.spec.fsGroup.withRule('MustRunAs') +
    podSecurityPolicy.spec.fsGroup.withRanges(idRange.withMin(1000) + idRange.withMax(1000)),

}
