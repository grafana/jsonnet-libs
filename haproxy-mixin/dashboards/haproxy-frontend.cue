package dashboards

import (
	"github.com/jdbaldry/haproxy-mixin/grafana"
	"github.com/jdbaldry/haproxy-mixin/grafana/panel"
)

let requests = _section & {
	_panelSize: {h: 6, w: 8}
	row: panel.#Row & {
		id:        100
		title:     "Requests"
		collapsed: false
	}
	panels: [httpRequestsPerSecond, connectionsPerSecond, frontendBytes]
}

let errors = _section & {
	_origin: y: 6
	_panelSize: {h: 6, w: 8}
	row: panel.#Row & {
		id:        200
		title:     "Errors"
		collapsed: false
	}
	panels: [requestErrors, internalErrors]
}

{
	dashboards: "haproxy-frontend.json": {
		title: "HAProxy / Frontend"
		uid:   "HAProxyFrontend"
		panels:
			[requests.row] +
			[ for i, panel in requests.panels {
				panel & {
					id: requests.row.id + (i + 1)
					gridPos: {
						x: requests._origin.x + i*requests._panelSize.w
						y: requests._origin.y + (i * requests._panelSize.w div _dashboardWidth * requests._panelSize.h)
						w: requests._panelSize.w
						h: requests._panelSize.h
					}
				}
			},
			] +
			[errors.row] +
			[ for i, panel in errors.panels {
				panel & {
					id: errors.row.id + (i + 1)
					gridPos: {
						x: errors._origin.x + i*errors._panelSize.w
						y: errors._origin.y + (i * errors._panelSize.w div _dashboardWidth * errors._panelSize.h)
						w: errors._panelSize.w
						h: errors._panelSize.h
					}
				}
			},
			]
		templating: {
			list: [
				grafana.Template & {
					name:  "datasource"
					query: "prometheus"
					type:  "datasource"
				},
				grafana.#QueryTemplate & {
					name:       "instance"
					datasource: "prometheus"
					definition: "label_values(haproxy_process_start_time_seconds, instance)"
					includeAll: true
					multi:      true
					query:      "label_values(haproxy_process_start_time_seconds, instance)"
				},
				grafana.#QueryTemplate & {
					name:       "job"
					datasource: "prometheus"
					definition: "label_values(haproxy_process_start_time_seconds, job)"
					includeAll: true
					multi:      true
					query:      "label_values(haproxy_process_start_time_seconds, job)"
				},
				grafana.#QueryTemplate & {
					name:       "frontend"
					datasource: "prometheus"
					definition: "label_values(haproxy_frontend_status, proxy)"
					includeAll: true
					multi:      true
					query:      "label_values(haproxy_frontend_status, proxy)"
				},
			]
		}
	}
}
