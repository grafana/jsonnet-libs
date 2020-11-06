package dashboards

import (
	"github.com/jdbaldry/haproxy-mixin/grafana"
	"github.com/jdbaldry/haproxy-mixin/grafana/panel"
)

// I didn't find this panel to be of use in my specific dashboard where no cache lookups were made but it's left here as an example.
cacheSuccess: panel.#Graph & {
	title:       "Cache success"
	description: "Percentage of HTTP cache hits."
	fieldConfig: defaults: unit: "reqps"
	targets: [{
		expr:  """
					rate(haproxy_frontend_http_cache_lookups_total{\(_frontendMatchers)}[5m])
					/
					rate(haproxy_frontend_http_cache_hits_total{\(_frontendMatchers)}[5m])
				"""
		refId: "A"
	}]
	yaxes: [{min: 0}, {min: 0}]
}

requestErrors: panel.#Graph & {
	title:       "Requests"
	datasource:  "prometheus"
	description: "Request errors per second"
	targets: [ {
		expr:  "rate(haproxy_frontend_request_errors_total{\(_frontendMatchers)}[$__rate_interval])"
		refId: "a"
	},
	]
	stack: true
	yaxes: [{min: 0}, {min: 0}]
}

httpRequestsPerSecond: panel.#Graph & {
	title:       "HTTP"
	description: "HTTP requests per second"
	fieldConfig: defaults: unit: "reqps"
	targets: [{
		expr:  "rate(haproxy_frontend_http_requests_total{\(_frontendMatchers)}[$__rate_interval])"
		refId: "A"
	}]
	yaxes: [{min: 0}, {min: 0}]
}

connectionsPerSecond: panel.#Graph & {
	title:       "Connections"
	description: "Connections per second"
	fieldConfig: defaults: unit: "connps"
	targets: [{
		expr:  "rate(haproxy_frontend_connections_total{\(_frontendMatchers)}[$__rate_interval])"
		refId: "A"
	}]
	yaxes: [{min: 0}, {min: 0}]
}

internalErrors: panel.#Graph & {
	title:       "Internal"
	datasource:  "prometheus"
	description: "Internal errors per second"
	targets: [{
		expr:  "rate(haproxy_frontend_internal_errors_total{\(_frontendMatchers)}[$__rate_interval])"
		refId: "A"
	}]
	stack: true
	yaxes: [{min: 0}, {min: 0}]
}

frontendBytes: panel.#Graph & {
	title: "Bytes in/out"
	fieldConfig: defaults: unit: "bytes"
	targets: [
		{
			expr:         "rate(haproxy_frontend_bytes_in_total{\(_frontendMatchers)}[$__rate_interval])"
			refId:        "A"
			legendFormat: "in{\(_frontendMatchers)}"
		},
		{
			expr:         "rate(haproxy_frontend_bytes_out_total{\(_frontendMatchers)}[$__rate_interval])"
			refId:        "B"
			legendFormat: "out{\(_frontendMatchers)}"
		},
	]
	seriesOverrides: [{alias: "/.*out.*/", transform: "negative-Y"}]
}

let requests = _board & {
	_panelSize: {h: 6, w: 8}
	row: panel.#Row & {
		title:     "Requests"
		collapsed: false
	}
	panels: [ for panel in [httpRequestsPerSecond, connectionsPerSecond, frontendBytes] {panel & {datasource: "prometheus"}}]
}

let errors = _board & {
	_origin: y: 6
	_panelSize: {h: 6, w: 8}
	row: panel.#Row & {
		title:     "Errors"
		collapsed: false
	}
	panels: [ for panel in [requestErrors, internalErrors] {panel & {datasource: "prometheus"}}]
}

{
	dashboards: "haproxy-frontend.json": {
		title: "HAProxy / Frontend"
		uid:   "HAProxyFrontend"
		panels:
			[requests.row] +
			[ for i, panel in requests.panels {
				panel & {
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
