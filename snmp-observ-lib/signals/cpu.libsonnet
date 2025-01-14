local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'sum',
    discoveryMetric: {
      generic: 'hrProcessorLoad',
      arista: self.generic,
      brocade_fc: 'swCpuUsage',
      brocade_foundry: 'snAgGblCpuUtil1MinAvg',
      cisco: 'cpmCPUTotal1minRev',
      dell_force: 'chStackUnitMemUsageUtil',
      dlink_des: 'agentCPUutilizationIn1min',
      extreme: 'extremeCpuMonitorTotalUtilization',
      eltex: 'eltexProcessCPUMonitorValue',
      eltex_mes: 'eltMesIssCpuUtilLastMinute',
      f5_bigip: 'sysGlobalHostCpuUsageRatio',
      fortigate: 'fgSysCpuUsage',
      hpe: 'hpSwitchCpuStat',
      huawei: 'hwEntityCpuUsage',
      juniper: 'jnxOperatingCPU',
      mikrotik: self.generic,
      netgear: 'agentSwitchCpuProcessTotalUtilization',
      qtech: 'switchCpuUsage',
      tplink: 'tpSysMonitorCpu1Minute',
      ubiquiti_airos: 'loadValue',

    },
    signals: {
      cpuUsage: {
        name: 'CPU utilization',
        description: 'CPU usage.',
        type: 'gauge',
        unit: 'percent',
        sources: {
          generic: {
            expr: 'hrProcessorLoad{%(queriesSelector)s}',
          },
          arista: self.generic,
          brocade_fc: {
            expr: 'swCpuUsage{%(queriesSelector)s}',
          },
          brocade_foundry: {
            expr: 'snAgGblCpuUtil1MinAvg{%(queriesSelector)s}',
          },
          cisco: {
            expr: 'cpmCPUTotal1minRev{%(queriesSelector)s}',
          },
          dell_force: {
            expr: 'chStackUnitMemUsageUtil{%(queriesSelector)s}',
          },
          dlink_des: {
            expr: 'agentCPUutilizationIn1min{%(queriesSelector)s}',
          },

          extreme: {
            expr: 'extremeCpuMonitorTotalUtilization(%(queriesSelector)s)',
          },
          eltex: {
            expr: 'eltexProcessCPUMonitorValue{eltexProcessCPUMonitorInterval="60", %(queriesSelector)s}',
          },
          eltex_mes: {
            expr: 'eltMesIssCpuUtilLastMinute{%(queriesSelector)s}',
          },
          f5_bigip: {
            expr: 'sysGlobalHostCpuUsageRatio{%(queriesSelector)s}',
          },
          fortigate: {
            expr: 'fgSysCpuUsage{%(queriesSelector)s}',
          },
          hpe: {
            expr: 'hpSwitchCpuStat{%(queriesSelector)s}',
          },
          huawei: {
            expr: 'hwEntityCpuUsage{%(queriesSelector)s}',
          },
          juniper: {
            expr: 'jnxOperatingCPU{%(queriesSelector)s}',
          },
          mikrotik: self.generic,
          netgear: {
            expr: 'agentSwitchCpuProcessTotalUtilization{%(queriesSelector)s}',
          },
          qtech: {
            expr: 'switchCpuUsage{%(queriesSelector)s}',
          },
          tplink: {
            expr: 'tpSysMonitorCpu1Minute{%(queriesSelector)s}',
          },
          ubiquiti_airos: {
            // FROGFOOT-RESOURCES-MIB
            expr: 'loadValue{%(queriesSelector)s}',
          },
        },
      },
    },
  }
