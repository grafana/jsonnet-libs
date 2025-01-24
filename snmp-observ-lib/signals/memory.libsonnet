local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'avg',
    discoveryMetric: {
      generic: 'hrStorageUsed',
      arista_sw: self.generic,
      brocade_fc: 'swMemUsage',
      brocade_foundry: 'snAgGblDynMemUtil',
      cisco: 'cpmCPUMemoryUsed',
      dell_network: 'dellNetCpuUtilMemUsage',
      dlink_des: 'agentDRAMutilization',
      extreme: 'extremeMemoryMonitorSystemTotal',
      eltex: 'eltexProcessMemoryTotal',
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
        description: 'Memory utilization.',
        type: 'gauge',
        unit: 'percent',
        sources: {
          generic: {
            expr: |||
              hrStorageUsed{%(memorySelector)s, %%(queriesSelector)s}/hrStorageSize{%(memorySelector)s, %%(queriesSelector)s}*100
            ||| % { memorySelector: this.memorySelector },
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
              # cisco
              cpmCPUMemoryUsed{%(queriesSelector)s}
              /
              (cpmCPUMemoryUsed{%(queriesSelector)s} + cpmCPUMemoryFree{%(queriesSelector)s}) * 100
            |||,
          },
          dell_network: {
            expr: 'chStackUnitMemUsageUtil{%(queriesSelector)s}',
          },
          dlink_des: {
            expr: 'agentDRAMutilization{%(queriesSelector)s}',
          },
          extreme: {
            expr: |||
              (extremeMemoryMonitorSystemTotal{%(queriesSelector)s}-extremeMemoryMonitorSystemFree{%(queriesSelector)s})/extremeMemoryMonitorSystemTotal{%(queriesSelector)s}*100
            |||,
          },
          eltex: {
            expr: |||
              # eltex
              (eltexProcessMemoryTotal{%(queriesSelector)s}-eltexProcessMemoryFree{%(queriesSelector)s})/eltexProcessMemoryTotal{%(queriesSelector)s}*100
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
          fortigate: {
            expr: self.generic,
          },
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
            expr: 'jnxOperatingBuffer{jnxOperatingContentsIndex="9", %(queriesSelector)s}',
            aggKeepLabels: ['jnxOperatingDescr'],
          },
          mikrotik: {
            expr: |||
              hrStorageUsed{%(memorySelector)s, %%(queriesSelector)s}/hrStorageSize{%(memorySelector)s, %%(queriesSelector)s}*100
            ||| % { memorySelector: this.mikrotikMemorySelector },
          },
          netgear: {
            expr: |||
              # netgear
              (agentSwitchCpuProcessMemAvailable{%(queriesSelector)s}-agentSwitchCpuProcessMemFree{%(queriesSelector)s}{%(queriesSelector)s})
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
