# Cloud Architecture — Phase 11 Reference

This document explains **production scaling concepts** and how they map to what you already built locally.  
**No real AWS resources are created from this project.**

---

## 1. High Availability (HA)

**Idea:** The system keeps working if one piece fails.

| Concept | In our project | In production AWS |
|---------|----------------|-------------------|
| Multiple API replicas | K8s Deployment `replicas: 2` | Multi-AZ ECS/EKS or ASG behind ALB |
| Health checks | `/health` probes | ALB health checks + target groups |
| Stateless API | Files in S3, not on disk | Same pattern |

```text
        Internet
            │
         Load Balancer
         /          \
     API AZ-a     API AZ-b
         \          /
      Shared data plane (S3, DynamoDB, SQS)
```

---

## 2. Auto Scaling

**Idea:** Add/remove capacity based on load.

| Layer | What we have | Production equivalent |
|-------|--------------|----------------------|
| Pods | HPA on CPU (`k8s/hpa.yaml`) | K8s HPA / ECS service autoscaling |
| Nodes | kind single node (learning) | EKS managed node groups / ASG |
| Data | DynamoDB on-demand | DynamoDB on-demand / Aurora autoscaling |

Rule of thumb: scale **stateless** compute first; scale databases carefully.

---

## 3. Multi-AZ

**Idea:** Spread resources across Availability Zones so one AZ outage is survivable.

LocalStack/kind = single machine. In AWS you would:

- Put ALB across 2+ AZs
- Run app tasks in 2+ AZs
- Use DynamoDB / SQS (regional, multi-AZ by design)
- Use S3 (already multi-AZ durable)

---

## 4. Caching

**Idea:** Store frequent reads closer to the user to cut latency and DynamoDB/S3 load.

Common pattern:

```text
Client → API → Redis/ElastiCache → (miss) → DynamoDB
```

For this project we did **not** add Redis (keeps Phase 11 conceptual).  
Good cache candidates later: user profile lookups, file metadata lists.

---

## 5. CDN (Content Delivery Network)

**Idea:** Serve static/heavy files from edge locations.

```text
User upload  → S3
User download → CloudFront (CDN) → S3 origin
```

API stays on ALB/API Gateway; large files go through CDN.

---

## 6. Disaster Recovery (DR)

| Level | Meaning | Example |
|-------|---------|---------|
| Backup | Copy data | S3 versioning, DynamoDB PITR |
| Pilot light | Minimal standby | Small warm env in another region |
| Warm standby | Scaled-down replica | Second region always on |
| Multi-region active | Full active-active | Complex + expensive |

**Learning rule:** DR is a business decision (RPO/RTO) before a tech decision.

- **RPO** — how much data can you lose?
- **RTO** — how fast must you recover?

---

## 7. Cost Optimization

What we already practice:

- LocalStack instead of real AWS for learning
- Phase 10 Terraform **apply blocked**
- DynamoDB PAY_PER_REQUEST (no idle capacity)
- Short CloudWatch retention in reference TF
- ALB/EC2 left off by default

Production tips:

- Right-size instances; turn off unused envs
- S3 lifecycle → Glacier for old objects
- Budgets + alerts (see Phase 10 `budget.tf` reference)
- Prefer managed multi-AZ services over DIY servers when team is small

---

## 8. Event-Driven Architecture

**You already built this:**

```text
Upload API  →  S3 + DynamoDB metadata
     │
     └── SQS message  →  Worker processes file  →  updates status
```

Benefits:

- API stays fast (returns before heavy work finishes)
- Worker can scale independently
- Failures retry via SQS visibility timeout

Production upgrades: SNS fan-out, EventBridge, DLQ (dead-letter queue) for poison messages.

---

## Target Production Architecture (reference only)

```text
                         Users
                           │
                      CloudFront (CDN)
                           │
                     ALB + ACM (HTTPS)
                           │
              ┌────────────┴────────────┐
           API tasks                 (Multi-AZ)
              │
     ┌────────┼────────┐
     ▼        ▼        ▼
    S3     DynamoDB   SQS ──► Workers
     │
 CloudWatch + alarms
     │
 IAM least-privilege roles
```

Your local map:

```text
Docker/Kind → API + Worker
LocalStack  → S3 + DynamoDB + SQS
Prometheus/Grafana/Loki → observe
Terraform (local) → create LocalStack resources
Terraform (aws-prod folder) → reference code only
```

---

## Phase 11 takeaway

You do not need to deploy multi-region AWS to **understand** architecture.  
You already practiced the hard parts locally: **stateless API, queues, managed data stores, autoscaling pods, and observability.**
