// Override defaults paramters for objects in the ksonnet libs here.
local k = import 'k.libsonnet';

k
+ (
  if std.objectHas(k, '__ksonnet')
  then (import 'legacy-types.libsonnet')
  else {}
)
+ {
  _config+:: {
    enable_rbac: true,
    enable_pod_priorities: false,
    namespace: error 'Must define a namespace',
  },

  core+: {
    v1+: {
      configMap+: {
        new(name)::
          super.new(name, {}),
        withData(data)::
          if (data == {}) then {}
          else super.withData(data),
        withDataMixin(data)::
          if (data == {}) then {}
          else super.withDataMixin(data),
      },

      // Expose containerPort type.
      containerPort+:: {
        // Force all ports to have names.
        new(name, port)::
          super.newNamed(name=name, containerPort=port),

        // Shortcut constructor for UDP ports.
        newUDP(name, port)::
          super.newNamed(name=name, containerPort=port) +
          super.withProtocol('UDP'),
      },

      // Expose volumes type.
      volume+:: {
        // Make items parameter optional from fromConfigMap
        fromConfigMap(name, configMapName, configMapItems=[])::
          {
            configMap+:
              if configMapItems == [] then { items:: null }
              else {},
          }
          + super.fromConfigMap(name, configMapName, configMapItems),

        // Shortcut constructor for secret volumes.
        fromSecret(name, secretName)::
          super.withName(name) +
          super.mixin.secret.withSecretName(secretName),

        // Rename emptyDir to claimName
        fromPersistentVolumeClaim(name='', claimName=''):: super.fromPersistentVolumeClaim(name=name, emptyDir=claimName),
      },

      volumeMount+:: {
        // Override new, such that it doesn't always set readOnly: false.
        new(name, mountPath, readOnly=false)::
          {} + self.withName(name) + self.withMountPath(mountPath) +
          if readOnly
          then self.withReadOnly(readOnly)
          else {},
      },

      persistentVolumeClaim+:: {
        new(name='')::
          if name != '' then
            if 'new' in super
            then super.new(name)
            else
              {} + super.mixin.metadata.withName(name)
          else
            {},
      },

      container+:: {
        new(name, image)::
          super.new(name, image) +
          super.withImagePullPolicy('IfNotPresent'),

        withEnvMixin(es)::
          // if an envvar has an empty value ("") we want to remove that property
          // because k8s will remove that and then it would always
          // show up as a difference.
          local removeEmptyValue(obj) =
            if std.objectHas(obj, 'value') && std.length(obj.value) == 0 then
              {
                [k]: obj[k]
                for k in std.objectFields(obj)
                if k != 'value'
              }
            else
              obj;
          super.withEnvMixin([
            removeEmptyValue(envvar)
            for envvar in es
          ]),

        withEnvMap(es)::
          self.withEnvMixin([
            $.core.v1.envVar.new(k, es[k])
            for k in std.objectFields(es)
          ]),
      },
    },
  },

  batch+: {
    v1beta1+: {
      cronJob+: {
        new(name='', schedule='', containers=[])::
          super.new() +
          (
            if name != '' then
              super.mixin.metadata.withName(name) +
              // set name label on pod
              super.mixin.spec.jobTemplate.spec.template.metadata.withLabels({ name: name })
            else
              {}
          ) +
          (
            if schedule != '' then
              super.mixin.spec.withSchedule(schedule)
            else
              {}
          ) +
          super.mixin.spec.jobTemplate.spec.template.spec.withContainers(containers),
      },
    },
  },

  local appsExtentions = {
    daemonSet+: {
      new(name, containers, podLabels={})::
        local labels = podLabels { name: name };

        super.new() +
        super.mixin.metadata.withName(name) +
        super.mixin.spec.template.metadata.withLabels(labels) +
        super.mixin.spec.template.spec.withContainers(containers) +

        // Can't think of a reason we wouldn't want a DaemonSet to run on
        // every node.
        super.mixin.spec.template.spec.withTolerations([
          $.core.v1.toleration.new() +
          $.core.v1.toleration.withOperator('Exists') +
          $.core.v1.toleration.withEffect('NoSchedule'),
        ]) +

        // We want to specify a minReadySeconds on every deamonset, so we get some
        // very basic canarying, for instance, with bad arguments.
        super.mixin.spec.withMinReadySeconds(10) +
        super.mixin.spec.updateStrategy.withType('RollingUpdate') +

        // apps.v1 requires an explicit selector:
        super.mixin.spec.selector.withMatchLabels(labels),
    },

    deployment+: {
      new(name, replicas, containers, podLabels={})::
        local labels = podLabels { name: name };

        super.new(name, replicas, containers, labels) +

        // We want to specify a minReadySeconds on every deployment, so we get some
        // very basic canarying, for instance, with bad arguments.
        super.mixin.spec.withMinReadySeconds(10) +

        // We want to add a sensible default for the number of old deployments
        // handing around.
        super.mixin.spec.withRevisionHistoryLimit(10) +

        // apps.v1 requires an explicit selector:
        super.mixin.spec.selector.withMatchLabels(labels),
    },

    statefulSet+: {
      new(name, replicas, containers, volumeClaims, podLabels={})::
        local labels = podLabels { name: name };

        super.new(name, replicas, containers, volumeClaims, labels) +
        super.mixin.spec.updateStrategy.withType('RollingUpdate') +

        // apps.v1 requires an explicit selector:
        super.mixin.spec.selector.withMatchLabels(labels) +

        // remove volumeClaimTemplates if empty (otherwise it will create a diff all the time)
        (if std.length(volumeClaims) == 0 then {
           spec+: { volumeClaimTemplates:: {} },
         } else {}),
    },
  },

  extensions+: {
    v1beta1+: appsExtentions,
  },

  apps+: {
    v1beta1+: appsExtentions,
    v1+: appsExtentions,
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
