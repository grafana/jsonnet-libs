local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;
{
  new(this):
    {
      local t = this.grafana.targets,

      memoryReservedMemory:
        commonlib.panels.memory.timeSeries.usageBytes.new(
          'Total reserved memory',
          targets=[t['group:go_memstats_sys_bytes:avg']],
          description='Average total bytes of memory reserved across all instances in a group.'
        ),
      memoryStackUse:
        commonlib.panels.memory.timeSeries.usageBytes.new(
          'Stack memory in use',
          targets=[t['group:go_memstats_stack_sys_bytes:avg']],
          description='Average stack memory usage across all instances in a group.'
        ),

      memoryOtherReservations:
        commonlib.panels.memory.timeSeries.usageBytes.new(
          'Other memory reservations',
          targets=[
            t['group:go_memstats_mspan_sys_bytes:avg'],
            t['group:go_memstats_mcache_sys_bytes:avg'],
            t['group:go_memstats_buck_hash_sys_bytes:avg'],
            t['group:go_memstats_gc_sys_bytes:avg'],
          ],
          description='Average memory reservations by the runtime, not for stack or heap, across all instances of a group.',
        ),

      memoryHeap:
        commonlib.panels.memory.timeSeries.usageBytes.new(
          title='Heap memory',
          targets=[
            t['group:go_memstats_heap_inuse_bytes:avg'],
            t['group:go_memstats_heap_sys_bytes:avg'],
          ],
          description='Average memory reserved, and actually in use, by the heap, across all instances of a group.',
          totalRegexp='heap reserved',
        ),

      memoryAllocationRate:
        commonlib.panels.generic.timeSeries.base.new(
          title='Allocation rate, bytes',
          targets=[t['group:go_memstats_alloc_bytes:avg_rate']],
          description='Average allocation rate in bytes per second, across all instances of a group.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('bps'),
      memoryObjectAllocationRate:
        commonlib.panels.generic.timeSeries.base.new(
          title='Heap object allocation rate',
          targets=[t['group:go_memstats_mallocs:avg_rate']],
          description='Average rate of heap object allocation, across all instances of a group.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('obj/s'),

      goroutines:
        commonlib.panels.generic.timeSeries.base.new(
          title='Goroutines',
          targets=[t['group:go_goroutines:avg']],
          description='Average number of goroutines across instances of a group.',
        ),

      garbageCollector:
        commonlib.panels.generic.timeSeries.base.new(
          title='Garbage collector',
          targets=[
            t['group:go_gc_duration_seconds:avg_min'],
            t['group:go_gc_duration_seconds:avg_max'],
          ],
          description='GC min & max duration.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('seconds'),

      nextGC:
        commonlib.panels.generic.timeSeries.base.new(
          title='Next GC, bytes',
          targets=[
            t['group:go_memstats_next_gc_bytes:avg'],
          ],
          description='The number used bytes at which the runtime plans to perform the next GC, averaged across all instances of a group.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('bytes'),


    },
}
