local utils = import './utils.libsonnet';
local g = import 'grafana-builder/grafana.libsonnet';
local grafana = import 'grafonnet/grafana.libsonnet';

local host_matcher = 'job=~"$job", instance=~"$instance", cluster=~"$cluster", namespace=~"$namespace", container=~"$container"';

// Templates
local ds_template = {
  current: {
    text: 'default',
    value: 'default',
  },
  hide: 0,
  label: 'Data Source',
  name: 'datasource',
  options: [],
  query: 'prometheus',
  refresh: 1,
  regex: '',
  type: 'datasource',
};

local job_template = grafana.template.new(
  'job',
  '$datasource',
  'label_values(agent_build_info, job)',
  label='Job',
  refresh='load',
  multi=true,
  includeAll=true,
  allValues='.+',
  sort=1,
);

local instance_template = grafana.template.new(
  'instance',
  '$datasource',
  'label_values(agent_build_info{job=~"$job"}, instance)',
  label='Instance',
  refresh='load',
  multi=true,
  includeAll=true,
  allValues='.+',
  sort=1,
);

local cluster_template = grafana.template.new(
  'cluster',
  '$datasource',
  'label_values(agent_build_info{job=~"$job"}, cluster)',
  label='Cluster',
  refresh='load',
  multi=true,
  includeAll=true,
  allValues='.+',
  sort=1,
);

local namespace_template = grafana.template.new(
  'namespace',
  '$datasource',
  'label_values(agent_build_info{job=~"$job"}, namespace)',
  label='Namespace',
  refresh='load',
  multi=true,
  includeAll=true,
  allValues='.+',
  sort=1,
);

local container_template = grafana.template.new(
  'container',
  '$datasource',
  'label_values(agent_build_info{job=~"$job"}, container)',
  label='Container',
  refresh='load',
  multi=true,
  includeAll=true,
  allValues='.+',
  sort=1,
);

local pod_template = grafana.template.new(
  'pod',
  '$datasource',
  'label_values(agent_build_info{job=~"$job"}, pod)',
  label='Pod',
  refresh='load',
  multi=true,
  includeAll=true,
  allValues='.+',
  sort=1,
);

{
  grafanaDashboards+:: {
    'agent-operational.json':
      grafana.dashboard.new('Agent Operational', tags=$._config.dashboardTags, editable=false, time_from='%s' % $._config.dashboardPeriod, uid='integration-agent-opr')
      .addTemplates([
        ds_template,
        job_template,
        instance_template,
        cluster_template,
        namespace_template,
        container_template,
        pod_template,
      ])
      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Agent Dashboards',
        includeVars=true,
        keepTime=true,
        tags=($._config.dashboardTags),
      ))
      .addRow(
        g.row('General')
        .addPanel(
          g.panel('GCs') +
          g.queryPanel(
            'rate(go_gc_duration_seconds_count{' + host_matcher + ', pod=~"$pod"}[5m])',
            '{{pod}}',
          )
        )
        .addPanel(
          g.panel('Go Heap') +
          { yaxes: g.yaxes('decbytes') } +
          g.queryPanel(
            'go_memstats_heap_inuse_bytes{' + host_matcher + ', pod=~"$pod"}',
            '{{pod}}',
          )
        )
        .addPanel(
          g.panel('Goroutines') +
          g.queryPanel(
            'go_goroutines{' + host_matcher + ', pod=~"$pod"}',
            '{{pod}}',
          )
        )
        .addPanel(
          g.panel('CPU') +
          g.queryPanel(
            'rate(container_cpu_usage_seconds_total{' + host_matcher + ', pod=~"$pod"}[5m])',
            '{{pod}}',
          )
        )
        .addPanel(
          g.panel('WSS') +
          g.queryPanel(
            'container_memory_working_set_bytes{' + host_matcher + ', pod=~"$pod"}',
            '{{pod}}',
          )
        )
        .addPanel(
          g.panel('Bad Words') +
          g.queryPanel(
            'rate(promtail_custom_bad_words_total{cluster=~"$cluster", exported_namespace=~"$namespace", exported_job=~"$job"}[5m])',
            '{{job}}',
          )
        )
      )
      .addRow(
        g.row('Network')
        .addPanel(
          g.panel('RX by Pod') +
          g.queryPanel(
            'sum by (pod) (rate(container_network_receive_bytes_total{cluster=~"$cluster", namespace=~"$namespace", pod=~"$pod"}[5m]))',
            '{{pod}}',
          )
        )
        .addPanel(
          g.panel('TX by Pod') +
          g.queryPanel(
            'sum by (pod) (rate(container_network_transmit_bytes_total{cluster=~"$cluster", namespace=~"$namespace", pod=~"$pod"}[5m]))',
            '{{pod}}',
          )
        )
      )
      .addRow(
        g.row('Prometheus Read')
        .addPanel(
          g.panel('Bytes/Series/Pod') +
          { yaxes: g.yaxes('decbytes') } +
          g.queryPanel(
            '
              (sum by (pod) (avg_over_time(go_memstats_heap_inuse_bytes{' + host_matcher + ', pod=~"$pod"}[1m])))
              /
              (sum by (pod) (agent_wal_storage_active_series{' + host_matcher + ', pod=~"$pod"}))
            ',
            '{{pod}}',
          )
        )
        .addPanel(
          g.panel('Bytes/Series') +
          { yaxes: g.yaxes('decbytes') } +
          g.queryPanel(
            '
              (sum by (container) (avg_over_time(go_memstats_heap_inuse_bytes{' + host_matcher + ', pod=~"$pod"}[1m])))
              /
              (sum by (container) (agent_wal_storage_active_series{' + host_matcher + ', pod=~"$pod"}))
            ',
            '{{container}}',
          )
        )
        .addPanel(
          g.panel('Series/Pod') +
          g.queryPanel(
            'sum by (pod) (agent_wal_storage_active_series{' + host_matcher + ', pod=~"$pod"})',
            '{{pod}}',
          )
        )
        .addPanel(
          g.panel('Series/Config') +
          g.queryPanel(
            'sum by (instance_group_name) (agent_wal_storage_active_series{' + host_matcher + ', pod=~"$pod"})',
            '{{instance_group_name}}',
          )
        )
        .addPanel(
          g.panel('Series') +
          g.queryPanel(
            'sum by (container) (agent_wal_storage_active_series{' + host_matcher + ', pod=~"$pod"})',
            '{{container}}',
          )
        )
      ),
  },
}
