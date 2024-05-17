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
    local testNameLabel = config.instanceLabels + config.testNameLabel,

    topAvgLoadTimeTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name) (2, avg by (instance, test_name) (catchpoint_load_time{%(testNameSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    topMaxTotalLoadTime:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name) (2, max by (instance, test_name) (catchpoint_load_time{%(testNameSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    topAvgDocumentCompletionTimeTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name) (2, avg by (instance, test_name) (catchpoint_document_complete_time{%(testNameSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    topMaxDocumentCompletionTime:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name) (2, max by (instance, test_name) (catchpoint_document_complete_time{%(testNameSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    topAvgRequestSuccessRatioTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name) (2, avg by (instance, test_name) ((catchpoint_requests_count{%(testNameSelector)s} - catchpoint_failed_requests_count{%(testNameSelector)s}) / clamp_min(catchpoint_requests_count{%(testNameSelector)s},1)))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    topAvgRequestFailureRatioTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name) (2, avg by (instance, test_name) ((catchpoint_failed_requests_count{%(testNameSelector)s}) / clamp_min(catchpoint_requests_count{%(testNameSelector)s},1)))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    topMaxRequestSuccessRatioTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        ''
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    topMaxRequestFailureRatioTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        ''
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    topAvgConnectionSetupTimeTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name) (2, avg by (instance, test_name) (catchpoint_connect_time{%(testNameSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    topMaxConnectionSetupTimeTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name) (2, max by (instance, test_name) (catchpoint_connect_time{%(testNameSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    topAvgContentLoadingTimeTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name) (2, avg by (instance, test_name) (catchpoint_load_time{%(testNameSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    topMaxContentLoadingTimeTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name) (2, max by (instance, test_name) (catchpoint_load_time{%(testNameSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    topAvgRedirectsTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name) (2, avg by (instance, test_name) (catchpoint_redirect_time{%(testNameSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    topMaxRedirectsTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name) (2, max by (instance, test_name) (catchpoint_redirect_time{%(testNameSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    topErrorsByTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name) (2, max by (instance, test_name) (catchpoint_any_error{%(testNameSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),
  },
}
