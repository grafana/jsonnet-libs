// Override defaults paramters for objects in the ksonnet libs here.
local k = import 'k.libsonnet';

k
+ (
  if std.objectHas(k, '__ksonnet')
  then
    (import 'legacy-types.libsonnet')
    + (import 'legacy-custom.libsonnet')
  else {}
)
+ {
  core+: {
    v1+: {
      containerPort+:: {
        // Force all ports to have names.
        new(name, port)::
          super.newNamed(name=name, containerPort=port),

        // Shortcut constructor for UDP ports.
        newUDP(name, port)::
          super.newNamedUDP(name=name, containerPort=port),
      },

      persistentVolumeClaim+:: {
        // allow empty name label (backward compat)
        new(name='')::
          if name != ''
          then super.new(name)
          else {
            apiVersion: 'v1',
            kind: 'PersistentVolumeClaim',
          },
      },

      container+:: {
        new(name, image)::
          super.new(name, image) +
          super.withImagePullPolicy('IfNotPresent'),
      },
    },
  },

  batch+: {
    v1beta1+: {
      cronJob+: {
        // allow empty name label (backward compat)
        new(name='', schedule='', containers=[])::
          if name != ''
          then super.new(name, schedule, containers)
          else
            {
              apiVersion: 'batch/v1beta1',
              kind: 'CronJob',
            }
            + super.mixin.spec.jobTemplate.spec.template.spec.withContainers(containers)
            + (
              if schedule != ''
              then super.mixin.spec.withSchedule(schedule)
              else {}
            ),

      },
    },
  },

  local appsExtentions = {
    daemonSet+: {
      new(name, containers, podLabels={})::
        super.new(name, containers, podLabels={}) +

        // Can't think of a reason we wouldn't want a DaemonSet to run on
        // every node.
        super.mixin.spec.template.spec.withTolerations([
          k.core.v1.toleration.new() +
          k.core.v1.toleration.withOperator('Exists') +
          k.core.v1.toleration.withEffect('NoSchedule'),
        ]) +

        // We want to specify a minReadySeconds on every deamonset, so we get some
        // very basic canarying, for instance, with bad arguments.
        super.mixin.spec.withMinReadySeconds(10) +
        super.mixin.spec.updateStrategy.withType('RollingUpdate'),
    },

    deployment+: {
      new(name, replicas, containers, podLabels={})::
        super.new(name, replicas, containers, podLabels) +

        // We want to specify a minReadySeconds on every deployment, so we get some
        // very basic canarying, for instance, with bad arguments.
        super.mixin.spec.withMinReadySeconds(10) +

        // We want to add a sensible default for the number of old deployments
        // handing around.
        super.mixin.spec.withRevisionHistoryLimit(10),
    },

    statefulSet+: {
      new(name, replicas, containers, volumeClaims=[], podLabels={})::
        super.new(name, replicas, containers, volumeClaims, podLabels) +
        super.mixin.spec.updateStrategy.withType('RollingUpdate'),
    },
  },

  extensions+: {
    v1beta1+: appsExtentions,
  },

  apps+: {
    v1beta1+: appsExtentions,
    v1+: appsExtentions,
  },
}
