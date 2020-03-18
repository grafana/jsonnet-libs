JSONNET_FMT := jsonnetfmt -n 2 --max-blank-lines 2 --string-style s --comment-style s

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
		exit $$RESULT
