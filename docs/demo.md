# Demo Checklist (Portfolio / Interviews)

Use this to walk through the project in ~10 minutes. **No real AWS required.**

---

## 1. Story (30 seconds)

> I built a cloud-native upload platform locally with LocalStack.  
> FastAPI handles auth + uploads, SQS drives async workers, Terraform manages infra,  
> Kubernetes runs the stack, and Prometheus/Grafana/Loki provide observability.  
> Production AWS Terraform exists as **reference code only** — apply is blocked to avoid cost.

---

## 2. Start the stack

```bash
# Terminal A — LocalStack + infra
docker compose up -d localstack
cd infrastructure/terraform
terraform apply   # LocalStack ONLY

# Terminal B — app
cd ../..
docker compose up api worker
```

Verify:

```bash
curl http://localhost:8000/health
curl http://localhost:8000/metrics | head
awslocal s3 ls
awslocal dynamodb list-tables
awslocal sqs list-queues
```

---

## 3. Show the API

1. Open http://localhost:8000/docs  
2. Register + login  
3. Upload a file  
4. Show worker processing (compose logs)

```bash
docker compose logs -f worker
```

---

## 4. Show Kubernetes (if kind is up)

```bash
kubectl get pods -n cloud-native
kubectl get hpa -n cloud-native
```

Monitoring:

```bash
kubectl port-forward -n cloud-native svc/prometheus 9090:9090
kubectl port-forward -n cloud-native svc/grafana 3000:3000
```

- Prometheus → Status → Targets → `cloud-native-api` **UP** (see `image-44.png`)  
- Grafana → Explore → `rate(http_requests_total[1m])`  
- Grafana → Loki → `{namespace="cloud-native", app="cloud-native-api"}`

---

## 5. Show IaC separation

| Folder | Point to make |
|--------|----------------|
| `infrastructure/terraform/` | Applied against LocalStack |
| `infrastructure/terraform-aws-prod/` | Same shape for real AWS — **DO NOT APPLY** |
| `DO_NOT_APPLY.txt` | Cost safety is intentional |

---

## 6. Architecture talking points

From `docs/architecture.md`:

- Stateless API + managed data stores  
- Event-driven worker via SQS  
- HPA for pod autoscaling  
- Observability triad: metrics, logs, health  

---

## Optional: short demo video outline

1. README roadmap (all phases ✅)  
2. `docker compose` + health/metrics  
3. Swagger upload flow  
4. Prometheus target UP  
5. Architecture diagram in docs  

Keep video under 3–5 minutes.
