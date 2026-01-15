local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'group', 
    aggFunction: 'sum',
    discoveryMetric: {
      prometheus: 'pinecone_db_record_total',
    },
    signals: {
      // Total number of indexes
      indexesCount: {
        name: 'Total indexes',
        nameShort: 'Indexes',
        type: 'raw',
        unit: 'short',
        description: |||
          Total number of Pinecone indexes being monitored.  
          Each index represents a separate vector database instance.
        |||,
        sources: {
          prometheus: {
            expr: 'count(count by (index_name) (pinecone_db_record_total{%(queriesSelector)s}))',
            legendCustomTemplate: 'Indexes',
          },
        },
      },

      // Aggregate total records across all indexes
      totalRecords: {
        name: 'Total records',
        nameShort: 'Total records',
        type: 'raw',
        unit: 'short',
        description: |||
          Total number of records across all indexes.  
          Sum of all records stored in all monitored Pinecone indexes.
        |||,
        sources: {
          prometheus: {
            expr: 'sum(pinecone_db_record_total{%(queriesSelector)s})',
            legendCustomTemplate: 'Records',
          },
        },
      },

      // Aggregate total storage across all indexes
      totalStorage: {
        name: 'Total storage',
        nameShort: 'Total storage',
        type: 'raw',
        unit: 'decbytes',
        description: |||
          Total storage size across all indexes in bytes.  
          Sum of storage used by all monitored Pinecone indexes.
        |||,
        sources: {
          prometheus: {
            expr: 'sum(pinecone_db_storage_size_bytes{%(queriesSelector)s})',
            legendCustomTemplate: 'Total storage',
          },
        },
      },

      // Aggregate total operations (read + write)
      totalOperationsPerSec: {
        name: 'Total operations',
        nameShort: 'Total ops',
        type: 'raw',
        unit: 'reqps',
        description: |||
          Total operations per second across all indexes.  
          Sum of all read (query, fetch) and write (upsert, delete) operations.
        |||,
        sources: {
          prometheus: {
            expr: |||
              sum(rate(pinecone_db_op_query_count{%(queriesSelector)s}[$__rate_interval]))
              + sum(rate(pinecone_db_op_fetch_count{%(queriesSelector)s}[$__rate_interval]))
              + sum(rate(pinecone_db_op_upsert_count{%(queriesSelector)s}[$__rate_interval]))
              + sum(rate(pinecone_db_op_delete_count{%(queriesSelector)s}[$__rate_interval]))
            |||,
            legendCustomTemplate: 'Total operations',
          },
        },
      },

      // Aggregate read operations
      totalReadOperationsPerSec: {
        name: 'Total read operations',
        nameShort: 'Read ops',
        type: 'raw',
        unit: 'reqps',
        description: |||
          Total read operations per second across all indexes.  
          Sum of query and fetch operations.
        |||,
        sources: {
          prometheus: {
            expr: |||
              sum(rate(pinecone_db_op_query_count{%(queriesSelector)s}[$__rate_interval]))
              + sum(rate(pinecone_db_op_fetch_count{%(queriesSelector)s}[$__rate_interval]))
            |||,
            legendCustomTemplate: 'Read operations',
          },
        },
      },

      // Aggregate write operations
      totalWriteOperationsPerSec: {
        name: 'Total write operations',
        nameShort: 'Write ops',
        type: 'raw',
        unit: 'reqps',
        description: |||
          Total write operations per second across all indexes.  
          Sum of upsert, and delete operations.
        |||,
        sources: {
          prometheus: {
            expr: |||
              sum(rate(pinecone_db_op_upsert_count{%(queriesSelector)s}[$__rate_interval]))
              + sum(rate(pinecone_db_op_delete_count{%(queriesSelector)s}[$__rate_interval]))
            |||,
            legendCustomTemplate: 'Write operations',
          },
        },
      },
    },
  }
