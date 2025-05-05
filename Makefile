.PHONY: help serve build check-exif strip-exif strip link-check check-warnings check-drafts lint-inclusive-language preflight ci test format

##@ 🧪 Verification

preflight: build install-htmltest check-exif link-check check-warnings check-drafts lint-inclusive-language ## Run local verification before pushing
	@echo "✅ Preflight checklist complete. Ready for takeoff!"

ci: preflight ## Run all checks exactly as CI does

test: check-exif link-check check-warnings check-drafts ## Run local tests (non-lint)
	@echo "✅ Basic tests complete."

check-exif: ## Run the EXIF metadata checker script
	bash scripts/check-exif.sh

strip-exif: ## Remove EXIF metadata from all images
	STRIP=1 $(MAKE) check-exif

strip: strip-exif ## Alias for strip-exif

link-check: ## Check for broken links using htmltest
	@if [ ! -x ./bin/htmltest ]; then \
	  echo "🔧 htmltest not found. Installing..."; \
	  $(MAKE) install-htmltest; \
	fi
	@./bin/htmltest || echo "⚠️  Link check completed with warnings"

check-warnings: ## Fail if Hugo emits any warnings
	@! hugo --minify 2>&1 | tee /tmp/hugo-build.log | grep -v 'schema_json' | grep -q "^WARN" && echo "✅ No critical Hugo warnings found." || (echo "❌ Hugo warnings detected:" && grep "^WARN" /tmp/hugo-build.log && exit 1)

check-drafts: ## Check for draft content in Git
	@git grep -q 'draft: *true' content && (echo "❌ Draft content detected in repo" && git grep 'draft: *true' content && exit 1) || echo "✅ No draft content committed."

lint-inclusive-language: ## Check for non-inclusive language
	@docker run --rm -v $$(pwd):/src -w /src getwoke/woke woke --exit-1-on-failure || echo "⚠️ Inclusive language check completed"

##@ 🚀 Development

install-htmltest: ## Install htmltest locally into ./bin
	@mkdir -p ./bin
	@set -x; \
	OS=$$(uname -s | tr '[:upper:]' '[:lower:]') && echo "Detected OS: $$OS" && \
	case "$$OS" in \
		linux) ARCHIVE=htmltest-linux-amd64.tar.gz ;; \
		darwin) ARCHIVE=htmltest-darwin-amd64.tar.gz ;; \
		*) echo "❌ Unsupported OS: $$OS" && exit 1 ;; \
	esac && \
	echo "Using archive: $$ARCHIVE" && \
	URL="https://github.com/wjdp/htmltest/releases/latest/download/$$ARCHIVE" && \
	echo "Downloading from URL: $$URL" && \
	curl -sSL -o ./bin/htmltest.tar.gz "$$URL" && \
	ls -l ./bin/htmltest.tar.gz && \
	file ./bin/htmltest.tar.gz && \
	tar -xzf ./bin/htmltest.tar.gz -C ./bin && \
	chmod +x ./bin/htmltest && \
	rm ./bin/htmltest.tar.gz && \
	echo "✅ htmltest installed to ./bin/htmltest"

serve: ## Run Hugo server with drafts and renderToMemory
	hugo serve -D --renderToMemory

build: ## Build the site with minification
	hugo --minify

clean: ## Remove generated files
	rm -rf public/ resources/ .hugo_build.lock


##@ 🧼 Formatting

format: ## Placeholder for future formatting steps (e.g. prettier, black, shfmt)
	@echo "🧼 No formatting configured yet. Add your tools here."

##@ 🆘 Help

help: ## Display this help
	@awk \
		-v "col=\033[36m" -v "nocol=\033[0m" \
		' \
			BEGIN { \
				FS = ":.*##" ; \
				printf "Usage:\n  make %s<target>%s\n", col, nocol \
			} \
			/^[0-9a-zA-Z_-]+:.*?##/ { \
				printf "  %s%-12s%s %s\n", col, $$1, nocol, $$2 \
			} \
			/^##@/ { \
				printf "\n%s%s%s\n", nocol, substr($$0, 5), nocol \
			} \
		' $(MAKEFILE_LIST)