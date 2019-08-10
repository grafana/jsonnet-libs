{
  prometheus:: {
    name:: error 'must specify name',

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

    // We bounce through various layers of indirection so user can:
    // a) override config for all Prometheus' by merging into $.prometheus_config,
    // b) override config for a specific Prometheus instance by merging in here.
    local configMap = $.core.v1.configMap,

    prometheus_config:: $.prometheus_config,
    prometheusAlerts:: $.prometheusAlerts,
    prometheusRules:: $.prometheusRules,
    _config:: $._config,

    prometheus_config_map:
      // Can't reference self.foo below as we're in a map context, so
      // need to capture reference to the configs in scope here.
      local prometheus_config = self.prometheus_config;
      local prometheusAlerts = self.prometheusAlerts;
      local prometheusRules = self.prometheusRules;

      configMap.new('%s-config' % self.name) +
      configMap.withData({
        'prometheus.yml': $.util.manifestYaml(prometheus_config),
        'alerts.rules': $.util.manifestYaml(prometheusAlerts),
        'recording.rules': $.util.manifestYaml(prometheusRules),
      }),

    local container = $.core.v1.container,

    prometheus_container::
      local _config = self._config;
      container.new('prometheus', $._images.prometheus) +
      container.withPorts($.core.v1.containerPort.new('http-metrics', 80)) +
      container.withArgs([
        '--config.file=/etc/prometheus/prometheus.yml',
        '--web.listen-address=:%s' % _config.prometheus_port,
        '--web.external-url=%s%s' % [_config.prometheus_external_hostname, _config.prometheus_path],
        '--web.enable-lifecycle',
        '--web.route-prefix=%s' % _config.prometheus_web_route_prefix,
        '--storage.tsdb.path=/prometheus/data',
        '--storage.tsdb.wal-compression',
      ]) +
      $.util.resourcesRequests('250m', '1536Mi') +
      $.util.resourcesLimits('500m', '2Gi'),

    prometheus_watch_container::
      local _config = self._config;

      container.new('watch', $._images.watch) +
      container.withArgs([
        '-v',
        '-t',
        '-p=/etc/prometheus',
        'curl',
        '-X',
        'POST',
        '--fail',
        '-o',
        '-',
        '-sS',
        'http://localhost:%s%s-/reload' % [_config.prometheus_port, _config.prometheus_web_route_prefix],
      ]),

    local deployment = $.apps.v1beta1.deployment,
    local pvc = $.core.v1.persistentVolumeClaim,

    prometheus_pvc::
      pvc.new() +
      pvc.mixin.metadata.withName('%s-data' % (self.name)) +
      pvc.mixin.spec.withAccessModes('ReadWriteOnce') +
      pvc.mixin.spec.resources.withRequests({ storage: '300Gi' }),

    local statefulset = $.apps.v1beta1.statefulSet,
    local volumeMount = $.core.v1.volumeMount,

    prometheus_statefulset:
      statefulset.new(self.name, 1, [
        self.prometheus_container.withVolumeMountsMixin(
          volumeMount.new('%s-data' % self.name, '/prometheus')
        ),
        self.prometheus_watch_container,
      ], self.prometheus_pvc) +
      $.util.configVolumeMount('%s-config' % self.name, '/etc/prometheus') +
      statefulset.mixin.spec.withServiceName('prometheus') +
      statefulset.mixin.spec.template.metadata.withAnnotations({ 'prometheus.io.path': '%smetrics' % _config.prometheus_web_route_prefix }) +
      statefulset.mixin.spec.template.spec.securityContext.withRunAsUser(0) +
      (if _config.enable_rbac
       then statefulset.mixin.spec.template.spec.withServiceAccount(self.name)
       else {})  +
      $.util.podPriority('critical')
  },

 prometheus_replica:: $.prometheus {
    replica:: error 'replica must be set',
    name: 'prometheus-%s' % self.replica,

    local _replica = self.replica,

    prometheus_config+: {
      global+: {
        scrape_interval: $._config.scrape_interval,
        external_labels+: {
          __replica__: _replica,
        },
      },

      alerting+: {
        alert_relabel_configs+: [
          {
            regex: '__replica__',
            action: 'labeldrop',
          },
        ],
      },
    },

    // We don't want the pods to be labeled name:prometheus-one etc.
    local statefulset = $.apps.v1beta1.statefulSet,
    local labels = { name: 'prometheus', replica: _replica },
    prometheus_statefulset+:
      statefulset.mixin.spec.selector.withMatchLabels(labels) +
      statefulset.mixin.spec.template.metadata.withLabels(labels),
  },

  prometheus_one: $.prometheus_replica {
    replica: 'one',
    prometheus_config+: {
      remote_write+: $._config.remote_write_both,
    },

    local service = $.core.v1.service,
    local port = service.mixin.spec.portsType,

    prometheus_service:
      service.new(
        'prometheus',
        { name: 'prometheus', replica: 'one' },
        port.newNamed('prometheus-http-metrics', 80, 80)
      ) +
      service.mixin.metadata.withLabels({ name: 'prometheus' }),
  },

  prometheus_two: $.prometheus_replica {
    replica: 'two',
    prometheus_config+: {
      remote_write+:
        if $._config.replicas_remote_write
        then $._config.remote_write_dev
        else [],
    },
  },
}
