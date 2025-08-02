# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal FluxCD GitOps repository for managing a Kubernetes cluster using Flux v2 and Kustomize. The structure follows the FluxCD multi-tenant and helm-based patterns.

## Essential Commands

### Validation and Testing
- **Validate all manifests**: `./scripts/validate.sh` - Validates YAML syntax and Kubernetes manifests
- **Encrypt secrets before commit**: `./scripts/encrypt.sh` - Encrypts secrets with SOPS using AGE key
- **Decrypt for local work**: `./scripts/decrypt.sh` - Decrypts .enc.yaml files for local editing

### Cluster Setup
- **Bootstrap new cluster**: `./scripts/setup.sh` - Sets up flux-system namespace and bootstraps FluxCD
  - Requires environment variables: `GITHUB_USER` and `GITHUB_TOKEN`
  - Expects AGE private key at `~/.config/sops/age/keys.txt`

### Pre-commit Integration
Add to your pre-commit hook: `source ./scripts/encrypt.sh`

## Repository Structure

```
├── clusters/               # Cluster configurations
│   ├── production/        # Production environment cluster config
│   └── staging/           # Staging environment cluster config (primary)
├── infrastructure/        # Platform components
│   ├── base/             # Base infrastructure manifests
│   └── production/       # Production-specific infrastructure
├── apps/                 # Application deployments
│   ├── base/            # Base application manifests
│   └── production/      # Production-specific applications
├── monitoring/          # Observability stack
│   ├── controllers/     # Prometheus, Grafana, Loki
│   ├── configs/        # Dashboards, rules, monitors
│   └── ingress/        # Monitoring ingress configurations
└── scripts/            # Automation scripts
```

## Key Patterns and Conventions

### Kustomization Structure
- Each component has a `base/` directory with core manifests
- Environment-specific overlays in `production/` or `staging/`
- Always include `apiVersion`, `kind`, `resources` in kustomization.yaml
- Use `secretGenerator` for encrypted secrets with `.enc.yaml` suffix

### Secret Management - CRITICAL
- **Individual Secret Files**: Each secret must be in its own separate file
- All secrets are SOPS-encrypted using AGE encryption
- Encrypted files use `.enc.yaml` suffix (e.g., `oauth2-secret.enc.yaml`, `keycloak-secret.enc.yaml`)
- AGE public key is stored in repository for encryption
- Private key expected at `~/.config/sops/age/keys.txt`
- Never commit plaintext secrets
- **Example structure**:
  ```
  infrastructure/production/keycloak/
  ├── kustomization.yaml
  ├── keycloak-postgresql.yaml
  ├── ingressConfig.yaml
  └── keycloak-secret.enc.yaml  # Individual secret file
  ```

### Helm Release Pattern
```yaml
apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: app-name
spec:
  timeout: 15m
  interval: 30m
  install:
    crds: Create
    remediation:
      retries: 3
  upgrade:
    crds: CreateReplace
    remediation:
      retries: 3
  chart:
    spec:
      chart: chart-name
      version: "x.y.z"
      sourceRef:
        kind: HelmRepository
        name: repo-name
        namespace: namespace
```

### File and Directory Naming
- Use kebab-case for all files and directories
- Component directories match their Kubernetes resource names
- Encrypted files: `component-secret.enc.yaml` (one secret per file)

### YAML Formatting
- 2-space indentation, no tabs
- Include standard Kubernetes labels where applicable
- Use comments (`#`) for complex configurations

## Technology Stack

- **GitOps**: FluxCD v2 (Flux toolkit)
- **Configuration**: Kustomize
- **Package Management**: Helm (via HelmRelease CRDs)
- **Secret Management**: SOPS with AGE encryption
- **Monitoring**: kube-prometheus-stack (Prometheus, Grafana, Alertmanager)
- **Logging**: Loki stack
- **Service Mesh**: Traefik ingress controller
- **Authentication**: Keycloak with OAuth2 Proxy
- **Storage**: Ceph CSI, SMB CSI, Velero backups
- **Automation**: Renovate for dependency updates

## Applications Deployed

### Core Infrastructure
- **cert-manager**: TLS certificate management
- **metallb**: Load balancer for bare metal
- **traefik**: Ingress controller and reverse proxy
- **keycloak**: Identity and access management
- **oauth2proxy**: Authentication proxy

### Storage and Backup
- **ceph-csi-rbd**: Ceph block storage
- **smb-csi**: SMB/CIFS storage driver
- **velero**: Kubernetes backup solution
- **cloudnative-pg**: PostgreSQL operator

### Monitoring Stack
- **kube-prometheus-stack**: Prometheus, Grafana, Alertmanager
- **loki-stack**: Log aggregation
- **influxdb**: Time series database for external metrics

### Applications
- **immich**: Photo management platform
- **open-webui**: Web UI for LLMs
- **searxng**: Privacy-respecting search engine

## Important Notes

- **Primary cluster**: Staging cluster (`./clusters/staging`)
- Always run `./scripts/validate.sh` before committing changes
- GitHub Actions automatically validates manifests on PRs
- Renovate automatically updates dependencies with automerge for minor/patch versions
- Main branch for GitOps sync: `main`
- Repository URL: `ssh://git@github.com/JvandeLocht/fluxcd`
- **Critical**: All secrets must be separated into individual files with descriptive names