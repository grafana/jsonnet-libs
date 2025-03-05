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
      azuremonitor_agentless: self.azuremonitor,
    },
    signals: {
      bytesDropped: {
        name: 'Bytes dropped DDoS',
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
        name: 'Bytes forwarded DDoS',
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
        name: 'TCP bytes dropped DDoS',
        description: 'Inbound TCP bytes per second dropped by DDoS protection.',
        type: 'gauge',
        unit: 'binBps',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_network_virtualnetworks_tcpbytesdroppedddos_bytespersecond_maximum{%(queriesSelector)s}',
            legendCustomTemplate: 'TCP Dropped',
          },
        },
      },

      tcpBytesForwarded: {
        name: 'TCP bytes forwarded DDoS',
        description: 'Inbound TCP bytes per second forwarded by DDoS protection.',
        type: 'gauge',
        unit: 'binBps',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_network_virtualnetworks_tcpbytesforwardedddos_bytespersecond_maximum{%(queriesSelector)s}',
            legendCustomTemplate: 'TCP forwarded',
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
            legendCustomTemplate: 'TCP Total',
          },
        },
      },

      udpBytesDropped: {
        name: 'UDP bytes dropped DDoS',
        description: 'Inbound UDP bytes per second dropped by DDoS protection.',
        type: 'gauge',
        unit: 'binBps',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_network_virtualnetworks_udpbytesdroppedddos_bytespersecond_maximum{%(queriesSelector)s}',
            legendCustomTemplate: 'UDP Dropped',
          },
        },
      },

      udpBytesForwarded: {
        name: 'UDP bytes forwarded DDoS',
        description: 'Inbound UDP bytes per second forwarded by DDoS protection.',
        type: 'gauge',
        unit: 'binBps',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_network_virtualnetworks_udpbytesforwardedddos_bytespersecond_maximum{%(queriesSelector)s}',
            legendCustomTemplate: 'UDP Forwarded',
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
            legendCustomTemplate: 'UDP Total',
          },
        },
      },

      packetsDropped: {
        name: 'Packets dropped DDoS',
        description: 'Inbound packets per second dropped by DDoS protection',
        type: 'gauge',
        unit: 'pps',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_network_virtualnetworks_packetsdroppedddos_countpersecond_maximum{%(queriesSelector)s}',
            legendCustomTemplate: 'Dropped',
          },
        },
      },

      packetsForwarded: {
        name: 'Packets forwarded DDoS',
        description: 'Inbound packets per second forwarded by DDoS protection',
        type: 'gauge',
        unit: 'pps',
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
        unit: 'pps',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_network_virtualnetworks_packetsinddos_countpersecond_maximum{%(queriesSelector)s}',
            legendCustomTemplate: 'Total',
          },
        },
      },

      tcpPacketsDropped: {
        name: 'TCP packets dropped DDoS',
        description: 'Inbound TCP packets per second dropped by DDoS protection',
        type: 'gauge',
        unit: 'pps',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_network_virtualnetworks_tcppacketsdroppedddos_countpersecond_maximum{%(queriesSelector)s}',
            legendCustomTemplate: 'TCP Dropped',
          },
        },
      },

      tcpPacketsForwarded: {
        name: 'TCP packets forwarded DDoS',
        description: 'Inbound TCP packets per second forwarded by DDoS protection',
        type: 'gauge',
        unit: 'pps',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_network_virtualnetworks_tcppacketsforwardedddos_countpersecond_maximum{%(queriesSelector)s}',
            legendCustomTemplate: 'TCP Forwarded',
          },
        },
      },

      tcpPacketsTotal: {
        name: 'TCP packets in DDoS',
        description: 'Total TCP packets per second inbound in DDoS protection.',
        type: 'gauge',
        unit: 'pps',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_network_virtualnetworks_tcppacketsinddos_countpersecond_maximum{%(queriesSelector)s}',
            legendCustomTemplate: 'TCP Total',
          },
        },
      },

      udpPacketsDropped: {
        name: 'UDP Packets dropped DDoS',
        description: 'Inbound UDP packets per second dropped by DDoS protection',
        type: 'gauge',
        unit: 'pps',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_network_virtualnetworks_udppacketsdroppedddos_countpersecond_maximum{%(queriesSelector)s}',
            legendCustomTemplate: 'UDP Dropped',
          },
        },
      },

      udpPacketsForwarded: {
        name: 'UDP packets forwarded DDoS',
        description: 'Inbound UDP packets per second forwarded by DDoS protection',
        type: 'gauge',
        unit: 'pps',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_network_virtualnetworks_udppacketsforwardedddos_countpersecond_maximum{%(queriesSelector)s}',
            legendCustomTemplate: 'UDP Forwarded',
          },
        },
      },

      udpPacketsTotal: {
        name: 'UDP packets in DDoS',
        description: 'Total UDP packets per second inbound in DDoS protection.',
        type: 'gauge',
        unit: 'pps',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_network_virtualnetworks_udppacketsinddos_countpersecond_maximum{%(queriesSelector)s}',
            legendCustomTemplate: 'UDP Total',
          },
        },
      },

      pingMeshAvgRoundrip: {
        name: 'Round trip time for pings to a VM',
        description: 'Round trip time for Pings sent to a destination VM',
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
        description: 'Percent of number of failed Pings to total sent Pings of a destination VM',
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
        name: 'Current DDoS status',
        description: 'Is the system currently under DDoS attack or not.',
        type: 'gauge',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_network_virtualnetworks_ifunderddosattack_count_maximum{%(queriesSelector)s}',
            exprWrappers: [['', 'OR on() vector(0)']],
            valueMappings: [
              {
                type: 'value',
                options: {
                  '0': {
                    text: 'OK',
                    index: 0,
                  },
                  '1': {
                    text: 'Under Attack',
                    color: 'dark-red',
                    index: 1,
                  },
                },
              },
            ],
          },
        },
      },
    },
  }
