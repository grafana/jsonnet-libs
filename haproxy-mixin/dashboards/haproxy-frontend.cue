package dashboards

import (
	"github.com/jdbaldry/haproxy-mixin/grafana"
)

let requests = #_section & {
	_panelSize: {h: 6, w: 8}
	_row: {id: 100, title: "Requests"}
	_panels: [httpRequestsPerSecond, connectionsPerSecond, frontendBytes]
}

let errors = #_section & {
	_origin: y: 6
	_panelSize: {h: 6, w: 8}
	_row: {id: 200, title: "Errors"}
	_panels: [requestErrors, internalErrors]
}

{
	dashboards: "haproxy-frontend.json": {
		title: "HAProxy / Frontend"
		uid:   "HAProxyFrontend"
		panels:
			requests.panels
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
