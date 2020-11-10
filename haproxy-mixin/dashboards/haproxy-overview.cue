package dashboards

import (
	"github.com/jdbaldry/haproxy-mixin/grafana"
)

let headline = #_section & {
	_panelSize: {h: 3, w: 4}
	_row: {id: 100, title: "Headline"}
	_panels: [uptime, processCurrentConnections, processMemoryAllocated, processMemoryUsed]
}

let frontend = #_section & {
	_origin: {x: 0, y: 3}
	_panelSize: {h: 6, w: _dashboardWidth}
	_row: {id: 200, title: "Frontend"}
	_panels: [frontendTable]
}

let backend = #_section & {
	_origin: {x: 0, y: 9}
	_panelSize: {w: _dashboardWidth, h: 6}
	_row: {id: 300, title: "Backend"}
	_panels: [backendTable]
}

let configuration = #_section & {
	_origin: {x: 0, y: 15}
	_panelSize: {h: 2, w: 3}
	_row: {id: 400, title: "Configuration"}
	_panels: [processCount, processThreads, processConnectionsLimit, processMemoryLimit, processFDLimit, processSocketLimit]
}

{
	dashboards: "haproxy-overview.json": {
		title: "HAProxy / Overview"
		uid:   "HAProxyOverview"
		panels:
			configuration.panels
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

			]
		}
	}
}
