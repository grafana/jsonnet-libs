// Override defaults paramters for objects in the ksonnet libs here.
local k = import "k.libsonnet";

k {
  _config+:: {
    namespace: error "Must define a namespace",
  },

  core+: {
    v1+: {
      configMap+: {
        new(name)::
          super.new(name, {}),
      },

      containerPort:: $.core.v1.container.portsType {
        // Force all ports to have names.
        new(name, port)::
          super.newNamed(name, port),
      },

      volume:: $.core.v1.pod.mixin.spec.volumesType {
        // Remove items parameter from fromConfigMap
        fromConfigMap(name, configMapName)::
          super.withName(name) +
          super.mixin.configMap.withName(configMapName),
      },

      container:: $.extensions.v1beta1.deployment.mixin.spec.template.spec.containersType {
        env(es)::
          super.env([
            $.core.v1.container.envType.new(k, es[k])
            for k in std.objectFields(es)
          ]),
      },

      toleration:: $.extensions.v1beta1.deployment.mixin.spec.template.spec.tolerationsType,
    },
  },

  extensions+: {
    v1beta1+: {
      daemonSet+: {
        new(name, containers)::
          super.new() +
          super.mixin.metadata.withName(name) +
          super.mixin.spec.template.metadata.withLabels({ name: name }) +
          super.mixin.spec.template.spec.withContainers(containers) +

          // Can't think of a reason we wouldn't want a DaemonSet to run on
          // every node.
          super.mixin.spec.template.spec.withTolerations([
            $.core.v1.toleration.new() +
            $.core.v1.toleration.withOperator("Exists") +
            $.core.v1.toleration.withEffect("NoSchedule"),
          ]) +

          // We want to specify a minReadySeconds on every deamonset, so we get some
          // very basic canarying, for instance, with bad arguments.
          super.mixin.spec.withMinReadySeconds(10) +
          super.mixin.spec.updateStrategy.withType("RollingUpdate"),
      },

      deployment+: {
        new(name, replicas, containers, podLabels={})::
          super.new(name, replicas, containers, podLabels { name: name }) +

          // We want to specify a minReadySeconds on every deployment, so we get some
          // very basic canarying, for instance, with bad arguments.
          super.mixin.spec.withMinReadySeconds(10) +

          // We want to add a sensible default for the number of old deployments
          // handing around.
          super.mixin.spec.withRevisionHistoryLimit(10),
      },
    },
  },

  rbac+: {
    v1beta1+: {
      // Shortcut to access the hidden types.
      policyRule:: $.rbac.v1beta1.clusterRole.rulesType,
      subject:: $.rbac.v1beta1.clusterRoleBinding.subjectsType,
    },
  },

  util:: {
    // serviceFor create service for a given deployment.
    serviceFor(deployment)::
      local container = $.core.v1.container;
      local servicePort = $.core.v1.service.mixin.spec.portsType;
      local ports = [
        servicePort.newNamed(c.name + "-" + port.name, port.containerPort, port.containerPort)
        for c in deployment.spec.template.spec.containers
        for port in (c + container.withPortsMixin([])).ports
      ];
      $.core.v1.service.new(
        deployment.metadata.name,  // name
        deployment.spec.template.metadata.labels,  // selector
        ports,
      ),

    // rbac creates a service account, role and role binding with the given
    // name and rules.
    rbac(name, rules):: {
      local clusterRole = $.rbac.v1beta1.clusterRole,
      local clusterRoleBinding = $.rbac.v1beta1.clusterRoleBinding,
      local subject = $.rbac.v1beta1.subject,
      local serviceAccount = $.core.v1.serviceAccount,

      service_account:
        serviceAccount.new(name),

      cluster_role:
        clusterRole.new() +
        clusterRole.mixin.metadata.withName(name) +
        clusterRole.withRules(rules),

      cluster_role_binding:
        clusterRoleBinding.new() +
        clusterRoleBinding.mixin.metadata.withName(name) +
        clusterRoleBinding.mixin.roleRef.withApiGroup("rbac.authorization.k8s.io") +
        { roleRef+: { kind: "ClusterRole" } } +
        clusterRoleBinding.mixin.roleRef.withName(name) +
        clusterRoleBinding.withSubjects([
          subject.new() +
          { kind: "ServiceAccount" } +
          subject.withName(name) +
          subject.withNamespace($._config.namespace),
        ]),
    },

    configVolumeMount(volumeName, path)::
      local deployment = $.extensions.v1beta1.deployment;
      local container = $.core.v1.container;
      local addMount(c) = c + container.withVolumeMountsMixin(
        container.volumeMountsType.new(volumeName, path)
      );
      local volume = $.core.v1.volume;
      deployment.mapContainers(addMount) +
      deployment.mixin.spec.template.spec.withVolumesMixin([
        volume.fromConfigMap(volumeName, volumeName),
      ]),

    hostVolumeMount(name, hostPath, path)::
      local container = $.core.v1.container;
      local addMount(c) = c + container.withVolumeMountsMixin(
        container.volumeMountsType.new(name, path)
      );
      local volume = $.core.v1.volume;
      local deployment = $.extensions.v1beta1.deployment;
      deployment.mapContainers(addMount) +
      deployment.mixin.spec.template.spec.withVolumesMixin([
        volume.fromHostPath(name, hostPath),
      ]),

    manifestYaml(value):: (
      local f = std.native("manifestYamlFromJson");
      f(std.toString(value))
    ),

    resourcesRequests(cpu, memory)::
      $.core.v1.container.mixin.resources.withRequests({
        cpu: cpu,
        memory: memory,
      }),

    resourcesLimits(cpu, memory)::
      $.core.v1.container.mixin.resources.withLimits({
        cpu: cpu,
        memory: memory,
      }),
  },
}
