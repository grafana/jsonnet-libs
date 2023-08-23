JSONNET_FMT := jsonnetfmt -n 2 --max-blank-lines 2 --string-style s --comment-style s
SHELL := /bin/bash

install-ci-deps:
	go install github.com/google/go-jsonnet/cmd/jsonnet@v0.20.0
	go install github.com/google/go-jsonnet/cmd/jsonnetfmt@v0.20.0
	go install github.com/google/go-jsonnet/cmd/jsonnet-lint@v0.20.0
	go install github.com/monitoring-mixins/mixtool/cmd/mixtool@44b4f22e0b5f1af611743503da95d2c64d0e71d3
	go install github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@v0.4.0

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
	for d in $$(find . -name '*-mixin' -a -type d -print); do \
		if [ -e "$$d/jsonnetfile.json" ]; then \
			echo "Installing dependencies for $$d"; \
			pushd "$$d" >/dev/null && jb install && popd >/dev/null; \
		fi; \
	done; \
	for m in $$(find . -maxdepth 2 -name 'mixin.libsonnet' -print); do \
			echo "Linting mixin $$m"; \
			mixtool lint -J $$(dirname "$$m")/vendor "$$m"; \
			if [ $$? -ne 0 ]; then \
				RESULT=1; \
			fi; \
	done; \
	exit $$RESULT

drone:
	drone jsonnet --stream --source .drone/drone.jsonnet --target .drone/drone.yml --format yaml
	drone lint .drone/drone.yml
	drone sign --save grafana/jsonnet-libs .drone/drone.yml || echo "You must set DRONE_SERVER and DRONE_TOKEN"
