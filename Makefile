JSONNET_FMT := jsonnetfmt -n 2 --max-blank-lines 2 --string-style s --comment-style s

fmt:
	find . -name '*.libsonnet' -o -name '*.jsonnet' | \
		xargs -n 1 -- $(JSONNET_FMT) -i

lint:
	find . -name '*.libsonnet' -o -name '*.jsonnet' | \
		while read f; do \
			$(JSONNET_FMT) "$$f" | diff -u "$$f" -; \
		done
