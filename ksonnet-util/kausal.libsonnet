// Override defaults paramters for objects in the ksonnet libs here.
local k = import 'k-mixin.libsonnet';

k {
  _config+:: {
    enable_rbac: true,
    enable_pod_priorities: false,
    namespace: error 'Must define a namespace',
  },

  util+::
    (import 'util.libsonnet')
    + {
      rbac(name, rules)::
        if $._config.enable_rbac
        then super.rbac(name, rules, $._config.namespace)
        else {},
      namespacedRBAC(name, rules)::
        if $._config.enable_rbac
        then super.namespaceRBAC(name, rules, $._config.namespace)
        else {},
      podPriority(p):
        if $._config.enable_pod_priorities
        then super.podPriority(p)
        else {},
    },
}
