function(noNewEmptyNameMixin) {
  extensions+: {
    v1beta1+: {
      ingress+: noNewEmptyNameMixin,
    },
  },
  networking+: {
    v1beta1+: {
      ingress+: noNewEmptyNameMixin,
    },
  },
  batch+: {
    v1+: {
      job+: noNewEmptyNameMixin,
    },
    v1beta1+: {
      job+: noNewEmptyNameMixin,
    },
  },
  local rbacPatch = {
    role+: noNewEmptyNameMixin,
    clusterRole+: noNewEmptyNameMixin,
    roleBinding+: noNewEmptyNameMixin,
    clusterRoleBinding+: noNewEmptyNameMixin,
  },
  rbac+: {
    v1+: rbacPatch,
    v1beta1+: rbacPatch,
  },
  policy+: { v1beta1+: {
    podDisruptionBudget+: noNewEmptyNameMixin,
    podSecurityPolicy+: noNewEmptyNameMixin,
  } },
  storage+: { v1+: {
    storageClass+: noNewEmptyNameMixin,
  } },

  scheduling+: { v1beta1+: {
    priorityClass+: noNewEmptyNameMixin,
  } },
  admissionregistration+: { v1beta1+: {
    mutatingWebhookConfiguration+: noNewEmptyNameMixin,
    validatingWebhookConfiguration+: noNewEmptyNameMixin,
  } },
}
