.PHONY: generate test clean

generate:
	cd ./schema && cue exp gengotypes && mv cue_types_gen.go ../gen/go/cue_types_gen.go

# Optional: add a clean target to remove generated files
clean:
	rm -f ./gen/go/gen/cue_types_gen.go

test:
	@echo "Running CUE validation tests..."
	@echo "Testing valid files (should pass):"
	@for file in ./schema/tests/test_*_ok.json; do \
		if [ -f "$$file" ]; then \
			echo "  Testing $$file (should pass)"; \
			if cue vet ./schema/*.cue "$$file"; then \
				echo "    ✓ PASS: $$file"; \
			else \
				echo "    ✗ FAIL: $$file (expected to pass)"; \
				exit 1; \
			fi; \
		fi; \
	done
	@echo "Testing invalid files (should fail):"
	@for file in ./schema/tests/test_*_bad.json; do \
		if [ -f "$$file" ]; then \
			echo "  Testing $$file (should fail)"; \
			if cue vet ./schema/*.cue "$$file" 2>/dev/null; then \
				echo "    ✗ FAIL: $$file (expected to fail but passed)"; \
				exit 1; \
			else \
				echo "    ✓ PASS: $$file (correctly failed validation)"; \
			fi; \
		fi; \
	done
	@echo "All tests completed successfully!"
