---
name: ci-cd-templates
description: CI/CD pipeline templates for GitHub Actions, including test, lint, security scan, and deployment workflows
---

# CI/CD Pipeline Templates

Ready-to-use GitHub Actions workflow templates. Copy the relevant YAML into your `.github/workflows/` directory and adapt to your project.

## Template 1: Basic CI (Test + Lint)

```yaml
# .github/workflows/ci.yml
name: CI
on:
  push:
    branches: ['*']
  pull_request:
    branches: [main]

jobs:
  ci:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [18, 20]  # Adapt: use your language/version matrix
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
          cache: npm
      - run: npm ci
      - run: npm run lint
      - run: npm test
```

## Template 2: Security Scan

```yaml
# .github/workflows/security.yml
name: Security Scan
on:
  pull_request:
    branches: [main]
  schedule:
    - cron: '0 8 * * 1'  # Weekly Monday scan

jobs:
  audit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm
      - run: npm ci
      - run: npm audit --audit-level=high
      # Optional: secret scanning with trufflehog
      # - uses: trufflesecurity/trufflehog@v3
      #   with:
      #     extra_args: --only-verified
  codeql:
    runs-on: ubuntu-latest
    permissions:
      security-events: write
    steps:
      - uses: actions/checkout@v4
      - uses: github/codeql-action/init@v3
        with:
          languages: javascript  # Adapt: python, java, go, etc.
      - uses: github/codeql-action/analyze@v3
```

## Template 3: Deploy (Staging + Production)

```yaml
# .github/workflows/deploy.yml
name: Deploy
on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm
      - run: npm ci
      - run: npm run build
      - uses: actions/upload-artifact@v4
        with:
          name: build-output
          path: dist/  # Adapt: your build output directory

  deploy-staging:
    needs: build
    runs-on: ubuntu-latest
    environment: staging
    steps:
      - uses: actions/download-artifact@v4
        with:
          name: build-output
      - run: echo "Deploy to staging here"  # Replace with real deploy step

  deploy-production:
    needs: deploy-staging
    runs-on: ubuntu-latest
    environment:
      name: production  # Requires manual approval configured in repo settings
    steps:
      - uses: actions/download-artifact@v4
        with:
          name: build-output
      - run: echo "Deploy to production here"  # Replace with real deploy step
```

## Which Templates to Use

| Tier | Workflows | Rationale |
|------|-----------|-----------|
| **Lightweight** | CI only | Fast feedback on tests and lint without overhead |
| **Standard** | CI + Security Scan | Adds dependency auditing and SAST for production-grade projects |
| **Rigorous** | CI + Security + Deploy | Full pipeline with gated deployments and manual production approval |

## Customization Guide

- **Language**: Replace `actions/setup-node` with `actions/setup-python`, `actions/setup-go`, etc. Swap `npm` commands for your package manager.
- **Monorepo**: Add path filters under `on.push.paths` and `on.pull_request.paths` to run workflows only for changed packages.
- **Secrets**: Store credentials in GitHub repository settings under Settings > Secrets. Reference them as `${{ secrets.YOUR_SECRET }}`.
- **Production gate**: The deploy template uses GitHub Environments. Configure required reviewers under Settings > Environments > production.

These are starting templates. Adapt them to your project's language, structure, and deployment target.
