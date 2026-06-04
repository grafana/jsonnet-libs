local g = import './g.libsonnet';

{
  new(panels):
    {
      overview:
        g.panel.row.new('Scrape overview')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels(
          [
            panels.logo { gridPos: { w: 5, h: 4 } },
            panels.samplesScraped { gridPos: { w: 19, h: 4 } },
            panels.description { gridPos: { w: 5, h: 9 } },
            panels.topCardinality { gridPos: { w: 19, h: 9 } },
            panels.scrapeStatus { gridPos: { w: 24, h: 9 } },
            panels.scrapeDuration { gridPos: { w: 24, h: 9 } },
          ]
        ),
    },
}
