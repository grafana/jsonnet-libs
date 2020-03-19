# Cert-manager jsonnet library (alpha)

This library was created as a mostly 1-to-1 rewrite of cert-manager helm chart and is in use internally at Grafana Labs. It should be considered experimental.

In addition to the helm chart content, this jsonnet library also provides `letsencrypt-prod` and `letsencrypt-staging` ClusterIssuers for direct consumption. Please have a look at `config.libsonnet` for configuration parameters.

