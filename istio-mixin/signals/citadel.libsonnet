local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'none',
    aggFunction: 'avg',
    signals: {
      citadelCsrCount: {
        name: 'Citadel CSR requests',
        nameShort: 'CSR requests',
        type: 'counter',
        description: 'Total number of certificate signing requests (CSRs) received by Citadel.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'citadel_server_csr_count{%(queriesSelector)s}',
          },
        },
      },

      citadelRootCertExpiry: {
        name: 'Citadel root cert expiry',
        nameShort: 'Cert expiry',
        type: 'gauge',
        description: 'Unix timestamp when the Citadel root certificate expires. Negative values indicate an expired cert.',
        unit: 'dateTimeFromNow',
        sources: {
          prometheus: {
            expr: 'citadel_server_root_cert_expiry_timestamp{%(queriesSelector)s}',
          },
        },
      },

      citadelSuccessCertIssuance: {
        name: 'Citadel cert issuances',
        nameShort: 'Cert issuances',
        type: 'counter',
        description: 'Total number of certificates successfully issued by Citadel.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'citadel_server_success_cert_issuance_count{%(queriesSelector)s}',
          },
        },
      },

      galleyValidationConfigUpdates: {
        name: 'Galley validation config updates',
        nameShort: 'Galley updates',
        type: 'counter',
        description: 'Total number of k8s webhook configuration updates by Galley.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'galley_validation_config_updates{%(queriesSelector)s}',
          },
        },
      },
    },
  }
