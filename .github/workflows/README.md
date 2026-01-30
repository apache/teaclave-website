# GitHub Actions Architecture Documentation

This document describes the CI/CD architecture for the Apache Teaclave website.

## 📁 Workflow Files

```
.github/workflows/
├── _reusable-build.yml              # [Reusable] Shared build logic for Docker + website
├── pr-validation.yml                # PR validation workflow (read-only)
├── deploy-staging.yml               # Deploys build to asf-staging branch
├── promote-staging-to-production.yml  # [Manual] Replaces asf-site with asf-staging
└── README.md                        # This file
```

### Naming Convention

- **`pr-*.yml`** - PR validation workflows (read-only permissions)
- **`deploy-*.yml`** - Deployment workflows (write permissions)
- **`promote-*.yml`** - Manual promotion workflows (e.g. staging → production)
- **`_reusable-*.yml`** - Reusable workflows (called by others, underscore prefix)

## 🌐 Website Update Flow

1. **PR merged** (or push to `master`) → **Deploy Staging** runs → build is deployed to the **asf-staging** branch. Staging site is updated.
2. **Verify** → Visit the staging website and confirm everything looks correct.
3. **Promote to production** → Go to **Actions** → **"Promote Staging to Production"** → **Run workflow**. This replaces the **asf-site** branch with the content of **asf-staging**, updating the final live website.

| Step | What happens |
|------|----------------|
| Merge / push to master | `deploy-staging.yml` → `asf-staging` updated |
| Manual check | You verify the staging site |
| Manual trigger | `promote-staging-to-production.yml` → `asf-site` = `asf-staging` |

## 🏗️ Architecture Overview

### Design Principles

1. **DRY (Don't Repeat Yourself)**: Shared build logic via reusable workflow
2. **Separation of Concerns**: Separate workflows for validation vs deployment
3. **Least Privilege**: Minimal permissions per workflow
4. **Security First**: No credentials on disk, token in memory only
5. **Developer Experience**: Clear feedback, fast builds, easy debugging

### Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────┐
│                     GitHub Repository Events                             │
│                                                                          │
│  Pull Request          Push to master        Manual Trigger               │
│       │                       │                     │                     │
│       ▼                       ▼                     ▼                     │
│  ┌─────────────┐       ┌──────────────┐      ┌──────────────────────┐    │
│  │pr-validation│       │deploy-       │      │promote-staging-to-   │    │
│  │.yml         │       │staging.yml   │      │production.yml        │    │
│  └────┬────────┘       └──────┬───────┘      │ (manual only)        │    │
│       │                       │              └──────────┬─────────────┘    │
│       │                       │                        │                  │
│       ▼                       ▼                        │                  │
│  ┌────────────────────────────────────────┐           │                  │
│  │     _reusable-build.yml (Shared Logic)  │           │                  │
│  │  build-docker-image → build-website     │           │                  │
│  └────────────────────┬───────────────────┘           │                  │
│                        │                               │                  │
│       ┌────────────────┴────────────────┐              │                  │
│       ▼                                 ▼              ▼                  │
│  ┌─────────┐                    ┌──────────────┐  ┌──────────────┐         │
│  │ validate│                    │deploy-staging│  │ promote      │         │
│  └─────────┘                    └──────┬───────┘  │ (asf-staging│         │
│       │                                 │         │  → asf-site)│         │
│       │                                 ▼         └──────┬───────┘         │
│       │                            asf-staging           │                 │
│       │                            (staging site)        ▼                 │
│       │                                 │           asf-site               │
│       │                                 │           (live site)           │
│       │                                 │                                  │
│       ▼                                 └──► Verify staging, then run       │
│  Result: ✓ PR Check                      "Promote Staging to Production"   │
└─────────────────────────────────────────────────────────────────────────┘
```
