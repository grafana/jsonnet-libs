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
    local testAndNodeLabel = config.nodeNameLabel + config.testNameLabel,

    topAvgLoadTimeTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name, node_name) ($top_cluster_count, avg by (instance, test_name, node_name) (catchpoint_load_time{%(testNameSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testAndNodeLabel)),

    topMaxTotalLoadTime:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name, node_name) ($top_cluster_count, max by (instance, test_name, node_name) (catchpoint_load_time{%(testNameSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testAndNodeLabel)),

    topAvgDocumentCompletionTimeTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name, node_name) ($top_cluster_count, avg by (instance, test_name, node_name) (catchpoint_document_complete_time{%(testNameSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testAndNodeLabel)),

    topMaxDocumentCompletionTime:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name, node_name) ($top_cluster_count, max by (instance, test_name, node_name) (catchpoint_document_complete_time{%(testNameSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testAndNodeLabel)),

    bottomAvgRequestSuccessRatioTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name, node_name) ($top_cluster_count, avg by (instance, test_name, node_name) ((catchpoint_requests_count{%(testNameSelector)s} - catchpoint_failed_requests_count{%(testNameSelector)s}) / clamp_min(catchpoint_requests_count{%(testNameSelector)s},1)))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - success' % utils.labelsToPanelLegend(testAndNodeLabel)),

    topMaxFailedRequestRatioTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name, node_name) ($top_cluster_count, max by (instance, test_name, node_name) (catchpoint_failed_requests_count{%(testNameSelector)s} / clamp_min(catchpoint_requests_count{%(testNameSelector)s},1)))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - failure' % utils.labelsToPanelLegend(testAndNodeLabel)),

    topAvgConnectionSetupTimeTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name, node_name) ($top_cluster_count, avg by (instance, test_name, node_name) (catchpoint_connect_time{%(testNameSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testAndNodeLabel)),

    topMaxConnectionSetupTimeTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name, node_name) ($top_cluster_count, max by (instance, test_name, node_name) (catchpoint_connect_time{%(testNameSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testAndNodeLabel)),

    topAvgContentLoadingTimeTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name, node_name) ($top_cluster_count, avg by (instance, test_name, node_name) (catchpoint_load_time{%(testNameSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testAndNodeLabel)),

    topMaxContentLoadingTimeTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name, node_name) ($top_cluster_count, max by (instance, test_name, node_name) (catchpoint_load_time{%(testNameSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testAndNodeLabel)),

    topAvgRedirectsTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name, node_name) ($top_cluster_count, avg by (instance, test_name, node_name) (catchpoint_redirect_time{%(testNameSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testAndNodeLabel)),

    topMaxRedirectsTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name, node_name) ($top_cluster_count, max by (instance, test_name, node_name) (catchpoint_redirect_time{%(testNameSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testAndNodeLabel)),

    topErrorsByTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name, node_name) ($top_cluster_count, max by (instance, test_name, node_name) (catchpoint_any_error{%(testNameSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testAndNodeLabel)),
  },
}
