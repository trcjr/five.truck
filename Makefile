.PHONY: help serve build clean check-exif strip-exif

##@ Development

serve: ## Run Hugo server with drafts and renderToMemory
	hugo serve -D --renderToMemory

build: ## Build the site with minification
	hugo --minify

clean: ## Remove generated files
	rm -rf public/ resources/ .hugo_build.lock

check-exif: ## Run the EXIF metadata checker script
	bash scripts/check-exif.sh

strip-exif: ## Remove EXIF metadata from all images
	bash scripts/check-exif.sh --strip

##@ Verification

preflight: build check-exif ## Run local verification before pushing
	@echo "✅ Preflight checklist complete. Ready for takeoff!"

##@ Help

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