# Change this to fetch a different revision of the dashboard from the library.
DASHBOARD_REV := 14
JSONNET_FMT := jsonnetfmt -n 2 --max-blank-lines 1 --string-style s --comment-style s

.PHONY: all
all: build dashboards_out

vendor:
	mkdir -p dashboards || true
	rm -rf dashboards/nginx-overview.json
	curl https://grafana.com/api/dashboards/12559/revisions/$(DASHBOARD_REV)/download -o dashboards/nginx-overview.json	

.PHONY: build
build: vendor

.PHONY: fmt
fmt:
	find . -name 'vendor' -prune -o -name '*.libsonnet' -print -o -name '*.jsonnet' -print | \
		xargs -n 1 -- $(JSONNET_FMT) -i

.PHONY: lint
lint: build
	find . -name 'vendor' -prune -o -name '*.libsonnet' -print -o -name '*.jsonnet' -print | \
		while read f; do \
			$(JSONNET_FMT) "$$f" | diff -u "$$f" -; \
		done
	mixtool lint mixin.libsonnet

dashboards_out: mixin.libsonnet config.libsonnet $(wildcard dashboards/*)
	@mkdir -p dashboards_out
	mixtool generate dashboards mixin.libsonnet -d dashboards_out

.PHONY: clean
clean:
	rm -rf dashboards_out
