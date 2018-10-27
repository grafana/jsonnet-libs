{
  local container = $.core.v1.container,

  node_exporter_container::
    container.new('node-exporter', $._images.nodeExporter) +
    container.withPorts($.core.v1.containerPort.new('http-metrics', 9100)) +
    container.withArgs([
      '--path.procfs=/host/proc',
      '--path.sysfs=/host/sys',

      '--no-collector.netstat',
      '--collector.netdev.ignored-devices=^veth.+$',

      # We run an older version due to the renamed metrics.  There ignores are from newer version.
      '--collector.filesystem.ignored-fs-types=^(tmpfs|autofs|binfmt_misc|bpf|cgroup2?|configfs|debugfs|devpts|devtmpfs|fusectl|hugetlbfs|mqueue|nsfs|overlay|proc|procfs|pstore|rpc_pipefs|securityfs|selinuxfs|squashfs|sysfs|tracefs)$',
      '--collector.filesystem.ignored-mount-points=^/(rootfs/)?(dev|proc|sys|var/lib/docker/.+)($|/)',
    ]) +
    container.mixin.securityContext.withPrivileged(true) +
    container.mixin.securityContext.withRunAsUser(0) +
    $.util.resourcesRequests('10m', '20Mi') +
    $.util.resourcesLimits('50m', '40Mi'),

  local daemonSet = $.extensions.v1beta1.daemonSet,

  node_exporter_daemonset:
    daemonSet.new('node-exporter', [$.node_exporter_container]) +
    daemonSet.mixin.spec.template.spec.withHostPid(true) +
    daemonSet.mixin.spec.template.spec.withHostNetwork(true) +
    daemonSet.mixin.spec.template.metadata.withAnnotationsMixin({ 'prometheus.io.scrape': 'false' }) +
    $.util.hostVolumeMount('proc', '/proc', '/host/proc') +
    $.util.hostVolumeMount('sys', '/sys', '/host/sys') +
    (if $._config.node_exporter_mount_root
     then $.util.hostVolumeMount('root', '/', '/rootfs')
     else {}),
}
