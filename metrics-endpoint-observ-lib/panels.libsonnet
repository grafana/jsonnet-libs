local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(signals, parentIntegration):
    {
      logo: g.panel.text.new('')
            + g.panel.text.panelOptions.withTransparent(true)
            + g.panel.text.options.withContent(|||
              <div style="width: 100%%; height: 100%%; display: flex; justify-content: center; align-items: center;">
                <img
                   style="width:auto;height:100%%"
                   src="%s">
              </div>
            ||| % parentIntegration.logoURL),
      description: g.panel.text.new('')
                   + g.panel.text.panelOptions.withTransparent(true)
                   + g.panel.text.options.withContent(|||
                     # Metrics scrape dashboard
                     This dashboard helps you analyze scrape metadata for the [%(name)s integration](https://grafana.com/docs/grafana-cloud/monitor-infrastructure/integrations/integration-reference/integration-%(id)s/).
                     It can help you debug issues with metrics not arriving or unexpected cardinality.

                     For metrics on %(name)s itself, refer to the [other dashboards provided by this integration](/dashboards/f/integration---%(id)s).
                   ||| % parentIntegration),
      scrapeStatus: g.panel.stateTimeline.new('Scrape status')
                    + g.panel.stateTimeline.queryOptions.withTargets([signals.scrapeStatus.asTarget()])
                    + g.panel.stateTimeline.standardOptions.withMin(0)
                    + g.panel.stateTimeline.standardOptions.withMappings([
                      g.panel.stateTimeline.standardOptions.mapping.ValueMap.withType()
                      + g.panel.stateTimeline.standardOptions.mapping.ValueMap.withOptions({
                        '0': {
                          text: 'Error',
                          index: 1,
                          color: commonlib.tokens.base.colors.palette.errors,
                        },
                        '1': {
                          text: 'Ok',
                          index: 0,
                          color: commonlib.tokens.base.colors.palette.ok,
                        },
                      }),
                    ])
      ,
      samplesScraped: signals.samplesScraped.asStat()
                      + commonlib.panels.generic.stat.base.stylize()
      ,
      topCardinality: signals.topCardinality.asTimeSeries()
                      + commonlib.panels.generic.timeSeries.base.stylize()
                      + g.panel.timeSeries.options.legend.withDisplayMode('table')
                      + g.panel.timeSeries.options.legend.withPlacement('right')
                      + g.panel.timeSeries.options.legend.withCalcs(['lastNotNull'])
      ,
      scrapeDuration: signals.scrapeDuration.asTimeSeries()
                      + commonlib.panels.generic.timeSeries.base.stylize(),
    },
}
