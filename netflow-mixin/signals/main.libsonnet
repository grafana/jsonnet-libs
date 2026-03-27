local commonlib = import 'common-lib/common/main.libsonnet';


local jsonSignals =
  {
    aggLevel: 'group',
    groupLabels: ['job'],
    instanceLabels: ['device_name'],
    filteringSelector: 'job=~"integrations/ktranslate-netflow|integrations/beyla-host-network"',
    datasource: 'prometheus_datasource',
    varAdHocEnabled: true,
    varAdHocLabels: ['network_local_address', 'network_peer_address'],
    discoveryMetric: {
      ktranslate: 'network_io_by_flow_bytes',
      obi: 'obi_network_flow_bytes_total',
      beyla: 'beyla_network_flow_bytes_total',
    },
    signals: {
      trafficRate: {
        name: 'Traffic rate',
        type: 'raw',
        aggLevel: 'instance',
        description: 'Total observed traffic, aggregated by collecting device',
        unit: 'Bps',
        sources: {
          local s = self,
          ktranslate: {
            expr: 'sum(network_io_by_flow_bytes{%(queriesSelector)s}) by (device_name)',
          },
          beyla: {
            expr: 'sum(irate(beyla_network_flow_bytes_total{%(queriesSelector)s}[%(interval)s])) by (device_name)',
          },
          obi: {
            expr: std.strReplace(s.beyla.expr, 'beyla', 'obi'),
          },
        },
      },
      collectingDevices: {
        name: 'Collecting Devices',
        type: 'raw',
        aggLevel: 'instance',
        description: 'Number of devices collecting flows',
        unit: 'short',
        sources: {
          local s = self,
          legend:: 'Collecting devices',
          ktranslate: {
            expr: 'count(count(network_io_by_flow_bytes{%(queriesSelector)s}) by (device_name))',
            legendCustomTemplate: s.legend,
          },
          beyla: {
            expr: 'count(count(beyla_network_flow_bytes_total{%(queriesSelector)s}) by (device_name))',
            legendCustomTemplate: s.legend,
          },
          obi: {
            expr: std.strReplace(s.beyla.expr, 'beyla', 'obi'),
            legendCustomTemplate: s.legend,
          },
        },
      },
      sources: {
        name: 'Sources',
        type: 'raw',
        aggLevel: 'instance',
        description: 'Number of unique sources over the time range',
        unit: 'short',
        sources: {
          local s = self,
          legend:: 'Sources',
          ktranslate: {
            expr: 'count(count(network_io_by_flow_bytes{%(queriesSelector)s}) by (network_local_address))',
            legendCustomTemplate: s.legend,
          },
          beyla: {
            expr: 'count(count(beyla_network_flow_bytes_total{%(queriesSelector)s}) by (network_local_address))',
            legendCustomTemplate: s.legend,
          },
          obi: {
            expr: std.strReplace(s.beyla.expr, 'beyla', 'obi'),
            legendCustomTemplate: s.legend,
          },
        },
      },
      destinations: {
        name: 'Destinations',
        type: 'raw',
        aggLevel: 'instance',
        description: 'Number of unique destinations over the time range',
        unit: 'short',
        sources: {
          local s = self,
          legend:: 'Destinations',
          ktranslate: {
            expr: 'count(count(network_io_by_flow_bytes{%(queriesSelector)s}) by (network_peer_address))',
            legendCustomTemplate: s.legend,
          },
          beyla: {
            expr: 'count(count(beyla_network_flow_bytes_total{%(queriesSelector)s}) by (network_peer_address))',
            legendCustomTemplate: s.legend,
          },
          obi: {
            expr: std.strReplace(s.beyla.expr, 'beyla', 'obi'),
            legendCustomTemplate: s.legend,
          },
        },
      },
      totalTraffic: {
        name: 'Total Traffic',
        type: 'raw',
        aggLevel: 'instance',
        description: 'Number of unique destinations over the time range',
        unit: 'bytes',
        sources: {
          local s = self,
          legend:: 'Total observed traffic',
          ktranslate: {
            expr: 'sum(sum_over_time(network_io_by_flow_bytes{%(queriesSelector)s}[$__range]))',
            legendCustomTemplate: s.legend,
          },
          beyla: {
            expr: 'sum(increase(beyla_network_flow_bytes_total{%(queriesSelector)s}[$__range]))',
            legendCustomTemplate: s.legend,
          },
          obi: {
            expr: std.strReplace(s.beyla.expr, 'beyla', 'obi'),
            legendCustomTemplate: s.legend,
          },
        },
      },
      topSources: {
        name: 'Top sources',
        type: 'raw',
        description: 'Source adresses ordered by observed traffic during the time range',
        unit: 'bytes',
        sources: {
          local s = self,
          ktranslate: {
            expr: 'topk(5,network_io_by_flow_bytes{%(queriesSelector)s})',
          },
          beyla: {
            expr: 'topk(5,increase(beyla_network_flow_bytes_total{%(queriesSelector)s}[$__range]))',
          },
          obi: {
            expr: std.strReplace(s.beyla.expr, 'beyla', 'obi'),
          },
        },
      },
      conversationTraffic: {
        name: 'Conversation total bytes',
        type: 'raw',
        description: 'Source/Destination pairs and their total traffic across all dimensions. Ordered by total traffic during selected time range',
        unit: 'bytes',
        sources: {
          local s = self,
          ktranslate: {
            expr: 'sum(sum_over_time(network_io_by_flow_bytes{%(queriesSelector)s}[$__range])) by (network_local_address,network_peer_address)',
          },
          beyla: {
            expr: 'sum(increase(beyla_network_flow_bytes_total{%(queriesSelector)s}[$__range])) by (network_local_address,network_peer_address)',
          },
          obi: {
            expr: std.strReplace(s.beyla.expr, 'beyla', 'obi'),
          },
        },
      },
      conversationTrafficOverTime: {
        name: 'Conversation traffic over time',
        type: 'raw',
        description: 'Traffic distribution of source/destination pairs over time',
        unit: 'Bps',
        sources: {
          local s = self,
          ktranslate: {
            expr: 'sum(network_io_by_flow_bytes{%(queriesSelector)s}) by (network_local_address,network_peer_address,device_name) / 60',
            legendCustomTemplate: '{{network_local_address}} -> {{ network_peer_address }} // {{device_name}}',
          },
          beyla: {
            expr: 'sum(irate(beyla_network_flow_bytes_total{%(queriesSelector)s}[%(interval)s])) by (network_local_address,network_peer_address)',
            legendCustomTemplate: s.ktranslate.legendCustomTemplate,
          },
          obi: {
            expr: std.strReplace(s.beyla.expr, 'beyla', 'obi'),
            legendCustomTemplate: s.ktranslate.legendCustomTemplate,
          },
        },
      },
      conversationPairs: {
        name: 'Breakdown by source/destination pair',
        type: 'raw',
        description: 'Breakdown of total traffic between source/destination pairs observed during the selected time range',
        unit: 'bytes',
        sources: {
          local s = self,
          ktranslate: {
            expr: 'sum(sum_over_time(network_io_by_flow_bytes{%(queriesSelector)s}[$__range])) by (network_local_address, network_peer_address, device_name)',
            legendCustomTemplate: '{{network_local_address}} -> {{ network_peer_address }} // {{device_name}}',
          },
          beyla: {
            expr: 'sum(increase(beyla_network_flow_bytes_total{%(queriesSelector)s}[$__range])) by (network_local_address,network_peer_address,device_name)',
            legendCustomTemplate: s.ktranslate.legendCustomTemplate,
          },
          obi: {
            expr: std.strReplace(s.beyla.expr, 'beyla', 'obi'),
            legendCustomTemplate: s.ktranslate.legendCustomTemplate,
          },
        },
      },
      protocolTraffic: {
        name: 'Total bytes',
        type: 'raw',
        description: 'List of protocols and the total amount of observed traffic during the selected time range',
        unit: 'bytes',
        sources: {
          local s = self,
          legend:: '{{network_protocol_name}}',
          ktranslate: {
            expr: 'sum(sum_over_time(network_io_by_flow_bytes{%(queriesSelector)s}[$__range])) by (network_protocol_name)',
            legendCustomTemplate: s.legend,
          },
          beyla: {
            expr: 'label_replace(sum(increase(beyla_network_flow_bytes_total{%(queriesSelector)s}[$__range])) by (network_protocol_name),"network_protocol_name","<not-yet-supported-by-beyla>","<not-yet-supported-by-beyla>","(.*)")',
            legendCustomTemplate: s.legend,
          },
          obi: {
            expr: std.strReplace(s.beyla.expr, 'beyla', 'obi'),
            legendCustomTemplate: s.legend,
          },
        },
      },
      protocolOverTime: {
        name: 'Protocol traffic over time',
        type: 'raw',
        description: 'Protocols and the amount of observed traffic over the selected time range',
        unit: 'bytes',
        sources: {
          local s = self,
          legend:: '{{network_protocol_name}}',
          ktranslate: {
            expr: 'sum(sum_over_time(network_io_by_flow_bytes{%(queriesSelector)s}[$__interval])) by (network_protocol_name)',
            legendCustomTemplate: s.legend,
          },
          beyla: {
            expr: 'label_replace(sum(increase(beyla_network_flow_bytes_total{%(queriesSelector)s}[$__interval])) by (network_protocol_name),"network_protocol_name","<not-yet-supported-by-beyla>","<not-yet-supported-by-beyla>","(.*)")',
            legendCustomTemplate: s.legend,
          },
          obi: {
            expr: std.strReplace(s.beyla.expr, 'beyla', 'obi'),
            legendCustomTemplate: s.legend,
          },
        },
      },
      trafficByDestination: {
        name: 'Traffic by destination',
        type: 'raw',
        description: 'Total traffic to specific countries during the selected time range',
        unit: 'bytes',
        sources: {
          local s = self,
          ktranslate: {
            expr: 'sum(sum_over_time(network_io_by_flow_bytes{%(queriesSelector)s,network_peer_country!="Private IP"}[$__range])) by (network_peer_country)',
          },
          beyla: {
            expr: 'sum(increase(beyla_network_flow_bytes_total{%(queriesSelector)s}[$__range])) by (network_peer_country)',
          },
          obi: {
            expr: std.strReplace(s.beyla.expr, 'beyla', 'obi'),
          },
        },
      },
      trafficBySource: {
        name: 'Traffic by Source',
        type: 'raw',
        description: 'Total traffic from specific countries during the selected time range',
        unit: 'bytes',
        sources: {
          local s = self,
          ktranslate: {
            expr: 'sum(sum_over_time(network_io_by_flow_bytes{%(queriesSelector)s,network_local_country!="Private IP"}[$__range])) by (network_local_country)',
          },
          beyla: {
            expr: 'sum(increase(beyla_network_flow_bytes_total{%(queriesSelector)s}[$__range])) by (network_local_country)',
          },
          obi: {
            expr: std.strReplace(s.beyla.expr, 'beyla', 'obi'),
          },
        },
      },
    },
  };

commonlib.signals.unmarshallJsonMulti(jsonSignals, type=['obi', 'ktranslate', 'beyla'])
