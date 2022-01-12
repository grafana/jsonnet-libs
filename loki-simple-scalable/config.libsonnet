local k = import 'ksonnet-util/kausal.libsonnet';

{
  _config+: {
    namespace: error 'must define namespace',
    cluster: error 'must define cluster',
    headless_service_name: error 'must define headless service name',
    http_listen_port: 3100,
    grpc_listen_port: 9095,

    // replication_factor: 3,
    //     memcached_replicas: 3,

    // Default to GCS and Bigtable for chunk and index store
    storage_backend: 'gcs',
    boltdb_shipper_shared_store: 'gcs',

    table_prefix: $._config.namespace,
    index_period_hours: 24,
    // index_period_hours: 168,  // 1 week

    // GCS variables
    gcs_bucket_name: error 'must specify GCS bucket name',

    client_configs: {
      gcs: {
        bucket_name: $._config.gcs_bucket_name,
      },
    },

    // December 11 is when we first launched to the public.
    // Assume we can ingest logs that are 5months old.
    schema_start_date: '2021-09-12',

    commonArgs: {
      'config.file': '/etc/loki/config.yaml',
    },

    loki: {
      server: {
        http_listen_port: $._config.http_listen_port,
        grpc_listen_port: $._config.grpc_listen_port,
      },
      memberlist: {
        join_members: [
          '%(headless_service_name)s.%(namespace)s.svc.cluster.local' % $._config,
        ],
      },
      common: {
        path_prefix: '/data',
        storage: {
          gcs: $._config.client_configs.gcs,
        },
      },
      ingester: {
        chunk_encoding: 'snappy',
        sync_min_utilization: 0.2,
        sync_period: '4h',
        wal: {
          replay_memory_ceiling: '5GB',
        },
      },
      limits_config: {
        enforce_metric_name: false,
        reject_old_samples_max_age: '168h',  //1 week
        max_global_streams_per_user: 60000,
        ingestion_rate_mb: 75,
        ingestion_burst_size_mb: 100,
      },
      schema_config: {
        configs: [{
          from: $._config.schema_start_date,
          store: 'boltdb-shipper',
          object_store: 'gcs',
          schema: 'v11',
          index: {
            prefix: '%s_index_' % $._config.table_prefix,
            period: '%dh' % $._config.index_period_hours,
          },
        }],
      },
      querier: {
        max_concurrent: 6,  // This is the number of threads a querier will consume with workers against the frontend, may tie to a --cpu flag. This is a worker per frontend
        query_ingesters_within: '2h',
        query_timeout: '5m',
      },
      query_range: {
        align_queries_with_step: true,
        cache_results: true,
        parallelise_shardable_queries: true,
        split_queries_by_interval: '30m',
      },
      frontend: {
        compress_responses: true,
        log_queries_longer_than: '5s',
        max_outstanding_per_tenant: 1024,
      },
      frontend_worker: {
        grpc_client_config: {
          max_send_msg_size: 1.048576e+08,
        },
        match_max_concurrent: true,
      },
    },
  },

  local configMap = k.core.v1.configMap,

  config_file:
    configMap.new('loki') +
    configMap.withData({
      'config.yaml': k.util.manifestYaml($._config.loki),
    }),

  local deployment = k.apps.v1.deployment,

  config_hash_mixin::
    deployment.mixin.spec.template.metadata.withAnnotationsMixin({
      config_hash: std.md5(std.toString($._config.loki)),
    }),
}
