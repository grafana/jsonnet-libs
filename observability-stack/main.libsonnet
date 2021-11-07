local grafana_mixin = import 'github.com/grafana/grafana/grafana-mixin/mixin.libsonnet';
local alertmanager = import 'github.com/grafana/jsonnet-libs/alertmanager/alertmanager.libsonnet';
local grafana = import 'github.com/grafana/jsonnet-libs/grafana/grafana.libsonnet';
local kube_state_metrics = import 'github.com/grafana/jsonnet-libs/kube-state-metrics/main.libsonnet';
local directory = import 'github.com/grafana/jsonnet-libs/nginx-directory/directory.libsonnet';
local node_exporter = import 'github.com/grafana/jsonnet-libs/node-exporter/main.libsonnet';
local pushgateway = import 'github.com/grafana/jsonnet-libs/prom-pushgateway/main.libsonnet';
local pushgateway_scrape_config = import 'github.com/grafana/jsonnet-libs/prom-pushgateway/scrape_config.libsonnet';
local prometheus = import 'github.com/grafana/jsonnet-libs/prometheus/prometheus.libsonnet';
local prom_scrape_configs = import 'github.com/grafana/jsonnet-libs/prometheus/scrape_configs.libsonnet';
local kubernetes_mixin = import 'github.com/kubernetes-monitoring/kubernetes-mixin/mixin.libsonnet';
local alertmanager_mixin = import 'github.com/prometheus/alertmanager/doc/alertmanager-mixin/mixin.libsonnet';
local node_exporter_mixin = import 'github.com/prometheus/node_exporter/docs/node-mixin/mixin.libsonnet';
local prometheus_mixin = import 'github.com/prometheus/prometheus/documentation/prometheus-mixin/mixin.libsonnet';
local rfrail_node_exporter_full_dashboard = import 'github.com/rfrail3/grafana-dashboards/prometheus/node-exporter-full.json';

