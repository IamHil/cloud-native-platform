# CI/CD Documentation

## Current approach

This learning repo focuses on **local DevOps skills** (Docker, Kubernetes, Terraform, monitoring).  
A starter GitHub Actions workflow runs on every push/PR to `main`:

- Install Python deps from `backend/requirements.txt`
- Syntax-check critical Python modules (`compileall`)

File: `.github/workflows/ci.yml`

---

## Why this CI is intentionally small

| We include | We defer |
|------------|----------|
| Dependency install | Full integration tests needing LocalStack in CI |
| Basic Python compile check | Deploy to real AWS |
| Fast feedback on broken imports | Paid runners / complex matrices |

Deploying to real AWS is **out of scope** for this project (Phase 10 apply is blocked).

---

## Recommended next CI/CD stages (portfolio stretch)

```text
1. lint + unit tests
2. build Docker image
3. scan image (Trivy) + deps (pip-audit)
4. (optional) kind smoke test in CI
5. NEVER auto-apply terraform-aws-prod
```

LocalStack apply can stay a **manual developer step** documented in the README Quick Start.

---

## Kubernetes / Terraform docs map

| Topic | Location |
|-------|----------|
| K8s deploy | README Phase 6 + `k8s/` |
| LocalStack Terraform | README Phase 7 + `infrastructure/terraform/` |
| AWS reference Terraform | README Phase 10 + `infrastructure/terraform-aws-prod/` |
| Monitoring | README Phase 8 + `monitoring/` |
| Security | README Phase 9 |
