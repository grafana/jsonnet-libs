.PHONY: build clean lint fmt test dashboards alerts vendor

JSONNET_FMT := jsonnetfmt -n 2 --max-blank-lines 2 --string-style s --comment-style s
JSONNET_LINT := jsonnet-lint -J vendor

all: build

build: vendor dashboards alerts

clean:
	rm -rf dashboards_out/* prometheus_rules_out/*

vendor:
	jb install

dashboards: vendor
	@mkdir -p dashboards_out
	jsonnet -J vendor -m dashboards_out -e '(import "mixin.libsonnet").grafanaDashboards'

alerts: vendor
	@mkdir -p prometheus_rules_out
	jsonnet -J vendor -S -e 'std.manifestYamlDoc((import "mixin.libsonnet").prometheusAlerts)' > prometheus_rules_out/prometheus_alerts.yaml

fmt:
	find . -name 'vendor' -prune -o -name '*.libsonnet' -print -o -name '*.jsonnet' -print | \
		xargs -n 1 -- $(JSONNET_FMT) -i

lint: vendor
	find . -name 'vendor' -prune -o -name '*.libsonnet' -print -o -name '*.jsonnet' -print | \
		xargs -n 1 -- $(JSONNET_LINT)

test: lint build
	@echo "Tests passed!"
