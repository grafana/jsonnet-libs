---
permalink: /
---

# package enterprise-metrics

```jsonnet
local enterprise-metrics = import "github.com/grafana/jsonnet-libs/enterprise-metrics/main.libsonnet"
```

`enterprise-metrics` produces Kubernetes manifests for a Grafana Enterprise Metrics cluster.

## Index

* [`obj _config`](#obj-_config)
  * [`obj _config.commonArgs`](#obj-_configcommonargs)
    * [`bool _config.commonArgs.auth.enabled`](#bool-_configcommonargsauthenabled)
    * [`bool _config.commonArgs.auth.type`](#bool-_configcommonargsauthtype)
    * [`string _config.commonArgs.cluster-name`](#string-_configcommonargscluster-name)
  * [`string _config.licenseSecretName`](#string-_configlicensesecretname)
* [`obj _images`](#obj-_images)
  * [`string _images.gem`](#string-_imagesgem)
  * [`string _images.kubectl`](#string-_imageskubectl)
* [`obj adminApi`](#obj-adminapi)
  * [`obj adminApi.args`](#obj-adminapiargs)
    * [`bool adminApi.args.auth.enabled`](#bool-adminapiargsauthenabled)
    * [`bool adminApi.args.auth.type`](#bool-adminapiargsauthtype)
    * [`string adminApi.args.bootstrap.license.path`](#string-adminapiargsbootstraplicensepath)
    * [`string adminApi.args.cluster-name`](#string-adminapiargscluster-name)
  * [`obj adminApi.container`](#obj-adminapicontainer)
    
  * [`obj adminApi.deployment`](#obj-adminapideployment)
    
  * [`obj adminApi.service`](#obj-adminapiservice)
    
* [`obj compactor`](#obj-compactor)
  * [`obj compactor.args`](#obj-compactorargs)
    * [`bool compactor.args.auth.enabled`](#bool-compactorargsauthenabled)
    * [`bool compactor.args.auth.type`](#bool-compactorargsauthtype)
    * [`string compactor.args.cluster-name`](#string-compactorargscluster-name)
  * [`obj compactor.container`](#obj-compactorcontainer)
    
  * [`obj compactor.service`](#obj-compactorservice)
    
  * [`obj compactor.statefulSet`](#obj-compactorstatefulset)
    
* [`obj distributor`](#obj-distributor)
  * [`obj distributor.args`](#obj-distributorargs)
    * [`bool distributor.args.auth.enabled`](#bool-distributorargsauthenabled)
    * [`bool distributor.args.auth.type`](#bool-distributorargsauthtype)
    * [`string distributor.args.cluster-name`](#string-distributorargscluster-name)
  * [`obj distributor.container`](#obj-distributorcontainer)
    
  * [`obj distributor.service`](#obj-distributorservice)
    
  * [`obj distributor.statefulSet`](#obj-distributorstatefulset)
    
* [`obj gateway`](#obj-gateway)
  * [`obj gateway.args`](#obj-gatewayargs)
    * [`bool gateway.args.auth.enabled`](#bool-gatewayargsauthenabled)
    * [`bool gateway.args.auth.type`](#bool-gatewayargsauthtype)
    * [`string gateway.args.cluster-name`](#string-gatewayargscluster-name)
    * [`string gateway.args.gateway.proxy.admin-api.url`](#string-gatewayargsgatewayproxyadmin-apiurl)
    * [`string gateway.args.gateway.proxy.distributor.url`](#string-gatewayargsgatewayproxydistributorurl)
    * [`string gateway.args.gateway.proxy.ingester.url`](#string-gatewayargsgatewayproxyingesterurl)
    * [`string gateway.args.gateway.proxy.query-frontend.url`](#string-gatewayargsgatewayproxyquery-frontendurl)
    * [`string gateway.args.gateway.proxy.store-gateway.url`](#string-gatewayargsgatewayproxystore-gatewayurl)
  * [`obj gateway.container`](#obj-gatewaycontainer)
    
  * [`obj gateway.deployment`](#obj-gatewaydeployment)
    
  * [`obj gateway.service`](#obj-gatewayservice)
    
* [`obj gossipRing`](#obj-gossipring)
  * [`obj gossipRing.service`](#obj-gossipringservice)
    
* [`obj ingester`](#obj-ingester)
  * [`obj ingester.args`](#obj-ingesterargs)
    * [`bool ingester.args.auth.enabled`](#bool-ingesterargsauthenabled)
    * [`bool ingester.args.auth.type`](#bool-ingesterargsauthtype)
    * [`string ingester.args.cluster-name`](#string-ingesterargscluster-name)
  * [`obj ingester.container`](#obj-ingestercontainer)
    
  * [`obj ingester.podDisruptionBudget`](#obj-ingesterpoddisruptionbudget)
    
  * [`obj ingester.service`](#obj-ingesterservice)
    
  * [`obj ingester.statefulSet`](#obj-ingesterstatefulset)
    
* [`obj memcached`](#obj-memcached)
  * [`obj memcached.chunks`](#obj-memcachedchunks)
    
  * [`obj memcached.metadata`](#obj-memcachedmetadata)
    
  * [`obj memcached.queries`](#obj-memcachedqueries)
    
* [`obj querier`](#obj-querier)
  * [`obj querier.args`](#obj-querierargs)
    * [`bool querier.args.auth.enabled`](#bool-querierargsauthenabled)
    * [`bool querier.args.auth.type`](#bool-querierargsauthtype)
    * [`string querier.args.cluster-name`](#string-querierargscluster-name)
  * [`obj querier.container`](#obj-queriercontainer)
    
  * [`obj querier.deployment`](#obj-querierdeployment)
    
  * [`obj querier.service`](#obj-querierservice)
    
* [`obj queryFrontend`](#obj-queryfrontend)
  * [`obj queryFrontend.args`](#obj-queryfrontendargs)
    * [`bool queryFrontend.args.auth.enabled`](#bool-queryfrontendargsauthenabled)
    * [`bool queryFrontend.args.auth.type`](#bool-queryfrontendargsauthtype)
    * [`string queryFrontend.args.cluster-name`](#string-queryfrontendargscluster-name)
  * [`obj queryFrontend.container`](#obj-queryfrontendcontainer)
    
  * [`obj queryFrontend.deployment`](#obj-queryfrontenddeployment)
    
  * [`obj queryFrontend.service`](#obj-queryfrontendservice)
    
* [`obj storeGateway`](#obj-storegateway)
  * [`obj storeGateway.args`](#obj-storegatewayargs)
    * [`bool storeGateway.args.auth.enabled`](#bool-storegatewayargsauthenabled)
    * [`bool storeGateway.args.auth.type`](#bool-storegatewayargsauthtype)
    * [`string storeGateway.args.cluster-name`](#string-storegatewayargscluster-name)
  * [`obj storeGateway.container`](#obj-storegatewaycontainer)
    
  * [`obj storeGateway.podDisruptionBudget`](#obj-storegatewaypoddisruptionbudget)
    
  * [`obj storeGateway.service`](#obj-storegatewayservice)
    
  * [`obj storeGateway.statefulSet`](#obj-storegatewaystatefulset)
    
* [`obj tokengen`](#obj-tokengen)
  * [`obj tokengen.args`](#obj-tokengenargs)
    * [`bool tokengen.args.auth.enabled`](#bool-tokengenargsauthenabled)
    * [`bool tokengen.args.auth.type`](#bool-tokengenargsauthtype)
    * [`string tokengen.args.cluster-name`](#string-tokengenargscluster-name)
  * [`obj tokengen.container`](#obj-tokengencontainer)
    
  * [`obj tokengen.createSecretContainer`](#obj-tokengencreatesecretcontainer)
    
  * [`obj tokengen.job`](#obj-tokengenjob)
    
  * [`obj tokengen.role`](#obj-tokengenrole)
    
  * [`obj tokengen.roleBinding`](#obj-tokengenrolebinding)
    
  * [`obj tokengen.serviceAccount`](#obj-tokengenserviceaccount)
    

## Fields

## obj _config

`_config` is used for consumer overrides and configuration. Similar to a Helm values.yaml file

## obj _config.commonArgs

`commonArgs` is a convenience field that can be used to modify the container arguments of all modules as key-value pairs.

### bool _config.commonArgs.auth.enabled

*Default value: * `true`

`auth.enabled` enables the tenant authentication

### bool _config.commonArgs.auth.type

*Default value: * `enterprise`

`auth.type` configures the type of authentication in use.
`enterprise` uses Grafana Enterprise token authentication.
`default` uses Cortex authentication.


### string _config.commonArgs.cluster-name

`cluster-name` is the cluster name associated with your Grafana Enterprise Metrics license.

### string _config.licenseSecretName

*Default value: * `gem-license`

The admin-api expects a Grafana Enterprise Metrics license configured as 'license.jwt' in the
Kubernetes Secret with `licenseSecretName`.
To create the Kubernetes Secret from a local 'license.jwt' file:
$ kubectl create secret generic gem-license -from-file=license.jwt


## obj _images

`_images` contains fields for container images.

### string _images.gem

*Default value: * `grafana/metrics-enterprise`

`gem` is the Grafana Enterprise Metrics container image.

### string _images.kubectl

*Default value: * `bitnami/kubectl`

`kubectl` is the image used for kubectl containers.

## obj adminApi

`adminApi` has configuration for the admin-api.

## obj adminApi.args

`args` is a convenience field that can be used to modify the admin-api container arguments as key value pairs.

### bool adminApi.args.auth.enabled

*Default value: * `true`

`auth.enabled` enables the tenant authentication

### bool adminApi.args.auth.type

*Default value: * `enterprise`

`auth.type` configures the type of authentication in use.
`enterprise` uses Grafana Enterprise token authentication.
`default` uses Cortex authentication.


### string adminApi.args.bootstrap.license.path

*Default value: * `/etc/gem-license/license.jwt`

`bootstrap.license.path` configures where the admin-api expects to find a Grafana Enterprise Metrics License.

### string adminApi.args.cluster-name

`cluster-name` is the cluster name associated with your Grafana Enterprise Metrics license.

## obj adminApi.container

`container` is a convenience field that can be used to modify the admin-api container.

## obj adminApi.deployment

`deployment` is the Kubernetes Deployment for the admin-api.

## obj adminApi.service

`service` is the Kubernetes Service for the admin-api.

## obj compactor

`compactor` has configuration for the compactor.

## obj compactor.args

`args` is a convenience field that can be used to modify the compactor container arguments as key-value pairs.

### bool compactor.args.auth.enabled

*Default value: * `true`

`auth.enabled` enables the tenant authentication

### bool compactor.args.auth.type

*Default value: * `enterprise`

`auth.type` configures the type of authentication in use.
`enterprise` uses Grafana Enterprise token authentication.
`default` uses Cortex authentication.


### string compactor.args.cluster-name

`cluster-name` is the cluster name associated with your Grafana Enterprise Metrics license.

## obj compactor.container

`container` is a convenience field that can be used to modify the compactor container.

## obj compactor.service

`service` is the Kubernetes Service for the compactor.

## obj compactor.statefulSet

`statefulSet` is the Kubernetes StatefulSet for the compactor.

## obj distributor

`distributor` has configuration for the distributor.

## obj distributor.args

`args` is a convenience field that can be used to modify the distributor container arguments as key-value pairs.

### bool distributor.args.auth.enabled

*Default value: * `true`

`auth.enabled` enables the tenant authentication

### bool distributor.args.auth.type

*Default value: * `enterprise`

`auth.type` configures the type of authentication in use.
`enterprise` uses Grafana Enterprise token authentication.
`default` uses Cortex authentication.


### string distributor.args.cluster-name

`cluster-name` is the cluster name associated with your Grafana Enterprise Metrics license.

## obj distributor.container

`container` is a convenience field that can be used to modify the distributor container.

## obj distributor.service

`service` is the Kubernetes Service for the distributor.

## obj distributor.statefulSet

`deployment` is the Kubernetes Deployment for the distributor.

## obj gateway

`gateway` has configuration for the gateway.

## obj gateway.args



### bool gateway.args.auth.enabled

*Default value: * `true`

`auth.enabled` enables the tenant authentication

### bool gateway.args.auth.type

*Default value: * `enterprise`

`auth.type` configures the type of authentication in use.
`enterprise` uses Grafana Enterprise token authentication.
`default` uses Cortex authentication.


### string gateway.args.cluster-name

`cluster-name` is the cluster name associated with your Grafana Enterprise Metrics license.

### string gateway.args.gateway.proxy.admin-api.url

*Default value: * `http://admin-api`

`gateway.proxy.admin-api.url is the upstream URL of the admin-api.

### string gateway.args.gateway.proxy.distributor.url

*Default value: * `dns:///distributor:9095`

`gateway.proxy.distributor.url is the upstream URL of the distributor.

### string gateway.args.gateway.proxy.ingester.url

*Default value: * `http://ingester`

`gateway.proxy.ingester.url is the upstream URL of the ingester.

### string gateway.args.gateway.proxy.query-frontend.url

*Default value: * `http://query-frontend`

`gateway.proxy.query-frontend.url is the upstream URL of the query-frontend.

### string gateway.args.gateway.proxy.store-gateway.url

*Default value: * `http://store-gateway`

`gateway.proxy.store-gateway.url is the upstream URL of the store-gateway.

## obj gateway.container

`container` is a convenience field that can be used to modify the gateway container.

## obj gateway.deployment

`deployment` is the Kubernetes Deployment for the gateway.

## obj gateway.service

`service` is the Kubernetes Service for the gateway.

## obj gossipRing

`gossipRing` is used by microservices to discover other memberlist members.

## obj gossipRing.service

`service` is the Kubernetes Service for the gossip ring.

## obj ingester

`ingester` has configuration for the ingester.

## obj ingester.args

`args` is a convenience field that can be used to modify the ingester container arguments as key-value pairs.

### bool ingester.args.auth.enabled

*Default value: * `true`

`auth.enabled` enables the tenant authentication

### bool ingester.args.auth.type

*Default value: * `enterprise`

`auth.type` configures the type of authentication in use.
`enterprise` uses Grafana Enterprise token authentication.
`default` uses Cortex authentication.


### string ingester.args.cluster-name

`cluster-name` is the cluster name associated with your Grafana Enterprise Metrics license.

## obj ingester.container

`container` is a convenience field that can be used to modify the ingester container.

## obj ingester.podDisruptionBudget

`podDisruptionBudget` is the Kubernetes PodDisruptionBudget for the ingester.

## obj ingester.service

`service` is the Kubernetes Service for the ingester.

## obj ingester.statefulSet

`statefulSet` is the Kubernetes StatefulSet for the ingester.

## obj memcached

`memcached` has configuration for GEM caches

## obj memcached.chunks

`chunks` is a cache for time series chunks

## obj memcached.metadata

`metadata` is cache for object store metadata used by the queriers and store-gateways

## obj memcached.queries

`queries` is a cache for index queries used by the store-gateways

## obj querier

`querier` has configuration for the querier.

## obj querier.args



### bool querier.args.auth.enabled

*Default value: * `true`

`auth.enabled` enables the tenant authentication

### bool querier.args.auth.type

*Default value: * `enterprise`

`auth.type` configures the type of authentication in use.
`enterprise` uses Grafana Enterprise token authentication.
`default` uses Cortex authentication.


### string querier.args.cluster-name

`cluster-name` is the cluster name associated with your Grafana Enterprise Metrics license.

## obj querier.container

`container` is a convenience field that can be used to modify the querier container.

## obj querier.deployment

`deployment` is the Kubernetes Deployment for the querier.

## obj querier.service

`service` is the Kubernetes Service for the querier.

## obj queryFrontend

`queryFrontend` has configuration for the query-frontend.

## obj queryFrontend.args

`args` is a convenience field that can be used to modify the query-frontend container arguments as key-value pairs.

### bool queryFrontend.args.auth.enabled

*Default value: * `true`

`auth.enabled` enables the tenant authentication

### bool queryFrontend.args.auth.type

*Default value: * `enterprise`

`auth.type` configures the type of authentication in use.
`enterprise` uses Grafana Enterprise token authentication.
`default` uses Cortex authentication.


### string queryFrontend.args.cluster-name

`cluster-name` is the cluster name associated with your Grafana Enterprise Metrics license.

## obj queryFrontend.container

`container` is a convenience field that can be used to modify the query-frontend container.

## obj queryFrontend.deployment

`deployment` is the Kubernetes Deployment for the query-frontend.

## obj queryFrontend.service

`service` is the Kubernetes Service for the query-frontend.

## obj storeGateway

`storeGateway` has configuration for the store-gateway.

## obj storeGateway.args

`args` is a convenience field that can be used to modify the store-gateway container arguments as key-value pairs.

### bool storeGateway.args.auth.enabled

*Default value: * `true`

`auth.enabled` enables the tenant authentication

### bool storeGateway.args.auth.type

*Default value: * `enterprise`

`auth.type` configures the type of authentication in use.
`enterprise` uses Grafana Enterprise token authentication.
`default` uses Cortex authentication.


### string storeGateway.args.cluster-name

`cluster-name` is the cluster name associated with your Grafana Enterprise Metrics license.

## obj storeGateway.container

`container` is a convenience field that can be used to modify the store-gateway container.

## obj storeGateway.podDisruptionBudget

`podDisruptionBudget` is the Kubernetes PodDisruptionBudget for the store-gateway.

## obj storeGateway.service

`service` is the Kubernetes Service for the store-gateway.

## obj storeGateway.statefulSet

`statefulSet` is the Kubernetes StatefulSet for the store-gateway.

## obj tokengen

`tokengen` has configuration for tokengen.

## obj tokengen.args

`args` is convenience field for modifying the tokegen container arguments as key-value pairs.

### bool tokengen.args.auth.enabled

*Default value: * `true`

`auth.enabled` enables the tenant authentication

### bool tokengen.args.auth.type

*Default value: * `enterprise`

`auth.type` configures the type of authentication in use.
`enterprise` uses Grafana Enterprise token authentication.
`default` uses Cortex authentication.


### string tokengen.args.cluster-name

`cluster-name` is the cluster name associated with your Grafana Enterprise Metrics license.

## obj tokengen.container

`container` is a convenience field for modifying the tokengen container.
By default, the container runs GEM with the tokengen target and writes the token to a file.


## obj tokengen.createSecretContainer

`createSecretContainer` creates a Kubernetes Secret from a token file.

## obj tokengen.job

`job` is the Kubernetes Job for tokengen

## obj tokengen.role

`role` is the Kubernetes Role for tokengen

## obj tokengen.roleBinding

`roleBinding` is the Kubernetes RoleBinding for tokengen

## obj tokengen.serviceAccount

`serviceAccount` is the Kubernetes ServiceAccount for tokengen