local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'instance',
    aggFunction: 'sum',
    discoveryMetric: {
      prometheus: 'pinecone_db_record_total',
    },
    signals: {
      // Overview/Capacity signals
      recordTotal: {
        name: 'Total records',
        nameShort: 'Records',
        type: 'gauge',
        unit: 'short',
        description: 'The total number of records in the index.',
        sources: {
          prometheus: {
            expr: 'pinecone_db_record_total{%(queriesSelector)s}',
          },
        },
      },

      storageSizeBytes: {
        name: 'Storage size',
        nameShort: 'Storage',
        type: 'gauge',
        unit: 'decbytes',
        description: 'The total size of the index in bytes.',
        sources: {
          prometheus: {
            expr: 'pinecone_db_storage_size_bytes{%(queriesSelector)s}',
          },
        },
      },

      // Upsert operations
      upsertTotal: {
        name: 'Upsert requests',
        nameShort: 'Upserts',
        type: 'counter',
        unit: 'reqps',
        description: 'The number of upsert requests made to an index.',
        sources: {
          prometheus: {
            expr: 'pinecone_db_op_upsert_count{%(queriesSelector)s}',
          },
        },
      },

      upsertDuration: {
        name: 'Upsert duration',
        nameShort: 'Upsert dur',
        type: 'raw',
        unit: 'ms',
        description: |||
          Average latency of upsert operations in milliseconds.  
          Calculated as rate of total duration divided by rate of requests.  
          Indicates how long each upsert operation takes on average.
        |||,
        sources: {
          prometheus: {
            expr: 'sum by(cloud, region, job, index_name) (rate(pinecone_db_op_upsert_duration_sum{%(queriesSelector)s}[$__rate_interval])) / sum by(cloud, region, job, index_name) (rate(pinecone_db_op_upsert_count{%(queriesSelector)s}[$__rate_interval]))',
          },
        },
      },

      // Query operations
      queryTotal: {
        name: 'Query requests',
        nameShort: 'Queries',
        type: 'counter',
        unit: 'reqps',
        description: 'The number of query requests made to an index.',
        sources: {
          prometheus: {
            expr: 'pinecone_db_op_query_count{%(queriesSelector)s}',
          },
        },
      },

      queryDuration: {
        name: 'Query duration',
        nameShort: 'Query dur',
        type: 'raw',
        unit: 'ms',
        description: |||
          Average latency of query operations in milliseconds.  
          Calculated as rate of total duration divided by rate of requests.  
          Indicates how long each query operation takes on average.
        |||,
        sources: {
          prometheus: {
            expr: 'sum by(cloud, region, job, index_name) (rate(pinecone_db_op_query_duration_sum{%(queriesSelector)s}[$__rate_interval])) / sum by(cloud, region, job, index_name) (rate(pinecone_db_op_query_count{%(queriesSelector)s}[$__rate_interval]))',
          },
        },
      },

      // Fetch operations
      fetchTotal: {
        name: 'Fetch requests',
        nameShort: 'Fetches',
        type: 'counter',
        unit: 'reqps',
        description: 'The number of fetch requests made to an index.',
        sources: {
          prometheus: {
            expr: 'pinecone_db_op_fetch_count{%(queriesSelector)s}',
          },
        },
      },

      fetchDuration: {
        name: 'Fetch duration',
        nameShort: 'Fetch dur',
        type: 'raw',
        unit: 'ms',
        description: |||
          Average latency of fetch operations in milliseconds.  
          Calculated as rate of total duration divided by rate of requests.  
          Indicates how long each fetch operation takes on average.
        |||,
        sources: {
          prometheus: {
            expr: 'sum by(cloud, region, job, index_name) (rate(pinecone_db_op_fetch_duration_sum{%(queriesSelector)s}[$__rate_interval])) / sum by(cloud, region, job, index_name) (rate(pinecone_db_op_fetch_count{%(queriesSelector)s}[$__rate_interval]))',
          },
        },
      },

      // Delete operations
      deleteTotal: {
        name: 'Delete requests',
        nameShort: 'Deletes',
        type: 'counter',
        unit: 'reqps',
        description: 'The number of delete requests made to an index.',
        sources: {
          prometheus: {
            expr: 'pinecone_db_op_delete_count{%(queriesSelector)s}',
          },
        },
      },

      deleteDuration: {
        name: 'Delete duration',
        nameShort: 'Delete dur',
        type: 'raw',
        unit: 'ms',
        description: |||
          Average latency of delete operations in milliseconds.  
          Calculated as rate of total duration divided by rate of requests.  
          Indicates how long each delete operation takes on average.
        |||,
        sources: {
          prometheus: {
            expr: 'sum by(cloud, region, job, index_name) (rate(pinecone_db_op_delete_duration_sum{%(queriesSelector)s}[$__rate_interval])) / sum by(cloud, region, job, index_name) (rate(pinecone_db_op_delete_count{%(queriesSelector)s}[$__rate_interval]))',
          },
        },
      },

      // Resource usage
      writeUnitsTotal: {
        name: 'Write units',
        nameShort: 'Write units',
        type: 'counter',
        unit: 'short',
        description: 'The total number of write units consumed by an index.',
        sources: {
          prometheus: {
            expr: 'pinecone_db_write_unit_total{%(queriesSelector)s}',
          },
        },
      },

      readUnitsTotal: {
        name: 'Read units',
        nameShort: 'Read units',
        type: 'counter',
        unit: 'short',
        description: 'The total number of read units consumed by an index.',
        sources: {
          prometheus: {
            expr: 'pinecone_db_read_unit_count{%(queriesSelector)s}',
          },
        },
      },
    },
  }
