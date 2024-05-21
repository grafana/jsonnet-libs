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
        'sum by (node_name) (catchpoint_document_complete_time{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - completion' % utils.labelsToPanelLegend(nodeNameLabel)),

    pageTotalLoadTime:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_total_time{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - load' % utils.labelsToPanelLegend(nodeNameLabel)),

    DNSResolution:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_dns_time{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - DNS' % utils.labelsToPanelLegend(nodeNameLabel)),

    SSLTime:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_ssl_time{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - SSL' % utils.labelsToPanelLegend(nodeNameLabel)),

    connectTime:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_connect_time{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - connect' % utils.labelsToPanelLegend(nodeNameLabel)),

    contentHandlingLoad:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_content_load_time{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - load' % utils.labelsToPanelLegend(nodeNameLabel)),


    contentHandlingRender:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_render_start_time{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - render' % utils.labelsToPanelLegend(nodeNameLabel)),

    clientProcessing:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_client_time{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(nodeNameLabel)),

    additionalDelay:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_redirect_time{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - redirect' % utils.labelsToPanelLegend(nodeNameLabel)),

    waitTime:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_wait_time{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - wait' % utils.labelsToPanelLegend(nodeNameLabel)),

    responseContentSize:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_response_content_size{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - content' % utils.labelsToPanelLegend(nodeNameLabel)),

    responseHeaderSize:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_response_header_size{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - header' % utils.labelsToPanelLegend(nodeNameLabel)),

    totalContentSize:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_total_content_size{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - content' % utils.labelsToPanelLegend(nodeNameLabel)),

    totalHeaderSize:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_total_header_size{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - header' % utils.labelsToPanelLegend(nodeNameLabel)),

    networkConnections:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_connections_count{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(nodeNameLabel)),

    hostsContacted:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_hosts_count{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(nodeNameLabel)),

    cacheAccess:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_cached_count{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(nodeNameLabel)),

    requestSuccessRatio:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '(avg by (node_name) (catchpoint_requests_count{%(testNameSelector)s}) - avg by (node_name) (catchpoint_failed_requests_count{%(testNameSelector)s})) / avg by (node_name) (catchpoint_requests_count{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(nodeNameLabel)),

    requestsFailureRatio:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'avg by (node_name) (catchpoint_failed_requests_count{%(testNameSelector)s}) / clamp_min(avg by (node_name) (catchpoint_requests_count{%(testNameSelector)s}), 1)' % vars
      )
      + prometheusQuery.withLegendFormat('%s - failure' % utils.labelsToPanelLegend(nodeNameLabel)),

    redirections:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_redirections_count{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(nodeNameLabel)),

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

    objectLoadedError:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_error_objects_loaded{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('object loaded'),

    DNSError:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_dns_error{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('DNS'),

    loadError:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_load_error{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('load'),

    timeoutError:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_timeout_error{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('timeout'),

    connectionError:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_connection_error{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('connection'),

    transactionError:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_transaction_error{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('transaction'),

    errors:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_any_error{%(testNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(nodeNameLabel)),

    // Web performance by node name dashboard
    pageCompletionTimeNodeName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_document_complete_time{%(nodeNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    DNSResolutionNodeName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_dns_time{%(nodeNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    contentHandlingLoadNodeName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_content_load_time{%(nodeNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - load' % utils.labelsToPanelLegend(testNameLabel)),

    contentHandlingRenderNodeName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_render_start_time{%(nodeNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - render' % utils.labelsToPanelLegend(testNameLabel)),

    clientProcessingNodeName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_client_time{%(nodeNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    additionalDelayNodeName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_redirect_time{%(nodeNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    responseContentSizeNodeName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_response_content_size{%(nodeNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - content' % utils.labelsToPanelLegend(testNameLabel)),

    responseHeaderSizeNodeName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_response_header_size{%(nodeNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - header' % utils.labelsToPanelLegend(testNameLabel)),

    totalContentSizeNodeName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_total_content_size{%(nodeNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - content' % utils.labelsToPanelLegend(testNameLabel)),

    totalHeaderSizeNodeName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_total_header_size{%(nodeNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - header' % utils.labelsToPanelLegend(testNameLabel)),

    networkConnectionsNodeName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_connections_count{%(nodeNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    hostsContactedNodeName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_hosts_count{%(nodeNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    cacheAccessNodeName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_cached_count{%(nodeNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    requestsSuccessRatioNodeName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '(avg by (test_name) (catchpoint_requests_count{%(nodeNameSelector)s}) - avg by (test_name) (catchpoint_failed_requests_count{%(nodeNameSelector)s})) / avg by (test_name) (catchpoint_requests_count{%(nodeNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s - success' % utils.labelsToPanelLegend(testNameLabel)),

    requestsFailureRatioNodeName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'avg by (test_name) (catchpoint_failed_requests_count{%(nodeNameSelector)s}) / clamp_min(avg by (test_name) (catchpoint_requests_count{%(nodeNameSelector)s}), 1)' % vars
      )
      + prometheusQuery.withLegendFormat('%s - failure' % utils.labelsToPanelLegend(testNameLabel)),

    redirectionsNodeName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_redirections_count{%(nodeNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),

    imageLoadedBySizeNodeName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_image_content_type{%(nodeNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('image'),

    scriptLoadedBySizeNodeName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_script_content_type{%(nodeNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('script'),

    htmlLoadedBySizeNodeName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_html_content_type{%(nodeNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('html'),

    cssLoadedBySizeNodeName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_css_content_type{%(nodeNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('css'),

    fontLoadedBySizeNodeName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_font_content_type{%(nodeNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('font'),

    xmlLoadedBySizeNodeName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_xml_content_type{%(nodeNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('xml'),

    mediaLoadedBySizeNodeName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_media_content_type{%(nodeNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('media'),

    imageLoadedByTypeNodeName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_image_count{%(nodeNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('image'),

    scriptLoadedByTypeNodeName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_script_count{%(nodeNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('script'),

    htmlLoadedByTypeNodeName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_html_count{%(nodeNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('html'),

    cssLoadedByTypeNodeName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_css_count{%(nodeNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('css'),

    fontLoadedByTypeNodeName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_font_count{%(nodeNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('font'),

    xmlLoadedByTypeNodeName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_xml_count{%(nodeNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('xml'),

    mediaLoadedByTypeNodeName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (node_name) (catchpoint_media_count{%(nodeNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('media'),

    errorsNodeName:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (test_name) (catchpoint_any_error{%(nodeNameSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(testNameLabel)),
  },
}
