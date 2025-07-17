JSONNET_VENDOR=vendor
DASHBOARDS_OUT_DIR ?=dashboards_out
JSONNET_FMT := jsonnetfmt -n 2 --max-blank-lines 2 --string-style s --comment-style s

.PHONY: all
all: fmt generate lint

.PHONY: generate
generate: prometheus_alerts.yaml prometheus_rules.yaml $(DASHBOARDS_OUT_DIR)

.PHONY: fmt
fmt:
	find . -name 'vendor' -prune -o -name '*.libsonnet' -print -o -name '*.jsonnet' -print | \
		xargs -n 1 -- jsonnetfmt -i

.PHONY: lint
lint: jsonnet-lint alerts-lint dashboards-lint

.PHONY: jsonnet-lint
jsonnet-lint:
	@find . -name 'vendor' -prune -o -name '*.libsonnet' -print -o -name '*.jsonnet' -print | \
		xargs -n 1 -- jsonnet-lint -J vendor

.PHONY: alerts-lint
alerts-lint: prometheus_alerts.yaml prometheus_rules.yaml
	promtool check rules prometheus_rules.yaml
	promtool check rules prometheus_alerts.yaml

.PHONY: dashboards-lint
dashboards-lint:
	@find $(DASHBOARDS_OUT_DIR) -name '*.json' -print0 | xargs -n 1 -0 dashboard-linter lint --strict

.PHONY: prometheus_alerts.yaml
prometheus_alerts.yaml: mixin.libsonnet config.libsonnet alerts/*.libsonnet
	jsonnet -S alerts.jsonnet >$@

.PHONY: prometheus_rules.yaml
prometheus_rules.yaml: mixin.libsonnet config.libsonnet rules/*.libsonnet
	jsonnet -S rules.jsonnet >$@


.PHONY: dashboards_out
dashboards_out: mixin.libsonnet config.libsonnet dashboards/*.libsonnet
	@mkdir -p dashboards_out
	cp .lint dashboards_out/.lint
	jsonnet -J vendor -m dashboards_out dashboards.jsonnet

.PHONY: clean
clean:
	rm -rf prometheus_alerts.yaml prometheus_rules.yaml dashboards_out

.PHONY: jb_install
jb_install:
	jb install
