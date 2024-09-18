local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(this): {
    // Blob Storage
    _tableCommon(valueName)::
      g.panel.table.queryOptions.withTransformations([
        g.panel.table.queryOptions.transformation.withId('filterFieldsByName')
        + g.panel.table.queryOptions.transformation.withOptions({
          include: {
            pattern: '%s.*|Value.*' % this.config.blobStorage.bucketLabel,
          },
        }),
        g.panel.table.queryOptions.transformation.withId('joinByField')
        + g.panel.table.queryOptions.transformation.withOptions({
          byField: this.config.blobStorage.bucketLabel,
          mode: 'outer',
        }),
      ])
      + g.panel.table.standardOptions.withOverrides([
        {
          matcher: {
            id: 'byName',
            options: this.config.blobStorage.bucketLabel,
          },
          properties: [
            {
              id: 'displayName',
              value: 'Bucket',
            },
            // TODO: The link "works" but does not refresh the dashboard upon following the link. Surely this is solvable?
            // {
            //   id: 'links',
            //   value: [
            //     {
            //       title: 'Filter to bucket',
            //       url: '/d/%(uid)s/%(uid)s?${datasource:queryparam}&var-%(bucketLabel)s=${__data.fields.%(bucketLabel)s}' % {
            //         uid: this.config.uid + '-blobstorage',
            //         bucketLabel: this.config.blobStorage.bucketLabel,
            //       },
            //     },
            //   ],
            // },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Value',
          },
          properties: [
            {
              id: 'displayName',
              value: valueName,
            },
          ],
        },
      ]),

    availabilityTs:
      this.signals.blobstore.availability.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.options.legend.withDisplayMode('table')
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),
    availabilityStat:
      this.signals.blobstore.availability.asStat()
      + commonlib.panels.generic.stat.base.stylize(),
    bucketCount:
      this.signals.blobstore.bucketCount.asStat()
      + commonlib.panels.generic.stat.base.stylize(),
    objectCountTotal:
      this.signals.blobstore.objectCountTotal.asStat()
      + commonlib.panels.generic.stat.base.stylize(),
    objectCountByBucket:
      this.signals.blobstore.objectCountTopK.common
      + commonlib.panels.generic.table.base.new(
        'Top 5 Buckets - Object Count',
        [
          this.signals.blobstore.objectCountTopK.asTarget()
          + g.query.prometheus.withFormat('table')
          + g.query.prometheus.withInstant(true),
        ],
        'Number of objects stored.'
      )
      + self._tableCommon('Object Count'),
    totalBytesTotal:
      this.signals.blobstore.totalBytesTotal.asStat()
      + commonlib.panels.generic.stat.base.stylize(),
    totalBytesByBucket:
      this.signals.blobstore.totalBytesTopK.common
      + commonlib.panels.generic.table.base.new(
        'Top 5 Buckets - Total Bytes',
        [
          this.signals.blobstore.totalBytesTopK.asTarget()
          + g.query.prometheus.withFormat('table')
          + g.query.prometheus.withInstant(true),
        ],
        'Total bytes stored'
      ) + self._tableCommon('Total Bytes'),
    totalNetworkThroughput:
      this.signals.blobstore.networkThroughputTopK.common
      + commonlib.panels.generic.table.base.new(
        'Top 5 Buckets - Network Throughput',
        [
          this.signals.blobstore.networkThroughputTopK.asTarget()
          + g.query.prometheus.withFormat('table')
          + g.query.prometheus.withInstant(true),
          this.signals.blobstore.networkRxTopK.asTarget()
          + g.query.prometheus.withFormat('table')
          + g.query.prometheus.withInstant(true),
          this.signals.blobstore.networkTxTopK.asTarget()
          + g.query.prometheus.withFormat('table')
          + g.query.prometheus.withInstant(true),
        ],
        'Total network throughput in bits for the selected timerange'
      ) + self._tableCommon('Total Throughput')
      + g.panel.table.fieldConfig.defaults.custom.withMinWidth(100)
      + g.panel.table.standardOptions.withOverridesMixin([
        {
          matcher: {
            id: 'byName',
            options: 'Value #Network bits throughput',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Total',
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Value #Network bits received',
          },
          properties: [
            {
              id: 'displayName',
              value: 'rx',
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Value #Network bits transmitted',
          },
          properties: [
            {
              id: 'displayName',
              value: 'tx',
            },
          ],
        },
      ]),
    apiRequestCount:
      this.signals.blobstore.apiRequestByTypeCount.asTimeSeries()
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),
    apiErrorRate:
      this.signals.blobstore.apiRequestErrorRate.asTimeSeries(),
    network:
      commonlib.panels.network.timeSeries.traffic.new('Network traffic', targets=[])
      + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets()
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
      + this.signals.blobstore.networkRx.asPanelMixin()
      + this.signals.blobstore.networkTx.asPanelMixin(),


    // Azure ElasticPool
    _aep_tableCommon()::
      g.panel.table.queryOptions.withTransformations([
        g.panel.table.queryOptions.transformation.withId('filterFieldsByName')
        + g.panel.table.queryOptions.transformation.withOptions({
          include: {
            pattern: 'resourceName.*|Value.*',
          },
        }),
        g.panel.table.queryOptions.transformation.withId('joinByField')
        + g.panel.table.queryOptions.transformation.withOptions({
          byField: 'resourceName',
          mode: 'outer',
        }),
      ])
      + g.panel.table.standardOptions.withOverrides([
        {
          matcher: {
            id: 'byName',
            options: 'resourceName',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Elastic pool',
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Value #Used',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Used',
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Value #Allocated',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Allocated',
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Value #Limit',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Limit',
            },
          ],
        },
      ]),

    aep_storage:
      this.signals.azureelasticpool.storageAllocTbl.common
      + commonlib.panels.generic.table.base.new(
        'Elastic pool storage',
        [
          this.signals.azureelasticpool.storageAllocTbl.asTarget()
          + g.query.prometheus.withFormat('table')
          + g.query.prometheus.withInstant(true),

          this.signals.azureelasticpool.storageUsedTbl.asTarget()
          + g.query.prometheus.withFormat('table')
          + g.query.prometheus.withInstant(true),

          this.signals.azureelasticpool.storageLimitTbl.asTarget()
          + g.query.prometheus.withFormat('table')
          + g.query.prometheus.withInstant(true),
        ],
        'Storage overview per elasticpool.'
      ) + self._aep_tableCommon(),

    aep_cpu:
      this.signals.azureelasticpool.cpu.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),

    aep_mem:
      this.signals.azureelasticpool.memory.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),

    aep_dtu:
      this.signals.azureelasticpool.edtu.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),

    aep_session:
      this.signals.azureelasticpool.session.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    // Azure SQL Database
    _asql_tableCommon()::
      g.panel.table.queryOptions.withTransformations([
        g.panel.table.queryOptions.transformation.withId('filterFieldsByName')
        + g.panel.table.queryOptions.transformation.withOptions({
          include: {
            pattern: 'database.*|Value.*',
          },
        }),
        g.panel.table.queryOptions.transformation.withId('joinByField')
        + g.panel.table.queryOptions.transformation.withOptions({
          byField: 'database',
          mode: 'outer',
        }),
      ])
      + g.panel.table.standardOptions.withOverrides([
        {
          matcher: {
            id: 'byName',
            options: 'database',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Database',
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Value #Used',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Used',
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Value #Percent of limit',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Percent of limit',
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Value #Limit',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Limit',
            },
          ],
        },
      ]),
    asql_conns:
      this.signals.azuresqldb.successfulConns.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),

    asql_deadlocks:
      this.signals.azuresqldb.deadlocks.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),

    asql_sessions:
      this.signals.azuresqldb.sessions.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),

    asql_cpu:
      this.signals.azuresqldb.cpuPercent.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + this.signals.azuresqldb.vCoreCpuPercent.asPanelMixin(),

    asql_storagebytes:
      this.signals.azuresqldb.storageBytes.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    asql_storagepercent:
      this.signals.azuresqldb.storagePercent.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),

    asql_dtuts:
      this.signals.azuresqldb.dtuUsed.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),

    asql_dtutbl:
      this.signals.azuresqldb.dtuUsed.common
      + commonlib.panels.generic.table.base.new(
        'DTU utilization and limits by database',
        [
          this.signals.azuresqldb.dtuUsed.asTarget()
          + g.query.prometheus.withFormat('table')
          + g.query.prometheus.withInstant(true),

          this.signals.azuresqldb.dtuPercent.asTarget()
          + g.query.prometheus.withFormat('table')
          + g.query.prometheus.withInstant(true),

          this.signals.azuresqldb.dtuLimit.asTarget()
          + g.query.prometheus.withFormat('table')
          + g.query.prometheus.withInstant(true),
        ],
        'DTU utilization and limits by database'
      ) + self._asql_tableCommon(),

    // GCP Load Balancer
    glb_reqsec:
      this.signals.gcploadbalancer.requestsByStatus.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('none')
      + g.panel.timeSeries.standardOptions.withUnit('reqps')
      + g.panel.timeSeries.standardOptions.withOverrides([])
      + g.panel.timeSeries.standardOptions.withNoValue('0'),

    glb_reqcountry:
      this.signals.gcploadbalancer.requestsByCountry.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('none')
      + g.panel.timeSeries.standardOptions.withUnit('short')
      + g.panel.timeSeries.standardOptions.withOverrides([])
      + g.panel.timeSeries.standardOptions.withNoValue('0'),

    glb_reqcache:
      this.signals.gcploadbalancer.requestsByCache.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('none')
      + g.panel.timeSeries.standardOptions.withUnit('short')
      + g.panel.timeSeries.standardOptions.withOverrides([])
      + g.panel.timeSeries.standardOptions.withNoValue('0'),

    glb_reqprotocol:
      this.signals.gcploadbalancer.requestsByProtocol.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('none')
      + g.panel.timeSeries.standardOptions.withUnit('short')
      + g.panel.timeSeries.standardOptions.withOverrides([])
      + g.panel.timeSeries.standardOptions.withNoValue('0'),

    glb_errorrate:
      this.signals.gcploadbalancer.errorRate.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('none')
      + g.panel.timeSeries.options.legend.withShowLegend(false)
      + g.panel.timeSeries.standardOptions.withUnit('percentunit')
      + g.panel.timeSeries.standardOptions.withMin(0)
      + g.panel.timeSeries.standardOptions.withMax(1)
      + g.panel.timeSeries.standardOptions.withOverrides([
        {
          matcher: {
            id: 'byName',
            options: 'Error Rate visualization',
          },
          properties: [
            {
              id: 'noValue',
              value: '0',
            },
            {
              id: 'color',
              value: {
                mode: 'fixed',
                fixedColor: 'red',
              },
            },
          ],
        },
      ]),

    glb_reslatency:
      this.signals.gcploadbalancer.totalResponseLatency50.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('none')
      + g.panel.timeSeries.standardOptions.withOverrides([])
      + this.signals.gcploadbalancer.totalResponseLatency90.asPanelMixin()
      + g.panel.timeSeries.standardOptions.withOverrides([])
      + this.signals.gcploadbalancer.totalResponseLatency99.asPanelMixin()
      + g.panel.timeSeries.standardOptions.withOverrides([])
      + this.signals.gcploadbalancer.totalResponseLatencyAverage.asPanelMixin()
      + g.panel.timeSeries.standardOptions.withUnit('ms')
      + g.panel.timeSeries.standardOptions.withNoValue('0')
      + g.panel.timeSeries.standardOptions.withOverrides([
        {
          matcher: {
            id: 'byName',
            options: 'p50',
          },
          properties: [
            {
              id: 'color',
              value: {
                mode: 'fixed',
                fixedColor: 'green',
              },
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'p90',
          },
          properties: [
            {
              id: 'color',
              value: {
                mode: 'fixed',
                fixedColor: 'orange',
              },
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'p99',
          },
          properties: [
            {
              id: 'color',
              value: {
                mode: 'fixed',
                fixedColor: 'red',
              },
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Average',
          },
          properties: [
            {
              id: 'color',
              value: {
                mode: 'fixed',
                fixedColor: 'blue',
              },
            },
          ],
        },
      ]),

    glb_frontendlatency:
      this.signals.gcploadbalancer.frontendLatency50.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('none')
      + g.panel.timeSeries.standardOptions.withOverrides([])
      + this.signals.gcploadbalancer.frontendLatency90.asPanelMixin()
      + g.panel.timeSeries.standardOptions.withOverrides([])
      + this.signals.gcploadbalancer.frontendLatency99.asPanelMixin()
      + g.panel.timeSeries.standardOptions.withUnit('ms')
      + g.panel.timeSeries.standardOptions.withNoValue('0')
      + g.panel.timeSeries.standardOptions.withOverrides([
        {
          matcher: {
            id: 'byName',
            options: 'p50',
          },
          properties: [
            {
              id: 'color',
              value: {
                mode: 'fixed',
                fixedColor: 'green',
              },
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'p90',
          },
          properties: [
            {
              id: 'color',
              value: {
                mode: 'fixed',
                fixedColor: 'orange',
              },
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'p99',
          },
          properties: [
            {
              id: 'color',
              value: {
                mode: 'fixed',
                fixedColor: 'red',
              },
            },
          ],
        },
      ]),

    glb_backendlatency:
      this.signals.gcploadbalancer.backendLatency50.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withOverrides([])
      + this.signals.gcploadbalancer.backendLatency90.asPanelMixin()
      + g.panel.timeSeries.standardOptions.withOverrides([])
      + this.signals.gcploadbalancer.backendLatency99.asPanelMixin()
      + g.panel.timeSeries.standardOptions.withUnit('ms')
      + g.panel.timeSeries.standardOptions.withNoValue('0')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('none')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.standardOptions.withOverrides([
        {
          matcher: {
            id: 'byName',
            options: 'p50',
          },
          properties: [
            {
              id: 'color',
              value: {
                mode: 'fixed',
                fixedColor: 'green',
              },
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'p90',
          },
          properties: [
            {
              id: 'color',
              value: {
                mode: 'fixed',
                fixedColor: 'orange',
              },
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'p99',
          },
          properties: [
            {
              id: 'color',
              value: {
                mode: 'fixed',
                fixedColor: 'red',
              },
            },
          ],
        },
      ]),

    glb_req_bytes_count:
      this.signals.gcploadbalancer.totalReqSent.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withOverrides([])
      + this.signals.gcploadbalancer.totalReqReceived.asPanelMixin()
      + g.panel.timeSeries.standardOptions.withUnit('short')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('none')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withAxisLabel('out(-) | in(+)')
      + g.panel.timeSeries.standardOptions.withOverrides([
        {
          matcher: {
            id: 'byName',
            options: 'Sent',
          },
          properties: [
            {
              id: 'color',
              value: {
                mode: 'fixed',
                fixedColor: 'blue',
              },
            },
            {
              id: 'custom.transform',
              value: 'negative-Y',
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Received',
          },
          properties: [
            {
              id: 'color',
              value: {
                mode: 'fixed',
                fixedColor: 'green',
              },
            },
          ],
        },
      ]),

    glb_backend_req_bytes_count:
      this.signals.gcpoadbalancerBackend.backendTotalReqSent.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withOverrides([])
      + this.signals.gcpoadbalancerBackend.backendTotalReqReceived.asPanelMixin()
      + g.panel.timeSeries.standardOptions.withUnit('short')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('none')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withAxisLabel('out(-) | in(+)')
      + g.panel.timeSeries.standardOptions.withOverrides([
        {
          matcher: {
            id: 'byName',
            options: 'Sent',
          },
          properties: [
            {
              id: 'color',
              value: {
                mode: 'fixed',
                fixedColor: 'blue',
              },
            },
            {
              id: 'custom.transform',
              value: 'negative-Y',
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Received',
          },
          properties: [
            {
              id: 'color',
              value: {
                mode: 'fixed',
                fixedColor: 'green',
              },
            },
          ],
        },
      ]),

    // Azure Load Balancer

    alb_sync_packets:
      this.signals.azureloadbalancer.summarySyncPackets.asStat()
      + commonlib.panels.generic.stat.base.stylize()
      + g.panel.stat.options.withColorMode('background_solid')
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.standardOptions.withUnit('short')
      + g.panel.stat.standardOptions.withNoValue('0')
      + g.panel.stat.standardOptions.withOverrides([]),

    alb_total_packets:
      this.signals.azureloadbalancer.summaryTotalPackets.asStat()
      + commonlib.panels.generic.stat.base.stylize()
      + g.panel.stat.options.withColorMode('background_solid')
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.standardOptions.withUnit('short')
      + g.panel.stat.standardOptions.withNoValue('0')
      + g.panel.stat.standardOptions.withOverrides([]),

    alb_total_bytes:
      this.signals.azureloadbalancer.summaryTotalBytes.asStat()
      + commonlib.panels.generic.stat.base.stylize()
      + g.panel.stat.options.withColorMode('background_solid')
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.standardOptions.withUnit('decbytes')
      + g.panel.stat.standardOptions.withNoValue('0')
      + g.panel.stat.standardOptions.withOverrides([]),

    alb_snat_connections:
      this.signals.azureloadbalancer.summarySnatConn.asStat()
      + commonlib.panels.generic.stat.base.stylize()
      + g.panel.stat.options.withColorMode('background_solid')
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.standardOptions.withNoValue('0')
      + g.panel.stat.standardOptions.withUnit('short')
      + g.panel.stat.standardOptions.withOverrides([]),

    alb_details_sync_packets:
      this.signals.azureloadbalancer.detailsSyncPackets.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('none')
      + g.panel.timeSeries.standardOptions.withUnit('short')
      + g.panel.timeSeries.standardOptions.withNoValue('0')
      + g.panel.timeSeries.standardOptions.withOverrides([]),

    alb_details_total_packets:
      this.signals.azureloadbalancer.detailsTotalPackets.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('none')
      + g.panel.timeSeries.standardOptions.withUnit('short')
      + g.panel.timeSeries.standardOptions.withNoValue('0')
      + g.panel.timeSeries.standardOptions.withOverrides([]),

    alb_details_total_bytes:
      this.signals.azureloadbalancer.detailsTotalBytes.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('none')
      + g.panel.timeSeries.standardOptions.withUnit('decbytes')
      + g.panel.timeSeries.standardOptions.withNoValue('0')
      + g.panel.timeSeries.standardOptions.withOverrides([]),

    alb_details_snat_connections:
      this.signals.azureloadbalancer.detailsSnatConn.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('none')
      + g.panel.timeSeries.standardOptions.withUnit('short')
      + g.panel.timeSeries.standardOptions.withNoValue('0')
      + g.panel.timeSeries.standardOptions.withOverrides([]),

    alb_snatports:
      this.signals.azureloadbalancer.snatPorts.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + this.signals.azureloadbalancer.allocatedSnatPorts.asPanelMixin()
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.standardOptions.withUnit('short')
      + g.panel.timeSeries.standardOptions.withNoValue('0')
      + g.panel.timeSeries.standardOptions.withOverrides([]),

    alb_used_snatports:
      this.signals.azureloadbalancer.usedSnatPorts.asGauge()
      + this.signals.azureloadbalancer.allocatedSnatPorts.asPanelMixin()
      + g.panel.gauge.standardOptions.color.withMode('thresholds')
      + g.panel.timeSeries.standardOptions.withUnit('short')
      + g.panel.timeSeries.standardOptions.withNoValue('0')
      + g.panel.timeSeries.standardOptions.withOverrides([])
      + g.panel.gauge.queryOptions.withTransformations([
        {
          id: 'configFromData',
          options: {
            configRefId: 'Allocated SNAT Ports',
            mappings: [
              {
                fieldName: 'Allocated',
                handlerKey: 'max',
              },
            ],
          },
        },
      ]),

    // Azure Virtual Network
    vn_under_ddos:
      this.signals.azurevirtualnetwork.underDdos.asStat(),

    vn_pingmesh_avg:
      this.signals.azurevirtualnetwork.pingMeshAvgRoundrip.asTimeSeries(),

    vn_packet_trigger:
      commonlib.panels.generic.timeSeries.base.new('DDoS trigger packets by type', targets=[])
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
      + this.signals.azurevirtualnetwork.synTriggerPackets.asPanelMixin()
      + this.signals.azurevirtualnetwork.tcpTriggerPackets.asPanelMixin()
      + this.signals.azurevirtualnetwork.udpTriggerPackets.asPanelMixin(),

    vn_bytes_by_action:
      commonlib.panels.generic.timeSeries.base.new('Bytes by DDoS action', targets=[])
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
      + this.signals.azurevirtualnetwork.bytesDropped.asPanelMixin()
      + this.signals.azurevirtualnetwork.bytesForwarded.asPanelMixin(),

    vn_bytes_dropped_by_protocol:
      commonlib.panels.generic.timeSeries.base.new('Bytes dropped in DDoS by protocol', targets=[])
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
      + this.signals.azurevirtualnetwork.tcpBytesDropped.asPanelMixin()
      + this.signals.azurevirtualnetwork.udpBytesDropped.asPanelMixin(),

    vn_bytes_forwarded_by_protocol:
      commonlib.panels.generic.timeSeries.base.new('Bytes forwarded in DDoS by protocol', targets=[])
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
      + this.signals.azurevirtualnetwork.tcpBytesForwarded.asPanelMixin()
      + this.signals.azurevirtualnetwork.udpBytesForwarded.asPanelMixin(),

    vn_packets_by_action:
      commonlib.panels.generic.timeSeries.base.new('Packets by DDoS action', targets=[])
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
      + this.signals.azurevirtualnetwork.packetsDropped.asPanelMixin()
      + this.signals.azurevirtualnetwork.packetsForwarded.asPanelMixin(),

    vn_packets_dropped_by_protocol:
      commonlib.panels.generic.timeSeries.base.new('Packets dropped in DDoS by protocol', targets=[])
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
      + this.signals.azurevirtualnetwork.tcpPacketsDropped.asPanelMixin()
      + this.signals.azurevirtualnetwork.udpPacketsDropped.asPanelMixin(),

    vn_packets_forwarded_by_protocol:
      commonlib.panels.generic.timeSeries.base.new('Packets forwarded in DDoS by protocol', targets=[])
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
      + this.signals.azurevirtualnetwork.tcpPacketsForwarded.asPanelMixin()
      + this.signals.azurevirtualnetwork.udpPacketsForwarded.asPanelMixin(),
  },
}
