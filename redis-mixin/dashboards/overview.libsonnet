local g = import 'grafonnet-7.0/grafana.libsonnet';
local uid = std.md5('redis_overview.json');

local newStat(datasource, title, expr, h, w, x, y) =
  g.panel.stat.new(
    datasource=datasource,
    title=title,
  )
  {
    fieldConfig: {
      defaults: {
        color: {
          fixedColor: 'text',
          mode: 'fixed',
        },
      },
    },
    options+: {
      graphMode: 'none',
    },
  }
  .setGridPos(h=h, w=w, x=x, y=y)
  .addTarget(
    g.target.prometheus.new(
      expr=expr,
      datasource=datasource,
      instant=true,
    ),
  );

local newGraph(datasource, title, expr, label, unit='short', description='', h, w, x, y) = (
  g.panel.graph.new(
    datasource=datasource,
    description=description,
    title=title,
  )
  {
    fieldConfig: {
      defaults: {
        unit: unit,
      },
    },
  }
  .setGridPos(h=h, w=w, x=x, y=y)
  .addTarget(
    g.target.prometheus.new(
      expr=expr,
      datasource=datasource,
      legendFormat=label,
    ),
  )
  .addYaxis(
    min=0,
  )
  .addYaxis(
    min=0,
  )

);


{
  new(datasource='default', horizon='6h', refresh='30s')::
    g.dashboard.new(
      title='Redis Overview',
      tags=['redis-overview'],
      uid=uid,
    )
    .addTemplate(
      g.template.query.new(
        datasource=datasource,
        name='cluster',
        label='Cluster',
        query='label_values(redis_instance_info, cluster)',
      )
    )
    .addTemplate(
      g.template.query.new(
        datasource=datasource,
        name='namespace',
        label='Namespace',
        query='label_values(redis_instance_info{cluster="$cluster"}, namespace)',
      )
    )
    .addTemplate(
      g.template.query.new(
        datasource=datasource,
        name='pod',
        label='Pod',
        multi=true,
        includeAll=true,
        query='label_values(redis_instance_info{cluster="$cluster",namespace="$namespace"}, pod)',
      )
    )

    .addPanels(
      [
        g.panel.row.new(title='Overview / Topology', collapsed=false),

        newStat(
          datasource=datasource,
          title='Masters',
          expr='sum(redis_instance_info{cluster="$cluster", namespace="$namespace", role="master"})',
          h=3,
          w=8,
          x=0,
          y=0,
        ),

        newStat(
          datasource=datasource,
          title='Slaves',
          expr='sum(redis_instance_info{cluster="$cluster", namespace="$namespace", role="slave"})',
          h=3,
          w=8,
          x=8,
          y=0,
        ),

        newStat(
          datasource=datasource,
          title='Sentinels',
          expr='sum(redis_instance_info{cluster="$cluster", namespace="$namespace", redis_mode="sentinel"})',
          h=3,
          w=8,
          x=16,
          y=0,
        ),

        g.panel.table.new(
          title='Instance Roles',
          datasource=datasource,
        ) {
          transformations: [
            {
              id: 'seriesToColumns',
              options: {
                byField: 'pod',
              },
            },
            {
              id: 'organize',
              options: {
                excludeByName: {
                  'Time 1': true,
                  'Value #A': true,
                  'Time 2': true,
                  'Value #B': true,
                  'Time 3': true,
                  'Value #C': true,
                  'Time 4': true,
                  'Time 5': true,
                  Time: true,
                  'Value #F': true,
                },
                indexByName: {
                  pod: 0,
                  pod_ip: 1,
                  role: 2,
                  master_host: 3,
                  master_address: 4,
                  'Value #D': 5,
                  'Value #E': 6,
                },
                renameByName: {
                  pod: 'Pod',
                  pod_ip: 'Pod IP',
                  role: 'Server Role',
                  master_host: 'Server Master',
                  master_address: 'Sentinel Master',
                  'Value #D': 'Master Link Up',
                  'Value #E': 'Sync in Progress',
                },
              },
            },
          ],
          fieldConfig: {
            defaults: {
              mappings: [
                {
                  options: {
                    '0': {
                      index: 1,
                      text: 'No',
                    },
                    '1': {
                      index: 0,
                      text: 'Yes',
                    },
                  },
                  type: 'value',
                },
              ],
            },
          },
        }
        .setOptions(
          showHeader=true,
        )
        .setGridPos(
          h=6,
          w=24,
          x=0,
          y=4,
        )
        .addTarget(
          g.target.prometheus.new(
            expr='sum(redis_sentinel_master_status{cluster="$cluster", master_name="redis-master.$namespace.svc.cluster.local"}) by (pod,master_address)',
            datasource=datasource,
            instant=true,
            format='table',
          ),
        )
        .addTarget(
          g.target.prometheus.new(
            expr='sum(redis_instance_info{cluster="$cluster", namespace="$namespace", container="redis-server-exporter"}) by (pod,role)',
            datasource=datasource,
            instant=true,
            format='table',
          ),
        )
        .addTarget(
          g.target.prometheus.new(
            expr='sum(kube_pod_info{cluster="$cluster", namespace="$namespace", pod=~"redis-[0-9]+"}) by (pod,pod_ip)',
            datasource=datasource,
            instant=true,
            format='table',
          ),
        )
        .addTarget(
          g.target.prometheus.new(
            expr='sum(redis_master_link_up{cluster="$cluster", namespace="$namespace", pod=~"redis-[0-9]+"}) by (pod)',
            datasource=datasource,
            instant=true,
            format='table',
          ),
        )
        .addTarget(
          g.target.prometheus.new(
            expr='sum(redis_master_sync_in_progress{cluster="$cluster", namespace="$namespace", pod=~"redis-[0-9]+"}) by (pod)',
            datasource=datasource,
            instant=true,
            format='table',
          ),
        )
        .addTarget(
          g.target.prometheus.new(
            expr='sum(redis_slave_info{cluster="$cluster", namespace="$namespace", pod=~"redis-[0-9]+"}) by (pod,master_host)',
            datasource=datasource,
            instant=true,
            format='table',
          ),
        ),

        g.panel.row.new(title='Replication', collapsed=false)
        .setGridPos(
          h=1,
          w=24,
          x=0,
          y=11,
        ),

        newGraph(
          datasource=datasource,
          title='Total Linked Slaves',
          description='Total number of slaves that have fully synced with the master and are receiving updates',
          expr='sum(redis_master_link_up{cluster="$cluster", namespace="$namespace", pod=~"redis-[0-9]+"})',
          label='Linked',
          h=8,
          w=8,
          x=0,
          y=11
        ),

        newGraph(
          datasource=datasource,
          title='Slaves With Sync in Progress',
          description='total number of slaves that are undergoing the initial replication from the master',
          expr='sum(redis_master_sync_in_progress{cluster="$cluster", namespace="$namespace", pod=~"redis-[0-9]+"})',
          label='Syncing',
          h=8,
          w=8,
          x=8,
          y=11
        ),

        newGraph(
          datasource=datasource,
          title='Replication Lag',
          expr=|||
            scalar(max(redis_master_repl_offset{cluster="$cluster", namespace="$namespace"}))
            -
            redis_slave_repl_offset{cluster="$cluster", namespace="$namespace", pod=~"redis-[0-9]+"}
          |||,
          label='{{ pod }}',
          unit='bytes',
          h=8,
          w=8,
          x=16,
          y=11
        ),

        g.panel.row.new(title='Clients', collapsed=false)
        .setGridPos(
          h=1,
          w=24,
          x=0,
          y=19,
        ),

        newGraph(
          datasource=datasource,
          title='Connected Clients',
          expr='redis_connected_clients{cluster="$cluster", namespace="$namespace", pod=~"$pod", container="redis-server-exporter"}',
          label='{{pod}}',
          h=8,
          w=12,
          x=0,
          y=20
        ),

        newGraph(
          datasource=datasource,
          title='Blocked Clients',
          expr='redis_blocked_clients{cluster="$cluster", namespace="$namespace", pod=~"$pod", container="redis-server-exporter"}',
          label='{{pod}}',
          h=8,
          w=12,
          x=12,
          y=20
        ),

        g.panel.row.new(title='Kubernetes / Resources', collapsed=false)
        .setGridPos(
          h=1,
          w=24,
          x=0,
          y=21,
        ),

        newGraph(
          datasource=datasource,
          title='CPU Usage',
          expr='sum(node_namespace_pod_container:container_cpu_usage_seconds_total:sum_irate{namespace="$namespace", pod=~"$pod", cluster="$cluster", container="redis-server"}) by (pod)',
          label='{{pod}}',
          h=8,
          w=12,
          x=0,
          y=22
        )
        .addTarget(
          g.target.prometheus.new(
            expr='avg(kube_pod_container_resource_requests{job="kube-state-metrics/kube-state-metrics", cluster="$cluster", namespace="$namespace", pod=~"$pod", container="redis-server", resource="cpu"})',
            datasource=datasource,
            legendFormat='requests',
          ),
        )
        .addSeriesOverride(
          alias='requests',
          color='#FF9830',
          fill=0,
          linewidth=2,
        )
        .addTarget(
          g.target.prometheus.new(
            expr='avg(kube_pod_container_resource_limits{job="kube-state-metrics/kube-state-metrics", cluster="$cluster", namespace="$namespace", pod=~"$pod", container="redis-server", resource="cpu"})',
            datasource=datasource,
            legendFormat='limits',
          ),
        )
        .addSeriesOverride(
          alias='limits',
          color='#F2495C',
          fill=0,
          linewidth=2,
        ),

        newGraph(
          datasource=datasource,
          title='Memory Usage',
          expr='sum(container_memory_working_set_bytes{job="kube-system/cadvisor", cluster="$cluster", namespace="$namespace", pod=~"$pod", container="redis-server", image!=""}) by (pod)',
          label='{{pod}}',
          unit='bytes',
          h=8,
          w=12,
          x=12,
          y=22
        )
        .addTarget(
          g.target.prometheus.new(
            expr='avg(kube_pod_container_resource_requests{job="kube-state-metrics/kube-state-metrics", cluster="$cluster", namespace="$namespace", pod=~"$pod", container="redis-server", resource="memory"})',
            datasource=datasource,
            legendFormat='requests',
          ),
        )
        .addSeriesOverride(
          alias='requests',
          color='#FF9830',
          fill=0,
          linewidth=2,
        )
        .addTarget(
          g.target.prometheus.new(
            expr='avg(kube_pod_container_resource_limits{job="kube-state-metrics/kube-state-metrics", cluster="$cluster", namespace="$namespace", pod=~"$pod", container="redis-server", resource="memory"})',
            datasource=datasource,
            legendFormat='limits',
          ),
        )
        .addSeriesOverride(
          alias='limits',
          color='#F2495C',
          fill=0,
          linewidth=2,
        ),

        newGraph(
          datasource=datasource,
          title='CPU Throttling',
          expr='sum(increase(container_cpu_cfs_throttled_periods_total{job="kube-system/cadvisor", namespace="$namespace", pod=~"$pod", container="redis-server", cluster="$cluster"}[$__rate_interval])) by (container) /sum(increase(container_cpu_cfs_periods_total{job="kube-system/cadvisor", namespace="$namespace", pod=~"$pod", container!="", cluster="$cluster"}[$__rate_interval])) by (pod)',
          label='{{pod}}',
          unit='percent',
          h=8,
          w=12,
          x=0,
          y=30
        ),


        newGraph(
          datasource=datasource,
          title='Network I/O',
          expr='avg(irate(redis_net_input_bytes_total{cluster="$cluster", namespace="$namespace", pod=~"$pod", container="redis-server-exporter"}[$__rate_interval])) by (cmd,pod)',
          label='{{pod}} in',
          unit='binBps',
          h=8,
          w=12,
          x=12,
          y=30
        )
        .addTarget(
          g.target.prometheus.new(
            expr='avg(irate(redis_net_output_bytes_total{cluster="$cluster", namespace="$namespace", pod=~"$pod", container="redis-server-exporter"}[$__rate_interval])) by (cmd,pod)',
            datasource=datasource,
            legendFormat='{{pod}} out',
          ),
        ),

        g.panel.row.new(title='Usage', collapsed=true)
        .setGridPos(
          h=1,
          w=24,
          x=0,
          y=31,
        )
        .addPanel(
          newGraph(
            datasource=datasource,
            title='Ops / Sec',
            expr='sum by (pod) (rate(redis_commands_total{cluster="$cluster", namespace="$namespace", pod=~"$pod", container="redis-server-exporter"}[$__rate_interval]))',
            label='{{pod}}',
            unit='ops/s',
            h=8,
            w=8,
            x=0,
            y=32
          )
        )
        .addPanel(
          newGraph(
            datasource=datasource,
            title='Commands / Sec',
            expr='sum by (cmd) (rate(redis_commands_total{cluster="$cluster", namespace="$namespace", pod=~"$pod", container="redis-server-exporter"}[$__rate_interval]))',
            label='{{pod}}',
            unit='ops/s',
            h=8,
            w=8,
            x=8,
            y=32
          )
        )
        .addPanel(
          newGraph(
            datasource=datasource,
            title='Total Keys',
            expr='sum(redis_db_keys{cluster="$cluster", namespace="$namespace", pod=~"$pod", container="redis-server-exporter"}) by (pod)',
            label='{{pod}}',
            h=8,
            w=8,
            x=16,
            y=32
          )
        ),

        g.panel.row.new(title='Persistence', collapsed=true)
        .setGridPos(
          h=1,
          w=24,
          x=0,
          y=33,
        )
        .addPanel(
          newGraph(
            datasource=datasource,
            title='AOF Size',
            expr='sum(redis_aof_current_size_bytes{cluster="$cluster", namespace="$namespace", pod=~"$pod", container="redis-server-exporter"}) by (pod)',
            label='{{pod}}',
            unit='bytes',
            h=8,
            w=8,
            x=0,
            y=34
          ),
        )
        .addPanel(
          newGraph(
            datasource=datasource,
            title='Time Since Last Snapshot',
            expr='sum(time() - redis_rdb_last_save_timestamp_seconds{cluster="$cluster", namespace="$namespace", pod=~"$pod", container="redis-server-exporter"}) by (pod)',
            label='{{pod}}',
            unit='seconds',
            h=8,
            w=8,
            x=8,
            y=34
          ),
        )
        .addPanel(
          newGraph(
            datasource=datasource,
            title='Persistent Volume Usage',
            expr=|||
              max by (persistentvolumeclaim) (
              (
                topk by (persistentvolumeclaim) (1, kubelet_volume_stats_capacity_bytes{cluster="$cluster", job="kube-system/kubelet", namespace="$namespace", persistentvolumeclaim=~"redis-server-data-$pod"})
                -
                topk by (persistentvolumeclaim) (1, kubelet_volume_stats_available_bytes{cluster="$cluster", job="kube-system/kubelet", namespace="$namespace", persistentvolumeclaim=~"redis-server-data-$pod"})
              )
              /
              topk by (persistentvolumeclaim) (1, kubelet_volume_stats_capacity_bytes{cluster="$cluster", job="kube-system/kubelet", namespace="$namespace", persistentvolumeclaim=~"redis-server-data-$pod"})
              * 100)
            |||,
            label='{{pod}}',
            unit='percent',
            h=8,
            w=8,
            x=16,
            y=34
          )
        ),
      ]
    ),
}
