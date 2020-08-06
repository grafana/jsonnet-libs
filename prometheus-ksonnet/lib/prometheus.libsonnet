local util = import '_util.libsonnet';
{
  /*
   * All Prometheus resources are contained within a `prometheus` node. This allows
     multiple Prometheus instances to be created by simply cloning this node, like
     so:
     `other_prometheus: $.prometheus {name: "other-prometheus"},`

     To remove the default Prometheus, use this code:
     `main_prometheus: {},`
  */

  prometheus:: {
    name:: error 'must specify name',

    _config:: $._config,
    local _config = self._config,

    local policyRule = $.rbac.v1beta1.policyRule,

    prometheus_rbac:
      $.util.rbac(self.name, [
        policyRule.new() +
        policyRule.withApiGroups(['']) +
        policyRule.withResources(['nodes', 'nodes/proxy', 'services', 'endpoints', 'pods']) +
        policyRule.withVerbs(['get', 'list', 'watch']),

        policyRule.new() +
        policyRule.withNonResourceUrls('/metrics') +
        policyRule.withVerbs(['get']),
      ]),

    local container = $.core.v1.container,

    prometheus_container::
      container.new('prometheus', $._images.prometheus) +
      container.withPorts($.core.v1.containerPort.new('http-metrics', _config.prometheus_port)) +
      container.withArgs([
        '--config.file=' + _config.prometheus_config_file,
        '--web.listen-address=:%s' % _config.prometheus_port,
        '--web.external-url=%(prometheus_external_hostname)s%(prometheus_path)s' % _config,
        '--web.enable-admin-api',
        '--web.enable-lifecycle',
        '--web.route-prefix=%s' % _config.prometheus_web_route_prefix,
        '--storage.tsdb.path=/prometheus/data',
        '--storage.tsdb.wal-compression',
      ]) +
      $.util.resourcesRequests('250m', '1536Mi') +
      $.util.resourcesLimits('500m', '2Gi'),

    prometheus_watch_container::
      container.new('watch', $._images.watch) +
      container.withArgs([
        '-v',
        '-t',
        '-p=' + _config.prometheus_config_dir,
        'curl',
        '-X',
        'POST',
        '--fail',
        '-o',
        '-',
        '-sS',
        'http://localhost:%(prometheus_port)s%(prometheus_web_route_prefix)s-/reload' % _config,
      ]),

    local pvc = $.core.v1.persistentVolumeClaim,

    prometheus_pvc::
      pvc.new() +
      pvc.mixin.metadata.withName('%s-data' % (self.name)) +
      pvc.mixin.spec.withAccessModes('ReadWriteOnce') +
      pvc.mixin.spec.resources.withRequests({ storage: '300Gi' }),

    local statefulset = $.apps.v1.statefulSet,
    local volumeMount = $.core.v1.volumeMount,

    prometheus_global_config_mount::
      $.util.configVolumeMount('%s-config' % self.name, _config.prometheus_config_dir),

    prometheus_config_mount::
      std.foldr(
        function(mixinName, acc)
          local normalisedName = util.normalise(mixinName);
          $.util.configVolumeMount('%s-%s-config' % [self.name, normalisedName], _config.prometheus_config_dir + '/' + normalisedName) + acc,
        std.objectFields($.mixins),
        {},
      ) + self.prometheus_global_config_mount,

    prometheus_statefulset:
      statefulset.new(self.name, 1, [
        self.prometheus_container + container.withVolumeMountsMixin(
          volumeMount.new('%s-data' % self.name, '/prometheus')
        ),
        self.prometheus_watch_container,
      ], self.prometheus_pvc) +
      self.prometheus_config_mount +
      statefulset.mixin.spec.withServiceName('prometheus') +
      statefulset.mixin.spec.template.metadata.withAnnotations({
        'prometheus.io.path': '%smetrics' % _config.prometheus_web_route_prefix,
      }) +
      statefulset.mixin.spec.template.spec.withServiceAccount(self.name) +
      statefulset.mixin.spec.template.spec.securityContext.withFsGroup(2000) +
      statefulset.mixin.spec.template.spec.securityContext.withRunAsUser(1000) +
      statefulset.mixin.spec.template.spec.securityContext.withRunAsNonRoot(true) +
      $.util.podPriority('critical'),

    local service = $.core.v1.service,
    local servicePort = service.mixin.spec.portsType,

    prometheus_service:
      $.util.serviceFor(self.prometheus_statefulset) +
      service.mixin.spec.withPortsMixin([
        servicePort.newNamed(
          name='http',
          port=80,
          targetPort=_config.prometheus_port,
        ),
      ]),
  },

  main_prometheus: $.prometheus { name: 'prometheus' },
}
