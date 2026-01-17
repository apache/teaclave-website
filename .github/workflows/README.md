# GitHub Actions Architecture Documentation

This document describes the CI/CD architecture for the Apache Teaclave website.

## 📁 Workflow Files

```
.github/workflows/
├── _reusable-build.yml     # [Reusable] Shared build logic for Docker + website
├── pr-validation.yml       # PR validation workflow (read-only)
├── deploy-staging.yml      # Deployment workflow for staging
└── README.md              # This file
```

### Naming Convention

- **`pr-*.yml`** - PR validation workflows (read-only permissions)
- **`deploy-*.yml`** - Deployment workflows (write permissions)
- **`_reusable-*.yml`** - Reusable workflows (called by others, underscore prefix)

## 🏗️ Architecture Overview

### Design Principles

1. **DRY (Don't Repeat Yourself)**: Shared build logic via reusable workflow
2. **Separation of Concerns**: Separate workflows for validation vs deployment
3. **Least Privilege**: Minimal permissions per workflow
4. **Security First**: No credentials on disk, token in memory only
5. **Developer Experience**: Clear feedback, fast builds, easy debugging

### Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                  GitHub Repository Events                        │
│                                                                   │
│  Pull Request          Push to master       Manual Trigger       │
│       │                     │                      │              │
│       ▼                     ▼                      ▼              │
│  ┌─────────────┐     ┌──────────────┐      ┌──────────────┐    │
│  │pr-validation│     │deploy-       │      │deploy-       │    │
│  │.yml         │     │staging.yml   │      │staging.yml   │    │
│  └────┬────────┘     └──────┬───────┘      └──────┬───────┘    │
│       │                     │                      │              │
│       │        ┌────────────┴──────────────────────┘             │
│       │        │                                                  │
│       ▼        ▼                                                  │
│  ┌────────────────────────────────────────────────┐             │
│  │      _reusable-build.yml (Shared Logic)        │             │
│  │                                                  │             │
│  │  ┌──────────────────┐  ┌────────────────────┐ │             │
│  │  │ build-docker-    │─▶│ build-website      │ │             │
│  │  │ image            │  │                    │ │             │
│  │  └──────────────────┘  └────────────────────┘ │             │
│  │                                                  │             │
│  │  Outputs:                                       │             │
│  │  - docker-artifact-name                         │             │
│  │  - build-artifact-name                          │             │
│  └─────────────────┬────────────────┬─────────────┘             │
│                    │                │                             │
│       ┌────────────┘                └────────────┐               │
│       ▼                                          ▼               │
│  ┌─────────┐                              ┌──────────────┐      │
│  │validate │                              │deploy-staging│      │
│  │         │                              │              │      │
│  └─────────┘                              └──────────────┘      │
│                                                                   │
│  Result: ✓ PR Check                       Result: ✓ Deployed    │
└─────────────────────────────────────────────────────────────────┘
```
