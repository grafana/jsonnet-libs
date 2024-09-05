local commonlib = import 'common-lib/common/main.libsonnet';
function(this)
  {
    local s = self,
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'none',
    discoveryMetric: {
      azuremonitor: 'azure_microsoft_network_loadbalancers_bytecount_total_bytes',
    },
    signals: {
      summarySyncPackets: {
        name: 'Total Sync Packets',
        description: 'Total number of SYN Packets transmitted',
        type: 'raw',
        unit: 'short',
        sources: {
          azuremonitor: {
            expr: 'sum(sum_over_time(azure_microsoft_network_loadbalancers_syncount_total_count[$__range]))',
            legendCustomTemplate: '',
          },
        },
      },

      summaryTotalPackets: {
        name: 'Total Packets',
        description: 'Total number of Packets transmitted',
        type: 'raw',
        unit: 'short',
        sources: {
          azuremonitor: {
            expr: 'sum(sum_over_time(azure_microsoft_network_loadbalancers_packetcount_total_count[$__range]))',
            legendCustomTemplate: '',
          },
        },
      },
      summaryTotalBytes: {
        name: 'Total Bytes',
        description: 'Total number of Bytes transmitted',
        type: 'raw',
        unit: 'short',
        sources: {
          azuremonitor: {
            expr: 'sum(sum_over_time(azure_microsoft_network_loadbalancers_bytecount_total_bytes[$__range]))',
            legendCustomTemplate: '',
          },
        },
      },
      summarySnatConn: {
        name: 'Total SNAT Connections',
        description: 'Total number of new SNAT connections created',
        type: 'raw',
        unit: 'short',
        sources: {
          azuremonitor: {
            expr: 'sum(sum_over_time(azure_microsoft_network_loadbalancers_snatconnectioncount_total_count[$__range]))',
            legendCustomTemplate: '',
          },
        },
      },

      detailsSyncPackets: {
        name: 'Total Sync Packets by Resource Group',
        description: 'Total number of SYN Packets transmitted by resource group',
        type: 'raw',
        sources: {
          azuremonitor: {
            expr: 'sum by (resourceGroup) (azure_microsoft_network_loadbalancers_syncount_total_count{%(queriesSelector)s})',
            legendCustomTemplate: '{{resourceGroup}}',
          },
        },
      },

      detailsTotalPackets: {
        name: 'Packet Count by Resource Group',
        description: 'Total number of Packets transmitted by resource group',
        type: 'raw',
        sources: {
          azuremonitor: {
            expr: 'sum by (resourceGroup) (azure_microsoft_network_loadbalancers_packetcount_total_count{%(queriesSelector)s})',
            legendCustomTemplate: '{{resourceGroup}}',
          },
        },
      },
      detailsTotalBytes: {
        name: 'Total Bytes by Resource Group',
        description: 'Total number of Bytes transmitted by resource group',
        type: 'raw',
        sources: {
          azuremonitor: {
            expr: 'sum by (resourceGroup) (azure_microsoft_network_loadbalancers_bytecount_total_bytes{%(queriesSelector)s})',
            legendCustomTemplate: '{{resourceGroup}}',
          },
        },
      },
      detailsSnatConn: {
        name: 'SNAT Connections by Resource Group',
        description: 'Total number of new SNAT connections created by resource group',
        type: 'raw',
        sources: {
          azuremonitor: {
            expr: 'sum by (resourceGroup) (azure_microsoft_network_loadbalancers_snatconnectioncount_total_count{%(queriesSelector)s})',
            legendCustomTemplate: '{{resourceGroup}}',
          },
        },
      },

      snatPorts: {
        name: 'SNAT Ports',
        description: 'Total number of SNAT ports used and allocated',
        type: 'raw',
        sources: {
          azuremonitor: {
            expr: 'sum(azure_microsoft_network_loadbalancers_usedsnatports_average_count{%(queriesSelector)s})',
            legendCustomTemplate: 'Used',
          },
        },
      },

      usedSnatPorts: {
        name: 'Used SNAT Ports',
        description: 'Total number of SNAT ports used',
        type: 'raw',
        sources: {
          azuremonitor: {
            expr: 'sum(azure_microsoft_network_loadbalancers_usedsnatports_average_count{%(queriesSelector)s})',
            legendCustomTemplate: 'Used',
          },
        },
      },

      allocatedSnatPorts: {
        name: 'Allocated SNAT Ports',
        description: 'Total number of SNAT ports allocated',
        type: 'raw',
        sources: {
          azuremonitor: {
            expr: 'sum(azure_microsoft_network_loadbalancers_allocatedsnatports_average_count{%(queriesSelector)s})',
            legendCustomTemplate: 'Allocated',
          },
        },
      },
    },
  }
