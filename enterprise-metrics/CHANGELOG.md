# Changelog

All notable changes to this library will be documented in this file.

Entries should be ordered as follows:
- [CHANGE]
- [FEATURE]
- [ENHANCEMENT]
- [BUGFIX]

Entries should include a reference to the Pull Request that introduced the change.

## Unreleased

- [CHANGE] Use of the deprecated `-bootstrap.license.path` flag has been replaced with `-license.path`. #645 
- [CHANGE] The tokengen configuration is now hidden by default to avoid confusing errors when immutable fields are changed. #541
- [CHANGE] Arbitrary storage class names are removed from PersistentVolumeClaims. If you were using those storage class names, you will need to configure the storageClassName in the persistentVolume object. For example in `$.ingester.persistentVolumeClaim`. #577
- [CHANGE] Enabled the self-monitoring feature, which was part of the GEM 1.4 release, by default. #608
- [FEATURE] Upgrade to [Grafana Enterprise Metrics v1.3.0](https://grafana.com/docs/metrics-enterprise/latest/downloads/#v130----april-26th-2021). #552
- [FEATURE] Alertmanager and ruler Kubernetes App manifests are now included. #541
- [FEATURE] PersistentVolumeClaims can be configured on all components run as a StatefulSet. This includes the alertmanager, compactor, ingester, and store-gateway components. #577
- [FEATURE] Upgrade to [Grafana Enterprise Metrics v1.4.0](https://grafana.com/docs/metrics-enterprise/latest/downloads/#v140----june-28th-2021). #598
- [FEATURE] Upgrade to [Grafana Enterprise Metrics v1.4.1](https://grafana.com/docs/metrics-enterprise/latest/downloads/#v141----june-29th-2021). #608
- [FEATURE] Run the Grafana Enterprise Metrics `overrides-exporter` target as a deployment. #626
- [FEATURE] Upgrade to [Grafana Enterprise Metrics v1.5.0](https://grafana.com/docs/metrics-enterprise/latest/downloads/#v150----august-24th-2021). #638
- [BUGFIX] The `gossip-ring` Service now publishes not ready addresses. #523
- [ENHANCEMENT] Make Secret name for GEM admin token configurable via `adminTokenSecretName`. #600- [BUGFIX] The `gossip-ring` Service now publishes not ready addresses. #523
- [BUGFIX] All ring members now have the `gossip_ring-member` label set. #523
- [BUGFIX] All microservices now use the `gossip-ring` Service as `memberlist.join` address. #523
- [BUGFIX] Enable admin-api leader election. This change does not affect single replica deployments of the admin-api but does fix the potential for an inconsistent state when running with multiple replicas of the admin-api and experiencing parallel writes for the same objects.
- [BUGFIX] Ensure only a single tokengen Pod is created by having the container restart on failure. #647

## 1.0.0

- [FEATURE] Initial versioned release. #TODO
