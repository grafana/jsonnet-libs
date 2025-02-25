local kausal = import 'ksonnet-util/kausal.libsonnet';

(import 'config.libsonnet') +
{
  local this = self,
  local k = kausal { _config+:: this._config },

  local configMap = k.core.v1.configMap,
  config_map:
    configMap.new('vault-config')
    + configMap.withData({
      'config.json': std.toString(this._config.vault.config),
    })
  ,

  local secret = k.core.v1.secret,

  // TODO: Remove once we are ready to migrate storage backend in ops-eu-south-0
  // Add GCS storage settings from a secret
  withStorageGCSFromSecret(secret_name, secret_key, bucket):: {
    _config+:: { vault+: { config+: {
      // See https://www.vaultproject.io/docs/configuration/storage/
      // for other storage backends
      storage+: {
        gcs+: {
          bucket: bucket,
          credentials_file: '/var/run/secrets/gcs-auth/%s' % secret_key,
          ha_enabled: 'true',
        },
      },
    } } },
    statefulset+: k.util.secretVolumeMount(secret_name, '/var/run/secrets/gcs-auth'),
  },

  withStorageDynamoDB(region, table):: {
    _config+:: { vault+: { config+: {
      storage+: {
        dynamodb+: {
          region: region,
          table: table,
          ha_enabled: 'true',
        },
      },
    } } },
  },

  // TODO: Replace with withStorageDynamoDB once we are ready to migrate ops-eu-south-0
  // Create the secret from a service account key and add the settings
  withStorageGCS(bucket, key):: {
    gcs_auth_secret:
      secret.new('gcs-auth', { key: key }),

  } + self.withStorageGCSFromSecret('gcs-auth', 'key', bucket),

  // Add GCP KMS settings from a secret
  withGoogleCloudKMSFromSecret(secret_name, secret_key, project, location, key_ring, crypto_key):: {
    _config+:: { vault+: { config+: {
      seal+: {
        gcpckms: {
          project: project,
          region: location,
          key_ring: key_ring,
          crypto_key: crypto_key,
        },
      },
    } } },
    statefulset+:
      k.util.secretVolumeMount(secret_name, '/var/run/secrets/kms-auth'),
    container+::
      container.withEnvMixin([
        envVar.new('GOOGLE_APPLICATION_CREDENTIALS', '/var/run/secrets/kms-auth/%s' % secret_key),
      ]),
  },

  // Create the secret from a service account key and add the settings
  withGoogleCloudKMS(key, project, location, key_ring, crypto_key):: {
    kms_auth_secret:
      secret.new('kms-auth', { key: key }),
  } + self.withGoogleCloudKMSFromSecret('kms-auth', 'key', project, location, key_ring, crypto_key),

  withSecretTLS(cert, key):: {
    _config+:: { vault+: { config+: {
      default_listener+: {
        tcp+: {
          tls_disable: false,
          tls_prefer_server_cipher_suites: true,
          tls_cipher_suites: 'TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA,TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA,TLS_RSA_WITH_AES_128_GCM_SHA256,TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_128_CBC_SHA,TLS_RSA_WITH_AES_256_CBC_SHA',
          tls_cert_file: '/vault/tls/server.crt',
          tls_key_file: '/vault/tls/server.key',
        },
      },
    } } },
    ssl_cert:
      secret.new(
        'ssl-cert',
        {
          'server.crt': std.base64(cert),
          'server.key': std.base64(key),
        },
      ),
    statefulset+:
      k.util.secretVolumeMount(self.ssl_cert.metadata.name, '/vault/tls'),
  },

  withExistingTLSSecret(name):: {
    _config+:: { vault+: { config+: {
      default_listener+: {
        tcp+: {
          tls_disable: false,
          tls_prefer_server_cipher_suites: true,
          tls_cipher_suites: 'TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA,TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA,TLS_RSA_WITH_AES_128_GCM_SHA256,TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_128_CBC_SHA,TLS_RSA_WITH_AES_256_CBC_SHA',
          tls_cert_file: '/vault/tls/server.crt',
          tls_key_file: '/vault/tls/server.key',
        },
      },
    } } },
    statefulset+:
      k.util.secretVolumeMount(name, '/vault/tls'),
  },

  withPrometheusMetrics(port, telemetry={ prometheus_retention_time: '1m' }):: {
    local this = self,
    _config+:: { vault+: { config+: {
      prometheus_listener+:: {
        tcp: {
          address: '[::]:%s' % port,
          disable_clustering: true,
          tls_disable: true,
          telemetry: {
            unauthenticated_metrics_access: true,
          },
        },
      },
      listener+: [this._config.vault.config.prometheus_listener],
      telemetry+: telemetry,
    } } },
    container+:
      container.withPortsMixin([
        containerPort.new('http-metrics', port),
      ]),
    statefulset+:
      statefulset.spec.template.metadata.withAnnotationsMixin({
        'prometheus.io.path': '/v1/sys/metrics',
        'prometheus.io.param-format': 'prometheus',
      }),
  },

  // This enables vault pods to be labeled as 'vault-active' (Vault K8s service registration),
  // indicating whether the pod is active or in standby mode
  // See https://developer.hashicorp.com/vault/docs/v1.10.x/configuration/service-registration/kubernetes#configuration
  withServiceRegistration(namespace, serviceAccount):: {
    local role = k.rbac.v1.role,
    local policyRule = k.rbac.v1.policyRule,
    local roleBinding = k.rbac.v1.roleBinding,
    local subject = k.rbac.v1.subject,
    _config+:: { vault+: { config+: {
      service_registration+: {
        kubernetes: {},
      },
    } } },
    role: role.new()
          + role.metadata.withName('vault-role')
          + role.metadata.withNamespace(namespace)
          + role.withRules([
            policyRule.new()
            + policyRule.withApiGroups([''])
            + policyRule.withResources(['pods'])
            + policyRule.withVerbs(['get', 'update', 'patch']),
          ]),
    roleBinding: roleBinding.new()
                 + roleBinding.metadata.withName('vault-role-binding')
                 + roleBinding.metadata.withNamespace(namespace)
                 + roleBinding.roleRef.withApiGroup('rbac.authorization.k8s.io')
                 + roleBinding.roleRef.withKind('Role')
                 + roleBinding.roleRef.withName('vault-role')
                 + roleBinding.withSubjects([
                   subject.withKind('ServiceAccount')
                   + subject.withName(serviceAccount)
                   + subject.withNamespace(namespace),
                 ]),
  },

  local container = k.core.v1.container,
  local containerPort = k.core.v1.containerPort,
  local envVar = k.core.v1.envVar,
  container::
    container.new('vault', this._images.vault)
    + container.withPorts([
      containerPort.new('container', this._config.vault.port),
      containerPort.new('cluster', this._config.vault.clusterPort),
    ])
    + container.withCommand([
      'vault',
      'server',
      '-config',
      '/vault/config/config.json',
    ])
    + container.withEnv([
      envVar.fromFieldPath('POD_IP', 'status.podIP'),
      envVar.fromFieldPath('POD_NAME', 'metadata.name'),
      // These environment variables are needed to support Vault K8s service registration
      // See https://developer.hashicorp.com/vault/docs/v1.10.x/configuration/service-registration/kubernetes#configuration
      envVar.fromFieldPath('VAULT_K8S_POD_NAME', 'metadata.name'),
      envVar.fromFieldPath('VAULT_K8S_NAMESPACE', 'metadata.namespace'),
      envVar.new(
        'VAULT_CLUSTER_ADDR',
        'https://$(POD_NAME).vault.vault.svc.cluster.local.:%s' % this._config.vault.clusterPort
      ),
      envVar.new(
        'VAULT_API_ADDR',
        'https://$(POD_NAME).vault.vault.svc.cluster.local.:%s' % this._config.vault.port
      ),
      envVar.new('VAULT_LOG_LEVEL', k._config.vault.logLevel),
    ])
  ,

  local statefulset = k.apps.v1.statefulSet,
  local volume = k.core.v1.volume,
  statefulset:
    statefulset.new(
      'vault',
      this._config.vault.replicas,
      this.container,
      volumeClaims=[],
    )
    + statefulset.spec.withServiceName('vault')
    + statefulset.spec.template.spec.withSubdomain('vault')
    + k.util.configMapVolumeMount(this.config_map, '/vault/config')
    + k.util.emptyVolumeMount('vault-root', '/root')
  ,

  local service = k.core.v1.service,
  service:
    k.util.serviceFor(this.statefulset)
    + service.spec.withClusterIp('None')
    + service.spec.withSessionAffinity('None'),

  withIngress(host, tlsSecretName, whitelistIps=[]):: {
    local this = self,
    local ingress = k.networking.v1.ingress,
    local rule = k.networking.v1.ingressRule,
    local path = k.networking.v1.httpIngressPath,
    ingress:
      ingress.new('vault')
      + ingress.metadata.withAnnotationsMixin({
        'nginx.ingress.kubernetes.io/backend-protocol': 'HTTPS',
      } + (
        if std.length(whitelistIps) != 0
        then { 'nginx.ingress.kubernetes.io/whitelist-source-range': std.join(',', whitelistIps) }
        else {}
      ))
      + ingress.spec.withTls({
        hosts: [host],
        secretName: tlsSecretName,
      })
      + ingress.spec.withRules(
        rule.withHost(host)
        + rule.http.withPaths([
          path.withPath('/')
          + path.withPathType('Prefix')
          + path.backend.service.withName(this.service.metadata.name)
          + path.backend.service.port.withNumber(this._config.vault.port),
        ])
      ),
  },
}
