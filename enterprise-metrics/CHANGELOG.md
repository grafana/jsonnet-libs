# Changelog

All notable changes to this library will be documented in this file.

Entries should be ordered as follows:
- [CHANGE]
- [FEATURE]
- [ENHANCEMENT]
- [BUGFIX]

Entries should include a reference to the Pull Request that introduced the change.

## Unreleased

- [CHANGE] The tokengen configuration is now hidden by default to avoid confusing errors when immutable fields are changed. #541
- [FEATURE] Alertmanager and ruler Kubernetes App manifests are now included. #541
- [BUGFIX] The `gossip-ring` Service now publishes not ready addresses. #523
- [BUGFIX] All ring members now have the `gossip_ring-member` label set. #523
- [BUGFIX] All microservices now use the `gossip-ring` Service as `memberlist.join` address. #523

## 1.0.0

- [FEATURE] Initial versioned release. #TODO
