package dashboards

import (
	"github.com/jdbaldry/haproxy-mixin/grafana"
)

let servers = #_section & {
	_panelSize: {w: _dashboardWidth, h: 6}
	_row: {id: 100, title: "Servers"}
	_panels: [serverTable]
}

let backendRequests = #_section & {
	_panelSize: {h: 6, w: 8}
	_origin: y: 6
	_row: {id: 200, title: "Requests"}
	_panels: [backendHTTPRequestsPerSecond, backendConnectionsPerSecond, backendBytes]
}

let backendErrors = #_section & {
	_origin: y: 12
	_panelSize: {h: 6, w: 8}
	_row: {id: 300, title: "Errors"}
	_panels: [backendConnectionErrors, backendInternalErrors]
}

let backendDuration = #_section & {
	_origin: y: 12
	_panelSize: {h: 6, w: 8}
	_row: {id: 400, title: "Duration"}
	_panels: [backendAverageDuration, backendMaxDuration]
}

{
	dashboards: "haproxy-backend.json": {
		title: "HAProxy / Backend"
		uid:   "HAProxyBackend"
		panels:
			servers.panels +
			backendRequests.panels +
			backendErrors.panels +
			backendDuration.panels
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
