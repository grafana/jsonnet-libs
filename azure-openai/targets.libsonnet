local g = import './g.libsonnet';
local prometheusQuery = g.query.prometheus;
local lokiQuery = g.query.loki;

{
  new(this): {
    local vars = this.grafana.variables,
    local config = this.config,

    lokiQuery1:
      lokiQuery.new(
        '${' + vars.datasources.loki.name + '}',
        '{%(queriesSelector)s, level=~"error|Error"} |= "searchstring"' % vars
      ),
    uptime1:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'uptime{%(queriesSelector)s}*1000 > $__from < $__to' % vars
      ),
    totalCalls:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'azure_microsoft_cognitiveservices_accounts_totalcalls_total_count{%(queriesSelector)s}' % vars
      ),
    successfulCalls:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'azure_microsoft_cognitiveservices_accounts_successfulcalls_total_count{%(queriesSelector)s}' % vars
      ),
    successRate:
    prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'azure_microsoft_cognitiveservices_accounts_successrate_average_percent{%(queriesSelector)s}' % vars
      ),
    totalErrors:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'azure_microsoft_cognitiveservices_accounts_totalerrors_total_count{%(queriesSelector)s}' % vars
      ),
    errorsRate:
    prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '( azure_microsoft_cognitiveservices_accounts_totalerrors_total_count{%(queriesSelector)s} / azure_microsoft_cognitiveservices_accounts_successfulcalls_total_count{%(queriesSelector)s} ) * 100' % vars
      ),
    generatedTokens:
    prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'azure_microsoft_cognitiveservices_accounts_generatedtokens_total_count{%(queriesSelector)s}' % vars
      ),
    tokenTransactions:
    prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'azure_microsoft_cognitiveservices_accounts_tokentransaction_total_count{%(queriesSelector)s}' % vars
      ),
    processedPromptTokens:
    prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'azure_microsoft_cognitiveservices_accounts_processedprompttokens_total_count{%(queriesSelector)s}' % vars
      ),
    processedInferenceTokens:
    prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'azure_microsoft_cognitiveservices_accounts_processedprompttokens_total_count{%(queriesSelector)s}' % vars
      ),
    rateLimitedCalls:
    prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'azure_microsoft_cognitiveservices_accounts_ratelimit_total_count{%(queriesSelector)s}' % vars
      ),
    blockedCalls:
    prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'azure_microsoft_cognitiveservices_accounts_blockedcalls_total_count{%(queriesSelector)s}' % vars
      ),
    clientErrors:
    prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'azure_microsoft_cognitiveservices_accounts_clienterrors_total_count{%(queriesSelector)s}' % vars
      ),
    fineTunedTrainingHours:
    prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'azure_microsoft_cognitiveservices_accounts_blockedcalls_total_count{%(queriesSelector)s}' % vars
      ),
    dataIn:
    prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'azure_microsoft_cognitiveservices_accounts_datain_total_bytes{%(queriesSelector)s}' % vars
      ),
    dataOut:
    prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'azure_microsoft_cognitiveservices_accounts_dataout_total_bytes{%(queriesSelector)s}' % vars
      ),
    metric2:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'metric2{%(queriesSelector)s}' % vars
      ),
    metric3:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '100 - (avg without (mode,core) (rate(metric3{mode="idle", %(queriesSelector)s}[$__rate_interval])*100))' % vars
      )
      + prometheusQuery.withLegendFormat('CPU usage'),

    // add more metrics or loki queries as targets below:

  },
}
