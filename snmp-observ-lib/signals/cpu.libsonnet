local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'avg',
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
            // # HELP loadValue The 1,5 and 10 minute load averages - 1.3.6.1.4.1.10002.1.1.1.4.2.1.3
            // # TYPE loadValue gauge
            // loadValue{loadIndex="1"} 12
            // loadValue{loadIndex="2"} 83
            // loadValue{loadIndex="3"} 2
            expr: 'loadValue{loadIndex="1", %(queriesSelector)s}',
          },
        },
      },
    },
  }
