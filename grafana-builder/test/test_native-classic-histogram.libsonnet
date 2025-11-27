local builder = import '../grafana.libsonnet';
local test = import 'github.com/jsonnet-libs/testonnet/main.libsonnet';

test.new(std.thisFile)

+ test.case.new(
  name='LatencyPanel fieldConfig',
  test=test.expect.eq(
    actual=std.get(builder.latencyPanelNativeHistogram('request_duration_seconds', 'cluster="cluster1", job="job1"'), 'targets', []),
    expected=[
      {
        expr: '(histogram_quantile(0.99, sum (rate(request_duration_seconds{cluster="cluster1", job="job1"}[$__rate_interval]))) * 1e3) and on() (vector($latency_metrics) == -1)',
        format: 'time_series',
        legendFormat: '99th percentile',
        refId: 'A',
      },
      {
        expr: '(histogram_quantile(0.99, sum by (le) (rate(request_duration_seconds_bucket{cluster="cluster1", job="job1"}[$__rate_interval]))) * 1e3) and on() (vector($latency_metrics) == 1)',
        format: 'time_series',
        legendFormat: '99th percentile',
        refId: 'A_classic',
      },
      {
        expr: '(histogram_quantile(0.50, sum (rate(request_duration_seconds{cluster="cluster1", job="job1"}[$__rate_interval]))) * 1e3) and on() (vector($latency_metrics) == -1)',
        format: 'time_series',
        legendFormat: '50th percentile',
        refId: 'B',
      },
      {
        expr: '(histogram_quantile(0.50, sum by (le) (rate(request_duration_seconds_bucket{cluster="cluster1", job="job1"}[$__rate_interval]))) * 1e3) and on() (vector($latency_metrics) == 1)',
        format: 'time_series',
        legendFormat: '50th percentile',
        refId: 'B_classic',
      },
      {
        expr: '(1e3 * sum(histogram_sum(rate(request_duration_seconds{cluster="cluster1", job="job1"}[$__rate_interval]))) /\nsum(histogram_count(rate(request_duration_seconds{cluster="cluster1", job="job1"}[$__rate_interval])))\n) and on() (vector($latency_metrics) == -1)',
        format: 'time_series',
        legendFormat: 'Average',
        refId: 'C',
      },
      {
        expr: '(1e3 * sum(rate(request_duration_seconds_sum{cluster="cluster1", job="job1"}[$__rate_interval])) /\nsum(rate(request_duration_seconds_count{cluster="cluster1", job="job1"}[$__rate_interval]))\n) and on() (vector($latency_metrics) == 1)',
        format: 'time_series',
        legendFormat: 'Average',
        refId: 'C_classic',
      },
    ],
  )
)
