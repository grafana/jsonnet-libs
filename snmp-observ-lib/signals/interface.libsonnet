local commonlib = import 'common-lib/common/main.libsonnet';
local xtd = import 'github.com/jsonnet-libs/xtd/main.libsonnet';
function(this, level='interface')
  {
    //level is interface or fleet
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels + (if level == 'interface' then ['ifName'] else []),
    aggLevel: 'instance',
    aggFunction: 'sum',
    rangeFunction: 'irate',
    enableLokiLogs: this.enableLokiLogs,
    aggKeepLabels: if level == 'interface' then ['ifAlias', 'ifDescr'] else [],
    local bitsWrapper = ['(', ')*8'],
    local nonZeroWrapper = ['(', ')>0'],
    //set max limit to workaround for TB-PB/sec spikes when counters are overloaded too quickly on very busy interfaces.
    local clampQuery = ['', '\n# set max limit to workaround for TB-PB/sec spikes when counters are overloaded too quickly on very busy interfaces.\n<100*10^9'],
    discoveryMetric: {
      generic: 'ifOperStatus',
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
    varAdHocEnabled: true,
    varAdHocLabels: self.aggKeepLabels,
    signals:
      {
        networkInBitPerSec: {
          name: 'Network interface traffic in',
          nameShort: 'received',
          description: |||
            Network interface traffic in.
          |||,
          type: 'counter',
          unit: 'bps',
          sources: {
            generic:
              {
                expr: 'ifHCInOctets{%(queriesSelector)s}',
                exprWrappers: [bitsWrapper, clampQuery],
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
        networkOutBitPerSec: {
          name: 'Network interface traffic out',
          nameShort: 'transmitted',
          description: |||
            Network interface traffic out.
          |||,
          type: 'counter',
          unit: 'bps',
          sources: {
            generic:
              {
                expr: 'ifHCOutOctets{%(queriesSelector)s} ',
                exprWrappers: [bitsWrapper, clampQuery],
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
        networkOutErrorsPerSec: {
          name: 'Network interface errors out',
          nameShort: 'errors out',
          description: |||
            Network interface errors out.
          |||,
          type: 'counter',
          unit: 'pps',
          sources: {
            generic:
              {
                expr: 'ifOutErrors{%(queriesSelector)s}',
                exprWrappers: [nonZeroWrapper],
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
        networkInErrorsPerSec: {
          name: 'Network interface errors in',
          nameShort: 'errors in',
          description: |||
            Network interface errors in.
          |||,
          type: 'counter',
          unit: 'pps',
          sources: {
            generic:
              {
                expr: 'ifInErrors{%(queriesSelector)s}',
                exprWrappers: [nonZeroWrapper],
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

        networkInDroppedPerSec: {
          name: 'Network interface discards in',
          nameShort: 'dropped in',
          description: |||
            Network interface discards in.
          |||,
          type: 'counter',
          unit: 'pps',
          sources: {
            generic:
              {
                expr: 'ifInDiscards{%(queriesSelector)s}',
                exprWrappers: [nonZeroWrapper],
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
        networkOutDroppedPerSec: {
          name: 'Network interface discards out',
          nameShort: 'dropped out',
          description: |||
            Network interface discards out.
          |||,
          type: 'counter',
          unit: 'pps',
          sources: {
            generic:
              {
                expr: 'ifOutDiscards{%(queriesSelector)s}',
                exprWrappers: [nonZeroWrapper],
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

        networkInUnicastPacketsPerSec: {
          name: 'Network interface unicast packets in',
          nameShort: 'unicast in',
          description: |||
            Network interface unicast packets in.
          |||,
          type: 'counter',
          unit: 'pps',
          sources: {
            generic:
              {
                expr: 'ifHCInUcastPkts{%(queriesSelector)s}',
                exprWrappers: [nonZeroWrapper],
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
        ifInUnknownProtos: {
          name: 'Network interface unknown protocol in packets dropped',
          nameShort: 'unknown dropped in',
          description: |||
            The number of packets received via the interface
            which were discarded because of an unknown or
            unsupported protocol.
          |||,
          type: 'counter',
          unit: 'pps',
          sources: {
            generic:
              {
                expr: 'ifInUnknownProtos{%(queriesSelector)s}',
                exprWrappers: [nonZeroWrapper],
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


        networkOutUnicastPacketsPerSec: {
          name: 'Network interface unicast packets out',
          nameShort: 'unicast out',
          description: |||
            Network interface unicast packets out.
          |||,
          type: 'counter',
          unit: 'pps',
          sources: {
            generic:
              {
                expr: 'ifHCOutUcastPkts{%(queriesSelector)s}',
                exprWrappers: [nonZeroWrapper],
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

        networkInMulticastPacketsPerSec: {
          name: 'Network interface multicast packets in',
          nameShort: 'multicast in',
          description: |||
            Network interface multicast packets in.
          |||,
          type: 'counter',
          unit: 'pps',
          sources: {
            generic:
              {
                expr: 'ifHCInMulticastPkts{%(queriesSelector)s}',
                exprWrappers: [nonZeroWrapper],
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

        networkOutMulticastPacketsPerSec: {
          name: 'Network interface multicast packets out',
          nameShort: 'multicast out',
          description: |||
            Network interface multicast packets out.
          |||,
          type: 'counter',
          unit: 'pps',
          sources: {
            generic:
              {
                expr: 'ifHCOutMulticastPkts{%(queriesSelector)s}',
                exprWrappers: [nonZeroWrapper],
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

        networkInBroadcastPacketsPerSec: {
          name: 'Network interface broadcast packets in',
          nameShort: 'broadcast in',
          description: |||
            Network interface broadcast packets in.
          |||,
          type: 'counter',
          unit: 'pps',
          sources: {
            generic:
              {
                expr: 'ifHCInBroadcastPkts{%(queriesSelector)s}',
                exprWrappers: [nonZeroWrapper],
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

        networkOutBroadcastPacketsPerSec: {
          name: 'Network interface broadcast packets out',
          nameShort: 'broadcast out',
          description: |||
            'Network interface broadcast packets out.',
          |||,
          type: 'counter',
          unit: 'pps',
          sources: {
            generic:
              {
                expr: 'ifHCOutBroadcastPkts{%(queriesSelector)s}',
                exprWrappers: [nonZeroWrapper],
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
        interfacesCount: self.ifOperStatus {
          name: 'Interfaces total',
          nameShort: 'Interfaces count',
          description: |||
            Device interface count
          |||,
          aggFunction: 'count',
          sources+: {
            generic+: {
              valueMappings:: [],
            },
          },
        },
        ifOperStatus: {
          name: 'Interface operational status',
          nameShort: 'status',
          description: |||
            Interface operational status(ifOperStatus).
          |||,
          type: 'gauge',
          aggFunction: 'sum',
          unit: 'short',
          sources: {
            generic:
              {
                expr: 'ifOperStatus{%(queriesSelector)s}',
                valueMappings: [
                  {
                    options: {
                      '1': {
                        color: 'green',
                        index: 1,
                        text: 'up',
                      },
                      '2': {
                        color: 'red',
                        index: 0,
                        text: 'down',
                      },
                      '3': {
                        color: 'orange',
                        index: 2,
                        text: 'testing',
                      },
                      '4': {
                        color: '#ccccdc',
                        index: 3,
                        text: 'unknown',
                      },
                      '5': {
                        color: 'orange',
                        index: 4,
                        text: 'dormant',
                      },
                      '6': {
                        color: 'text',
                        index: 5,
                        text: 'notPresent',
                      },
                      '7': {
                        color: 'orange',
                        index: 6,
                        text: 'lowerLayerDown',
                      },
                    },
                    type: 'value',
                  },
                ],
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
      }
      +
      (
        //signals only make sense on interface level, not fleet.
        if level == 'interface' then
          {

            ifAdminStatus: {
              name: 'Interface admin status',
              nameShort: 'admin status',
              description: |||
                The desired state of the interface. 
                The testing(3) state indicates that no operational
                packets can be passed.
              |||,
              type: 'gauge',
              unit: 'short',
              sources: {
                generic:
                  {
                    expr: 'ifAdminStatus{%(queriesSelector)s}',
                    valueMappings: [
                      {
                        options: {
                          '1': {
                            color: 'green',
                            index: 1,
                            text: 'up',
                          },
                          '2': {
                            color: 'red',
                            index: 0,
                            text: 'down',
                          },
                          '3': {
                            color: 'orange',
                            index: 2,
                            text: 'testing',
                          },
                        },
                        type: 'value',
                      },
                    ],
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
            ifConnectorPresent: {
              name: 'Interface connector present',
              nameShort: 'connector',
              description: |||
                This object has the value 'true(1)' if the interface sublayer has a physical connector and the value 'false(2)' otherwise.
              |||,
              type: 'gauge',
              unit: 'short',
              sources: {
                generic:
                  {
                    expr: 'ifConnectorPresent{%(queriesSelector)s}',
                    valueMappings: [
                      {
                        options: {
                          '1': {
                            color: 'green',
                            index: 1,
                            text: 'present',
                          },
                          '2': {
                            color: 'red',
                            index: 0,
                            text: 'disconnected',
                          },
                        },
                        type: 'value',
                      },
                    ],
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
            ifPromiscuousMode: {
              name: 'Interface promiscuous mode',
              nameShort: 'promiscuous mode',
              description: |||
                This object has a value of false(2) if this interface only accepts packets/frames that are addressed to this station. 
                This object has a value of true(1) when the station accepts all packets/frames transmitted on the media.
                The value true(1) is only legal on certain types of media. 
                If legal, setting this object to a value of true(1) may require the interface to be reset before becoming effective. 
                The value of ifPromiscuousMode does not affect the reception of broadcast and multicast packets/frames by the interface.
              |||,
              type: 'gauge',
              unit: 'short',
              sources: {
                generic:
                  {
                    expr: 'ifPromiscuousMode{%(queriesSelector)s}',
                    valueMappings: [
                      {
                        options: {
                          '1': {
                            color: 'green',
                            index: 1,
                            text: 'present',
                          },
                          '2': {
                            color: 'red',
                            index: 0,
                            text: 'false',
                          },
                        },
                        type: 'value',
                      },
                    ],
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

            ifHighSpeed: {
              name: 'Interface estimated bandwidth',
              nameShort: 'Speed',
              description: |||
                An estimate of the interface's current bandwidth in units of 1,000,000 bits per second.
                If this object reports a value of `n' then the speed of the interface is somewhere in the range of `n-500,000' to `n+499,999'.
                For interfaces which do not vary in bandwidth or for those where no accurate estimation can be made, this object should contain the nominal bandwidth.
                For a sub-layer which has no concept of bandwidth, this object should be zero.
              |||,
              type: 'gauge',
              unit: 'bps',
              sources: {
                generic:
                  {
                    expr: 'ifHighSpeed{%(queriesSelector)s}',
                    exprWrappers: [['(', ')*1000000']],
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
                //TODO ifSpeed
              },
            },


            ifType_info: {
              name: 'Interface type',
              nameShort: 'Type',
              description: |||
                The type of interface, distinguished according to the physical/link protocol(s) immediately `below' the network layer in the protocol stack.
              |||,
              type: 'info',
              sources: {
                generic:
                  {
                    expr: 'ifType_info{%(queriesSelector)s}',
                    infoLabel: 'ifType',
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

            ifLastChange: {
              name: 'Interface last change',
              nameShort: 'Last change',
              description: |||
                Interface last change.
              |||,
              type: 'raw',
              unit: 'dtdurations',
              sources: {
                generic:
                  {

                    expr:
                      |||
                        # ignore when ifLastCHange == 0 as invalid
                        sum by (%%(agg)s) (
                          (sysUpTime{%s} - on(%s) group_right () (ifLastChange{%%(queriesSelector)s})!=0)
                        )/100
                      |||
                      %
                      [
                        commonlib.utils.labelsToPromQLSelector(this.groupLabels + this.instanceLabels),
                        std.join(',', this.groupLabels + this.instanceLabels),
                      ],
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
            ifMtu: {
              name: 'Interface MTU',
              nameShort: 'MTU',
              description: |||
                Maximum transmission unit (MTU).
              |||,
              type: 'gauge',
              unit: 'none',
              sources: {
                generic:
                  {
                    expr: 'ifMtu{%(queriesSelector)s}',
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
            ifPhysAddress: {
              name: 'Interface physical address',
              nameShort: 'MAC',
              description: |||
                MAC.
              |||,
              type: 'info',

              sources: {
                generic:
                  {
                    expr: 'ifPhysAddress{%(queriesSelector)s}',
                    infoLabel: 'ifPhysAddress',
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
          }
        else {}
      ),
  }
