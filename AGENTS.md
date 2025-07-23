# FluxCD GitOps Repository - Agent Guidelines

## Build/Test Commands
- **Validate all manifests**: `./scripts/validate.sh` (validates YAML syntax and Kubernetes manifests)
- **Encrypt secrets**: `./scripts/encrypt.sh` (encrypts secrets with SOPS before commit)
- **Decrypt for local work**: `./scripts/decrypt.sh` 
- **CI validation**: GitHub Actions runs `./scripts/validate.sh` on all PRs

## Code Style & Conventions
- **YAML formatting**: 2-space indentation, no tabs
- **File naming**: kebab-case for directories and files (e.g., `kube-prometheus-stack`)
- **Kustomization structure**: Always include `apiVersion`, `kind`, `resources` at minimum
- **Secret handling**: All secrets must be SOPS-encrypted (.enc.yaml suffix), never commit plaintext
- **Comments**: Use `#` for YAML comments, include context for complex configurations
- **Resource organization**: Group by environment (base/production/staging), then by service
- **Dependencies**: Use `dependsOn` in Flux Kustomizations for proper ordering
- **Namespaces**: Explicitly declare namespace in kustomization.yaml when needed
- **Labels**: Include standard k8s labels (app.kubernetes.io/name, app.kubernetes.io/part-of)

## Security Requirements
- Never commit unencrypted secrets or sensitive data
- All .enc.yaml files must be SOPS-encrypted with AGE key
- Use secretGenerator in kustomization.yaml for secret management
- Validate all changes with `./scripts/validate.sh` before committing