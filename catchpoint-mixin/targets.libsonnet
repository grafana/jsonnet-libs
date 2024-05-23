local g = import './g.libsonnet';
local prometheusQuery = g.query.prometheus;
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils {
  labelsToPanelLegend(labels): std.join(' - ', ['{{%s}}' % [label] for label in labels]),
};

{
  new(this): {
    local vars = this.grafana.variables,
    local config = this.config,
    local testNameLabel = config.testNameLabel,
    local nodeNameLabel = config.nodeNameLabel,
    local testAndNodeLabel = config.nodeNameLabel + config.testNameLabel,

    topAvgLoadTimeTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(1, avg by (test_name) (avg_over_time(catchpoint_load_time{%(pureTestNameSelector)s}[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    topMaxTotalLoadTime:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(1, max by (node_name) (max_over_time(catchpoint_load_time{%(pureTestNameSelector)s}[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(nodeNameLabel)),

    topAvgDocumentCompletionTimeTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(1, avg by (test_name) (avg_over_time(catchpoint_document_complete_time{%(pureTestNameSelector)s}[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    topMaxDocumentCompletionTime:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(1, max by (node_name) (max_over_time(catchpoint_document_complete_time{%(pureTestNameSelector)s}[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(nodeNameLabel)),

    bottomAvgRequestSuccessRatioTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'bottomk(1, avg by (test_name) (avg_over_time(((catchpoint_requests_count{%(pureTestNameSelector)s} - catchpoint_failed_requests_count{%(pureTestNameSelector)s}) / clamp_min(catchpoint_requests_count{%(pureTestNameSelector)s},1))[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - success' % utils.labelsToPanelLegend(testNameLabel)),

    topMaxFailedRequestRatioTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(1, avg by (node_name) (avg_over_time(((catchpoint_failed_requests_count{%(pureTestNameSelector)s}) / clamp_min(catchpoint_requests_count{%(pureTestNameSelector)s},1))[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - failure' % utils.labelsToPanelLegend(nodeNameLabel)),

    topAvgConnectionSetupTimeTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(1, avg by (test_name) (avg_over_time(catchpoint_connect_time{%(pureTestNameSelector)s}[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    topMaxConnectionSetupTimeTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(1, max by (node_name) (max_over_time(catchpoint_connect_time{%(pureTestNameSelector)s}[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testAndNodeLabel)),

    topAvgContentLoadingTimeTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(1, avg by (test_name) (avg_over_time(catchpoint_content_load_time{%(pureTestNameSelector)s}[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    topMaxContentLoadingTimeTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(1, max by (node_name) (max_over_time(catchpoint_content_load_time{%(pureTestNameSelector)s}[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testAndNodeLabel)),

    topAvgRedirectsTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(1, avg by (test_name) (avg_over_time(catchpoint_redirect_time{%(pureTestNameSelector)s}[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    topMaxRedirectsTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(1, max by (node_name) (max_over_time(catchpoint_redirect_time{%(pureTestNameSelector)s}[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testAndNodeLabel)),

    topErrorsByTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(1, sum by (test_name) (sum_over_time(catchpoint_any_error{%(pureTestNameSelector)s}[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),
  },
}
