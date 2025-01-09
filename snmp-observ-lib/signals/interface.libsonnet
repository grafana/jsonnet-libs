local commonlib = import 'common-lib/common/main.libsonnet';
local xtd = import 'github.com/jsonnet-libs/xtd/main.libsonnet';
function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'sum',
    rangeFunction: 'irate',
    aggKeepLabels: ["ifName"],
    local topkWrapper = ['topk(25,',')',],
    local bitsWrapper = ['(',')*8',],
    local nonZeroWrapper = ['(',')>0',],
    local clampQuery = ['','\n# Only show TB/s spikes if can be confirmed by ifSpeed. ifSpeed == 0 then clamp to 100Mbit.\n<\non (%(agg)s) clamp_min(ifHighSpeed{%(queriesSelector)s}*1000000 or ifSpeed{%(queriesSelector)s},100000000)'],
    discoveryMetric: {
      prometheus: 'ifOperStatus',
    },
    signals: {
      networkInBitPerSec: {
        name: 'Network interface traffic in',
        nameShort: 'in',
        description: |||
          Network interface traffic in.
        |||,
        type: 'counter',
        unit: 'bytes',
        sources: {
          prometheus:
            {
              expr: 'ifHCInOctets{%(queriesSelector)s}',
              exprWrappers: [topkWrapper,bitsWrapper,clampQuery],
            },
        },
      },
      networkOutBitPerSec: {
        name: 'Network interface traffic out',
        nameShort: 'out',
        description: |||
          Network interface traffic out.
        |||,
        type: 'counter',
        unit: 'bytes',

        sources: {
          prometheus:
            {
              expr: 'ifHCOutOctets{%(queriesSelector)s}',
              exprWrappers: [topkWrapper,bitsWrapper,clampQuery],
            },
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
          prometheus:
            {
              expr: 'ifOutErrors{%(queriesSelector)s}',
              exprWrappers: [topkWrapper,nonZeroWrapper],
            },
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
          prometheus:
            {
              expr: 'ifInErrors{%(queriesSelector)s}',
              exprWrappers: [topkWrapper,nonZeroWrapper],
            },
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
          prometheus:
            {
              expr: 'ifInDiscards{%(queriesSelector)s}',
              exprWrappers: [topkWrapper,nonZeroWrapper],
            },
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
          prometheus:
            {
              expr: 'ifOutDiscards{%(queriesSelector)s}',
              exprWrappers: [topkWrapper,nonZeroWrapper],
            },
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
          prometheus:
            {
              expr: 'ifHCInUcastPkts{%(queriesSelector)s}',
              exprWrappers: [topkWrapper,nonZeroWrapper],
            },
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
          prometheus:
            {
              expr: 'ifInUnknownProtos{%(queriesSelector)s}',
              exprWrappers: [topkWrapper,nonZeroWrapper],
            },
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
          prometheus:
            {
              expr: 'ifHCOutUcastPkts{%(queriesSelector)s}',
              exprWrappers: [topkWrapper],
            },
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
          prometheus:
            {
              expr: 'ifHCInMulticastPkts{%(queriesSelector)s}',
              exprWrappers: [topkWrapper],
            },
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
          prometheus:
            {
              expr: 'ifHCOutMulticastPkts{%(queriesSelector)s}',
            },
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
          prometheus:
            {
              expr: 'ifHCInBroadcastPkts{%(queriesSelector)s}',
              exprWrappers: [topkWrapper],
            },
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
          prometheus:
            {
              expr: 'ifHCOutBroadcastPkts{%(queriesSelector)s}',
              exprWrappers: [topkWrapper],
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
        unit: 'short',
        sources: {
          prometheus:
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
        },
      },
      ifAdminStatus: {
        name: 'Interface admin status',
        nameShort: 'admin status',
        description: |||
          The desired state of the interface.  The
          testing(3) state indicates that no operational
          packets can be passed.
        |||,
        type: 'gauge',
        unit: 'short',
        sources: {
          prometheus:
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
        },
      },
      ifConnectorPresent: {
        name: 'Interface connector present',
        description: |||
          This object has the value 'true(1)' if the interface sublayer has a physical connector and the value 'false(2)' otherwise.
        |||,
        type: 'gauge',
        unit: 'short',
        sources: {
          prometheus:
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
        },
      },
      ifPromiscuousMode: {
        name: 'Interface promiscuous mode',
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
          prometheus:
            {
              expr: 'ifPromiscuousMode{%(queriesSelector)s}',
              valueMappings: [
                {
                  options: {
                    '1': {
                      color: 'true',
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
        },
      },

      ifHighSpeed: {
        name: 'Interface estimated bandwidth',
        description: |||
          An estimate of the interface's current bandwidth in units of 1,000,000 bits per second.
          If this object reports a value of `n' then the speed of the interface is somewhere in the range of `n-500,000' to `n+499,999'.
          For interfaces which do not vary in bandwidth or for those where no accurate estimation can be made, this object should contain the nominal bandwidth.
          For a sub-layer which has no concept of bandwidth, this object should be zero.
        |||,
        type: 'gauge',
        unit: 'bps',
        sources: {
          prometheus:
            {
              expr: 'ifHighSpeed{%(queriesSelector)s}',
            },
        },
      },
      local ifTypeFile = import './IANAifType.txt',
      //TODO: Split by ) then by (
      // local ifTypeMapping = {
      //   for line in std.split(ifTypeFile, "\n"),
      // },
      ifType: {
        name: 'Interface type',
        description: |||
          The type of interface, distinguished according to the physical/link protocol(s) immediately `below' the network layer in the protocol stack.
        |||,
        type: 'gauge',
        unit: 'short',
        sources: {
          prometheus:
            {
              expr: 'ifType{%(queriesSelector)s}',
              //TODO: add valueMapping
            },
        },
      },
    },
  }
