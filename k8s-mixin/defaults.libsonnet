{
  _config+:: {
    enable_rbac: true,
    enable_pod_priorities: false,
    namespace: error 'Must define a namespace',
  },

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
        fromConfigMap(name, configMapName, configMapItems={})::
          super.fromConfigMap(name, configMapName, configMapItems),

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

  util+:: {
    // mapToFlags converts a map to a set of golang-style command line flags.
    mapToFlags(map, prefix='-'): [
      '%s%s=%s' % [prefix, key, map[key]]
      for key in std.objectFields(map)
      if map[key] != null
    ],

    // serviceFor create service for a given deployment.
    serviceFor(deployment, ignored_labels=[], nameFormat='%(container)s-%(port)s')::
      local container = $.core.v1.container;
      local service = $.core.v1.service;
      local servicePort = $.core.v1.servicePort;
      local ports = [
        servicePort.newNamed(
          name=(nameFormat % { container: c.name, port: port.name }),
          port=port.containerPort,
          targetPort=port.containerPort
        ) +
        if std.objectHas(port, 'protocol')
        then servicePort.withProtocol(port.protocol)
        else {}
        for c in deployment.spec.template.spec.containers
        for port in (c + container.withPortsMixin([])).ports
      ];
      local labels = {
        [x]: deployment.spec.template.metadata.labels[x]
        for x in std.objectFields(deployment.spec.template.metadata.labels)
        if std.count(ignored_labels, x) == 0
      };

      service.new(
        deployment.metadata.name,  // name
        labels,  // selector
        ports,
      ) +
      service.metadata.withLabels({ name: deployment.metadata.name }),

    // rbac creates a service account, role and role binding with the given
    // name and rules.
    rbac(name, rules)::
      if $._config.enable_rbac
      then {
        local clusterRole = $.rbac.v1.clusterRole,
        local clusterRoleBinding = $.rbac.v1.clusterRoleBinding,
        local subject = $.rbac.v1.subject,
        local serviceAccount = $.core.v1.serviceAccount,

        service_account:
          serviceAccount.new(name),

        cluster_role:
          clusterRole.new(name) +
          clusterRole.withRules(rules),

        cluster_role_binding:
          clusterRoleBinding.new(name) +
          clusterRoleBinding.roleRef.withApiGroup('rbac.authorization.k8s.io') +
          clusterRoleBinding.roleRef.withKind('ClusterRole') +
          clusterRoleBinding.roleRef.withName(self.cluster_role.metadata.name) +
          clusterRoleBinding.withSubjects([
            subject.withKind('ServiceAccount') +
            subject.withName(self.service_account.metadata.name) +
            subject.withNamespace(self.service_account.metadata.namespace),
          ]),
      }
      else {},

    namespacedRBAC(name, rules)::
      if $._config.enable_rbac
      then {
        local role = $.rbac.v1.role,
        local roleBinding = $.rbac.v1.roleBinding,
        local subject = $.rbac.v1.subject,
        local serviceAccount = $.core.v1.serviceAccount,

        service_account:
          serviceAccount.new(name) +
          serviceAccount.metadata.withNamespace($._config.namespace),

        role:
          role.new(name) +
          role.metadata.withNamespace($._config.namespace) +
          role.withRules(rules),

        cluster_role_binding:
          roleBinding.new(name) +
          roleBinding.metadata.withNamespace($._config.namespace) +
          roleBinding.roleRef.withApiGroup('rbac.authorization.k8s.io') +
          roleBinding.roleRef.withKind('Role') +
          roleBinding.roleRef.withName(self.role.metadata.name) +
          roleBinding.withSubjects([
            subject.withKind('ServiceAccount') +
            subject.withName(self.service_account.metadata.name) +
            subject.withNamespace(self.service_account.metadata.namespace),
          ]),
      }
      else {},

    // VolumeMount helper functions can be augmented with mixins.
    // For example, passing "volumeMount.withSubPath(subpath)" will result in
    // a subpath mixin.
    configVolumeMount(name, path, volumeMountMixin={})::
      local container = $.core.v1.container,
            deployment = $.apps.v1.deployment,
            volumeMount = $.core.v1.volumeMount,
            volume = $.core.v1.volume,
            addMount(c) = c + container.withVolumeMountsMixin(
        volumeMount.new(name, path) +
        volumeMountMixin,
      );

      deployment.mapContainers(addMount) +
      deployment.spec.template.spec.withVolumesMixin([
        volume.fromConfigMap(name, name),
      ]),

    // configMapVolumeMount adds a configMap to deployment-like objects.
    // It will also add an annotation hash to ensure the pods are re-deployed
    // when the config map changes.
    configMapVolumeMount(configMap, path, volumeMountMixin={})::
      local name = configMap.metadata.name,
            hash = std.md5(std.toString(configMap)),
            container = $.core.v1.container,
            deployment = $.apps.v1.deployment,
            volumeMount = $.core.v1.volumeMount,
            volume = $.core.v1.volume,
            addMount(c) = c + container.withVolumeMountsMixin(
        volumeMount.new(name, path) +
        volumeMountMixin,
      );

      deployment.mapContainers(addMount) +
      deployment.spec.template.spec.withVolumesMixin([
        volume.fromConfigMap(name, name),
      ]) +
      deployment.spec.template.metadata.withAnnotationsMixin({
        ['%s-hash' % name]: hash,
      }),

    hostVolumeMount(name, hostPath, path, readOnly=false, volumeMountMixin={})::
      local container = $.core.v1.container,
            deployment = $.apps.v1.deployment,
            volumeMount = $.core.v1.volumeMount,
            volume = $.core.v1.volume,
            addMount(c) = c + container.withVolumeMountsMixin(
        volumeMount.new(name, path, readOnly=readOnly) +
        volumeMountMixin,
      );

      deployment.mapContainers(addMount) +
      deployment.spec.template.spec.withVolumesMixin([
        volume.fromHostPath(name, hostPath),
      ]),

    secretVolumeMount(name, path, defaultMode=256, volumeMountMixin={})::
      local container = $.core.v1.container,
            deployment = $.apps.v1.deployment,
            volumeMount = $.core.v1.volumeMount,
            volume = $.core.v1.volume,
            addMount(c) = c + container.withVolumeMountsMixin(
        volumeMount.new(name, path) +
        volumeMountMixin,
      );

      deployment.mapContainers(addMount) +
      deployment.spec.template.spec.withVolumesMixin([
        volume.fromSecret(name, name) +
        volume.secret.withDefaultMode(defaultMode),
      ]),

    emptyVolumeMount(name, path, volumeMountMixin={}, volumeMixin={})::
      local container = $.core.v1.container,
            deployment = $.apps.v1.deployment,
            volumeMount = $.core.v1.volumeMount,
            volume = $.core.v1.volume,
            addMount(c) = c + container.withVolumeMountsMixin(
        volumeMount.new(name, path) +
        volumeMountMixin,
      );

      deployment.mapContainers(addMount) +
      deployment.spec.template.spec.withVolumesMixin([
        volume.fromEmptyDir(name) + volumeMixin,
      ]),

    manifestYaml(value):: (
      local f = std.native('manifestYamlFromJson');
      f(std.toString(value))
    ),

    resourcesRequests(cpu, memory)::
      $.core.v1.container.resources.withRequests(
        (if cpu != null
         then { cpu: cpu }
         else {}) +
        (if memory != null
         then { memory: memory }
         else {})
      ),

    resourcesLimits(cpu, memory)::
      $.core.v1.container.resources.withLimits(
        (if cpu != null
         then { cpu: cpu }
         else {}) +
        (if memory != null
         then { memory: memory }
         else {})
      ),

    antiAffinity:
      {
        local podAntiAffinity = $.apps.v1.deployment.spec.template.spec.affinity.podAntiAffinity,
        local podAffinityTerm = $.core.v1.podAffinityTerm,
        local name = super.spec.template.metadata.labels.name,

        spec+: podAntiAffinity.withRequiredDuringSchedulingIgnoredDuringExecution([
          podAffinityTerm.labelSelector.withMatchLabels({ name: name }) +
          podAffinityTerm.withTopologyKey('kubernetes.io/hostname'),
        ]).spec,
      },

    antiAffinityStatefulSet:
      {
        local podAntiAffinity = $.apps.v1.statefulSet.spec.template.spec.affinity.podAntiAffinity,
        local podAffinityTerm = $.core.v1.podAffinityTerm,
        local name = super.spec.template.metadata.labels.name,

        spec+: podAntiAffinity.withRequiredDuringSchedulingIgnoredDuringExecution([
          podAffinityTerm.labelSelector.withMatchLabels({ name: name }) +
          podAffinityTerm.withTopologyKey('kubernetes.io/hostname'),
        ]).spec,
      },

    // Add a priority to the pods in a deployment (or deployment-like objects
    // such as a statefulset) iff _config.enable_pod_priorities is set to true.
    podPriority(p):
      local deployment = $.apps.v1.deployment;
      if $._config.enable_pod_priorities
      then deployment.spec.template.spec.withPriorityClassName(p)
      else {},
  },
}
