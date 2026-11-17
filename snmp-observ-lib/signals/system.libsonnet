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
        type: 'info',
        sources: {
          generic: {
            expr: 'label_replace(sysDescr{sysDescr=~".+Version.+", %(queriesSelector)s}, "version", "$1", "sysDescr", ".+Version ([^ ,]+).*")',
            infoLabel: 'version',
          },
          arista_sw: self.generic,
          brocade_fc: self.generic,
          brocade_foundry: self.generic,
          cisco: {
            expr: |||
              label_replace(
                ciscoImageString{ciscoImageString=~"CW_VERSION.+", %(queriesSelector)s}, "version", "$1", "ciscoImageString", "CW_VERSION\\$(.+)\\$"
              )
            |||,
            infoLabel: 'version',
          },
          dell_network: self.generic,
          dlink_des: self.generic,
          extreme: self.generic,
          eltex_mes: self.generic,
          f5_bigip: self.generic,
          fortigate: self.generic,
          hpe: self.generic,
          huawei: self.generic,
          juniper: {
            expr: 'label_replace(sysDescr{sysDescr=~".+JUNOS.+", %(queriesSelector)s}, "version", "$1", "sysDescr", ".+JUNOS ([^ ,]+).*")',
            infoLabel: 'version',
          },
          // RouterOS's sysDescr names only the model, such as "RouterOS RB941-2nD".
          mikrotik: {
            expr: 'label_replace(mtxrLicVersion{%(queriesSelector)s}, "version", "$1", "mtxrLicVersion", "(.+)")',
            infoLabel: 'version',
          },
          netgear: self.generic,
          qtech: self.generic,
          tplink: self.generic,
          ubiquiti_airos: self.generic,
        },
      },
      fruOperStatus: {
        name: 'FRU status',
        nameShort: 'FRU status',
        description: 'Field replaceable unit status.',
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
