JSONNET_FMT := jsonnetfmt -n 2 --max-blank-lines 2 --string-style s --comment-style s
SHELL := /usr/bin/env bash
PROMTOOL_VERSION := 3.2.0

# Detect OS and architecture
UNAME_S := $(shell uname -s | tr '[:upper:]' '[:lower:]')
UNAME_M := $(shell uname -m)

# Map architecture names
ifeq ($(UNAME_M),x86_64)
    ARCH := amd64
else ifeq ($(UNAME_M),aarch64)
    ARCH := arm64
else ifeq ($(UNAME_M),armv7l)
    ARCH := armv7
else
    ARCH := $(UNAME_M)
endif

# Check if .github/workflows/*.yml need to be updated
# when changing the install-ci-deps target.
install-ci-deps: install-promtool
	go install github.com/google/go-jsonnet/cmd/jsonnet@v0.20.0
	go install github.com/google/go-jsonnet/cmd/jsonnetfmt@v0.20.0
	go install github.com/google/go-jsonnet/cmd/jsonnet-lint@v0.20.0
	go install github.com/monitoring-mixins/mixtool/cmd/mixtool@main
	go install github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@v0.5.1
	go install github.com/grafana/grizzly/cmd/grr@latest
	go install github.com/cloudflare/pint/cmd/pint@v0.70.0

.PHONY: install-promtool
install-promtool:
	@echo "Installing promtool $(PROMTOOL_VERSION) for $(UNAME_S)/$(ARCH)..."
	@wget https://github.com/prometheus/prometheus/releases/download/v$(PROMTOOL_VERSION)/prometheus-$(PROMTOOL_VERSION).$(UNAME_S)-$(ARCH).tar.gz
	@mkdir -p prometheus-$(PROMTOOL_VERSION).$(UNAME_S)-$(ARCH)
	@tar xvf prometheus-$(PROMTOOL_VERSION).$(UNAME_S)-$(ARCH).tar.gz
	@sudo mv prometheus-$(PROMTOOL_VERSION).$(UNAME_S)-$(ARCH)/promtool /usr/local/bin/
	@rm -rf prometheus-$(PROMTOOL_VERSION).$(UNAME_S)-$(ARCH) prometheus-$(PROMTOOL_VERSION).$(UNAME_S)-$(ARCH).tar.gz
	@echo "promtool $(PROMTOOL_VERSION) installed successfully"

fmt:
	@find . -name '*.libsonnet' -print -o -name '*.jsonnet' -print | \
			xargs -n 1 -- $(JSONNET_FMT) -i

lint-fmt:
	@RESULT=0; \
	for f in $$(find . -name '*.libsonnet' -print -o -name '*.jsonnet' -print); do \
			$(JSONNET_FMT) -- "$$f" | diff -u "$$f" -; \
			if [ $$? -ne 0 ]; then \
				RESULT=1; \
			fi; \
	done; \
	exit $$RESULT

lint-mixins:
	@RESULT=0; \
	for d in $$(find . -maxdepth 1 -regex '.*-mixin\|.*-lib' -a -type d -print); do \
		echo "=== Linting mixin: $$d ==="; \
		if [ -e "$$d/jsonnetfile.json" ]; then \
			echo "Installing dependencies..."; \
			pushd "$$d" >/dev/null && jb install && popd >/dev/null; \
		fi; \
		if [ -e "$$d/mixin.libsonnet" ]; then \
			echo "Running mixtool lint..."; \
			mixtool lint -J "$$d/vendor" "$$d/mixin.libsonnet"; \
			if [ $$? -ne 0 ]; then \
				RESULT=1; \
			fi; \
		fi; \
		if [ -d "$$d/prometheus_rules_out" ]; then \
			echo "Running pint..."; \
			pint lint --min-severity=info --fail-on=warning "$$d/prometheus_rules_out/"; \
			if [ $$? -ne 0 ]; then \
				RESULT=1; \
			fi; \
		fi; \
	done; \
	exit $$RESULT

update-mixins:
	@for d in $$(find . -maxdepth 1 -regex '.*-mixin\|.*-lib' -a -type d -print); do \
		if [ -e "$$d/jsonnetfile.json" ]; then \
			echo "Updating dependencies for $$d"; \
			pushd "$$d" >/dev/null && jb update && popd >/dev/null; \
		fi; \
	done

tests:
	pushd . && cd ./common-lib && make vendor && make tests
	pushd . && cd ./grafana-builder/test && make tests
	pushd . && cd ./mixin-utils/test && make tests
