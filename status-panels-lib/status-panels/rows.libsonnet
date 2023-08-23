local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local row = g.row;

function(
  title,
  panels,
)
  {
    local this = self,
    statusPanelRow:
      row.new(title)
      + row.withPanels(panels),
  }
