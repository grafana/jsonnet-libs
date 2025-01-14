local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'sum',
    discoveryMetric: {
      generic: 'hrStorageUsed',
      arista: self.generic,
      brocade_fc: 'swMemUsage',
      brocade_foundry: 'snAgGblDynMemUtil',
      cisco: 'cpmCPUMemoryUsed',
      dell_force: 'chStackUnitMemUsageUtil',
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
            //TODO: add memory filter: type!=buffer,cache, adjust type="hrStorageRam"
            expr: |||
              hrStorageUsed{%(queriesSelector)s, type="hrStorageRam"}/hrStorageSize{%(queriesSelector)s, type="hrStorageRam"}*100
            |||,
          },
          arista: self.generic,
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
          dell_force: {
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
            expr: 'jnxOperatingBuffer{%(queriesSelector)s}',
          },
          mikrotik: self.generic,
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
