package dashboards

import (
	"github.com/jdbaldry/haproxy-mixin/grafana"
)

let serverRequests = #_section & {
	_panelSize: {h: 6, w: 8}
	_row: {id: 100, title: "Requests"}
	_panels: [serverHTTPResponsesPerSecond, serverConnectionsPerSecond, serverBytes]
}

let serverErrors = #_section & {
	_origin: y: 6
	_panelSize: {h: 6, w: 8}
	_row: {id: 200, title: "Errors"}
	_panels: [serverResponseErrors, serverConnectionErrors, serverInternalErrors]
}

let serverDuration = #_section & {
	_origin: y: 12
	_panelSize: {h: 6, w: 8}
	_row: {id: 300, title: "Duration"}
	_panels: [serverAverageDuration, serverMaxDuration]
}

{
	dashboards: "haproxy-server.json": {
		title: "HAProxy / Server"
		uid:   "HAProxyServer"
		panels:
			serverRequests.panels
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
