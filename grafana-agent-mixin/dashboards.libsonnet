local g = import 'grafana-builder/grafana.libsonnet';
local grafana = import 'grafonnet/grafana.libsonnet';

local dashboard = grafana.dashboard;
local row = grafana.row;
local singlestat = grafana.singlestat;
local prometheus = grafana.prometheus;
local graphPanel = grafana.graphPanel;
local tablePanel = grafana.tablePanel;
local template = grafana.template;
local timeSeries = grafana.timeSeries;

local job_instance_matcher = 'job=~"$job", instance=~"$instance"';
local host_matcher = job_instance_matcher + ', cluster=~"$cluster", namespace=~"$namespace", container=~"$container"';

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
  label='job',
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
  label='instance',
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
  label='cluster',
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
  label='namespace',
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
  label='container',
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
  label='pod',
  refresh='load',
  multi=true,
  includeAll=true,
  allValues='.+',
  sort=1,
);

{
  grafanaDashboards+:: {
    'agent.json':
      grafana.dashboard.new('Agent', tags=$._config.dashboardTags, editable=false, time_from='%s' % $._config.dashboardPeriod, uid='integration-agent')
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
        g.row('Agent Stats')
        .addPanel(
          g.panel('Agent Stats') +
          g.tablePanel([
            'count by (pod, container, version) (agent_build_info{' + host_matcher + '})',
            'max by (pod, container) (time() - process_start_time_seconds{' + host_matcher + '})',
          ], {
            pod: { alias: 'Pod' },
            container: { alias: 'Container' },
            version: { alias: 'Version' },
            'Value #A': { alias: 'Count', type: 'hidden' },
            'Value #B': { alias: 'Uptime' },
            datasource:'$datasource',
          })
        )
      )
      .addRow(
        g.row('Prometheus Discovery')
        .addPanel(
          g.panel('Target Sync') +
          g.queryPanel('sum(rate(prometheus_target_sync_length_seconds_sum{' + host_matcher + '}[$__rate_interval])) by (pod, scrape_job) * 1e3', '{{pod}}/{{scrape_job}}') +
          { yaxes: g.yaxes('ms') }
        )
        .addPanel(
          g.panel('Targets') +
          g.queryPanel('sum by (pod) (prometheus_sd_discovered_targets{' + host_matcher + '})', '{{pod}}') +
          g.stack
        )
      )
      .addRow(
        g.row('Prometheus Retrieval')
        .addPanel(
          g.panel('Average Scrape Interval Duration') +
          g.queryPanel('
            rate(prometheus_target_interval_length_seconds_sum{' + host_matcher + '}[$__rate_interval])
            /
            rate(prometheus_target_interval_length_seconds_count{' + host_matcher + '}[$__rate_interval])
            * 1e3
          ', '{{pod}} {{interval}} configured') +
          { yaxes: g.yaxes('ms') }
        )
        .addPanel(
          g.panel('Scrape failures') +
          g.queryPanel([
            'sum by (job) (rate(prometheus_target_scrapes_exceeded_sample_limit_total{' + host_matcher + '}[$__rate_interval]))',
            'sum by (job) (rate(prometheus_target_scrapes_sample_duplicate_timestamp_total{' + host_matcher + '}[$__rate_interval]))',
            'sum by (job) (rate(prometheus_target_scrapes_sample_out_of_bounds_total{' + host_matcher + '}[$__rate_interval]))',
            'sum by (job) (rate(prometheus_target_scrapes_sample_out_of_order_total{' + host_matcher + '}[$__rate_interval]))',
          ], [
            'exceeded sample limit: {{job}}',
            'duplicate timestamp: {{job}}',
            'out of bounds: {{job}}',
            'out of order: {{job}}',
          ]) +
          g.stack
        )
        .addPanel(
          g.panel('Appended Samples') +
          g.queryPanel('sum by (job, instance_group_name) (rate(agent_wal_samples_appended_total{' + host_matcher + '}[$__rate_interval]))', '{{job}} {{instance_group_name}}') +
          g.stack
        )
      ),

    // Remote write specific dashboard.
    'agent-remote-write.json':
      local timestampComparison =
        graphPanel.new(
          'Highest Timestamp In vs. Highest Timestamp Sent',
          datasource='$datasource',
          span=6,
        )
        .addTarget(prometheus.target(
          '
            (
              prometheus_remote_storage_highest_timestamp_in_seconds{' + host_matcher + '}
              -
              ignoring(url, remote_name) group_right(pod)
              prometheus_remote_storage_queue_highest_sent_timestamp_seconds{' + host_matcher + '}
            )
          ',
          legendFormat='{{cluster}}:{{pod}}-{{instance_group_name}}-{{url}}',
        ));

      local remoteSendLatency =
        graphPanel.new(
          'Latency [$__rate_interval]',
          datasource='$datasource',
          span=6,
        )
        .addTarget(prometheus.target(
          'rate(prometheus_remote_storage_sent_batch_duration_seconds_sum{' + host_matcher + '}[$__rate_interval]) / rate(prometheus_remote_storage_sent_batch_duration_seconds_count{' + host_matcher + '}[$__rate_interval])',
          legendFormat='mean {{cluster}}:{{pod}}-{{instance_group_name}}-{{url}}',
        ))
        .addTarget(prometheus.target(
          'histogram_quantile(0.99, rate(prometheus_remote_storage_sent_batch_duration_seconds_bucket{' + host_matcher + '}[$__rate_interval]))',
          legendFormat='p99 {{cluster}}:{{pod}}-{{instance_group_name}}-{{url}}',
        ));

      local samplesInRate =
        graphPanel.new(
          'Rate in [$__rate_interval]',
          datasource='$datasource',
          span=6,
        )
        .addTarget(prometheus.target(
          'rate(agent_wal_samples_appended_total{' + host_matcher + '}[$__rate_interval])',
          legendFormat='{{cluster}}:{{pod}}-{{instance_group_name}}-{{url}}',
        ));

      local samplesOutRate =
        graphPanel.new(
          'Rate succeeded [$__rate_interval]',
          datasource='$datasource',
          span=6,
        )
        .addTarget(prometheus.target(
          'rate(prometheus_remote_storage_succeeded_samples_total{' + host_matcher + '}[$__rate_interval]) or rate(prometheus_remote_storage_samples_total{' + host_matcher + '}[$__rate_interval])',
          legendFormat='{{cluster}}:{{pod}}-{{instance_group_name}}-{{url}}',
        ));

      local currentShards =
        graphPanel.new(
          'Current Shards',
          datasource='$datasource',
          span=12,
          min_span=6,
        )
        .addTarget(prometheus.target(
          'prometheus_remote_storage_shards{' + host_matcher + '}',
          legendFormat='{{cluster}}:{{pod}}-{{instance_group_name}}-{{url}}',
        ));

      local maxShards =
        graphPanel.new(
          'Max Shards',
          datasource='$datasource',
          span=4,
        )
        .addTarget(prometheus.target(
          'prometheus_remote_storage_shards_max{' + host_matcher + '}',
          legendFormat='{{cluster}}:{{pod}}-{{instance_group_name}}-{{url}}',
        ));

      local minShards =
        graphPanel.new(
          'Min Shards',
          datasource='$datasource',
          span=4,
        )
        .addTarget(prometheus.target(
          'prometheus_remote_storage_shards_min{' + host_matcher + '}',
          legendFormat='{{cluster}}:{{pod}}-{{instance_group_name}}-{{url}}',
        ));

      local desiredShards =
        graphPanel.new(
          'Desired Shards',
          datasource='$datasource',
          span=4,
        )
        .addTarget(prometheus.target(
          'prometheus_remote_storage_shards_desired{' + host_matcher + '}',
          legendFormat='{{cluster}}:{{pod}}-{{instance_group_name}}-{{url}}',
        ));

      local shardsCapacity =
        graphPanel.new(
          'Shard Capacity',
          datasource='$datasource',
          span=6,
        )
        .addTarget(prometheus.target(
          'prometheus_remote_storage_shard_capacity{' + host_matcher + '}',
          legendFormat='{{cluster}}:{{pod}}-{{instance_group_name}}-{{url}}',
        ));

      local pendingSamples =
        graphPanel.new(
          'Pending Samples',
          datasource='$datasource',
          span=6,
        )
        .addTarget(prometheus.target(
          'prometheus_remote_storage_samples_pending{' + host_matcher + '}',
          legendFormat='{{cluster}}:{{pod}}-{{instance_group_name}}-{{url}}',
        ));

      local queueSegment =
        graphPanel.new(
          'Remote Write Current Segment',
          datasource='$datasource',
          span=6,
          formatY1='none',
        )
        .addTarget(prometheus.target(
          'prometheus_wal_watcher_current_segment{' + host_matcher + '}',
          legendFormat='{{cluster}}:{{pod}}-{{instance_group_name}}-{{url}}',
        ));

      local droppedSamples =
        graphPanel.new(
          'Dropped Samples',
          datasource='$datasource',
          span=6,
        )
        .addTarget(prometheus.target(
          'rate(prometheus_remote_storage_samples_dropped_total{' + host_matcher + '}[$__rate_interval])',
          legendFormat='{{cluster}}:{{pod}}-{{instance_group_name}}-{{url}}',
        ));

      local failedSamples =
        graphPanel.new(
          'Failed Samples',
          datasource='$datasource',
          span=6,
        )
        .addTarget(prometheus.target(
          'rate(prometheus_remote_storage_samples_failed_total{' + host_matcher + '}[$__rate_interval])',
          legendFormat='{{cluster}}:{{pod}}-{{instance_group_name}}-{{url}}',
        ));

      local retriedSamples =
        graphPanel.new(
          'Retried Samples',
          datasource='$datasource',
          span=6,
        )
        .addTarget(prometheus.target(
          'rate(prometheus_remote_storage_samples_retried_total{' + host_matcher + '}[$__rate_interval])',
          legendFormat='{{cluster}}:{{pod}}-{{instance_group_name}}-{{url}}',
        ));

      local enqueueRetries =
        graphPanel.new(
          'Enqueue Retries',
          datasource='$datasource',
          span=6,
        )
        .addTarget(prometheus.target(
          'rate(prometheus_remote_storage_enqueue_retries_total{' + host_matcher + '}[$__rate_interval])',
          legendFormat='{{cluster}}:{{pod}}-{{instance_group_name}}-{{url}}',
        ));

      grafana.dashboard.new('Agent Prometheus Remote Write', tags=$._config.dashboardTags, editable=false, time_from='%s' % $._config.dashboardPeriod, uid='integration-agent-prom-rw')
      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Agent Dashboards',
        includeVars=true,
        keepTime=true,
        tags=($._config.dashboardTags),
      ))
      .addTemplates([
        ds_template,
        job_template,
        instance_template,
        cluster_template,
        namespace_template,
        container_template,
        pod_template,
      ])
      .addRow(
        row.new('Timestamps')
        .addPanel(timestampComparison)
        .addPanel(remoteSendLatency)
      )
      .addRow(
        row.new('Samples')
        .addPanel(samplesInRate)
        .addPanel(samplesOutRate)
        .addPanel(pendingSamples)
        .addPanel(droppedSamples)
        .addPanel(failedSamples)
        .addPanel(retriedSamples)
      )
      .addRow(
        row.new('Shards')
        .addPanel(currentShards)
        .addPanel(maxShards)
        .addPanel(minShards)
        .addPanel(desiredShards)
      )
      .addRow(
        row.new('Shard Details')
        .addPanel(shardsCapacity)
      )
      .addRow(
        row.new('Segments')
        .addPanel(queueSegment)
      )
      .addRow(
        row.new('Misc. Rates')
        .addPanel(enqueueRetries)
      ),

    'agent-tracing-pipeline.json':
      local acceptedSpans =
        graphPanel.new(
          'Accepted spans',
          datasource='$datasource',
          interval='1m',
          span=3,
          legend_show=false,
          fill=0,
        )
        .addTarget(prometheus.target(
          '
            rate(traces_receiver_accepted_spans{' + host_matcher + ',receiver!="otlp/lb"}[$__rate_interval])
          ',
          legendFormat='{{ pod }} - {{ receiver }}/{{ transport }}',
        ));

      local refusedSpans =
        graphPanel.new(
          'Refused spans',
          datasource='$datasource',
          interval='1m',
          span=3,
          legend_show=false,
          fill=0,
        )
        .addTarget(prometheus.target(
          '
            rate(traces_receiver_refused_spans{' + host_matcher + ',receiver!="otlp/lb"}[$__rate_interval])
          ',
          legendFormat='{{ pod }} - {{ receiver }}/{{ transport }}',
        ));

      local sentSpans =
        graphPanel.new(
          'Exported spans',
          datasource='$datasource',
          interval='1m',
          span=3,
          legend_show=false,
          fill=0,
        )
        .addTarget(prometheus.target(
          '
            rate(traces_exporter_sent_spans{' + host_matcher + ',exporter!="otlp"}[$__rate_interval])
          ',
          legendFormat='{{ pod }} - {{ exporter }}',
        ));

      local exportedFailedSpans =
        graphPanel.new(
          'Exported failed spans',
          datasource='$datasource',
          interval='1m',
          span=3,
          legend_show=false,
          fill=0,
        )
        .addTarget(prometheus.target(
          '
            rate(traces_exporter_send_failed_spans{' + host_matcher + ',exporter!="otlp"}[$__rate_interval])
          ',
          legendFormat='{{ pod }} - {{ exporter }}',
        ));

      local receivedSpans(receiverFilter, width) =
        graphPanel.new(
          'Received spans',
          datasource='$datasource',
          interval='1m',
          span=width,
          fill=1,
        )
        .addTarget(prometheus.target(
          '
            sum(rate(traces_receiver_accepted_spans{' + host_matcher + ',%s}[$__rate_interval]))
          ' % receiverFilter,
          legendFormat='Accepted',
        ))
        .addTarget(prometheus.target(
          '
            sum(rate(traces_receiver_refused_spans{' + host_matcher + ',%s}[$__rate_interval]))
          ' % receiverFilter,
          legendFormat='Refused',
        ));

      local exportedSpans(exporterFilter, width) =
        graphPanel.new(
          'Exported spans',
          datasource='$datasource',
          interval='1m',
          span=width,
          fill=1,
        )
        .addTarget(prometheus.target(
          '
            sum(rate(traces_exporter_sent_spans{' + host_matcher + ',%s}[$__rate_interval]))
          ' % exporterFilter,
          legendFormat='Sent',
        ))
        .addTarget(prometheus.target(
          '
            sum(rate(traces_exporter_send_failed_spans{' + host_matcher + ',%s}[$__rate_interval]))
          ' % exporterFilter,
          legendFormat='Send failed',
        ));

      local loadBalancedSpans =
        graphPanel.new(
          'Load-balanced spans',
          datasource='$datasource',
          interval='1m',
          span=3,
          fill=1,
          stack=true,
        )
        .addTarget(prometheus.target(
          '
            rate(traces_loadbalancer_backend_outcome{' + job_instance_matcher + ', cluster=~"$cluster",namespace=~"$namespace",success="true",container=~"$container",pod=~"$pod"}[$__rate_interval])
          ',
          legendFormat='{{ pod }}',
        ));

      local peersNum =
        graphPanel.new(
          'Number of peers',
          datasource='$datasource',
          interval='1m',
          span=3,
          legend_show=false,
          fill=0,
        )
        .addTarget(prometheus.target(
          '
            traces_loadbalancer_num_backends{' + host_matcher + '}
          ',
          legendFormat='{{ pod }}',
        ));

      dashboard.new('Agent Tracing Pipeline', tags=$._config.dashboardTags, editable=false, time_from='%s' % $._config.dashboardPeriod, uid='integration-agent-tracing-pl')
      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Agent Dashboards',
        includeVars=true,
        keepTime=true,
        tags=($._config.dashboardTags),
      ))
      .addTemplates([
        ds_template,
        job_template,
        instance_template,
        cluster_template,
        namespace_template,
        container_template,
        pod_template,
      ])
      .addRow(
        row.new('Write / Read')
        .addPanel(acceptedSpans)
        .addPanel(refusedSpans)
        .addPanel(sentSpans)
        .addPanel(exportedFailedSpans)
        .addPanel(receivedSpans('receiver!="otlp/lb"', 6))
        .addPanel(exportedSpans('exporter!="otlp"', 6))
      )
      .addRow(
        row.new('Load balancing')
        .addPanel(loadBalancedSpans)
        .addPanel(peersNum)
        .addPanel(receivedSpans('receiver="otlp/lb"', 3))
        .addPanel(exportedSpans('exporter="otlp"', 3))
      ),
  },
}
