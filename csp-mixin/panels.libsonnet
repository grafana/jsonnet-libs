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

    // Azure Virtual Machines

    avm_instance_count:
      this.signals.virtualMachinesOverview.instanceCount.asStat()
      + commonlib.panels.generic.stat.base.stylize(),

    avm_availability:
      this.signals.virtualMachinesOverview.vmAvailability.common
      + commonlib.panels.generic.stat.base.new(
        'VM Availability',
        [
          this.signals.virtualMachinesOverview.vmAvailability.asTarget()
          + g.query.prometheus.withFormat('time_series')
          + g.query.prometheus.withInstant(true)
          + g.query.prometheus.withRange(false),
        ],
        'Measure of Availability of Virtual machines'
      )
      + g.panel.stat.options.withColorMode('background')
      + g.panel.stat.standardOptions.withUnit('short')
      + g.panel.stat.standardOptions.withOverrides([
        {
          matcher: {
            id: 'byType',
            options: 'number',
          },
          properties: [
            {
              id: 'mappings',
              value: [
                {
                  options: {
                    '0': {
                      color: 'red',
                      index: 1,
                      text: 'Not Available',
                    },
                    '1': {
                      color: 'green',
                      index: 0,
                      text: 'Available',
                    },
                  },
                  type: 'value',
                },
              ],
            },
          ],
        },
      ]),

    _avm_timeSeriesCommon()::
      g.panel.timeSeries.standardOptions.color.withMode('palette-classic')
      + g.panel.timeSeries.standardOptions.withNoValue('0')
      + g.panel.timeSeries.standardOptions.withOverrides([]),

    avm_cpu_utilization:
      this.signals.virtualMachines.cpuUtilization.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('percent')
      + self._avm_timeSeriesCommon(),

    avm_available_memory:
      this.signals.virtualMachines.availableMemory.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('decbytes')
      + self._avm_timeSeriesCommon(),

    avm_cpu_credits_consumed:
      this.signals.virtualMachines.cpuCreditsConsumed.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('short')
      + self._avm_timeSeriesCommon(),

    avm_cpu_credits_remaining:
      this.signals.virtualMachines.cpuCreditsRemaining.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('short')
      + self._avm_timeSeriesCommon(),

    avm_disk_total_bytes:
      this.signals.virtualMachinesOverview.diskReadBytes.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + this.signals.virtualMachinesOverview.diskWriteBytes.asPanelMixin()
      + g.panel.timeSeries.standardOptions.withOverrides([])
      + g.panel.timeSeries.standardOptions.withUnit('decbytes')
      + self._avm_timeSeriesCommon(),

    avm_disk_operations:
      this.signals.virtualMachinesOverview.diskReadOperations.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + this.signals.virtualMachinesOverview.diskWriteOperations.asPanelMixin()
      + g.panel.timeSeries.standardOptions.withOverrides([])
      + g.panel.timeSeries.standardOptions.withUnit('cps')
      + self._avm_timeSeriesCommon(),

    avm_network_total:
      this.signals.virtualMachinesOverview.networkInTotal.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + this.signals.virtualMachinesOverview.networkOutTotal.asPanelMixin()
      + g.panel.timeSeries.standardOptions.withOverrides([])
      + g.panel.timeSeries.standardOptions.withUnit('decbytes')
      + self._avm_timeSeriesCommon(),

    avm_connections:
      this.signals.virtualMachinesOverview.inboundFlows.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + this.signals.virtualMachinesOverview.outboundFlows.asPanelMixin()
      + g.panel.timeSeries.standardOptions.withOverrides([])
      + g.panel.timeSeries.standardOptions.withUnit('cps')
      + self._avm_timeSeriesCommon(),

    avm_network_in_by_instance:
      this.signals.virtualMachines.networkInByVM.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('decbytes')
      + self._avm_timeSeriesCommon(),

    avm_network_out_by_instance:
      this.signals.virtualMachines.networkOutByVM.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('decbytes')
      + self._avm_timeSeriesCommon(),

    avm_disk_read_by_instance:
      this.signals.virtualMachines.diskReadByVM.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('decbytes')
      + self._avm_timeSeriesCommon(),

    avm_disk_write_by_instance:
      this.signals.virtualMachines.diskWriteByVM.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('decbytes')
      + self._avm_timeSeriesCommon(),

    avm_disk_read_operations_by_instance:
      this.signals.virtualMachines.diskReadOperationsByVM.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('decbytes')
      + self._avm_timeSeriesCommon(),

    avm_disk_write_operations_by_instance:
      this.signals.virtualMachines.diskWriteOperationsByVM.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('decbytes')
      + self._avm_timeSeriesCommon(),

    avm_top5_cpu_utilization:
      this.signals.virtualMachinesOverview.top5CpuUtilization.common
      + commonlib.panels.generic.table.base.new(
        'Top 5 Instances - CPU utilitization',
        [
          this.signals.virtualMachinesOverview.top5CpuUtilization.asTarget()
          + g.query.prometheus.withFormat('table')
          + g.query.prometheus.withInstant(true)
          + g.query.prometheus.withRange(false),
        ],
        'Fractional utilization of allocated CPU on an instance'
      )
      + g.panel.table.standardOptions.withOverrides([
        {
          matcher: {
            id: 'byName',
            options: 'Value',
          },
          properties: [
            {
              id: 'custom.width',
              value: 100,
            },
            {
              id: 'unit',
              value: 'percent',
            },
            {
              id: 'custom.cellOptions',
              value: {
                mode: 'gradient',
                type: 'gauge',
                valueDisplayMode: 'text',
              },
            },
            {
              id: 'thresholds',
              value: {
                mode: 'absolute',
                steps: [
                  {
                    color: 'green',
                    value: null,
                  },
                  {
                    color: 'orange',
                    value: 70,
                  },
                  {
                    color: 'red',
                    value: 90,
                  },
                ],
              },
            },
          ],
        },
      ])
      + g.panel.table.queryOptions.withTransformations([
        {
          id: 'organize',
          options: {
            excludeByName: {
              Time: true,
              job: true,
              subscriptionName: true,
            },
            indexByName: {
              Time: 1,
              Value: 4,
              job: 2,
              resourceGroup: 3,
              resourceName: 0,
            },
            renameByName: {
              job: '',
              resourceGroup: 'Group',
              resourceName: 'Instance',
            },
          },
        },
      ]),

    avm_top5_disk_read_write:
      this.signals.virtualMachinesOverview.top5DiskRead.common
      + commonlib.panels.generic.table.base.new(
        'Top 5 Instances - Disk read/write bytes',
        [
          this.signals.virtualMachinesOverview.top5DiskRead.asTarget()
          + g.query.prometheus.withFormat('table')
          + g.query.prometheus.withInstant(true)
          + g.query.prometheus.withRange(false),

          this.signals.virtualMachinesOverview.top5DiskWrite.asTarget()
          + g.query.prometheus.withFormat('table')
          + g.query.prometheus.withInstant(true)
          + g.query.prometheus.withRange(false),
        ],
        'List of top 5 Instances by disk read/write bytes'
      )
      + g.panel.table.standardOptions.withUnit('decbytes')
      + g.panel.table.standardOptions.withOverrides([
        {
          matcher: {
            id: 'byName',
            options: 'Read',
          },
          properties: [
            {
              id: 'custom.width',
              value: 100,
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Write',
          },
          properties: [
            {
              id: 'custom.width',
              value: 100,
            },
          ],
        },
      ])
      + g.panel.table.queryOptions.withTransformations([
        {
          id: 'merge',
          options: {},
        },
        {
          id: 'organize',
          options: {
            excludeByName: {
              subscriptionName: true,
              Time: true,
              job: true,
            },
            indexByName: {
              Time: 1,
              'Value #Top 5 Instances - Disk read bytes': 4,
              'Value #Top 5 Instances - Disk write bytes': 5,
              job: 2,
              resourceGroup: 3,
              resourceName: 0,
            },
            renameByName: {
              'Value #Top 5 Instances - Disk read bytes': 'Read',
              'Value #Top 5 Instances - Disk write bytes': 'Write',
              job: '',
              resourceGroup: 'Group',
              resourceName: 'Instance',
            },
          },
        },
      ]),

    avm_top5_disk_operations:
      this.signals.virtualMachinesOverview.top5DiskReadOperations.common
      + commonlib.panels.generic.table.base.new(
        'Top 5 Instances - Disk read/write operations/sec',
        [
          this.signals.virtualMachinesOverview.top5DiskReadOperations.asTarget()
          + g.query.prometheus.withFormat('table')
          + g.query.prometheus.withInstant(true)
          + g.query.prometheus.withRange(false),

          this.signals.virtualMachinesOverview.top5DiskWriteOperations.asTarget()
          + g.query.prometheus.withFormat('table')
          + g.query.prometheus.withInstant(true)
          + g.query.prometheus.withRange(false),
        ],
        'List of top 5 Instances with higher disk read/write IOPS'
      )
      + g.panel.table.standardOptions.withUnit('cps')
      + g.panel.table.standardOptions.withOverrides([
        {
          matcher: {
            id: 'byName',
            options: 'Read',
          },
          properties: [
            {
              id: 'custom.width',
              value: 100,
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Write',
          },
          properties: [
            {
              id: 'custom.width',
              value: 100,
            },
          ],
        },
      ])
      + g.panel.table.queryOptions.withTransformations([
        {
          id: 'merge',
          options: {},
        },
        {
          id: 'organize',
          options: {
            excludeByName: {
              subscriptionName: true,
              Time: true,
              job: true,
            },
            indexByName: {
              Time: 1,
              'Value #Top 5 Instances - Disk read operations/sec': 4,
              'Value #Top 5 Instances - Disk write operations/sec': 5,
              job: 2,
              resourceGroup: 3,
              resourceName: 0,
            },
            renameByName: {
              'Value #Top 5 Instances - Disk read operations/sec': 'Read',
              'Value #Top 5 Instances - Disk write operations/sec': 'Write',
              job: '',
              resourceGroup: 'Group',
              resourceName: 'Instance',
            },
          },
        },
      ]),

    avm_top5_network_total:
      this.signals.virtualMachinesOverview.top5NetworkIn.common
      + commonlib.panels.generic.table.base.new(
        'Top 5 Instances - Network throughput received/sent',
        [
          this.signals.virtualMachinesOverview.top5NetworkIn.asTarget()
          + g.query.prometheus.withFormat('table')
          + g.query.prometheus.withInstant(true)
          + g.query.prometheus.withRange(false),

          this.signals.virtualMachinesOverview.top5NetworkOut.asTarget()
          + g.query.prometheus.withFormat('table')
          + g.query.prometheus.withInstant(true)
          + g.query.prometheus.withRange(false),
        ],
        'List of top 5 Instances with higher number of bytes received/sent over the network.'
      )
      + g.panel.table.standardOptions.withUnit('cps')
      + g.panel.table.standardOptions.withOverrides([
        {
          matcher: {
            id: 'byName',
            options: 'Received',
          },
          properties: [
            {
              id: 'custom.width',
              value: 100,
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Sent',
          },
          properties: [
            {
              id: 'custom.width',
              value: 100,
            },
          ],
        },
      ])
      + g.panel.table.queryOptions.withTransformations([
        {
          id: 'merge',
          options: {},
        },
        {
          id: 'organize',
          options: {
            excludeByName: {
              subscriptionName: true,
              Time: true,
              job: true,
            },
            indexByName: {
              Time: 1,
              'Value #Top 5 Instances - Network throughput received': 4,
              'Value #Top 5 Instances - Network throughput sent': 5,
              job: 2,
              resourceGroup: 3,
              resourceName: 0,
            },
            renameByName: {
              'Value #Top 5 Instances - Network throughput received': 'Received',
              'Value #Top 5 Instances - Network throughput sent': 'Sent',
              job: '',
              resourceGroup: 'Group',
              resourceName: 'Instance',
            },
          },
        },
      ]),
  },
}
