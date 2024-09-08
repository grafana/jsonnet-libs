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
        name: 'Sync Packets',
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
        name: 'Packets',
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
        name: 'Bytes',
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
        name: 'SNAT connetions',
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
        name: 'Sync Packets',
        description: 'Total number of SYN Packets transmitted within time period',
        type: 'raw',
        sources: {
          azuremonitor: {
            expr: 'sum by (resourceGroup) (azure_microsoft_network_loadbalancers_syncount_total_count{%(queriesSelector)s})',
            legendCustomTemplate: '{{resourceGroup}}',
          },
        },
      },

      detailsTotalPackets: {
        name: 'Packets',
        description: 'Total number of Packets transmitted within time period',
        type: 'raw',
        sources: {
          azuremonitor: {
            expr: 'sum by (resourceGroup) (azure_microsoft_network_loadbalancers_packetcount_total_count{%(queriesSelector)s})',
            legendCustomTemplate: '{{resourceGroup}}',
          },
        },
      },
      detailsTotalBytes: {
        name: 'Bytes',
        description: 'Total number of Bytes transmitted within time period',
        type: 'raw',
        sources: {
          azuremonitor: {
            expr: 'sum by (resourceGroup) (azure_microsoft_network_loadbalancers_bytecount_total_bytes{%(queriesSelector)s})',
            legendCustomTemplate: '{{resourceGroup}}',
          },
        },
      },
      detailsSnatConn: {
        name: 'SNAT connections',
        description: 'Total number of new SNAT connections created within time period',
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
        description: 'Total SNAT ports used and allocated within time period',
        type: 'raw',
        sources: {
          azuremonitor: {
            expr: 'sum(azure_microsoft_network_loadbalancers_usedsnatports_average_count{%(queriesSelector)s})',
            legendCustomTemplate: 'Used',
          },
        },
      },

      usedSnatPorts: {
        name: 'Currently used SNAT ports',
        description: 'Total SNAT ports used at the current time',
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
