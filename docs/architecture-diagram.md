# Portfolio Architecture Diagram (ASCII — Phase 12)

```text
                         ┌──────────────────────┐
                         │   Developer / Demo   │
                         └──────────┬───────────┘
                                    │
                    ┌───────────────┴───────────────┐
                    │                               │
                    ▼                               ▼
           Docker Compose                    Kubernetes (kind)
           API + Worker                      API · Worker · Monitoring
                    │                               │
                    └───────────────┬───────────────┘
                                    │
                                    ▼
                            LocalStack :4566
                         ┌──────┼──────┐
                         ▼      ▼      ▼
                        S3   DynamoDB  SQS
                                    │
                                    ▼
                              Worker updates
                              file status

Observability:  Prometheus ← /metrics ← API
                Loki ← Promtail ← pod logs
                Grafana ← dashboards + Explore

IaC:  infrastructure/terraform/          → LocalStack (apply OK)
      infrastructure/terraform-aws-prod/ → reference only (DO NOT APPLY)
```

Use this in README, interviews, or a demo video slide.
