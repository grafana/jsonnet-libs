// Override defaults paramters for objects in the ksonnet libs here.
// Taken from: https://github.com/kausalco/public/blob/master/prometheus-ksonnet/lib/kausal.libsonnet
local k = import 'k.libsonnet';

k {
  core+: {
    v1+: {
      configMap+: {
        new(name)::
          super.new(name, {}),
      },

      // Expose containerPort type.
      containerPort:: $.core.v1.container.portsType {
        // Force all ports to have names.
        new(name, port)::
          super.newNamed(name, port),

        // Shortcut constructor for UDP ports.
        newUDP(name, port)::
          super.newNamed(name, port) +
          super.withProtocol('UDP'),
      },

      // Expose volumes type.
      volume:: $.core.v1.pod.mixin.spec.volumesType {
        // Remove items parameter from fromConfigMap
        fromConfigMap(name, configMapName)::
          super.withName(name) +
          super.mixin.configMap.withName(configMapName),

        // Shortcut constructor for secret volumes.
        fromSecret(name, secret)::
          super.withName(name) +
          super.mixin.secret.withSecretName(secret),
      },

      volumeMount:: $.core.v1.container.volumeMountsType {
        // Override new, such that it doesn't always set readOnly: false.
        new(name, mountPath, readOnly=false)::
          {} + self.withName(name) + self.withMountPath(mountPath) +
          if readOnly
          then self.withReadOnly(readOnly)
          else {},
      },

      container:: $.extensions.v1beta1.deployment.mixin.spec.template.spec.containersType {
        new(name, image)::
          super.new(name, image) +
          super.withImagePullPolicy('IfNotPresent'),

        withEnvMap(es)::
          super.withEnv([
            $.core.v1.container.envType.new(k, es[k])
            for k in std.objectFields(es)
          ]),

        withEnvFromSecret(name)::
          super.withEnvFrom([super.envFromType.mixin.secretRef.withName(name)]),
      },

      servicePort:: $.core.v1.service.mixin.spec.portsType,
    },
  },

  local appsExtentions = {
    deployment+: {
      new(name, replicas, containers, podLabels={})::
        super.new(name, replicas, containers, podLabels { name: name }) +
        super.mixin.metadata.withNamespace($._config.namespace) +
        super.mixin.metadata.withLabels({ name: name }) +

        // We want to specify a minReadySeconds on every deployment, so we get some
        // very basic canarying, for instance, with bad arguments.
        super.mixin.spec.withMinReadySeconds(10) +

        // We want to add a sensible default for the number of old deployments
        // handing around.
        super.mixin.spec.withRevisionHistoryLimit(10),
    },
  },

  extensions+: {
    v1beta1+: appsExtentions,
  },

  apps+: {
    v1beta1+: appsExtentions,
  },

  util+:: {
    // serviceFor create service for a given deployment.
    serviceFor(deployment)::
      local container = $.core.v1.container;
      local servicePort = $.core.v1.service.mixin.spec.portsType;
      local ports = [
        servicePort.newNamed(c.name + '-' + port.name, port.containerPort, port.containerPort)
        for c in deployment.spec.template.spec.containers
        for port in (c + container.withPortsMixin([])).ports
      ];
      $.core.v1.service.new(
        deployment.metadata.name,  // name
        deployment.spec.template.metadata.labels,  // selector
        ports,
      ),

    // VolumeMount helper functions can be augmented with mixins.
    // For example, passing "volumeMount.withSubPath(subpath)" will result in
    // a subpath mixin.
    configVolumeMount(name, path, volumeMountMixin={})::
      local container = $.core.v1.container,
            deployment = $.extensions.v1beta1.deployment,
            volumeMount = $.core.v1.volumeMount,
            volume = $.core.v1.volume,
            addMount(c) = c + container.withVolumeMountsMixin(
        volumeMount.new(name, path) +
        volumeMountMixin,
      );

      deployment.mapContainers(addMount) +
      deployment.mixin.spec.template.spec.withVolumesMixin([
        volume.fromConfigMap(name, name),
      ]),

    hostVolumeMount(name, hostPath, path, readOnly=false, volumeMountMixin={})::
      local container = $.core.v1.container,
            deployment = $.extensions.v1beta1.deployment,
            volumeMount = $.core.v1.volumeMount,
            volume = $.core.v1.volume,
            addMount(c) = c + container.withVolumeMountsMixin(
        volumeMount.new(name, path, readOnly=readOnly) +
        volumeMountMixin,
      );

      deployment.mapContainers(addMount) +
      deployment.mixin.spec.template.spec.withVolumesMixin([
        volume.fromHostPath(name, hostPath),
      ]),

    secretVolumeMount(name, path, defaultMode=256, volumeMountMixin={})::
      local container = $.core.v1.container,
            deployment = $.extensions.v1beta1.deployment,
            volumeMount = $.core.v1.volumeMount,
            volume = $.core.v1.volume,
            addMount(c) = c + container.withVolumeMountsMixin(
        volumeMount.new(name, path) +
        volumeMountMixin,
      );

      deployment.mapContainers(addMount) +
      deployment.mixin.spec.template.spec.withVolumesMixin([
        volume.fromSecret(name, name) +
        volume.mixin.secret.withDefaultMode(defaultMode),
      ]),

    emptyVolumeMount(name, path, volumeMountMixin={})::
      local container = $.core.v1.container,
            deployment = $.extensions.v1beta1.deployment,
            volumeMount = $.core.v1.volumeMount,
            volume = $.core.v1.volume,
            addMount(c) = c + container.withVolumeMountsMixin(
        volumeMount.new(name, path) +
        volumeMountMixin,
      );

      deployment.mapContainers(addMount) +
      deployment.mixin.spec.template.spec.withVolumesMixin([
        volume.fromEmptyDir(name),
      ]),

    manifestYaml(value):: (
      local f = std.native('manifestYamlFromJson');
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
