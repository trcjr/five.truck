.PHONY: help serve serve-develop build build-develop check-exif strip-exif strip link-check check-warnings check-drafts lint-inclusive-language check-metadata preflight ci test format

##@ 🧪 Verification

preflight: build install-htmltest check-exif link-check check-warnings check-drafts lint-inclusive-language check-metadata check-slugs-unique ## Run local verification before pushing
	pre-commit run --all-files || (echo "❌ Pre-commit hooks failed." && exit 1)
	@echo "Checking if public/ directory exists:"
	@if [ -d "./public" ]; then \
	  echo "✅ public/ directory exists."; \
	else \
	  echo "❌ public/ directory is missing!"; \
	  exit 1; \
	fi
	@echo "✅ Preflight checklist complete. Ready for takeoff!"

ci: preflight ## Run all checks exactly as CI does

test: check-exif link-check check-warnings check-drafts check-metadata ## Run local tests (non-lint)
	@echo "✅ Basic tests complete."

check-metadata: ## Validate frontmatter metadata in content files
	bash scripts/check-metadata.sh

check-slugs-unique: ## Check for duplicate slugs/permalinks in content files
	bash scripts/check-slugs-unique.sh

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
	@./bin/htmltest || (echo "❌ Link check failed!" && exit 1)

check-warnings: ## Fail if Hugo emits any warnings
	@! hugo --minify 2>&1 | tee /tmp/hugo-build.log | grep -v 'schema_json' | grep -q "^WARN" && echo "✅ No critical Hugo warnings found." || (echo "❌ Hugo warnings detected:" && grep "^WARN" /tmp/hugo-build.log && exit 1)

check-drafts: ## Check for draft content in Git
	@git grep -q 'draft: *true' content && (echo "❌ Draft content detected in repo" && git grep 'draft: *true' content && exit 1) || echo "✅ No draft content committed."

lint-inclusive-language: ## Check for non-inclusive language
	@docker run --rm -v $$(pwd):/src -w /src getwoke/woke woke --exit-1-on-failure || echo "⚠️ Inclusive language check completed"

##@ 🚀 Development

install-htmltest: ## Install htmltest locally into ./bin
	@mkdir -p ./bin
	@set -e; \
	echo "🔍 Starting htmltest installation..."; \
	VERSION=0.17.0; \
	OS_RAW=$$(uname -s); \
	ARCH_RAW=$$(uname -m); \
	echo "🔧 Raw OS: $$OS_RAW"; \
	echo "🔧 Raw ARCH: $$ARCH_RAW"; \
	OS=$$(echo "$$OS_RAW" | tr '[:upper:]' '[:lower:]'); \
	case "$$OS" in \
		darwin) OS_NAME=macos ;; \
		linux) OS_NAME=linux ;; \
		*) echo "❌ Unsupported OS: $$OS_RAW" && exit 1 ;; \
	esac; \
	case "$$ARCH_RAW" in \
		x86_64) ARCH_NAME=amd64 ;; \
		arm64|aarch64) ARCH_NAME=arm64 ;; \
		*) echo "❌ Unsupported architecture: $$ARCH_RAW" && exit 1 ;; \
	esac; \
	echo "✅ Normalized OS: $$OS_NAME"; \
	echo "✅ Normalized ARCH: $$ARCH_NAME"; \
	ARCHIVE="htmltest_$${VERSION}_$${OS_NAME}_$${ARCH_NAME}.tar.gz"; \
	URL="https://github.com/wjdp/htmltest/releases/download/v$${VERSION}/$${ARCHIVE}"; \
	echo "📦 Downloading: $$URL"; \
	curl -sSL -o ./bin/htmltest.tar.gz "$$URL" || (echo "❌ Download failed!" && exit 1); \
	echo "📁 File type of downloaded archive:"; \
	file ./bin/htmltest.tar.gz || true; \
	echo "📂 Listing contents of ./bin:"; \
	ls -alh ./bin; \
	echo "📦 Attempting to extract archive..."; \
	tar -tzf ./bin/htmltest.tar.gz || (echo "❌ Archive is invalid or corrupted!" && exit 1); \
	tar -xzf ./bin/htmltest.tar.gz -C ./bin || (echo "❌ Extraction failed!" && exit 1); \
	chmod +x ./bin/htmltest || echo "⚠️ Couldn't set executable permission"; \
	rm ./bin/htmltest.tar.gz; \
	echo "✅ htmltest $$VERSION installed to ./bin/htmltest"

serve: ## Run Hugo server with drafts and renderToMemory
	hugo serve -D --renderToMemory


serve-develop: ## Run Hugo server for develop preview build
	hugo server --baseURL="http://localhost:1313/develop/" --renderToMemory -D

serve-develop-static: build-develop ## Serve the /develop/ site statically at localhost:8000/develop/
	@echo "📦 Serving static site from public/"
	@python3 -m http.server 8000 --directory public

build: ## Build the site with minification
	hugo --minify

build-develop: ## Build the site for develop preview
	hugo --baseURL="/develop/" --destination=public/develop --minify

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