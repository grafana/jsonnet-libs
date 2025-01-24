local commonlib = import 'common-lib/common/main.libsonnet';
local xtd = import 'github.com/jsonnet-libs/xtd/main.libsonnet';
function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'sum',
    discoveryMetric: {
      generic: 'sysUpTime',
      arista_sw: self.generic,
      brocade_fc: self.generic,
      brocade_foundry: self.generic,
      cisco: self.generic,
      dell_network: self.generic,
      dlink_des: self.generic,
      extreme: self.generic,
      eltex: self.generic,
      eltex_mes: self.generic,
      f5_bigip: self.generic,
      fortigate: self.generic,
      hpe: self.generic,
      huawei: self.generic,
      juniper: self.generic,
      mikrotik: self.generic,
      netgear: self.generic,
      qtech: self.generic,
      tplink: self.generic,
      ubiquiti_airos: self.generic,
    },
    signals: {
      uptime: {
        name: 'Uptime',
        description: |||
          The time since the network management portion of the system was last re-initialized.
        |||,
        type: 'gauge',
        unit: 'dtdurations',
        sources: {
          generic:
            {
              expr: 'sysUpTime{%(queriesSelector)s}',
              //ticks to seconds
              exprWrappers: [['(', ')/100']],
            },
          arista_sw: self.generic,
          brocade_fc: self.generic,
          brocade_foundry: self.generic,
          cisco: self.generic,
          dell_network: self.generic,
          dlink_des: self.generic,
          extreme: self.generic,
          eltex: self.generic,
          eltex_mes: self.generic,
          f5_bigip: self.generic,
          fortigate: self.generic,
          hpe: self.generic,
          huawei: self.generic,
          juniper: self.generic,
          mikrotik: self.generic,
          netgear: self.generic,
          qtech: self.generic,
          tplink: self.generic,
          ubiquiti_airos: self.generic,
        },
      },
      sysName: {
        name: 'System name',
        description: |||
          System name.
        |||,
        type: 'info',
        sources: {
          generic:
            {
              expr: 'sysName{%(queriesSelector)s}',
              infoLabel: 'sysName',
            },
          arista_sw: self.generic,
          brocade_fc: self.generic,
          brocade_foundry: self.generic,
          cisco: self.generic,
          dell_network: self.generic,
          dlink_des: self.generic,
          extreme: self.generic,
          eltex: self.generic,
          eltex_mes: self.generic,
          f5_bigip: self.generic,
          fortigate: self.generic,
          hpe: self.generic,
          huawei: self.generic,
          juniper: self.generic,
          mikrotik: self.generic,
          netgear: self.generic,
          qtech: self.generic,
          tplink: self.generic,
          ubiquiti_airos: self.generic,
        },
      },
      version: {
        name: 'Version',
        description: |||
          System version.
        |||,
        type: 'info',
        sources: {
          generic: self.cisco,
          arista_sw: self.generic,
          brocade_fc: self.generic,
          brocade_foundry: self.generic,
          cisco:
            {
              expr: 'label_replace(sysDescr{%(queriesSelector)s}, "sysDescr", "$1", "sysDescr", ".*Version(.+?),.*")',
              infoLabel: 'sysDescr',
            },
          dell_network: self.generic,
          dlink_des: self.generic,
          extreme: self.generic,
          eltex: self.generic,
          eltex_mes: self.generic,
          f5_bigip: self.generic,
          fortigate: self.generic,
          hpe: self.generic,
          huawei: self.generic,
          juniper: self.generic,
          mikrotik: self.generic,
          netgear: self.generic,
          qtech: self.generic,
          tplink: self.generic,
          ubiquiti_airos: self.generic,
        },
      },
    },
  }


// - uuid: 64128e7f2adf44988b0ca3edd76cba61
//   name: 'JUNIPER-ALARM-MIB::jnxOperatingState'
//   mappings:
//     - value: '1'
//       newvalue: unknown
//     - value: '2'
//       newvalue: running
//     - value: '3'
//       newvalue: ready
//     - value: '4'
//       newvalue: reset
//     - value: '5'
//       newvalue: runningAtFullSpeed
//     - value: '6'
//       newvalue: 'down or off'
//     - value: '7'
//       newvalue: standby
// - uuid: 3aaa451c55cd4e72ab84b65dd8310564
//   name: 'JUNIPER-ALARM-MIB::jnxRedAlarmState'
//   mappings:
//     - value: '1'
//       newvalue: other
//     - value: '2'
//       newvalue: 'off'
//     - value: '3'
//       newvalue: 'on - RedAlarm'
