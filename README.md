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

### Deployment

To deploy the generated site to the staging and production environments:

```bash
# Deploy to staging
ghp-import --no-history --force site/build/ -b asf-staging
git push -f asf-staging

# Deploy to production
ghp-import --no-history --force site/build/ -b asf-site
git push -f asf-site
```

### Website URLs

- **Staging**: https://teaclave.staged.apache.org (for preview)
- **Production**: https://teaclave.apache.org
