{
  _images+:: {
    // Various third-party images.
    memcached: 'memcached:1.5.17-alpine',
    memcachedExporter: 'prom/memcached-exporter:v0.6.0',

    loki: 'grafana/loki:2.4.2',

    read: self.loki,
    write: self.loki,
  },
}
