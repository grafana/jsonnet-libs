local commonlib = import 'common-lib/common/main.libsonnet';
function(this)
{
  local s = self,
  filteringSelector: this.filteringSelector,
  groupLabels: this.groupLabels,
  instanceLabels: this.instanceLabels,
  aggLevel: 'instance',
  discoveryMetric: {
    azuremonitor: 'azure_microsoft_network_virtualnetworks_ifunderddosattack_maximum_count',
  },
  signals: {
    bytesDropped: {
      name: 'Bytes Dropped DDoS',
      description: 'Inbound bytes per second dropped by DDoS protection.',
      type: 'gauge',
      unit: 'binBps',
      sources: {
        azuremonitor: {
          expr: 'azure_microsoft_network_virtualnetworks_bytesdroppedddos_bytespersecond_maximum{%(queriesSelector)s}',
          legendCustomTemplate: 'Dropped',
        },
      },
    },
    
    bytesForwarded: {
      name: 'Bytes Forwarded DDoS',
      description: 'Inbound bytes per second forwarded by DDoS protection.',
      type: 'gauge',
      unit: 'binBps',
      sources: {
        azuremonitor: {
          expr: 'azure_microsoft_network_virtualnetworks_bytesforwardedddos_bytespersecond_maximum{%(queriesSelector)s}',
          legendCustomTemplate: 'Forwarded',
        },
      },
    },
    
    bytesTotal: {
      name: 'Bytes in DDoS',
      description: 'Total bytes per second inbound in DDoS protection.',
      type: 'gauge',
      unit: 'binBps',
      sources: {
        azuremonitor: {
          expr: 'azure_microsoft_network_virtualnetworks_bytesinddos_bytespersecond_maximum{%(queriesSelector)s}',
          legendCustomTemplate: 'Total',
        },
      },
    },
    
    tcpBytesDropped: {
      name: 'TCP bytes Dropped DDoS',
      description: 'Inbound TCP bytes per second dropped by DDoS protection.',
      type: 'gauge',
      unit: 'binBps',
      sources: {
        azuremonitor: {
          expr: 'azure_microsoft_network_virtualnetworks_tcpbytesdroppedddos_bytespersecond_maximum{%(queriesSelector)s}',
          legendCustomTemplate: 'Dropped',
        },
      },
    },
    
    tcpBytesForwarded: {
      name: 'TCP bytes Forwarded DDoS',
      description: 'Inbound tcp bytes per second forwarded by DDoS protection.',
      type: 'gauge',
      unit: 'binBps',
      sources: {
        azuremonitor: {
          expr: 'azure_microsoft_network_virtualnetworks_tcpbytesforwardedddos_bytespersecond_maximum{%(queriesSelector)s}',
          legendCustomTemplate: 'Forwarded',
        },
      },
    },
    
    tcpBytesTotal: {
      name: 'TCP bytes in DDoS',
      description: 'Total TCP bytes per second inbound in DDoS protection.',
      type: 'gauge',
      unit: 'binBps',
      sources: {
        azuremonitor: {
          expr: 'azure_microsoft_network_virtualnetworks_tcpbytesinddos_bytespersecond_maximum{%(queriesSelector)s}',
          legendCustomTemplate: 'Total',
        },
      },
    },
    
    udpBytesDropped: {
      name: 'UDP bytes Dropped DDoS',
      description: 'Inbound UDP bytes per second dropped by DDoS protection.',
      type: 'gauge',
      unit: 'binBps',
      sources: {
        azuremonitor: {
          expr: 'azure_microsoft_network_virtualnetworks_udpbytesdroppedddos_bytespersecond_maximum{%(queriesSelector)s}',
          legendCustomTemplate: 'Dropped',
        },
      },
    },
    
    udpBytesForwarded: {
      name: 'UDP bytes Forwarded DDoS',
      description: 'Inbound udp bytes per second forwarded by DDoS protection.',
      type: 'gauge',
      unit: 'binBps',
      sources: {
        azuremonitor: {
          expr: 'azure_microsoft_network_virtualnetworks_udpbytesforwardedddos_bytespersecond_maximum{%(queriesSelector)s}',
          legendCustomTemplate: 'Forwarded',
        },
      },
    },
    
    udpBytesTotal: {
      name: 'UDP bytes in DDoS',
      description: 'Total UDP bytes per second inbound in DDoS protection.',
      type: 'gauge',
      unit: 'binBps',
      sources: {
        azuremonitor: {
          expr: 'azure_microsoft_network_virtualnetworks_udpbytesinddos_bytespersecond_maximum{%(queriesSelector)s}',
          legendCustomTemplate: 'Total',
        },
      },
    },

    packetsDropped: {
      name: 'Packets Dropped DDoS',
      description: 'Inbound packets per second dropped by DDoS protection',
      type: 'gauge',
      sources: {
        azuremonitor: {
          expr: 'azure_microsoft_network_virtualnetworks_packetsdroppedddos_countpersecond_maximum{%(queriesSelector)s}',
          legendCustomTemplate: 'Dropped',
        },
      },
    },

    packetsForwarded: {
      name: 'Packets Forwarded DDoS',
      description: 'Inbound packets per second forwarded by DDoS protection',
      type: 'gauge',
      sources: {
        azuremonitor: {
          expr: 'azure_microsoft_network_virtualnetworks_packetsforwardedddos_countpersecond_maximum{%(queriesSelector)s}',
          legendCustomTemplate: 'Forwarded',
        },
      },
    },
    
    packetsTotal: {
      name: 'Packets in DDoS',
      description: 'Total packets per second inbound in DDoS protection.',
      type: 'gauge',
      sources: {
        azuremonitor: {
          expr: 'azure_microsoft_network_virtualnetworks_packetsinddos_countpersecond_maximum{%(queriesSelector)s}',
          legendCustomTemplate: 'Total',
        },
      },
    },

    tcpPacketsDropped: {
      name: 'TCP Packets Dropped DDoS',
      description: 'Inbound TCP packets per second dropped by DDoS protection',
      type: 'gauge',
      sources: {
        azuremonitor: {
          expr: 'azure_microsoft_network_virtualnetworks_tcppacketsdroppedddos_countpersecond_maximum{%(queriesSelector)s}',
          legendCustomTemplate: 'Dropped',
        },
      },
    },

    tcpPacketsForwarded: {
      name: 'TCP packets Forwarded DDoS',
      description: 'Inbound TCP packets per second forwarded by DDoS protection',
      type: 'gauge',
      sources: {
        azuremonitor: {
          expr: 'azure_microsoft_network_virtualnetworks_tcppacketsforwardedddos_countpersecond_maximum{%(queriesSelector)s}',
          legendCustomTemplate: 'Forwarded',
        },
      },
    },
    
    tcpPacketsTotal: {
      name: 'TCP packets in DDoS',
      description: 'Total TCP packets per second inbound in DDoS protection.',
      type: 'gauge',
      sources: {
        azuremonitor: {
          expr: 'azure_microsoft_network_virtualnetworks_tcppacketsinddos_countpersecond_maximum{%(queriesSelector)s}',
          legendCustomTemplate: 'Total',
        },
      },
    },

    udpPacketsDropped: {
      name: 'UDP Packets Dropped DDoS',
      description: 'Inbound UDP packets per second dropped by DDoS protection',
      type: 'gauge',
      sources: {
        azuremonitor: {
          expr: 'azure_microsoft_network_virtualnetworks_udppacketsdroppedddos_countpersecond_maximum{%(queriesSelector)s}',
          legendCustomTemplate: 'Dropped',
        },
      },
    },

    udpPacketsForwarded: {
      name: 'UDP packets Forwarded DDoS',
      description: 'Inbound UDP packets per second forwarded by DDoS protection',
      type: 'gauge',
      sources: {
        azuremonitor: {
          expr: 'azure_microsoft_network_virtualnetworks_udppacketsforwardedddos_countpersecond_maximum{%(queriesSelector)s}',
          legendCustomTemplate: 'Forwarded',
        },
      },
    },
    
    udpPacketsTotal: {
      name: 'UDP packets in DDoS',
      description: 'Total UDP packets per second inbound in DDoS protection.',
      type: 'gauge',
      sources: {
        azuremonitor: {
          expr: 'azure_microsoft_network_virtualnetworks_udppacketsinddos_countpersecond_maximum{%(queriesSelector)s}',
          legendCustomTemplate: 'Total',
        },
      },
    },
    
    pingMeshAvgRoundrip: {
      name: 'Round trip time for Pings to a VM',
      type: 'gauge',
      unit: 'ms',
      sources: {
        azuremonitor: {
          expr: 'azure_microsoft_network_virtualnetworks_pingmeshaveragerountdripms_milliseconds_average{%(queriesSelector)s}',
        },
      },
    },
    
    pingMeshProbesFailed: {
      name: 'Failed pings to a VM %',
      type: 'gauge',
      unit: 'percent',
      sources: {
        azuremonitor: {
          expr: 'azure_microsoft_network_virtualnetworks_pingmeshprobesfailedpercent_percent_average{%(queriesSelector)s}',
        },
      },
    },
    
    synTriggerPackets: {
      name: 'SYN packets to trigger DDoS',
      description: 'Inbound SYN packet count to trigger DDoS.',
      type: 'gauge',
      sources: {
        azuremonitor: {
          expr: 'azure_microsoft_network_virtualnetworks_ddostriggersynpackets_countpersecond_maximum{%(queriesSelector)s}',
          legendCustomTemplate: 'SYN',
        },
      },
    },
    
    tcpTriggerPackets: {
      name: 'TCP packets to trigger DDoS',
      description: 'Inbound TCP packet count to trigger DDoS.',
      type: 'gauge',
      sources: {
        azuremonitor: {
          expr: 'azure_microsoft_network_virtualnetworks_ddostriggertcppackets_countpersecond_maximum{%(queriesSelector)s}',
          legendCustomTemplate: 'TCP',
        },
      },
    },
    
    udpTriggerPackets: {
      name: 'UDP packets to trigger DDoS',
      description: 'Inbound UDP packet count to trigger DDoS.',
      type: 'gauge',
      sources: {
        azuremonitor: {
          expr: 'azure_microsoft_network_virtualnetworks_ddostriggerudppackets_countpersecond_maximum{%(queriesSelector)s}',
          legendCustomTemplate: 'UDP',
        },
      },
    },
    
    underDdos: {
      name: 'Currently DDoS Status',
      description: 'Is the system currently under DDoS attack or not.',
      type: 'gauge',
      sources: {
        azuremonitor: {
          expr: 'azure_microsoft_network_virtualnetworks_ifunderddosattack_count_maximum{%(queriesSelector)s}',
          exprWrappers: [['','OR on() vector(0)']]
        },
      },
    },
  }
}