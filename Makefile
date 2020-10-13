JSONNET_FMT := jsonnetfmt -n 2 --max-blank-lines 2 --string-style s --comment-style s
SHELL := /bin/bash

fmt:
		@find . -name '*.libsonnet' -print -o -name '*.jsonnet' -print | \
				xargs -n 1 -- $(JSONNET_FMT) -i

lint:
		@RESULT=0; \
		for f in $$(find . -name '*.libsonnet' -print -o -name '*.jsonnet' -print); do \
				$(JSONNET_FMT) -- "$$f" | diff -u "$$f" -; \
				if [ $$? -ne 0 ]; then \
					RESULT=1; \
				fi; \
		done; \
		for d in $$(find . -name '*-mixin' -a -type d -print); do \
			if [ -e "$$d/jsonnetfile.json" ]; then \
				echo "Installing dependencies for $$d"; \
				pushd "$$d" >/dev/null && jb install && popd >/dev/null; \
			fi; \
		done; \
		for m in $$(find . -name 'mixin.libsonnet' -print); do \
				echo "Linting $$m"; \
				mixtool lint -J $$(dirname "$$m")/vendor "$$m"; \
				if [ $$? -ne 0 ]; then \
					RESULT=1; \
				fi; \
		done; \
		exit $$RESULT
