// Configuration common to all dashboards. Also defines the output structure.
package dashboards

import (
	"github.com/jdbaldry/haproxy-mixin/grafana"
	"github.com/jdbaldry/haproxy-mixin/grafana/panel"
)

_dashboardWidth: 24

_instanceMatcher:  "instance=~\"$instance\""
_jobMatcher:       "job=~\"$job\""
_frontendMatcher:  "proxy=~\"$frontend\""
_backendMatcher:   "proxy=~\"$backend\""
_serverMatcher:    "server=~\"$server\""
_baseMatchers:     "\(_instanceMatcher),\(_jobMatcher)"
_frontendMatchers: "\(_baseMatchers),\(_frontendMatcher)"
_backendMatchers:  "\(_baseMatchers),\(_backendMatcher)"
_serverMatchers:   "\(_baseMatchers),\(_backendMatcher),\(_serverMatcher)"

_statPanel: panel.#Stat & {datasource: "prometheus"}

_board: {
	_origin: {x: int | *0, y: int | *0}
	_panelSize: {h: int | *4, w: int | *6}
	row: panel.#Row & {
		gridPos: {x: _origin.x, y: _origin.y}
	}
	panels: [...panel.Base]
}

{
	dashboards: [File=string]: grafana.#Dashboard
}
