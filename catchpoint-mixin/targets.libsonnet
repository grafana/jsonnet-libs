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

    topAvgTotalLoadTimeNodeName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(1, avg by (node_name) (avg_over_time(catchpoint_load_time{%(pureTestNameSelector)s}[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(nodeNameLabel)),

    topAvgDocumentCompletionTimeTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(1, avg by (test_name) (avg_over_time(catchpoint_document_complete_time{%(pureTestNameSelector)s}[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    topAvgDocumentCompletionTimeNodeName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(1, avg by (node_name) (avg_over_time(catchpoint_document_complete_time{%(pureTestNameSelector)s}[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(nodeNameLabel)),

    bottomAvgRequestSuccessRatioTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'bottomk(1, avg by (test_name) (avg_over_time(((catchpoint_requests_count{%(pureTestNameSelector)s} - catchpoint_failed_requests_count{%(pureTestNameSelector)s}) / clamp_min(catchpoint_requests_count{%(pureTestNameSelector)s},1))[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - success' % utils.labelsToPanelLegend(testNameLabel)),

    bottomAvgRequestSuccessRatioNodeName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'bottomk(1, avg by (node_name) (avg_over_time(((catchpoint_requests_count{%(pureTestNameSelector)s} - catchpoint_failed_requests_count{%(pureTestNameSelector)s}) / clamp_min(catchpoint_requests_count{%(pureTestNameSelector)s},1))[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - success' % utils.labelsToPanelLegend(nodeNameLabel)),

    topAvgConnectionSetupTimeTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(1, avg by (test_name) (avg_over_time(catchpoint_connect_time{%(pureTestNameSelector)s}[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    topAvgConnectionSetupTimeNodeName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(1, avg by (node_name) (avg_over_time(catchpoint_connect_time{%(pureTestNameSelector)s}[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(nodeNameLabel)),

    topAvgContentLoadingTimeTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(1, avg by (test_name) (avg_over_time(catchpoint_content_load_time{%(pureTestNameSelector)s}[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    topAvgContentLoadingTimeNodeName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(1, avg by (node_name) (avg_over_time(catchpoint_content_load_time{%(pureTestNameSelector)s}[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testAndNodeLabel)),

    topAvgRedirectsTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(1, avg by (test_name) (avg_over_time(catchpoint_redirect_time{%(pureTestNameSelector)s}[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    topAvgRedirectsNodeName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(1, avg by (node_name) (avg_over_time(catchpoint_redirect_time{%(pureTestNameSelector)s}[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testAndNodeLabel)),

    topErrorsByTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk(1, sum by (test_name) (sum_over_time(catchpoint_any_error{%(pureTestNameSelector)s}[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    // Web performance by test name dashboard
    pageCompletionTime:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '(sum by (test_name) (catchpoint_document_complete_time{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    DNSResolution:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '(sum by (test_name) (catchpoint_dns_time{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    contentHandlingLoad:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '(sum by (test_name) (catchpoint_content_load_time{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - load' % utils.labelsToPanelLegend(testNameLabel)),

    contentHandlingRender:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '(sum by (test_name) (catchpoint_render_start_time{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - render' % utils.labelsToPanelLegend(testNameLabel)),

    clientProcessing:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '(sum by (test_name) (catchpoint_client_time{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    additionalDelay:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '(sum by (test_name) (catchpoint_redirect_time{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    responseContentSize:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '(sum by (test_name) (catchpoint_response_content_size{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - content' % utils.labelsToPanelLegend(testNameLabel)),

    responseHeaderSize:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '(sum by (test_name) (catchpoint_response_header_size{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - header' % utils.labelsToPanelLegend(testNameLabel)),

    totalContentSize:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '(sum by (test_name) (catchpoint_total_content_size{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - content' % utils.labelsToPanelLegend(testNameLabel)),

    totalHeaderSize:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '(sum by (test_name) (catchpoint_total_header_size{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - header' % utils.labelsToPanelLegend(testNameLabel)),

    networkConnections:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '(sum by (test_name) (catchpoint_connections_count{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    hostsContacted:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '(sum by (test_name) (catchpoint_hosts_count{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    cacheAccess:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '(sum by (test_name) (catchpoint_cached_count{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    requestsSuccessRatio:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '(sum by (test_name) (catchpoint_requests_count{%(testNameSelector)s}) - catchpoint_failed_requests_count{%(testNameSelector)s}) / clamp_min(catchpoint_requests_count{%(testNameSelector)s}, 1)' % vars
      )
      + prometheusQuery.withLegendFormat('%s - success' % utils.labelsToPanelLegend(testNameLabel)),

    requestsFailureRatio:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'catchpoint_failed_requests_count{%(testNameSelector)s} / clamp_min(catchpoint_requests_count{%(testNameSelector)s}, 1)' % vars
      )
      + prometheusQuery.withLegendFormat('%s - failure' % utils.labelsToPanelLegend(testNameLabel)),

    redirections:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_redirections_count{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    imageLoadedBySize:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_image_content_type{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat(''),

    scriptLoadedBySize:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_script_content_type{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat(''),

    htmlLoadedBySize:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_html_content_type{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat(''),

    cssLoadedBySize:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_css_content_type{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat(''),

    fontLoadedBySize:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_font_content_type{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat(''),

    xmlLoadedBySize:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_xml_content_type{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat(''),

    mediaLoadedBySize:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_media_content_type{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat(''),


    imageLoadedByType:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_image_count{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat(''),

    scriptLoadedByType:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_script_count{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat(''),

    htmlLoadedByType:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_html_count{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat(''),

    cssLoadedByType:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_css_count{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat(''),

    fontLoadedByType:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_font_count{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat(''),

    xmlLoadedByType:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_xml_count{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat(''),

    mediaLoadedByType:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_media_count{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat(''),

    Errors:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_any_error{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat(''),

  },
}
