JSONNET_FMT := jsonnetfmt -n 2 --max-blank-lines 2 --string-style s --comment-style s

.PHONY: all
all: build dashboards_out prometheus_alerts.yaml prometheus_rules.yaml test

vendor: $(wildcard jsonnetfile.json)
ifneq ("$(wildcard jsonnetfile.json)","")
	jb install
endif

.PHONY: build
build: vendor

.PHONY: fmt
fmt:
	find . -name 'vendor' -prune -o -name '*.libsonnet' -print -o -name '*.jsonnet' -print | \
		xargs -n 1 -- $(JSONNET_FMT) -i

.PHONY: lint
lint: build lint-pint
	@set -e; \
	find . -name 'vendor' -prune -o -name '*.libsonnet' -print -o -name '*.jsonnet' -print | \
		while read f; do \
			$(JSONNET_FMT) "$$f" | diff -u "$$f" - || exit 1; \
		done; \
	mixtool lint mixin.libsonnet

.PHONY: lint-pint
lint-pint: prometheus_alerts.yaml prometheus_rules.yaml
	pint lint --min-severity=info --fail-on=warning prometheus_rules_out/

dashboards_out: mixin.libsonnet $(wildcard **/*.libsonnet) $(wildcard **/*.jsonnet) $(wildcard panels/*) $(wildcard signals/*)
	@mkdir -p dashboards_out
	mixtool generate dashboards mixin.libsonnet -d dashboards_out

prometheus_alerts.yaml: mixin.libsonnet $(wildcard vendor/**/alerts.yaml) $(wildcard alerts/*) $(wildcard vendor/**/alerts.libsonnet) $(wildcard alerts.libsonnet) $(wildcard signals/*)
	@mkdir -p prometheus_rules_out
	@if [ -f alerts.libsonnet -o -d alerts ]; then \
		mixtool generate alerts mixin.libsonnet -a prometheus_rules_out/prometheus_alerts.yaml; \
	else \
		touch prometheus_rules_out/prometheus_alerts.yaml; \
	fi
prometheus_rules.yaml: mixin.libsonnet $(wildcard vendor/**/rules.yaml) $(wildcard rules/*) $(wildcard vendor/**/rules.libsonnet) $(wildcard rules.libsonnet) $(wildcard signals/*) 
	@if [ -f rules.libsonnet -o -d rules ]; then \
		mixtool generate rules mixin.libsonnet -a prometheus_rules_out/prometheus_rules.yaml; \
	else \
		touch prometheus_rules_out/prometheus_rules.yaml; \
	fi

.PHONY: test
test:
	@if [ -f tests/prometheus_*.yaml ]; then \
		echo "Execute promtool tests:"; \
		promtool test rules tests/prometheus_*.yaml; \
	else \
		echo "No tests/prometheus_*.yaml files found, skipping promtool test."; \
	fi

.PHONY: deploy deploy_rules deploy_dashboards
deploy: deploy_rules deploy_dashboards

deploy_dashboards:
ifdef GRAFANA_URL
	grr apply mixin.libsonnet --target "Dashboard.*" --target "DashboardFolder.*"
else
	$(warning GRAFANA_URL is not set, skipping grafana dashboards deployment)
endif

deploy_rules:
ifdef CORTEX_ADDRESS
	grr apply mixin.libsonnet --target "PrometheusRuleGroup.*"
else
	$(warning CORTEX_ADDRESS is not set, skipping prometheus alerts deployment)
endif

.PHONY: clean
clean:
	rm -rf dashboards_out prometheus_rules_out
