local k = import 'ksonnet-util/kausal.libsonnet';

k {
  util+:: {
    // Convert number to k8s "quantity" (ie 1.5Gi -> "1536Mi")
    // as per https://github.com/kubernetes/kubernetes/blob/master/staging/src/k8s.io/apimachinery/pkg/api/resource/quantity.go
    bytesToK8sQuantity(i)::
      local remove_factors_exponent(x, y) =
        if x % y > 0
        then 0
        else remove_factors_exponent(x / y, y) + 1;
      local remove_factors_remainder(x, y) =
        if x % y > 0
        then x
        else remove_factors_remainder(x / y, y);
      local suffixes = ['', 'Ki', 'Mi', 'Gi'];
      local suffix = suffixes[remove_factors_exponent(i, 1024)];
      '%d%s' % [remove_factors_remainder(i, 1024), suffix],
  },

  memcached:: {
    name:: error 'must specify name',
    max_item_size:: '1m',
    memory_limit_mb:: 1024,
    memory_request_bytes::
      std.ceil((self.memory_limit_mb * 1.2) + 100) * 1024 * 1024,
    memory_limits_bytes::
      self.memory_limit_mb * 1.5 * 1024 * 1024,

    local container = $.core.v1.container,
    local containerPort = $.core.v1.containerPort,

    memcached_container::
      container.new('memcached', $._images.memcached) +
      container.withPorts([containerPort.new('client', 11211)]) +
      container.withArgs([
        '-m %(memory_limit_mb)s' % self,
        '-I %(max_item_size)s' % self,
        '-v',
      ]) +
      $.util.resourcesRequests('500m', $.util.bytesToK8sQuantity(self.memory_request_bytes)) +
      $.util.resourcesLimits('3', $.util.bytesToK8sQuantity(self.memory_limits_bytes)),

    memcached_exporter::
      container.new('exporter', $._images.memcachedExporter) +
      container.withPorts([containerPort.new('http-metrics', 9150)]) +
      container.withArgs([
        '--memcached.address=localhost:11211',
        '--web.listen-address=0.0.0.0:9150',
      ]),

    local deployment = $.apps.v1beta1.deployment,

    deployment:
      deployment.new(self.name, $._config.memcached_replicas, [
        self.memcached_container,
        self.memcached_exporter,
      ]) +
      $.util.antiAffinity,

    local service = $.core.v1.service,

    service:
      $.util.serviceFor(self.deployment) +
      service.mixin.spec.withClusterIp('None'),
  },
}
