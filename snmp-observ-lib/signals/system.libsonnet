local commonlib = import 'common-lib/common/main.libsonnet';
local xtd = import 'github.com/jsonnet-libs/xtd/main.libsonnet';
function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'sum',
    enableLokiLogs: this.enableLokiLogs,
    discoveryMetric: {
      generic: 'sysUpTime',
      arista_sw: self.generic,
      brocade_fc: self.generic,
      brocade_foundry: self.generic,
      cisco: self.generic,
      dell_network: self.generic,
      dlink_des: self.generic,
      extreme: self.generic,
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
      fruOperStatus: {
        name: 'FRU status',
        nameShort: 'FRU status',
        description: 'Field replaceable unit status',
        type: 'info',
        optional: true,
        sources: {
          cisco: {
            expr: 'cefcFRUPowerOperStatus{%(queriesSelector)s}',
            aggKeepLabels: ['entPhysicalName'],
            infoLabel: 'cefcFRUPowerOperStatus',
            exprWrappers: [
              ['(', ')!=0'],
            ],
            // valueMappings: [
            //   {
            //     options: {
            //       '1': {
            //         color: 'orange',
            //         index: 1,
            //         text: 'offEnvOther',
            //       },
            //       '2': {
            //         color: 'green',
            //         index: 0,
            //         text: 'on',
            //       },
            //       '3': {
            //         color: 'orange',
            //         index: 2,
            //         text: 'offAdmin',
            //       },
            //       '4': {
            //         color: 'orange',
            //         index: 4,
            //         text: 'offEnvPower',
            //       },
            //       '5': {
            //         color: 'orange',
            //         index: 5,
            //         text: 'offEnvFan',
            //       },
            //       '6': {
            //         color: 'red',
            //         index: 6,
            //         text: 'offEnvTemp',
            //       },
            //       '7': {
            //         color: 'red',
            //         index: 7,
            //         text: 'offEnvFan',
            //       },
            //       '8': {
            //         color: 'red',
            //         index: 8,
            //         text: 'failed',
            //       },
            //       '9': {
            //         color: 'red',
            //         index: 9,
            //         text: 'onButFanFail',
            //       },
            //       '10': {
            //         color: 'red',
            //         index: 10,
            //         text: 'offCooling',
            //       },
            //       '11': {
            //         color: 'red',
            //         index: 11,
            //         text: 'offConnectorRating',
            //       },
            //       '12': {
            //         color: 'yellow',
            //         index: 12,
            //         text: 'onButInlinePowerFail',
            //       },
            //     },
            //     type: 'value',
            //   },
            // ],
            // offEnvOther(1)   FRU is powered off because of a problem not
            //                          listed below.

            //         on(2):           FRU is powered on.

            //         offAdmin(3):     Administratively off.

            //         offDenied(4):    FRU is powered off because available
            //                          system power is insufficient.

            //         offEnvPower(5):  FRU is powered off because of power problem in
            //                          the FRU.  for example, the FRU's power
            //                          translation (DC-DC converter) or distribution
            //                          failed.

            //         offEnvTemp(6):   FRU is powered off because of temperature
            //                          problem.

            //         offEnvFan(7):    FRU is powered off because of fan problems.

            //         failed(8):       FRU is in failed state.

            //         onButFanFail(9): FRU is on, but fan has failed.

            //         offCooling(10):  FRU is powered off because of the system's
            //                          insufficient cooling capacity.

            //         offConnectorRating(11): FRU is powered off because of the
            //                                 system's connector rating exceeded.

            //         onButInlinePowerFail(12): The FRU on, but no inline power
            //                                   is being delivered as the
            //                                   data/inline power component of the
            //                                   FRU has failed."
          },
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
