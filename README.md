# Apache Teaclave™  Website

The official website for Apache Teaclave™, generated with the Docusaurus static site generator. This repository contains the source code and configuration for the Teaclave project website, including documentation for Teaclave TrustZone SDK, Teaclave SGX SDK, and related components.

## Quick Start

### Building the Website

1. **Build the Docker container:**
   ```bash
   docker build . -t website
   ```

2. **Run the container and build the site:**
   ```bash
   docker run -it --rm -v $(pwd):/app/repo website /bin/bash
   cd site
   make build
   ```

### Deployment (CI/CD)

Deployment is handled by GitHub Actions:

1. **Merge a PR** (or push to `master`) → the **Deploy Staging** workflow runs and updates the **asf-staging** branch.
2. **Verify** the staging site.
3. **Promote to production** → In the repo, go to **Actions** → **"Promote Staging to Production"** → **Run workflow**. This updates **asf-site** with the content of **asf-staging**.

For workflow details and architecture, see [.github/workflows/README.md](.github/workflows/README.md).

Manual deployment from a local build (e.g. `make staging` / `make site` in `site/`) is still supported; see `site/Makefile`.

### Website URLs

- **Staging**: https://teaclave.staged.apache.org (for preview)
- **Production**: https://teaclave.apache.org
