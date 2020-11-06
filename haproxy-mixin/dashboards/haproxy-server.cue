package dashboards

import (
	"github.com/jdbaldry/haproxy-mixin/grafana"
	"github.com/jdbaldry/haproxy-mixin/grafana/panel"
)

let serverRequests = _section & {
	_panelSize: {h: 6, w: 8}
	row: panel.#Row & {
		id:        100
		title:     "Requests"
		collapsed: false
	}
	panels: [serverHTTPResponsesPerSecond, serverConnectionsPerSecond, serverBytes]
}

let serverErrors = _section & {
	_origin: y: 6
	_panelSize: {h: 6, w: 8}
	row: panel.#Row & {
		id:        200
		title:     "Errors"
		collapsed: false
	}
	panels: [serverResponseErrors, serverConnectionErrors, serverInternalErrors]
}

let serverDuration = _section & {
	_origin: y: 12
	_panelSize: {h: 6, w: 8}
	row: panel.#Row & {
		id:        300
		title:     "Duration"
		collapsed: false
	}
	panels: [serverAverageDuration, serverMaxDuration]
}

{
	dashboards: "haproxy-server.json": {
		title: "HAProxy / Server"
		uid:   "HAProxyServer"
		panels:
			[serverRequests.row] +
			[ for i, panel in serverRequests.panels {
				panel & {
					id: serverRequests.row.id + (i + 1)
					gridPos: {
						x: serverRequests._origin.x + i*serverRequests._panelSize.w
						y: serverRequests._origin.y + (i * serverRequests._panelSize.w div _dashboardWidth * serverRequests._panelSize.h)
						w: serverRequests._panelSize.w
						h: serverRequests._panelSize.h
					}
				}
			},
			] +
			[serverErrors.row] +
			[ for i, panel in serverErrors.panels {
				panel & {
					id: serverErrors.row.id + (i + 1)
					gridPos: {
						x: serverErrors._origin.x + i*serverErrors._panelSize.w
						y: serverErrors._origin.y + (i * serverErrors._panelSize.w div _dashboardWidth * serverErrors._panelSize.h)
						w: serverErrors._panelSize.w
						h: serverErrors._panelSize.h
					}
				}
			},
			] +
			[serverDuration.row] +
			[ for i, panel in serverDuration.panels {
				panel & {
					id: serverDuration.row.id + (i + 1)
					gridPos: {
						x: serverDuration._origin.x + i*serverDuration._panelSize.w
						y: serverDuration._origin.y + (i * serverDuration._panelSize.w div _dashboardWidth * serverDuration._panelSize.h)
						w: serverDuration._panelSize.w
						h: serverDuration._panelSize.h
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
					name:       "backend"
					datasource: "prometheus"
					definition: "label_values(haproxy_backend_status, proxy)"
					includeAll: true
					multi:      true
					query:      "label_values(haproxy_backend_status, proxy)"
				},
				grafana.#QueryTemplate & {
					name:       "server"
					datasource: "prometheus"
					definition: "label_values(haproxy_server_status, server)"
					includeAll: true
					multi:      true
					query:      "label_values(haproxy_server_status, server)"
				},
			]
		}
	}
}
