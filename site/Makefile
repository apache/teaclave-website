all: staging site

staging: build
	ghp-import --no-history --force build -b asf-staging

site: build
	ghp-import --no-history --force build -b asf-site

init-repo:
	git clone -b main https://github.com/apache/teaclave.git docs/teaclave-docs --depth 1
	git clone -b legacy https://github.com/apache/teaclave.git docs/teaclave-faas-legacy --depth 1

	# v2.0.0-preview branch does not have documents folder, we use master branch instead
	git clone -b master https://github.com/apache/teaclave-sgx-sdk.git docs/teaclave-sgx-sdk --depth 1
	git clone https://github.com/apache/teaclave-trustzone-sdk.git docs/teaclave-trustzone-sdk --depth 1

check-repo:
	@if [ ! -d "docs/teaclave-docs" ] || [ ! -d "docs/teaclave-faas-legacy" ] || [ ! -d "docs/teaclave-sgx-sdk" ] || [ ! -d "docs/teaclave-trustzone-sdk" ]; then \
		echo "Repositories not found. Running init-repo..."; \
		$(MAKE) init-repo; \
	fi

update-repo: check-repo
	cd docs/teaclave-docs && git pull --depth 1
	cd docs/teaclave-faas-legacy && git pull --depth 1
	cd docs/teaclave-sgx-sdk && git pull --depth 1
	cd docs/teaclave-trustzone-sdk && git pull --depth 1 --rebase

sgx-sdk-api-docs: site-build
	mkdir -p build/api-docs/sgx-sdk/
	cp -r /prebuilt_docs/sgx-sdk-docs/* build/api-docs/sgx-sdk/
	@echo "<meta http-equiv=refresh content=0;url=`echo sgx_tstd | cut -d '/' -f 2`/index.html>" > build/api-docs/sgx-sdk/index.html

trustzone-sdk-api-docs: site-build
	mkdir -p build/api-docs/trustzone-sdk/
	cp -r /prebuilt_docs/tz-sdk-docs/* build/api-docs/trustzone-sdk/
	@echo "<meta http-equiv=refresh content=0;url=`echo optee_teec | cut -d '/' -f 2`/index.html>" > build/api-docs/trustzone-sdk/index.html

site-build: update-repo
	npm run build
	mkdir -p build/api-docs

dev:
	npm run start

preview:
	cd build && python3 -m http.server

build: sgx-sdk-api-docs trustzone-sdk-api-docs 
	cp ../.asf.yaml build
	find build -name '*.lock' -exec chmod 655 {} \;

clean-repo:
	rm -rf docs/teaclave-docs
	rm -rf docs/teaclave-faas-legacy
	rm -rf docs/teaclave-sgx-sdk
	rm -rf docs/teaclave-trustzone-sdk

clean: clean-repo
	rm -rf build
