// Configuration common to all dashboards. Also defines the output structure.
package dashboards

import (
	"github.com/jdbaldry/haproxy-mixin/grafana"
	"github.com/jdbaldry/haproxy-mixin/grafana/panel"
)

_dashboardWidth: 24

// Sections is used to group multiple panels with common dimensions under a single uncollapsed row.
// _origin defines the start x and y grid positions for the section. Grafana grid positions are not absolute and therefore a section and its panels will gravitate towards the origin of the dashboard if there are no other panels in the way.
// _panelSize defines the width and height of all grouped panels.
#_section: {
	_origin: {x: int | *0, y: int | *0}
	_panelSize: {h: int | *4, w: int | *6}
	_row: panel.#Row & {
		collapsed: false
		gridPos: {x: _origin.x, y: _origin.y}
	}
	_panels: [...panel.Base]
	panels: [_row] + [ for i, panel in _panels {
		panel & {
			id: _row.id + (i + 1)
			gridPos: {
				x: _origin.x + i*_panelSize.w
				y: _origin.y + (i * _panelSize.w div _dashboardWidth * _panelSize.h)
				w: _panelSize.w
				h: _panelSize.h
			}
		}
	},
	]
}

{
	dashboards: [File=string]: grafana.#Dashboard
}
