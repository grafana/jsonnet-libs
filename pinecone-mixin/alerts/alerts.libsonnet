local xtd = import 'github.com/jsonnet-libs/xtd/main.libsonnet';

{
  new(this): {
    local instanceLabel = xtd.array.slice(this.config.instanceLabels, -1)[0],
    local firstInstanceLabel = this.config.instanceLabels[0],
    prometheusAlerts: {
      groups: [
        {
          name: this.config.uid + '-pinecone-alerts',
          rules: [
            {
              alert: 'PineconeHighQueryLatencyWarning',
              expr: 'rate(pinecone_db_op_query_duration_total{%(filteringSelector)s}[5m]) / clamp_min(rate(pinecone_db_op_query_total{%(filteringSelector)s}[5m]), 1) > (%(queryLatencySimpleWarningMs)s / 1000)' % this.config {
                queryLatencySimpleWarningMs: this.config.alertsQueryLatencySimpleWarningMs,
              },
              'for': '5m',
              keep_firing_for: '5m',
              labels: {
                severity: 'warning',
              },
              annotations: {
                summary: 'Query latency exceeds warning thresholds, indicating performance degradation in query operations.',
                description: 'Query latency on {{ $labels.%s }} (index: {{ $labels.%s }}) is {{ printf "%%.3f" $value }}s. This exceeds the warning threshold: > %sms.' % [
                  firstInstanceLabel,
                  instanceLabel,
                  this.config.alertsQueryLatencySimpleWarningMs,
                ],
              },
            },
            {
              alert: 'PineconeHighQueryLatencyCritical',
              expr: 'rate(pinecone_db_op_query_duration_total{%(filteringSelector)s}[5m]) / clamp_min(rate(pinecone_db_op_query_total{%(filteringSelector)s}[5m]), 1) > (%(queryLatencySimpleCriticalMs)s / 1000)' % this.config {
                queryLatencySimpleCriticalMs: this.config.alertsQueryLatencySimpleCriticalMs,
              },
              'for': '5m',
              keep_firing_for: '5m',
              labels: {
                severity: 'critical',
              },
              annotations: {
                summary: 'Query latency exceeds critical thresholds, indicating performance degradation in query operations.',
                description: 'Query latency on {{ $labels.%s }} (index: {{ $labels.%s }}) is {{ printf "%%.3f" $value }}s. CRITICAL: This exceeds the critical threshold: > %sms.' % [
                  firstInstanceLabel,
                  instanceLabel,
                  this.config.alertsQueryLatencySimpleCriticalMs,
                ],
              },
            },
            {
              alert: 'PineconeHighUpsertLatencyWarning',
              expr: 'rate(pinecone_db_op_upsert_duration_total{%(filteringSelector)s}[15m]) / clamp_min(rate(pinecone_db_op_upsert_total{%(filteringSelector)s}[15m]), 1) > (%(upsertLatencyWarningMs)s / 1000)' % this.config {
                upsertLatencyWarningMs: this.config.alertsUpsertLatencyWarningMs,
              },
              'for': '5m',
              keep_firing_for: '5m',
              labels: {
                severity: 'warning',
              },
              annotations: {
                summary: 'Upsert latency exceeds warning thresholds, indicating performance degradation in upsert operations.',
                description: 'Upsert latency on {{ $labels.%s }} (index: {{ $labels.%s }}) is {{ printf "%%.3f" $value }}s. This exceeds the warning threshold: > %sms sustained.' % [
                  firstInstanceLabel,
                  instanceLabel,
                  this.config.alertsUpsertLatencyWarningMs,
                ],
              },
            },
            {
              alert: 'PineconeHighUpsertLatencyCritical',
              expr: 'rate(pinecone_db_op_upsert_duration_total{%(filteringSelector)s}[15m]) / clamp_min(rate(pinecone_db_op_upsert_total{%(filteringSelector)s}[15m]), 1) > (%(upsertLatencyCriticalMs)s / 1000)' % this.config {
                upsertLatencyCriticalMs: this.config.alertsUpsertLatencyCriticalMs,
              },
              'for': '5m',
              keep_firing_for: '5m',
              labels: {
                severity: 'critical',
              },
              annotations: {
                summary: 'Upsert latency exceeds critical thresholds, indicating performance degradation in upsert operations.',
                description: 'Upsert latency on {{ $labels.%s }} (index: {{ $labels.%s }}) is {{ printf "%%.3f" $value }}s. CRITICAL: This exceeds the critical threshold: > %sms sustained.' % [
                  firstInstanceLabel,
                  instanceLabel,
                  this.config.alertsUpsertLatencyCriticalMs,
                ],
              },
            },
            {
              alert: 'PineconeSaturationWarning',
              expr: '(pinecone_index_fullness{%(filteringSelector)s} > %(indexFullnessWarning)s) OR ((100 * pinecone_db_storage_size_bytes{%(filteringSelector)s} / clamp_min(pinecone_db_storage_max_bytes{%(filteringSelector)s}, 1)) > %(storageUsageWarning)s)' % this.config {
                indexFullnessWarning: this.config.alertsSaturationIndexFullnessWarning,
                storageUsageWarning: this.config.alertsSaturationStorageUsageWarning,
              },
              'for': '5m',
              keep_firing_for: '10m',
              labels: {
                severity: 'warning',
              },
              annotations: {
                summary: 'Index nearing capacity or growing unexpectedly, risking degraded performance.',
                description: 'Index saturation on {{ $labels.%s }} (index: {{ $labels.%s }}) is high. Index fullness: {{ printf "%%.1f" $value }}%%. This exceeds the warning threshold: either index fullness > %s%% or storage > %s%% of allowed size.' % [
                  firstInstanceLabel,
                  instanceLabel,
                  this.config.alertsSaturationIndexFullnessWarning,
                  this.config.alertsSaturationStorageUsageWarning,
                ],
              },
            },
            {
              alert: 'PineconeSaturationCritical',
              expr: |||
                (pinecone_index_fullness{%(filteringSelector)s} > %(indexFullnessCritical)s)
                OR
                (
                  100 * (pinecone_db_storage_size_bytes{%(filteringSelector)s} - pinecone_db_storage_size_bytes{%(filteringSelector)s} offset 1h) 
                  / clamp_min(pinecone_db_storage_size_bytes{%(filteringSelector)s} offset 1h, 1)
                  > %(storageGrowthCritical)s
                )
              ||| % this.config {
                indexFullnessCritical: this.config.alertsSaturationIndexFullnessCritical,
                storageGrowthCritical: this.config.alertsSaturationStorageGrowthCritical,
              },
              'for': '5m',
              keep_firing_for: '10m',
              labels: {
                severity: 'critical',
              },
              annotations: {
                summary: 'Index nearing capacity or growing unexpectedly, risking degraded performance.',
                description: 'Index saturation on {{ $labels.%s }} (index: {{ $labels.%s }}) is critical. Index fullness: {{ printf "%%.1f" $value }}%%. CRITICAL: This exceeds the critical threshold: either index fullness > %s%% or storage growth > %s%% over 1 hour.' % [
                  firstInstanceLabel,
                  instanceLabel,
                  this.config.alertsSaturationIndexFullnessCritical,
                  this.config.alertsSaturationStorageGrowthCritical,
                ],
              },
            },
            {
              alert: 'PineconeUnitBurnDownWarning',
              expr: |||
                (
                  rate(pinecone_db_read_unit_total{%(filteringSelector)s}[30m])
                  / clamp_min(rate(pinecone_db_read_unit_total{%(filteringSelector)s}[30m] offset 30m), 1)
                  > (%(unitBurnDownBaselineIncreaseWarning)s / 100)
                )
                OR
                (
                  rate(pinecone_db_write_unit_total{%(filteringSelector)s}[30m])
                  / clamp_min(rate(pinecone_db_write_unit_total{%(filteringSelector)s}[30m] offset 30m), 1)
                  > (%(unitBurnDownBaselineIncreaseWarning)s / 100)
                )
                OR
                (
                  increase(pinecone_db_read_unit_total{%(filteringSelector)s}[1h]) > 0
                  AND
                  100 * 24 * increase(pinecone_db_read_unit_total{%(filteringSelector)s}[1h]) / clamp_min(pinecone_db_read_unit_budget{%(filteringSelector)s}, 1) > %(unitBurnDownBudgetUsageWarning)s
                )
                OR
                (
                  increase(pinecone_db_write_unit_total{%(filteringSelector)s}[1h]) > 0
                  AND
                  100 * 24 * increase(pinecone_db_write_unit_total{%(filteringSelector)s}[1h]) / clamp_min(pinecone_db_write_unit_budget{%(filteringSelector)s}, 1) > %(unitBurnDownBudgetUsageWarning)s
                )
              ||| % this.config {
                unitBurnDownBaselineIncreaseWarning: this.config.alertsUnitBurnDownBaselineIncreaseWarning,
                unitBurnDownBudgetUsageWarning: this.config.alertsUnitBurnDownBudgetUsageWarning,
              },
              'for': '5m',
              keep_firing_for: '10m',
              labels: {
                severity: 'warning',
              },
              annotations: {
                summary: 'RU/WU usage increasing rapidly or nearing allocated limits, causing potential throttling or cost spikes.',
                description: 'Unit consumption on {{ $labels.%s }} (index: {{ $labels.%s }}) is high. This exceeds the warning threshold: either RU or WU rate > %s%% above 30-minute baseline or sustained usage over 1h > %s%% of allocated budget.' % [
                  firstInstanceLabel,
                  instanceLabel,
                  (this.config.alertsUnitBurnDownBaselineIncreaseWarning - 100),
                  this.config.alertsUnitBurnDownBudgetUsageWarning,
                ],
              },
            },
          ],
        },
      ],
    },
  },
}
