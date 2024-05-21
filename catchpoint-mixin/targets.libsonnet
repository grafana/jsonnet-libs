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
    local maxPanelLegend = config.testNameLabel + config.nodeNameLabel,

    topAvgLoadTimeTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name) (2, avg by (instance, test_name) (catchpoint_load_time{%(testNameSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    topMaxTotalLoadTime:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name, node_name) (2, max by (instance, test_name, node_name) (catchpoint_load_time{%(testNameSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(maxPanelLegend)),

    topAvgDocumentCompletionTimeTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name) (2, avg by (instance, test_name) (catchpoint_document_complete_time{%(testNameSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    topMaxDocumentCompletionTime:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name, node_name) (2, max by (instance, test_name, node_name) (catchpoint_document_complete_time{%(testNameSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(maxPanelLegend)),

    topAvgRequestSuccessRatioTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name) (2, avg by (instance, test_name) ((catchpoint_requests_count{%(testNameSelector)s} - catchpoint_failed_requests_count{%(testNameSelector)s}) / clamp_min(catchpoint_requests_count{%(testNameSelector)s},1)))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - success' % utils.labelsToPanelLegend(testNameLabel)),

    topAvgRequestFailureRatioTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name) (2, avg by (instance, test_name) ((catchpoint_failed_requests_count{%(testNameSelector)s}) / clamp_min(catchpoint_requests_count{%(testNameSelector)s},1)))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - failure' % utils.labelsToPanelLegend(testNameLabel)),

    topMaxRequestSuccessRatioTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        ''
      )
      + prometheusQuery.withLegendFormat('%s - success' % utils.labelsToPanelLegend(testNameLabel)),

    topMaxRequestFailureRatioTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        ''
      )
      + prometheusQuery.withLegendFormat('%s - failure' % utils.labelsToPanelLegend(maxPanelLegend)),

    topAvgConnectionSetupTimeTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name) (2, avg by (instance, test_name) (catchpoint_connect_time{%(testNameSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    topMaxConnectionSetupTimeTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name, node_name) (2, max by (instance, test_name, node_name) (catchpoint_connect_time{%(testNameSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(maxPanelLegend)),

    topAvgContentLoadingTimeTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name) (2, avg by (instance, test_name) (catchpoint_load_time{%(testNameSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    topMaxContentLoadingTimeTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name, node_name) (2, max by (instance, test_name, node_name) (catchpoint_load_time{%(testNameSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(maxPanelLegend)),

    topAvgRedirectsTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name) (2, avg by (instance, test_name) (catchpoint_redirect_time{%(testNameSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    topMaxRedirectsTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name, node_name) (2, max by (instance, test_name, node_name) (catchpoint_redirect_time{%(testNameSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(maxPanelLegend)),

    topErrorsByTestName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by (test_name) (2, max by (instance, test_name) (catchpoint_any_error{%(testNameSelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),


    // Web performance by test name dashboard
    pageCompletionTime:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_document_complete_time{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    DNSResolution:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_dns_time{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    contentHandlingLoad:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_content_load_time{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - load' % utils.labelsToPanelLegend(testNameLabel)),

    contentHandlingRender:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_render_start_time{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - render' % utils.labelsToPanelLegend(testNameLabel)),

    clientProcessing:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_client_time{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    additionalDelay:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_redirect_time{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    responseContentSize:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_response_content_size{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - content' % utils.labelsToPanelLegend(testNameLabel)),

    responseHeaderSize:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_response_header_size{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - header' % utils.labelsToPanelLegend(testNameLabel)),

    totalContentSize:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_total_content_size{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - content' % utils.labelsToPanelLegend(testNameLabel)),

    totalHeaderSize:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_total_header_size{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - header' % utils.labelsToPanelLegend(testNameLabel)),

    networkConnections:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_connections_count{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    hostsContacted:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_hosts_count{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    cacheAccess:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_cached_count{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    requestsSuccessRatio:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '(avg by (node_name) (catchpoint_requests_count{%(testNameSelector)s}) - avg by (node_name) (catchpoint_failed_requests_count{%(testNameSelector)s})) / avg by (node_name) (catchpoint_requests_count{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - success' % utils.labelsToPanelLegend(testNameLabel)),

    requestsFailureRatio:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'avg by (node_name) (catchpoint_failed_requests_count{%(testNameSelector)s}) / clamp_min(avg by (node_name) (catchpoint_requests_count{%(testNameSelector)s}), 1)' % vars
      )
      + prometheusQuery.withLegendFormat('%s - failure' % utils.labelsToPanelLegend(testNameLabel)),

    redirections:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_redirections_count{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    imageLoadedBySize:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_image_content_type{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('image'),

    scriptLoadedBySize:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_script_content_type{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('script'),

    htmlLoadedBySize:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_html_content_type{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('html'),

    cssLoadedBySize:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_css_content_type{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('css'),

    fontLoadedBySize:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_font_content_type{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('font'),

    xmlLoadedBySize:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_xml_content_type{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('xml'),

    mediaLoadedBySize:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_media_content_type{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('media'),

    imageLoadedByType:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_image_count{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('image'),

    scriptLoadedByType:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_script_count{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('script'),

    htmlLoadedByType:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_html_count{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('html'),

    cssLoadedByType:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_css_count{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('css'),

    fontLoadedByType:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_font_count{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('font'),

    xmlLoadedByType:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_xml_count{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('xml'),

    mediaLoadedByType:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_media_count{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('media'),

    errors:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_any_error{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

  },
}
