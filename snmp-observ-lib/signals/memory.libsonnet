local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'avg',
    enableLokiLogs: this.enableLokiLogs,
    discoveryMetric: {
      generic: 'hrStorageUsed',
      arista_sw: self.generic,
      brocade_fc: 'swMemUsage',
      brocade_foundry: 'snAgGblDynMemUtil',
      cisco: 'cempMemPoolUsed',
      dell_network: 'dellNetCpuUtilMemUsage',
      dlink_des: 'agentDRAMutilization',
      extreme: 'extremeMemoryMonitorSystemTotal',
      eltex_mes: 'issSwitchCurrentRAMUsage',
      f5_bigip: 'sysGlobalTmmStatMemoryUsed',
      fortigate: self.generic,
      hpe: 'hpLocalMemAllocBytes',
      huawei: 'hwEntityMemUsage',
      juniper: 'jnxOperatingBuffer',
      mikrotik: self.generic,
      netgear: 'agentSwitchCpuProcessMemAvailable',
      qtech: 'switchMemoryBusy',
      tplink: 'tpSysMonitorMemoryUtilization',
      ubiquiti_airos: 'memTotal',
    },
    signals: {
      memoryUsage: {
        name: 'Memory utilization',
        type: 'gauge',
        unit: 'percent',
        sources: {
          generic: {
            // net-snmp's Physical memory row counts page cache as used. Its Available memory row, from net-snmp 5.9.1, is the kernel's MemAvailable.
            local agg = std.join(',', this.groupLabels + this.instanceLabels),
            local bySelector(selector) = |||
              avg by (%(agg)s) (
                hrStorageUsed{%(selector)s, %%(queriesSelector)s}/hrStorageSize{%(selector)s, %%(queriesSelector)s}*100
              )
            ||| % { agg: agg, selector: selector },
            expr:
              if this.memorySelector != '' then bySelector(this.memorySelector)
              else |||
                # net-snmp 5.9.1 and later:
                avg by (%(agg)s) (
                  100 * (1 - hrStorageSize{hrStorageDescr="Available memory", %%(queriesSelector)s}
                  / on (%(agg)s) hrStorageSize{hrStorageDescr="Physical memory", %%(queriesSelector)s})
                )
                or
                # earlier net-snmp: cached memory and buffers are subtracted
                avg by (%(agg)s) (
                  100 * (hrStorageUsed{hrStorageDescr="Physical memory", %%(queriesSelector)s}
                  - on (%(agg)s) hrStorageUsed{hrStorageDescr="Cached memory", %%(queriesSelector)s}
                  - on (%(agg)s) hrStorageUsed{hrStorageDescr="Memory buffers", %%(queriesSelector)s})
                  / on (%(agg)s) hrStorageSize{hrStorageDescr="Physical memory", %%(queriesSelector)s}
                )
                or
              ||| % { agg: agg } + bySelector('hrStorageDescr!~".*(?i:(cache|buffer)).*", hrStorageType="1.3.6.1.2.1.25.2.1.2"'),
          },
          arista_sw: self.generic,
          brocade_fc: {
            expr: 'swMemUsage{%(queriesSelector)s}',
          },
          brocade_foundry: {
            expr: 'snAgGblDynMemUtil{%(queriesSelector)s}',
          },
          cisco: {
            expr: |||
              # cisco CISCO-ENHANCED-MEMPOOL-MIB
              # cempMemPoolType="10" - virtual memory, i.e in ASA(v).
              (
                (
                  cempMemPoolUsed{%%(queriesSelector)s}
                  /
                  (cempMemPoolUsed{%%(queriesSelector)s} + cempMemPoolFree{%%(queriesSelector)s}) * 100
                ) * on (%(joinLabels)s, cempMemPoolIndex, entPhysicalIndex) group_left ()
                      (cempMemPoolType{%%(queriesSelector)s} == 10)/10
              )
              or
              # cisco firmwares that supports only CISCO-MEMORY-POOL-MIB
              # ciscoMemoryPoolType="1" - Processor
              (ciscoMemoryPoolUsed{ciscoMemoryPoolType="1", %%(queriesSelector)s}
              /
              (ciscoMemoryPoolUsed{ciscoMemoryPoolType="1", %%(queriesSelector)s} + ciscoMemoryPoolFree{ciscoMemoryPoolType="1", %%(queriesSelector)s}) * 100)
            ||| % { joinLabels: std.join(',', this.groupLabels + this.instanceLabels) },
          },
          dell_network: {
            expr: 'dellNetCpuUtilMemUsage{%(queriesSelector)s}',
          },
          dlink_des: {
            expr: 'agentDRAMutilization{%(queriesSelector)s}',
          },
          extreme: {
            expr: |||
              (extremeMemoryMonitorSystemTotal{%(queriesSelector)s}-extremeMemoryMonitorSystemFree{%(queriesSelector)s})/extremeMemoryMonitorSystemTotal{%(queriesSelector)s}*100
            |||,
          },
          eltex_mes: {
            expr: 'issSwitchCurrentRAMUsage{%(queriesSelector)s}',
          },
          // https://my.f5.com/manage/s/article/K44014003
          f5_bigip: {
            expr: |||
              # f5_bigip
              (sysGlobalTmmStatMemoryUsed{%(queriesSelector)s}+sysGlobalHostOtherMemoryUsed{%(queriesSelector)s})
              /
              (sysGlobalTmmStatMemoryTotal{%(queriesSelector)s} + sysGlobalHostOtherMemoryTotal{%(queriesSelector)s}) * 100
            |||,
          },
          fortigate: self.generic,
          hpe: {
            expr: |||
              # hpe
              hpLocalMemAllocBytes{%(queriesSelector)s}
              /
              hpLocalMemTotalBytes{%(queriesSelector)s} * 100
            |||,
          },
          huawei: {
            expr: 'hwEntityMemUsage{%(queriesSelector)s}',
          },
          juniper: {
            // Category 9 also lists routing engine components, such as a "USB Hub" at level two index 1, that report 0.
            // With two routing engines, max takes the master's: on the EX4200 and MX240 recordings, the master reports the higher memory use.
            expr: 'max by (%(agg)s) (jnxOperatingBuffer{jnxOperatingContentsIndex="9", jnxOperatingL2Index="0", %%(queriesSelector)s})'
                  % { agg: std.join(',', this.groupLabels + this.instanceLabels) },
          },
          mikrotik: {
            expr: |||
              hrStorageUsed{%(memorySelector)s, %%(queriesSelector)s}/hrStorageSize{%(memorySelector)s, %%(queriesSelector)s}*100
            ||| % { memorySelector: this.mikrotikMemorySelector },
          },
          netgear: {
            expr: |||
              # netgear
              (agentSwitchCpuProcessMemAvailable{%(queriesSelector)s}-agentSwitchCpuProcessMemFree{%(queriesSelector)s})
              /
              agentSwitchCpuProcessMemAvailable{%(queriesSelector)s} * 100
            |||,
          },
          qtech: {
            expr: |||
              switchMemoryBusy{%(queriesSelector)s}
              /
              switchMemorySize{%(queriesSelector)s} * 100
            |||,
          },
          tplink: {
            expr: 'tpSysMonitorMemoryUtilization{%(queriesSelector)s}',
          },
          ubiquiti_airos: {
            // FROGFOOT-RESOURCES-MIB
            // # HELP memFree Available physical memory (in KB) - 1.3.6.1.4.1.10002.1.1.1.1.2
            // # TYPE memFree gauge
            // memFree 42576
            // # HELP memTotal Total usable physical memory (in KB) - 1.3.6.1.4.1.10002.1.1.1.1.1
            // # TYPE memTotal gauge
            // memTotal 62268
            expr: |||
              (memTotal{%(queriesSelector)s}-memFree{%(queriesSelector)s})
              /
              memTotal{%(queriesSelector)s} * 100
            |||,
          },
        },
      },
    },
  }
