{
  // any modular library should include as inputs:
  // 'dashboardNamePrefix' - Use as prefix for all Dashboards and (optional) rule groups
  // 'filteringSelector' - Static selector to apply to ALL dashboard variables of type query, panel queries, alerts and recording rules.
  // 'groupLabels' - one or more labels that can be used to identify 'group' of instances. In simple cases, can be 'job' or 'cluster'.
  // 'instanceLabels' - one or more labels that can be used to identify single entity of instances. In simple cases, can be 'instance' or 'pod'.
  // 'uid' - UID to prefix all dashboards original uids
  local this = self,
  filteringSelector: 'job!=""',
  groupLabels: ['job'],
  instanceLabels: ['instance'],
  dashboardTags: [self.uid],
  uid: 'golang',
  dashboardNamePrefix: '',

  // additional params can be added if needed
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  // otel: https://pkg.go.dev/go.opentelemetry.io/contrib/instrumentation/runtime
  // or prometheus
  metricsSource: 'prometheus',
  signals: {
    discoveryMetric: {
      prometheus: 'go_info',
      otel: 'process_runtime_go_goroutines',
    },
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',  // group, instance, or none.
    alertsInterval: '5m',
    signals: {
      //general go
      uptime: {
        name: 'Uptime',
        type: 'gauge',  //show as is.
        description: 'Golang process uptime.',
        unit: 'dtdurations',  //duration in seconds
        sources: {
          prometheus:
            {
              expr: 'time()-process_start_time_seconds{%(queriesSelector)s}',
            },
          otel: {
            expr: 'runtime_uptime{%(queriesSelector)s}/1000',
          },
        },
      },
      version: {
        name: 'Golang version',
        type: 'info',
        description: 'Golang version used.',
        optional: true,
        sources: {
          prometheus:
            {
              expr: 'go_info{%(queriesSelector)s}',
              infoLabel: 'version',
            },
          //no otel metric?
        },
      },
      goRoutines: {
        name: 'Goroutines',
        type: 'gauge',
        unit: 'short',
        description: 'Number of goroutines.',
        sources: {
          prometheus:
            {
              expr: 'go_goroutines{%(queriesSelector)s}',
            },
          otel:
            {
              expr: 'process_runtime_go_goroutines{%(queriesSelector)s}',
            },
        },
      },
      cgoCalls: {
        name: 'CGo calls',
        type: 'counter',
        description: 'Number of cgo calls made by the current process',
        sources: {
          prometheus: {
            expr: 'go_cgo_go_to_c_calls_calls_total{%(queriesSelector)s}',
          },
          otel: {
            expr: 'process_runtime_go_cgo_calls{%(queriesSelector)s}',
          },
        },
      },
      // gc duration:
      gcDurationMin: {
        name: 'GC duration (min)',
        description: |||
          Minimum amount of time in GC stop-the-world pauses. 
          During a stop-the-world pause, all goroutines are paused and only the garbage collector can run.
        |||,
        type: 'gauge',
        unit: 'ns',
        optional: true,
        sources: {
          prometheus: {
            expr: 'go_gc_duration_seconds{%(queriesSelector)s, quantile="0"}*10^6',
          },
        },
      },
      gcDurationMax: {
        name: 'GC duration (max)',
        description: |||
          Maximum amount of time in GC stop-the-world pauses.
          During a stop-the-world pause, all goroutines are paused and only the garbage collector can run.
        |||,
        type: 'gauge',
        unit: 'ns',
        optional: true,
        sources: {
          prometheus: {
            expr: 'go_gc_duration_seconds{%(queriesSelector)s, quantile="1"}*10^6',
          },
        },
      },
      gcDurationPercentile: {
        name: 'GC duration',
        description: |||
          Amount of time in GC stop-the-world pauses (95th percentile).
          During a stop-the-world pause, all goroutines are paused and only the garbage collector can run.
        |||,
        type: 'histogram',
        unit: 'ns',
        optional: true,
        sources: {
          otel: {
            expr: 'process_runtime_go_gc_pause_ns_bucket{%(queriesSelector)s}',
          },
        },
      },
      goThreads: {
        name: 'Threads used',
        description: |||
          System threads used.
        |||,
        type: 'gauge',
        optional: true,
        sources: {
          prometheus: {
            expr: 'go_threads{%(queriesSelector)s}',
          },
        },
      },

      //memory
      memReserved: {
        name: 'Memory reserved from system',
        description: |||
          Memory reserved from system.
        |||,
        type: 'gauge',
        optional: true,
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'go_memstats_sys_bytes{%(queriesSelector)s}',
          },
        },
      },
      memTotal: {
        name: 'Memory allocated from system',
        type: 'gauge',
        optional: true,
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'go_memstats_alloc_bytes{%(queriesSelector)s}',
          },
        },
      },

      //memory heap
      memHeapReserved: {
        name: 'Memory reserved from system by heap',
        description: |||
          Memory reserved from system by heap.
        |||,
        type: 'gauge',
        unit: 'decbytes',
        optional: true,
        sources: {
          prometheus: {
            expr: 'go_memstats_heap_sys_bytes{%(queriesSelector)s}',
          },
        },
      },
      memHeapObjBytes: {
        name: 'Heap objects, bytes',
        description: |||
          Bytes of allocated heap objects.
        |||,
        type: 'gauge',
        unit: 'decbytes',
        optional: true,
        sources: {
          prometheus: {
            expr: 'go_memstats_heap_alloc_bytes{%(queriesSelector)s}',
          },
          otel: {
            expr: 'process_runtime_go_mem_heap_alloc{%(queriesSelector)s}',
          },
        },
      },
      memHeapIdleBytes: {
        name: 'Heap idle spans, bytes',
        description: |||
          Bytes in idle (unused) spans.
        |||,
        type: 'gauge',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'go_memstats_heap_idle_bytes{%(queriesSelector)s}',
          },
          otel: {
            expr: 'process_runtime_go_mem_heap_idle{%(queriesSelector)s}',
          },
        },
      },
      memHeapInUseBytes: {
        name: 'Heap in-use spans, bytes',
        description: |||
          Bytes in in-use spans.
        |||,
        type: 'gauge',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'go_memstats_heap_inuse_bytes{%(queriesSelector)s}',
          },
          otel: {
            expr: 'process_runtime_go_mem_heap_inuse{%(queriesSelector)s}',
          },
        },
      },
      memHeapReleasedBytes: {
        name: 'Heap released, bytes',
        description: |||
          Bytes of idle spans whose physical memory has been returned to the OS.
        |||,
        type: 'gauge',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'go_memstats_heap_released_bytes{%(queriesSelector)s}',
          },
          otel: {
            expr: 'process_runtime_go_mem_heap_released{%(queriesSelector)s}',
          },
        },
      },

      memHeapAllocatedObjects: {
        name: 'Heap allocated objects',
        description: |||
          Number of allocated heap objects.
          This changes as GC is performed and new objects are allocated.
        |||,
        type: 'gauge',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'go_memstats_heap_objects{%(queriesSelector)s}',
          },
          otel: {
            expr: 'process_runtime_go_mem_heap_objects{%(queriesSelector)s}',
          },
        },
      },

      // memHeapLiveObjects: {
      //   name: 'Heap live objects',
      //   description: |||
      //     Number of live objects in heap.
      //   |||,
      //   type: 'gauge',
      //   unit: 'allocations',
      //   sources: {
      //     prometheus: {
      //       expr: |||
      //         idelta(go_memstats_mallocs_total{%(queriesSelector)s}[5m])-
      //         idelta(go_memstats_frees_total{%(queriesSelector)s}[5m])
      //       |||,
      //     },
      //     otel: {
      //       expr: 'process_runtime_go_mem_heap_objects{%(queriesSelector)s}',
      //     },
      //   },
      // },

      //memory stack
      memStack: {
        name: 'Memory reserved by stack',
        description: |||
          Memory reserved by stack.
        |||,
        type: 'gauge',
        unit: 'decbytes',
        optional: true,
        sources: {
          prometheus: {
            expr: 'go_memstats_stack_sys_bytes{%(queriesSelector)s}',
          },
        },
      },

      //memory off-heap
      memMspan: {
        name: 'Memory mspan',
        description: 'Memory reserved by mspan',
        unit: 'decbytes',
        type: 'gauge',
        optional: true,
        sources: {
          prometheus: {
            expr: 'go_memstats_mspan_sys_bytes{%(queriesSelector)s}',
          },
        },
      },
      memMcache: {
        name: 'Memory mcache',
        description: 'Memory reserved by mcache',
        unit: 'decbytes',
        type: 'gauge',
        optional: true,
        sources: {
          prometheus: {
            expr: 'go_memstats_mcache_sys_bytes{%(queriesSelector)s}',
          },
        },
      },
      memBuckHash: {
        name: 'Memory buck hash',
        description: 'Memory reserved by mcache',
        unit: 'decbytes',
        type: 'gauge',
        optional: true,
        sources: {
          prometheus: {
            expr: 'go_memstats_buck_hash_sys_bytes{%(queriesSelector)s}',
          },
        },
      },
      memGc: {
        name: 'Memory gc metadata',
        description: 'Memory reserved by gc metadata',
        unit: 'decbytes',
        type: 'gauge',
        optional: true,
        sources: {
          prometheus: {
            expr: 'go_memstats_gc_sys_bytes{%(queriesSelector)s}',
          },
        },
      },
      memOther: {
        name: 'Memory other',
        description: 'Memory reserved for other needs',
        unit: 'decbytes',
        type: 'gauge',
        optional: true,
        sources: {
          prometheus: {
            expr: 'go_memstats_other_sys_bytes{%(queriesSelector)s}',
          },
        },
      },

    },
  },
}
