# SGX Docs stage
FROM teaclave/teaclave-build-ubuntu-1804-sgx-2.14:latest AS sgx-docs
WORKDIR /app
COPY sgx-sdk-api-docs /app/sgx-sdk-api-docs
RUN . "$HOME/.cargo/env" && cd sgx-sdk-api-docs && cargo doc
RUN mkdir -p /prebuilt_docs && \
    cp -r sgx-sdk-api-docs/target/doc /prebuilt_docs/sgx-sdk-docs

# Trustzone Docs stage
FROM teaclave/teaclave-trustzone-emulator-std-optee-4.5.0-expand-memory:latest AS tz-docs
WORKDIR /app
COPY tz-sdk-api-docs /app/tz-sdk-api-docs
RUN . /opt/teaclave/setup/bootstrap_env && \
    . /opt/teaclave/environment && \
    . $HOME/.cargo/env && \
    cd tz-sdk-api-docs && cargo doc
RUN mkdir -p /prebuilt_docs && \
    cp -r tz-sdk-api-docs/target/doc /prebuilt_docs/tz-sdk-docs

# Teaclave Docs stage
#FROM teaclave/teaclave-build-ubuntu-2004-sgx-2.17.1:0.2.0 AS teaclave-docs
#WORKDIR /app

# Dependencies stage
FROM node:22-slim AS deps
WORKDIR /app
COPY site/package*.json ./
RUN npm install

# Final stage
FROM node:22-slim AS teaclave-docs-site

COPY --from=deps /app/node_modules /app/node_modules
COPY --from=sgx-docs /prebuilt_docs/sgx-sdk-docs /prebuilt_docs/sgx-sdk-docs
COPY --from=tz-docs /prebuilt_docs/tz-sdk-docs /prebuilt_docs/tz-sdk-docs

ENV PATH="/root/.cargo/bin:${PATH}"
ENV PYTHONPATH="/usr/local/lib/python3.9/dist-packages"
ENV NPM_CONFIG_PREFIX="/app/node_modules"

WORKDIR /app

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    git \
    curl
RUN pip3 install --break-system-packages ghp-import