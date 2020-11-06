package dashboards

import (
	"github.com/jdbaldry/haproxy-mixin/grafana"
	"github.com/jdbaldry/haproxy-mixin/grafana/panel"
)

let servers = _section & {
	_panelSize: {w: _dashboardWidth, h: 6}
	row: {
		id:        100
		title:     "Servers"
		collapsed: false
	}
	panels: [serverTable]
}

let backendRequests = _section & {
	_panelSize: {h: 6, w: 8}
	_origin: y: 6
	row: panel.#Row & {
		id:        200
		title:     "Requests"
		collapsed: false
	}
	panels: [backendHTTPRequestsPerSecond, backendConnectionsPerSecond, backendBytes]
}

let backendErrors = _section & {
	_origin: y: 12
	_panelSize: {h: 6, w: 8}
	row: panel.#Row & {
		id:        300
		title:     "Errors"
		collapsed: false
	}
	panels: [backendConnectionErrors, backendInternalErrors]
}

let backendDuration = _section & {
	_origin: y: 12
	_panelSize: {h: 6, w: 8}
	row: panel.#Row & {
		id:        400
		title:     "Duration"
		collapsed: false
	}
	panels: [backendAverageDuration, backendMaxDuration]
}

{
	dashboards: "haproxy-backend.json": {
		title: "HAProxy / Backend"
		uid:   "HAProxyBackend"
		panels:
			[servers.row] +
			[ for i, panel in servers.panels {
				panel & {
					id: servers.row.id + (i + 1)
					gridPos: {
						x: servers._origin.x + i*servers._panelSize.w
						y: servers._origin.y + (i * servers._panelSize.w div _dashboardWidth * servers._panelSize.h)
						w: servers._panelSize.w
						h: servers._panelSize.h
					}
				}
			},
			] +
			[backendRequests.row] +
			[ for i, panel in backendRequests.panels {
				panel & {
					id: backendRequests.row.id + (i + 1)
					gridPos: {
						x: backendRequests._origin.x + i*backendRequests._panelSize.w
						y: backendRequests._origin.y + (i * backendRequests._panelSize.w div _dashboardWidth * backendRequests._panelSize.h)
						w: backendRequests._panelSize.w
						h: backendRequests._panelSize.h
					}
				}
			},
			] +
			[backendErrors.row] +
			[ for i, panel in backendErrors.panels {
				panel & {
					id: backendErrors.row.id + (i + 1)
					gridPos: {
						x: backendErrors._origin.x + i*backendErrors._panelSize.w
						y: backendErrors._origin.y + (i * backendErrors._panelSize.w div _dashboardWidth * backendErrors._panelSize.h)
						w: backendErrors._panelSize.w
						h: backendErrors._panelSize.h
					}
				}
			},
			] +
			[backendDuration.row] +
			[ for i, panel in backendDuration.panels {
				panel & {
					id: backendDuration.row.id + (i + 1)
					gridPos: {
						x: backendDuration._origin.x + i*backendDuration._panelSize.w
						y: backendDuration._origin.y + (i * backendDuration._panelSize.w div _dashboardWidth * backendDuration._panelSize.h)
						w: backendDuration._panelSize.w
						h: backendDuration._panelSize.h
					}
				}
			},
			]
		templating: {
			list: [
				grafana.Template & {
					name:  "datasource"
					query: _datasource
					type:  "datasource"
				},
				grafana.#QueryTemplate & {
					name:       "instance"
					datasource: _datasource
					definition: "label_values(haproxy_process_start_time_seconds, instance)"
					includeAll: true
					multi:      true
					query:      "label_values(haproxy_process_start_time_seconds, instance)"
				},
				grafana.#QueryTemplate & {
					name:       "job"
					datasource: _datasource
					definition: "label_values(haproxy_process_start_time_seconds, job)"
					includeAll: true
					multi:      true
					query:      "label_values(haproxy_process_start_time_seconds, job)"
				},
				grafana.#QueryTemplate & {
					name:       "backend"
					datasource: _datasource
					definition: "label_values(haproxy_backend_status, proxy)"
					includeAll: true
					multi:      true
					query:      "label_values(haproxy_backend_status, proxy)"
				},
			]
		}
	}
}
