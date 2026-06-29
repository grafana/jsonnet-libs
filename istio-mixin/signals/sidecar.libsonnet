local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'none',
    aggFunction: 'avg',
    signals: {
      sidecarInjectionRequests: {
        name: 'Sidecar injection requests',
        nameShort: 'Inject requests',
        type: 'counter',
        description: 'Total number of sidecar injection requests.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'sidecar_injection_requests_total{%(queriesSelector)s}',
          },
        },
      },

      sidecarInjectionSuccess: {
        name: 'Sidecar injection successes',
        nameShort: 'Inject success',
        type: 'counter',
        description: 'Total number of successful sidecar injection requests.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'sidecar_injection_success_total{%(queriesSelector)s}',
          },
        },
      },

      webhookPatchAttempts: {
        name: 'Webhook patch attempts',
        nameShort: 'Webhook patches',
        type: 'counter',
        description: 'Total number of webhook configuration patch attempts, by webhook name.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'webhook_patch_attempts_total{%(queriesSelector)s}',
          },
        },
      },
    },
  }
