local k = import "ksonnet.beta.2/k8s.libsonnet",
  util = import "ksonnet.beta.1/util.libsonnet";

local configMap = k.core.v1.configMap,
  daemonSet = k.extensions.v1beta1.daemonSet,
  container = daemonSet.mixin.spec.template.spec.containersType;

{
  node_exporter_container::
    $.util.container("node-exporter", $._images.nodeExporter) +
    $.util.containerPort("http", 9100) +
    container.args([
      "-collector.procfs=/host/proc",
      "-collector.sysfs=/host/sys",
      "-collector.filesystem.ignored-mount-points=^/(sys|proc|dev|host|etc)($|/)",
    ]) +
    container.mixin.securityContext.privileged(true) +
    $.util.containerResourcesRequests("30Mi", "100m") +
    $.util.containerResourcesLimits("50Mi", "200m"),

  node_exporter_deamonset:
    $.util.daemonSet("node-exporter", [$.node_exporter_container]) +
    daemonSet.mixin.spec.template.spec.hostPid(true) +
    daemonSet.mixin.spec.template.spec.hostNetwork(true) +
    $.util.hostVolumeMount("proc", "/proc", "/host/proc") +
    $.util.hostVolumeMount("sys", "/sys", "/host/sys") +
    $.util.hostVolumeMount("root", "/", "/rootfs"),
}