{
  new(
    namespace,
    cluster_name='cluster',
    cluster_dns_tld='local',
  ):: {
    namespace:: namespace,
    cluster_name:: cluster_name,
    cluster_dns_tld:: cluster_dns_tld,

    admin_services:: [],
    alertmanagers:: {},
    mixins:: {},
    prometheus:: {},  // Hide initially, configured by `withPrometheus`
  },

  withGrafana(
    uidForDashboard=function(filename, dashboard) std.md5(filename),
  ):: {
    local this = self,

    grafana:
      grafana
      + grafana.withAnonymous()
      + grafana.addMixinDashboards(self.mixins, mixinProto)
      + {
        _config+: {
          grafana_ini+: {
            date_formats+: {
              default_timezone: 'UTC',
            },
          },
        },

        grafanaPlugins+:: std.foldr(
          function(mixinName, acc)
            local mixin = this.mixins[mixinName];
            if std.objectHas(mixin, 'grafanaPlugins')
            then mixin.grafanaPlugins + acc
            else acc,
          std.objectFields(this.mixins),
          [],
        ),
      },

    // `mixinProto` ensures the `grafanaDashboards` key exists on each mixin.
    // It also configures two fields:
    // - uid: consistent Dashboard UIDs (overrideable with `uidForDashboard`).
    // - timezone: cleared to match the default configuration.
    local mixinProto = {
      grafanaDashboards+:: {},
    } + {
      local grafanaDashboards = super.grafanaDashboards,

      grafanaDashboards+:: {
        [filename]:
          local dashboard = grafanaDashboards[filename];
          dashboard {
            uid: uidForDashboard(filename, dashboard),
            timezone: '',
          }
        for filename in std.objectFields(grafanaDashboards)
      },
    },

    local admin_service(theme) = {
      title: 'Grafana (%s)' % theme,
      path: 'grafana',
      params: '/?search=open&theme=' + theme,
      url: 'http://%s' %
           std.join('.', [
             this.grafana.grafana_service.metadata.name,
             this.namespace,
             this.cluster_name,
             this.cluster_dns_tld,
           ]),
      allowWebsockets: true,
    },

    admin_services+: [
      admin_service('light'),
      admin_service('dark'),
    ],

    mixins+:: {
      grafana: grafana_mixin,
    },
  },

  withPrometheus():: {
    local this = self,

    prometheus+:::
      prometheus
      + prometheus.withHighAvailability()
      + prometheus.withAlertmanagers(
        self.alertmanagers,
        self.cluster_name,
      )
      + prometheus.withMixinsConfigmaps(self.mixins)
      + {
        _config+: {
          namespace: this.namespace,
          cluster_name: this.cluster_name,
          cluster_dns_tld: this.cluster_dns_tld,
        },
      },

    admin_services+: [{
      title: 'Prometheus',
      path: 'prometheus',
      url: 'http://%s/%s' % [
        std.join('.', [
          this.prometheus.prometheus_service.metadata.name,
          this.namespace,
          this.cluster_name,
          this.cluster_dns_tld,
        ]),
        this.prometheus._config.prometheus_path,
      ],
    }],

    mixins+::
      prometheus.mixins
      {
        prometheus:
          prometheus_mixin {
            grafanaDashboardFolder: 'Prometheus',

            _config+:: {
              prometheusSelector: 'job="%s/prometheus"' % this.namespace,
              prometheusHAGroupLabels: 'job,cluster,namespace',
              prometheusHAGroupName: '{{$labels.job}} in {{$labels.cluster}}',
            },
          },
      },

    grafana+:
      grafana.addDatasource(
        'prometheus',
        grafana.datasource.new(
          name='prometheus',
          type='prometheus',
          url='http://' + self.prometheus.prometheus_service.metadata.name,
          default=true,
        )
      ),
  },

  withLocalAlertmanager(
    replicas=2,
    global=false,
    path='/alertmanager/',
    port=9093,
    gossip_port=9094,
  ):: {
    local this = self,

    alertmanager:
      alertmanager
      + alertmanager.isGossiping(
        alertmanager.buildPeers(this.alertmanagers),
        gossip_port,
      )
      + {
        _config+: {
          namespace: this.namespace,
          cluster_name:: this.cluster_name,
          cluster_dns_tld: this.cluster_dns_tld,

          alertmanager_path: path,
          alertmanager_port: port,
          alertmanager_replicas: replicas,
        },
      },

    admin_services+: [{
      title: 'Alertmanager',
      path: 'alertmanager',
      url: 'http://%s/%s' % [
        std.join('.', [
          this.alertmanager.alertmanager_service.metadata.name,
          this.namespace,
          this.cluster_name,
          this.cluster_dns_tld,
        ]),
        this.alertmanager._config.alertmanager_path,
      ],
    }],

    mixins+: {
      alertmanager:
        alertmanager_mixin {
          grafanaDashboardFolder: 'Alertmanager',

          _config+:: {
            alertmanagerSelector: 'job="%s/alertmanager"' % this.namespace,
            alertmanagerClusterLabels: 'job, namespace',
            alertmanagerName: '{{$labels.instance}} in {{$labels.cluster}}',
          },
        },
    },

    alertmanagers+:: {
      local_alertmanager: {
        namespace: this.namespace,
        cluster_name: this.cluster_name,
        cluster_dns_tld: this.cluster_dns_tld,
        replicas: replicas,

        global: global,
        path: path,

        port: port,
        gossip_port: gossip_port,
      },
    },
  },

  addExternalAlertmanager(
    name,
    namespace,
    cluster_name,
    cluster_dns_tld,
    replicas,

    global=true,
    path='/alertmanager/',

    port=9093,
    gossip_port=9094,
  ):: {
    local this = self,

    alertmanagers+:: {
      [name]: {
        namespace: namespace,
        cluster_name: cluster_name,
        cluster_dns_tld: cluster_dns_tld,
        replicas: replicas,

        global: global,
        path: path,

        port: port,
        gossip_port: gossip_port,
      },
    },
  },

  withKubernetesScrapeConfigs(
    api_server='kubernetes.default.svc.cluster.local',
    api_scrape_role='service'
  ):: {
    prometheus+:
      prometheus.addScrapeConfig(
        prom_scrape_configs.kubernetes_pods
      )
      + prometheus.addScrapeConfig(
        prom_scrape_configs.kube_dns
      )
      + prometheus.addScrapeConfig(
        prom_scrape_configs.kubelet(api_server)
      )
      + prometheus.addScrapeConfig(
        prom_scrape_configs.cadvisor(api_server)
      )
      + prometheus.addScrapeConfig(
        prom_scrape_configs.kubernetes_api(api_scrape_role)
      ),

  },

  withKubernetesMixin(
    node_exporter_namespace='',
    kube_state_metrics_namespace='',
  ):: {
    local node_namespace =
      if node_exporter_namespace != ''
      then node_exporter_namespace
      else self.namespace,

    local ksm_namespace =
      if kube_state_metrics_namespace != ''
      then kube_state_metrics_namespace
      else self.namespace,

    mixins+: {
      kubernetes:
        kubernetes_mixin {
          grafanaDashboardFolder: 'Kubernetes',

          _config+:: {
            cadvisorSelector: 'job="kube-system/cadvisor"',

            kubeApiserverSelector: 'job="kube-system/kube-apiserver"',
            kubeControllerManagerSelector: 'job="kube-system/kube-controller-manager"',
            kubeSchedulerSelector: 'job="kube-system/kube-scheduler"',
            kubeletSelector: 'job="kube-system/kubelet"',

            notKubeDnsCoreDnsSelector: 'job!~"kube-system/kube-dns|coredns"',
            notKubeDnsSelector: 'job!="kube-system/kube-dns"',

            podLabel: 'instance',

            nodeExporterSelector: 'job="%s/node-exporter"' % node_namespace,
            kubeStateMetricsSelector: 'job="%s/kube-state-metrics"' % ksm_namespace,
          },
        },
    },
  },

  withNodeExporter():: {
    local this = self,

    node_exporter:
      node_exporter.new(),

    prometheus+:
      prometheus.addScrapeConfig(
        node_exporter.scrape_config(this.namespace)
      ),

    mixins+: {
      node_exporter:
        node_exporter_mixin {
          grafanaDashboardFolder: 'node_exporter',

          _config+:: {
            nodeExporterSelector: 'job="%s/node-exporter"' % this.namespace,

            // Do not page if nodes run out of disk space.
            nodeCriticalSeverity: 'warning',
            grafanaPrefix: '/grafana',
          },

          grafanaDashboards+:: {
            'node-exporter-full.json': rfrail_node_exporter_full_dashboard,
          },
        },
    },
  },

  withKubeStateMetrics():: {
    kube_state_metrics:
      kube_state_metrics.new(self.namespace),

    prometheus+:
      prometheus.addScrapeConfig(
        kube_state_metrics.scrape_config(self.namespace)
      ),
  },

  withPushGateway():: {
    local this = self,
    pushgateway:
      pushgateway.new(self.namespace),

    prometheus+:
      prometheus.addScrapeConfig(
        pushgateway_scrape_config(self.namespace)
      ),

    admin_services+: [{
      title: 'Pushgateway',
      path: 'pushgateway',
      url:
        this.pushgateway.external_hostname
        + this.pushgateway.path,
    }],
  },

  withDirectory():: {
    local this = self,
    directory:
      directory {
        _config+: {
          cluster_dns_suffix: this.cluster_name + '.' + this.cluster_dns_tld,
          title: 'Observability Stack',
          admin_services: this.admin_services,
        },
      },
  },

  final:
    self.new(namespace='default')
    + self.withGrafana()
    + self.withPrometheus()
    + self.withPushGateway()
    + self.withDirectory()
    + self.withKubernetesScrapeConfigs()
    + self.withKubernetesMixin()
    + self.withNodeExporter()
    + self.withKubeStateMetrics()
    + self.withLocalAlertmanager(
      global=true,
    )
    + self.addExternalAlertmanager(
      name='remote_am',
      namespace='default',
      cluster_name='us-central-1',
      cluster_dns_tld='local',
      replicas=2,
    ),
}
