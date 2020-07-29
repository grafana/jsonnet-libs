{
  core+: {
    v1+: {
      configMap+: {
        new(name, data={})::
          super.new(name, data),
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


        // Rename emptyDir to claimName
        fromPersistentVolumeClaim(name='', claimName='')::
          super.fromPersistentVolumeClaim(name=name, emptyDir=claimName),
      },

      volumeMount+:: {
        // Override new, such that it doesn't always set readOnly: false.
        new(name, mountPath, readOnly=false)::
          super.new(name, mountPath, readOnly),
      },

      persistentVolumeClaim+:: {
        new(name='')::
          super.new(name),
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
            $.core.v1.envVar(k, es[k])
            for k in std.objectFields(es)
          ]),
      },
    },
  },

  rbac+: {
    v1+: {
      subject+: {
        fromServiceAccount(service_account)::
          self.withKind('ServiceAccount') +
          self.withName(service_account.metadata.name) +
          self.withNamespace(service_account.metadata.namespace),
      },
    },
  },

  batch+: {
    v1beta1+: {
      cronJob+: {
        new(name='', schedule='', containers=[])::
          super.new(name) +
          (
            if name != '' then
              super.metadata.withName(name) +
              // set name label on pod
              super.spec.jobTemplate.spec.template.metadata.withLabels({ name: name })
            else
              {}
          ) +
          (
            if schedule != '' then
              super.spec.withSchedule(schedule)
            else
              {}
          ) +
          super.spec.jobTemplate.spec.template.spec.withContainers(containers),
      },
    },
  },

  local appsExtentions = {
    daemonSet+: {
      new(name, containers, podLabels={})::
        local labels = podLabels { name: name };

        super.new(name) +
        super.spec.template.metadata.withLabels(labels) +
        super.spec.template.spec.withContainers(containers) +

        // Can't think of a reason we wouldn't want a DaemonSet to run on
        // every node.
        super.spec.template.spec.withTolerations([
          $.core.v1.toleration.withOperator('Exists') +
          $.core.v1.toleration.withEffect('NoSchedule'),
        ]) +

        // We want to specify a minReadySeconds on every deamonset, so we get some
        // very basic canarying, for instance, with bad arguments.
        super.spec.withMinReadySeconds(10) +
        super.spec.updateStrategy.withType('RollingUpdate') +

        // apps.v1 requires an explicit selector:
        super.spec.selector.withMatchLabels(labels),
    },

    deployment+: {
      new(name, replicas, containers, podLabels={})::
        local labels = podLabels { name: name };

        super.new(name, replicas, containers, labels) +

        // We want to specify a minReadySeconds on every deployment, so we get some
        // very basic canarying, for instance, with bad arguments.
        super.spec.withMinReadySeconds(10) +

        // We want to add a sensible default for the number of old deployments
        // handing around.
        super.spec.withRevisionHistoryLimit(10) +

        // apps.v1 requires an explicit selector:
        super.spec.selector.withMatchLabels(labels),
    },

    statefulSet+: {
      new(name, replicas, containers, volumeClaims, podLabels={})::
        local labels = podLabels { name: name };

        super.new(name, replicas, containers, volumeClaims, labels) +
        super.spec.updateStrategy.withType('RollingUpdate') +

        // apps.v1 requires an explicit selector:
        super.spec.selector.withMatchLabels(labels) +

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
    v1beta2+: appsExtentions,
    v1beta1+: appsExtentions,
    v1+: appsExtentions,
  },
}
