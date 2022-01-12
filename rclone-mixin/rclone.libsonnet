local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local row = grafana.row;
local prometheus = grafana.prometheus;
local graphPanel = grafana.graphPanel;
local piechart = grafana.pieChartPanel;
local singlestat = grafana.singlestat;
local statPanel = grafana.statPanel;

local matcher = 'job=~"$job", instance=~"$instance"';

local queries = {
  fchecked_total: 'sum(increase(rclone_checked_files_total{' + matcher + '}[$__range]))',
  ftransferred_total: 'sum(increase(rclone_files_transferred_total{' + matcher + '}[$__range]))',
  frenamed_total: 'sum(increase(rclone_files_renamed_total{' + matcher + '}[$__range]))',
  fdeleted_total: 'sum(increase(rclone_files_deleted_total{' + matcher + '}[$__range]))',
  err_total: 'sum(increase(rclone_errors_total{' + matcher + '}[$__range]))',
  bytes_transferred_rate_sum: 'sum(irate(rclone_bytes_transferred_total{' + matcher + '}[$__rate_interval]))',
  bytes_transferred_range: 'sum(increase(rclone_bytes_transferred_total{' + matcher + '}[$__range]))',
  bytes_transferred_day: 'sum(increase(rclone_bytes_transferred_total{' + matcher + '}[24h]))',
  bytes_transferred_total: 'sum(rclone_bytes_transferred_total{' + matcher + '})',
  bytes_transferred_rate_ts: 'sum(irate(rclone_bytes_transferred_total{' + matcher + '}[$__rate_interval])) by (instance)',
};

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
  'label_values(rclone_speed, job)',
  refresh='load',
  multi=true,
  includeAll=true,
  allValues='.+',
  sort=1,
);

local instance_template = grafana.template.new(
  'instance',
  '$datasource',
  'label_values(rclone_speed{job=~"$job"}, instance)',
  refresh='load',
  multi=true,
  includeAll=true,
  allValues='.+',
  sort=1,
);

local statusPiePanel = piechart.new('Status', span=5, datasource='$datasource', legendType='Right side')
                       .addTarget(grafana.prometheus.target(queries.fchecked_total, legendFormat='Files Checked'))
                       .addTarget(grafana.prometheus.target(queries.ftransferred_total, legendFormat='Files Transferred'))
                       .addTarget(grafana.prometheus.target(queries.frenamed_total, legendFormat='Files Renamed'))
                       .addTarget(grafana.prometheus.target(queries.fdeleted_total, legendFormat='Files Deleted'))
                       .addTarget(grafana.prometheus.target(queries.err_total, legendFormat='Transfer Errors'));

local transferGauge = singlestat.new(
  'Transfer Rate',
  description='Thresholds are; 0-80MB/s (Internet speed), 80-200MB/s (Harddisk speed), 200MB/s+ (Solid State disk speed)',
  datasource='$datasource',
  gaugeShow=true,
  format='Bps',
  span=2,
  thresholds='80000000,200000000',
  gaugeMaxValue='500000000'
)
                      .addTarget(grafana.prometheus.target(queries.bytes_transferred_rate_sum));

local transferredStat = statPanel.new(
  'Data Transferred',
  datasource='$datasource',
  unit='bytes',
)
                        .addTargets([
  grafana.prometheus.target(queries.bytes_transferred_range, legendFormat='Range'),
  grafana.prometheus.target(queries.bytes_transferred_day, legendFormat='24h'),
  grafana.prometheus.target(queries.bytes_transferred_total, legendFormat='Total'),
])
                        .addThreshold({ color: 'green', value: 0 }) { span: 5 };

local transferGraph = graphPanel.new(
    'Traffic',
    datasource='$datasource',
    span=12,
    stack=true,
    format='bps',
)
.addTarget(grafana.prometheus.target(queries.bytes_transferred_rate_ts, legendFormat='{{instance}}'))
+ {
  line: 1,
  fill: 5,
  fillGradient: 10,
};

{
  grafanaDashboards+:: {
    'rclone.json':
      dashboard.new('rclone', uid='Mkm2KHPzS').addTemplates([
        ds_template,
        job_template,
        instance_template,
      ])
      .addRow(
        row.new('Overview')
        .addPanel(statusPiePanel)
        .addPanel(transferGauge)
        .addPanel(transferredStat)
      )
      .addRow(
        row.new('Realtime')
        .addPanel(transferGraph)
      ),
  },
}
