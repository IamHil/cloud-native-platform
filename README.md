# Cloud Native Platform

Build a production-style cloud-native application using AWS services locally with **LocalStack** — no real AWS costs.

Repository: [github.com/IamHil/cloud-native-platform](https://github.com/IamHil/cloud-native-platform) (branch: `main`)

**Portfolio one-liner:** FastAPI + LocalStack (S3/DynamoDB/SQS) + Docker + Kubernetes + Terraform + Prometheus/Grafana/Loki — with security hardening and production AWS Terraform as **code-only reference** (apply blocked).

| Quick links | |
|-------------|---|
| Docs index | [docs/README.md](docs/README.md) |
| Architecture | [docs/architecture.md](docs/architecture.md) |
| Diagram | [docs/architecture-diagram.md](docs/architecture-diagram.md) |
| API | [docs/api.md](docs/api.md) · Swagger `/docs` |
| Demo script | [docs/demo.md](docs/demo.md) |
| CI/CD | [docs/ci-cd.md](docs/ci-cd.md) |

---

## Learning Goals

- AWS Core Services (S3, DynamoDB, SQS)
- Docker & Docker Compose
- Kubernetes
- Infrastructure as Code (Terraform)
- Monitoring & Logging *(Phase 8)* ✅
- Security *(Phase 9)* ✅
- Production AWS *(Phase 10)* ✅ code-only — **no real AWS apply**
- Scaling & Architecture *(Phase 11)* ✅
- Final Polish *(Phase 12)* ✅

---

## Project Roadmap

| Phase | Topic | Status |
|-------|-------|--------|
| 0 | Environment / Git / LocalStack | ✅ |
| 1 | AWS Core Services | ✅ |
| 2 | FastAPI | ✅ |
| 3 | AWS Integration | ✅ |
| 4 | Auth + SQS + Upload Pipeline | ✅ |
| 5 | Docker + Compose | ✅ |
| 6 | Kubernetes | ✅ |
| 7 | Infrastructure as Code (Terraform) | ✅ |
| 8 | Monitoring & Logging | ✅ |
| 9 | Security | ✅ |
| 10 | Production AWS | ✅ code-only |
| 11 | Scaling & Cloud Architecture | ✅ |
| 12 | Final Polish | ✅ |

---

## Architecture

```text
┌─────────────────────────────────────────────────────────┐
│  TERRAFORM (infrastructure/terraform/)                  │
│  Creates: S3 bucket, DynamoDB tables, SQS queue         │
│  Target: LocalStack ONLY — never production AWS           │
└──────────────────────────┬──────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────┐
│  LOCALSTACK (localhost:4566)                            │
│  Emulates AWS: S3 · DynamoDB · SQS                      │
└──────────────────────────┬──────────────────────────────┘
                           │
              ┌────────────┴────────────┐
              ▼                         ▼
┌─────────────────────────┐  ┌─────────────────────────┐
│  DOCKER COMPOSE         │  │  KUBERNETES (optional)  │
│  API + Worker containers│  │  API · Worker · LS pods │
└─────────────────────────┘  └─────────────────────────┘
              │                         │
              └────────────┬────────────┘
                           ▼
┌─────────────────────────────────────────────────────────┐
│  FASTAPI APP (backend/)                                 │
│  Upload files · Auth · SQS worker                       │
└─────────────────────────────────────────────────────────┘
```

---

## Repository Structure

```text
DevOps-Cloud-Native-Platform/
├── backend/                    # FastAPI app (API + worker)
│   ├── app/
│   │   ├── api/                # Routes (auth, files, health, metrics)
│   │   ├── services/           # S3, DynamoDB, SQS clients
│   │   └── worker/             # SQS message processor
│   └── Dockerfile
├── docs/
│   ├── README.md               # Docs index
│   ├── architecture.md         # Phase 11 scaling & architecture
│   ├── architecture-diagram.md # Portfolio diagram
│   ├── api.md                  # API overview
│   ├── demo.md                 # Demo checklist
│   └── ci-cd.md                # CI/CD notes
├── .github/workflows/ci.yml    # GitHub Actions CI
├── infrastructure/
│   ├── terraform/              # IaC — LocalStack only (Phase 7)
│   └── terraform-aws-prod/     # IaC — real AWS shape (Phase 10) — DO NOT APPLY
├── monitoring/                 # Prometheus, Grafana, Loki (Phase 8)
├── k8s/                        # Kubernetes manifests (Phase 6)
├── docker-compose.yml          # LocalStack + API + worker
└── README.md
```

---

## Prerequisites

| Tool | Purpose |
|------|---------|
| [Docker Desktop](https://www.docker.com/products/docker-desktop/) | Run LocalStack and app containers |
| [Terraform](https://developer.hashicorp.com/terraform/install) ≥ 1.6 | Manage AWS resources in LocalStack |
| [AWS CLI](https://aws.amazon.com/cli/) | Verify resources via `awslocal` |
| [kind](https://kind.sigs.k8s.io/) + [kubectl](https://kubernetes.io/docs/tasks/tools/) | Optional — Kubernetes (Phase 6) |

---

## AWS CLI Profile (LocalStack)

Create a dedicated profile so CLI commands never touch production AWS.

**`~/.aws/credentials`**
```ini
[cloud-native]
aws_access_key_id = test
aws_secret_access_key = test
```

**`~/.aws/config`**
```ini
[profile cloud-native]
region = us-east-1
output = json
```

**Add to `~/.bashrc` or `~/.zshrc`** (persists across sessions):
```bash
alias awslocal='aws --profile cloud-native --endpoint-url=http://localhost:4566'
```

---

## Quick Start

Always follow this order — Terraform creates infrastructure **before** the app starts:

```bash
# 1. Start LocalStack
docker compose up -d localstack

# 2. Apply Terraform (creates S3, DynamoDB, SQS in LocalStack)
cd infrastructure/terraform
terraform init          # first time only
terraform apply

# 3. Verify resources
awslocal s3 ls
awslocal dynamodb list-tables
awslocal sqs list-queues

# 4. Start the app
cd ../..
docker compose up api worker

# 5. Test
curl http://localhost:8000/health
# Swagger UI: http://localhost:8000/docs
```

> **Note:** The app no longer creates tables or queues on startup. If you skip step 2, the app will fail.

---

# Phase 0 - Environment Setup

## Objective

Create a safe and isolated learning environment that mimics AWS locally using LocalStack.

---

## GitHub Repository

Repository:

https://github.com/IamHil/cloud-native-platform

Branch:

main

Authentication:

SSH


![alt text](image.png)


![alt text](image-1.png)

---

## Phase 0 - Completed

# Phase 1 - AWS Core Services Fundamentals

## S3 bucket 

- Create and Upload 

![alt text](image-2.png)

![alt text](image-3.png)

- Get file data 

![alt text](image-4.png)

- Copy a file 

![alt text](image-5.png)

![alt text](image-6.png)

- Delete a file

![alt text](image-7.png)

![alt text](image-8.png)

## S3 Bucket Fundamental Completed

---

## DynamoDB

- Create a Table 

![alt text](image-9.png)

![alt text](image-10.png)

- Update item 

![alt text](image-11.png)

- Get item 

![alt text](image-12.png)

- Query Items 

![alt text](image-13.png)

- GSI 

![alt text](image-14.png)

- TTL( Time to Live)

![alt text](image-15.png)

![alt text](image-16.png)

## Phase 1 Completed

---

## Phase 2 and 3 -  Build the Backend


![alt text](image-18.png)


![alt text](image-17.png)


![alt text](image-19.png)


![alt text](image-20.png)


- Built a FastAPI backend with a modular architecture and integrated LocalStack S3 for local AWS development. Implemented REST APIs for file upload and listing using boto3, with interactive API documentation via Swagger UI.

![alt text](image-21.png)


![alt text](image-22.png)


![alt text](image-23.png)

## Phase 2 and 3 Completed

# Phase 4

- Apply the Register, Login functionality along with SQS system using localstack
- This Phase consist of mini cloud-native backend using FastAPI + LocalStack, and the working upload pipeline.


![alt text](image-24.png)


![alt text](image-25.png)


User Register 

![alt text](image-26.png)

User Login 

![alt text](image-27.png)


![alt text](image-28.png)
## Phase 4 Completed

---

# Phase 5


![alt text](image-29.png)


![alt text](image-30.png)

Create a docker compose file :

![alt text](image-35.png)

![alt text](image-34.png)


## Phase 5 Completed

---

# Phase 6 — Kubernetes

**Goal:** Deploy and operate the application with Kubernetes.

## Roadmap Progress

| # | Topic | Status |
|---|-------|--------|
| 1 | Pods | ✅ |
| 2 | ReplicaSets | ✅ |
| 3 | Deployments | ✅ |
| 4 | Services | ✅ |
| 5 | ConfigMaps | ✅ |
| 6 | Secrets | ✅ |
| 7 | Persistent Volumes | ✅ |
| 8 | Ingress | ✅ |
| 9 | Rolling Updates | ✅ |
| 10 | Horizontal Pod Autoscaler | ✅ |
| 11 | Complete K8s architecture review | ✅ |

**Phase 6 — Completed**

---

## Initial Setup (Docker + kind)

![alt text](image-31.png)

![alt text](image-32.png)

![alt text](image-33.png)

![alt text](image-36.png)

![alt text](image-37.png)

![alt text](image-38.png)

Create kind cluster:

![alt text](image-39.png)

Apply Deployment and Service:

![alt text](image-40.png)

---

## Architecture

```text
                    Kubernetes
                 cloud-native NS
                       │
             ┌─────────┴─────────┐
             │                   │
          API Pods           Worker Pod
           2 replicas          1
             │                   │
             └─────────┬─────────┘
                       │
                       ▼
               LocalStack Service
                       │
                       ▼
                 LocalStack Pod
                       │
              ┌────────┼────────┐
              ▼        ▼        ▼
             S3       DDB      SQS
```

The application stores files in **S3**, metadata in **DynamoDB**, and uses **SQS** for async processing. Persistent Volumes are a separate learning exercise — the API does not need them.

---

## Manifests

```text
k8s/
├── namespace.yaml          # cloud-native namespace
├── configmap.yaml          # non-sensitive config (AWS region, bucket, etc.)
├── secret.yaml             # credentials (AWS keys, JWT secret)
├── localstack.yaml         # LocalStack deployment + ClusterIP service
├── deployment.yaml         # API deployment (2 replicas, rolling update)
├── worker.yaml             # background worker deployment
├── service.yaml            # API NodePort service
├── ingress.yaml            # HTTP routing via Ingress controller
├── hpa.yaml                # CPU-based autoscaling for API
└── pv/
    ├── persistentvolume.yaml
    ├── persistentvolumeclaim.yaml
    └── pv-test-pod.yaml    # standalone PV learning exercise
```

---

## Prerequisites

1. Docker Desktop running
2. [kind](https://kind.sigs.k8s.io/) installed
3. `kubectl` configured
4. API image built and loaded into kind:

```bash
docker build -t cloud-native-api:v1 ./backend
kind load docker-image cloud-native-api:v1 --name cloud-native
```

---

## Deploy the Stack

> **Prerequisite:** Run `terraform apply` first (see [Quick Start](#quick-start)) so S3, DynamoDB, and SQS exist in LocalStack before pods start.

```bash
# Core resources
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/secret.yaml
kubectl apply -f k8s/localstack.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/worker.yaml
kubectl apply -f k8s/service.yaml

# Verify
kubectl get pods -n cloud-native
kubectl get svc -n cloud-native
```

![alt text](image-41.png)

Pod monitoring:

![alt text](image-42.png)

Secrets:

![alt text](image-43.png)

---

## 1–6. Pods, ReplicaSets, Deployments, Services, ConfigMaps, Secrets

### What we learned

- **Pods** — smallest deployable unit; one or more containers sharing network/storage.
- **ReplicaSets** — keep a stable set of pod replicas (managed by Deployments).
- **Deployments** — declarative updates for pods and ReplicaSets.
- **Services** — stable DNS + load balancing to pods (`cloud-native-api`, `localstack`).
- **ConfigMaps** — non-sensitive configuration (`AWS_REGION`, `S3_BUCKET`, etc.).
- **Secrets** — sensitive values (`AWS_ACCESS_KEY_ID`, `JWT_SECRET_KEY`).

### Key fix: LocalStack DNS

The API pods initially crashed because they called `localstack:4566` but no Kubernetes Service existed for LocalStack. DNS resolution failed.

**Fix:** Created `localstack.yaml` with a Deployment + ClusterIP Service named `localstack`.

---

## 7. Persistent Volumes

### Why PV/PVC exist

Kubernetes pods are ephemeral — when a pod dies, its filesystem is gone. **PersistentVolumes (PV)** represent real storage in the cluster. **PersistentVolumeClaims (PVC)** request storage from a PV. Pods mount the PVC as a filesystem.

```text
PersistentVolume  →  PersistentVolumeClaim  →  Pod  →  mounted /data
```

Our app uses S3 for files, so PVs are a **learning exercise only** — we do not modify the API/worker.

### Apply and test

```bash
kubectl apply -f k8s/pv/persistentvolume.yaml
kubectl apply -f k8s/pv/persistentvolumeclaim.yaml
kubectl apply -f k8s/pv/pv-test-pod.yaml

# Confirm binding
kubectl get pv,pvc -n cloud-native

# See the file written to the volume
kubectl logs pv-test-pod -n cloud-native
```

### Verify data survives pod restart

```bash
kubectl delete pod pv-test-pod -n cloud-native
kubectl apply -f k8s/pv/pv-test-pod.yaml
kubectl logs pv-test-pod -n cloud-native
```

The timestamp in `/data/test.txt` should change on re-apply, but the **volume itself persists** across pod deletions because the PVC remains bound to the PV.

---

## 8. Ingress

Ingress exposes HTTP routes from outside the cluster to Services — one entry point instead of many NodePorts.

### Install Ingress controller (kind)

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s
```

### Apply Ingress

```bash
kubectl apply -f k8s/ingress.yaml
```

### Access the API

Add to your hosts file (`C:\Windows\System32\drivers\etc\hosts` on Windows):

```text
127.0.0.1  cloud-native.local
```

Forward kind port 80 (if not already):

```bash
kubectl port-forward -n ingress-nginx svc/ingress-nginx-controller 8080:80
```

Then open: `http://cloud-native.local:8080/health`

---

## 9. Rolling Updates

The API Deployment uses a **RollingUpdate** strategy:

```yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1        # allow 1 extra pod during update
    maxUnavailable: 0  # never drop below desired replica count
```

### Trigger a rolling update

```bash
# Build and load a new image tag
docker build -t cloud-native-api:v2 ./backend
kind load docker-image cloud-native-api:v2 --name cloud-native

# Update the deployment image
kubectl set image deployment/cloud-native-api \
  api=cloud-native-api:v2 -n cloud-native

# Watch the rollout
kubectl rollout status deployment/cloud-native-api -n cloud-native
kubectl get pods -n cloud-native -w
```

### Rollback if needed

```bash
kubectl rollout undo deployment/cloud-native-api -n cloud-native
```

---

## 10. Horizontal Pod Autoscaler (HPA)

HPA automatically scales pod replicas based on CPU (or custom metrics).

### Install metrics-server (required for CPU metrics)

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# kind requires this patch for kubelet TLS
kubectl patch deployment metrics-server -n kube-system --type=json \
  -p='[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'
```

### Apply HPA

```bash
kubectl apply -f k8s/hpa.yaml
kubectl get hpa -n cloud-native
```

HPA scales `cloud-native-api` between **2 and 5 replicas** when average CPU exceeds **70%**.

### Generate load to test (optional)

```bash
kubectl run load-test --image=busybox:1.36 -n cloud-native --restart=Never -- \
  sh -c "while true; do wget -q -O- http://cloud-native-api:8000/health; done"
```

Watch scaling: `kubectl get hpa,pods -n cloud-native -w`

---

## 11. Complete Kubernetes Architecture Review

| Component | Resource | Purpose |
|-----------|----------|---------|
| Namespace | `cloud-native` | Isolates all project resources |
| Config | ConfigMap + Secret | Environment variables for API/worker |
| AWS emulator | LocalStack Deployment + Service | S3, DynamoDB, SQS in-cluster |
| API | Deployment (2 replicas) + Service + Ingress + HPA | REST API with health probes |
| Worker | Deployment (1 replica) | SQS message processor |
| Storage (learning) | PV + PVC + test Pod | Demonstrates persistent filesystem |

### Useful commands

```bash
kubectl get all -n cloud-native
kubectl describe pod <name> -n cloud-native
kubectl logs -f deployment/cloud-native-api -n cloud-native
kubectl exec -it <pod> -n cloud-native -- sh
kubectl rollout history deployment/cloud-native-api -n cloud-native
```

---

# Phase 7 — Infrastructure as Code (Terraform)

**Goal:** Manage AWS infrastructure declaratively with Terraform instead of creating resources manually or in application code.

## Roadmap Progress

| # | Topic | Status |
|---|-------|--------|
| 1 | Terraform fundamentals | ✅ |
| 2 | Providers | ✅ |
| 3 | Resources | ✅ |
| 4 | Variables | ✅ |
| 5 | Outputs | ✅ |
| 6 | State | ✅ |
| 7 | `terraform init` | ✅ |
| 8 | `terraform plan` | ✅ |
| 9 | `terraform apply` | ✅ |
| 10 | `terraform destroy` | ✅ |
| 11 | Terraform project structure | ✅ |
| 12 | Use Terraform with our infrastructure | ✅ |
| 13 | Terraform vs Kubernetes manifests | ✅ |

**Phase 7 — Completed**

---

## Startup Order (Important)

Terraform creates AWS resources **before** the app starts. Always follow this order:

```text
1. Start LocalStack     →  docker compose up -d localstack
2. Apply Terraform      →  cd infrastructure/terraform && terraform apply
3. Start the app        →  docker compose up  OR  kubectl apply -f k8s/
```

If you skip step 2, the app will fail because tables and queues no longer auto-create.

---

## What is Terraform?

Terraform is **Infrastructure as Code (IaC)**. You describe what you want (an S3 bucket, a DynamoDB table) in `.tf` files, and Terraform figures out how to create it.

```text
You write .tf files  →  terraform plan  →  terraform apply  →  AWS/LocalStack resources exist
```

**Previously**, the Python app called `create_table()` and `create_queue()` on startup, mixing application logic with infrastructure. **Now**, Terraform creates resources and the app only uses them:

| Layer | Tool | Manages |
|-------|------|---------|
| Infrastructure | **Terraform** | S3, DynamoDB, SQS, IAM, VPC… |
| Orchestration | **Kubernetes** | Pods, Services, Deployments |
| Application | **FastAPI** | Business logic, API routes |

---

## Project Structure

Every `.tf` file in the same folder is combined into one configuration. Files are split by topic for readability — Terraform doesn't care about filenames.

```text
infrastructure/terraform/
├── versions.tf              # Terraform + provider version constraints
├── provider.tf              # AWS provider → LocalStack ONLY (not real AWS)
├── checks.tf                # Safety guards that block production AWS
├── localstack.auto.tfvars   # Auto-loaded LocalStack settings (committed)
├── variables.tf             # Input parameters with safety validations
├── locals.tf                # Computed/reusable values (tags)
├── state.tf                 # State documentation (learning reference)
├── s3.tf                    # S3 bucket resource
├── dynamodb.tf              # files + users tables
├── sqs.tf                   # file-processing queue
├── outputs.tf               # Values printed after apply
└── terraform.tfvars.example # Optional overrides (LocalStack only)
```

**Read the comments in each file** — they explain the syntax and why each block exists.

---

## LocalStack Only — Safety Guards

This Terraform folder is **locked to LocalStack**. It cannot touch production AWS.

| Guard | What it does |
|-------|----------------|
| `provider.tf` | All API calls routed to `localhost:4566` via `endpoints` block |
| `localstack.auto.tfvars` | Auto-loads `test`/`test` credentials and local endpoint |
| `variables.tf` | Rejects `amazonaws.com`, non-`test` credentials, non-`local` environment |
| `checks.tf` | Fails `plan`/`apply` if any safety rule is violated |
| Resource tags | Every resource tagged `Target = localstack` |

**Production Terraform** will be a **separate folder** in Phase 10 (e.g. `infrastructure/terraform-aws-prod/`). Never mix local and production in the same directory.

### Before running Terraform

Clear your AWS profile so Terraform does not pick up production credentials from your environment:

```powershell
# PowerShell
$env:AWS_PROFILE = ""
$env:AWS_ACCESS_KEY_ID = ""
$env:AWS_SECRET_ACCESS_KEY = ""
```

```bash
# Bash
unset AWS_PROFILE AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY
```

### What happens if you try production values?

```bash
terraform plan -var="aws_endpoint_url=https://s3.amazonaws.com"
# → Error: SAFETY: Real AWS endpoints are not allowed.
```

```bash
terraform plan -var="environment=prod"
# → Error: SAFETY: environment must be 'local'.
```

---

## Core Concepts (Quick Reference)

### 1. Resource

Creates and manages one piece of infrastructure:

```hcl
resource "aws_s3_bucket" "uploads" {
  bucket = var.s3_bucket_name
}
```

- `aws_s3_bucket` → resource type (from AWS provider)
- `uploads` → local name (reference as `aws_s3_bucket.uploads`)
- `bucket` → argument the provider sends to the AWS API

### 2. Variable

Input you can change without editing resource files:

```hcl
variable "s3_bucket_name" {
  type    = string
  default = "cloud-native-uploads"
}
```

Reference anywhere: `var.s3_bucket_name`

### 3. Output

Value Terraform shows after apply:

```hcl
output "s3_bucket_name" {
  value = aws_s3_bucket.uploads.bucket
}
```

### 4. Provider

Plugin that talks to a cloud API:

```hcl
provider "aws" {
  region = var.aws_region
}
```

### 5. State

After `terraform apply`, a `terraform.tfstate` file records what was created. Terraform compares your `.tf` files to state on the next plan — that's how it knows what to create, change, or destroy.

---

## Prerequisites

1. [Terraform](https://developer.hashicorp.com/terraform/install) installed (you have v1.14+)
2. LocalStack running (Docker Compose or Kubernetes)

```bash
# Option A: Docker Compose
docker compose up -d localstack

# Option B: Kubernetes (if using kind cluster)
kubectl get pods -n cloud-native -l app=localstack
```

---

## Step-by-Step: Your First Apply

### Step 1 — `terraform init`

Downloads the AWS provider plugin. Run once per machine / after cloning.

```bash
cd infrastructure/terraform
terraform init
```

What happens:
- Creates `.terraform/` directory (provider binaries — gitignored)
- Creates `.terraform.lock.hcl` (lock file — commit this)

### Step 2 — `terraform plan`

Shows what Terraform **would** create without making changes. Always run this before apply.

```bash
terraform plan
```

Expected output: `Plan: 4 to add, 0 to change, 0 to destroy`

Resources:
- 1 S3 bucket
- 2 DynamoDB tables
- 1 SQS queue

### Step 3 — `terraform apply`

Creates the resources. Type `yes` when prompted.

```bash
terraform apply
```

Verify with outputs:

```bash
terraform output
```

Or check LocalStack directly:

```bash
awslocal s3 ls
awslocal dynamodb list-tables
awslocal sqs list-queues
```

### Step 4 — `terraform destroy`

Removes everything Terraform created. Use when cleaning up.

```bash
terraform destroy
```

### Importing existing resources

If DynamoDB tables or SQS queue already exist in LocalStack (e.g. from an older app version), `terraform apply` may fail with "already exists". Import them into state instead:

```bash
cd infrastructure/terraform

terraform import aws_dynamodb_table.files files
terraform import aws_dynamodb_table.users users
terraform import aws_sqs_queue.file_processing \
  "http://sqs.us-east-1.localhost.localstack.cloud:4566/000000000000/file-processing-queue"

terraform apply   # syncs tags and settings
```

---

## Terraform vs Kubernetes — What Manages What?

```text
┌─────────────────────────────────────────────────────────┐
│  TERRAFORM manages (AWS layer)                          │
│    S3 bucket, DynamoDB tables, SQS queue, IAM roles     │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│  KUBERNETES manages (container layer)                   │
│    API pods, worker pods, LocalStack pod, services      │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│  APPLICATION manages (business logic)                   │
│    Upload files, auth, process SQS messages             │
└─────────────────────────────────────────────────────────┘
```

Terraform does **not** replace Kubernetes manifests. They operate at different layers.

---

## What We Created

| Resource | Terraform file | App config key |
|----------|---------------|----------------|
| S3 bucket `cloud-native-uploads` | `s3.tf` | `S3_BUCKET` |
| DynamoDB table `files` | `dynamodb.tf` | `DYNAMODB_TABLE` |
| DynamoDB table `users` | `dynamodb.tf` | `USERS_TABLE` |
| SQS queue `file-processing-queue` | `sqs.tf` | `SQS_QUEUE_NAME` |

Names match your `config.py` and `k8s/configmap.yaml` defaults.

---

## App Refactor — Terraform Owns Infrastructure

The Python services no longer create AWS resources on startup:

| Service | Before | After |
|---------|--------|-------|
| `dynamodb_service.py` | `create_table()` on startup | Connects to existing `files` table |
| `user_service.py` | `create_table()` on startup | Connects to existing `users` table |
| `sqs_service.py` | `create_queue()` on startup | Looks up queue by name via `get_queue_url()` |
| `s3_service.py` | Already only used the bucket | No change |

**Rule:** Terraform creates infrastructure. The app only uses it.

---

## Verify Everything Works

```bash
# 1. Start LocalStack
docker compose up -d localstack

# 2. Apply Terraform
cd infrastructure/terraform
terraform apply

# 3. Check outputs
terraform output

# 4. Verify in LocalStack
awslocal s3 ls
awslocal dynamodb list-tables
awslocal sqs list-queues

# 5. Start the app
cd ../..
docker compose up api worker

# 6. Test health endpoint
curl http://localhost:8000/health
```

### Clean up with destroy

```bash
cd infrastructure/terraform
terraform destroy
```

This removes the S3 bucket, DynamoDB tables, and SQS queue. Run `terraform apply` again to recreate them.

---

## Phase 7 — Completed

---

# Phase 8 — Monitoring & Logging

**Goal:** Observe the application with metrics, dashboards, logs, and basic alerts.

## Roadmap Progress

| # | Topic | Status |
|---|-------|--------|
| 1 | Prometheus | ✅ |
| 2 | Metrics (`/metrics`) | ✅ |
| 3 | Grafana | ✅ |
| 4 | Dashboards | ✅ |
| 5 | Loki | ✅ |
| 6 | Log aggregation (Promtail) | ✅ |
| 7 | Health endpoints | ✅ |
| 8 | Alerting basics | ✅ |

**Phase 8 — Completed**

---

## Architecture

```text
FastAPI /metrics  ──→  Prometheus  ──→  Grafana (dashboards + alerts)
       │
       └── pod logs ──→  Promtail  ──→  Loki  ──→  Grafana (Explore)
```

All monitoring components run in the **`cloud-native`** namespace alongside the app.

---

## What Was Added

### Application

| File | Purpose |
|------|---------|
| `backend/app/api/metrics.py` | Exposes `GET /metrics` (Prometheus format) |
| `backend/app/api/health.py` | Enhanced `/health` with service name + version |
| `backend/requirements.txt` | Added `prometheus-client` for `/metrics` |

### Kubernetes manifests

```text
monitoring/
├── prometheus/
│   ├── configmap.yaml      # scrape config + alert rules
│   ├── deployment.yaml
│   └── service.yaml
├── grafana/
│   ├── datasources-configmap.yaml   # auto-configures Prometheus + Loki
│   ├── deployment.yaml
│   └── service.yaml
├── loki/
│   ├── configmap.yaml
│   ├── deployment.yaml
│   └── service.yaml
└── promtail/
    ├── rbac.yaml           # read pod logs from the cluster
    ├── configmap.yaml
    └── daemonset.yaml      # ships logs to Loki
```

---

## Deploy Monitoring Stack

**Prerequisites:** kind cluster running, API deployed with rebuilt image (includes `/metrics`).

```bash
# 1. Rebuild API with metrics support
docker build -t cloud-native-api:v1 ./backend
kind load docker-image cloud-native-api:v1 --name cloud-native
kubectl rollout restart deployment/cloud-native-api -n cloud-native

# 2. Deploy monitoring
kubectl apply -f monitoring/prometheus/
kubectl apply -f monitoring/loki/
kubectl apply -f monitoring/grafana/
kubectl apply -f monitoring/promtail/

# 3. Verify pods
kubectl get pods -n cloud-native
```

---

## Access UIs

```bash
# Prometheus
kubectl port-forward -n cloud-native svc/prometheus 9090:9090
# → http://localhost:9090

# Grafana (admin / admin)
kubectl port-forward -n cloud-native svc/grafana 3000:3000
# → http://localhost:3000
```

---

## Verify Metrics

```bash
# From your machine (Docker Compose)
curl http://localhost:8000/metrics

# In Prometheus UI → Status → Targets
# cloud-native-api should be UP

# In Grafana → Explore → Prometheus
rate(http_requests_total[1m])
```

Prometheus **Status → Targets** showing `cloud-native-api` **UP** (scraping `/metrics`):

![Prometheus targets — cloud-native-api UP](image-44.png)

This means Prometheus successfully reaches `http://cloud-native-api:8000/metrics` inside the cluster.

---

## Verify Logs

In Grafana → **Explore** → select **Loki**:

```logql
{namespace="cloud-native", app="cloud-native-api"}
```

Or filter worker logs:

```logql
{namespace="cloud-native", app="cloud-native-worker"}
```

---

## Alerting

Prometheus includes a starter rule (`ApiHighErrorRate`) in `monitoring/prometheus/configmap.yaml` — fires when the API returns 5xx errors.

View in Prometheus UI → **Alerts**, or configure Grafana alert notifications later in Phase 9/10.

---

## Docker Compose (local testing)

Metrics work with Docker Compose too — no Prometheus/Grafana in compose yet, but you can test:

```bash
docker compose build api
docker compose up api
curl http://localhost:8000/metrics
curl http://localhost:8000/health
```

---



## Phase 8 — Completed

---

# Phase 9 — Security

**Goal:** Make the platform production-ready with security best practices (local learning — still LocalStack only).

## Roadmap Progress

| # | Topic | Status |
|---|-------|--------|
| 1 | IAM best practices | ✅ |
| 2 | Secrets management | ✅ |
| 3 | Docker security | ✅ |
| 4 | Kubernetes security | ✅ |
| 5 | Image scanning | ✅ |
| 6 | Dependency scanning | ✅ |
| 7 | HTTPS | ✅ |
| 8 | JWT security | ✅ |
| 9 | Rate limiting | ✅ |
| 10 | CORS | ✅ |
| 11 | Security headers | ✅ |

---

## What We Implemented

### Application security (`backend/`)

| Feature | Where | What it does |
|---------|-------|--------------|
| CORS | `main.py` | Restrict which origins can call the API from a browser |
| Security headers | `app/middleware/security_headers.py` | Adds `X-Content-Type-Options`, `X-Frame-Options`, `Referrer-Policy`, etc. |
| Rate limiting | `main.py` + `slowapi` | Limits requests per IP (default 60/minute) |
| JWT hardening | `jwt_handler.py` + `config.py` | Requires `JWT_SECRET_KEY`, rejects weak defaults |

### Docker security

| Change | Why |
|--------|-----|
| Non-root user in `Dockerfile` | Container does not run as root |
| No secrets in image | Credentials come from env / K8s Secrets |

### Kubernetes security

| Change | Why |
|--------|-----|
| `securityContext` on API/worker | `runAsNonRoot`, drop capabilities |
| Secrets stay in `k8s/secret.yaml` | Not baked into ConfigMaps or images |
| NetworkPolicy (optional) | Restrict pod-to-pod traffic |

### Scanning (how to run)

```bash
# Dependency scan (Python)
pip install pip-audit
pip-audit -r backend/requirements.txt

# Image scan (requires Trivy installed)
trivy image cloud-native-api:v1
```

### HTTPS / TLS

For local learning we keep HTTP. Production HTTPS belongs in Phase 10 (ACM + Load Balancer / Ingress TLS). Documented here so you know the gap.

### IAM best practices (LocalStack / AWS)

- Use least privilege — never use root/admin keys in apps
- LocalStack uses `test`/`test` only in local Terraform
- Production IAM roles come in Phase 10 — separate from this folder

---

## Apply Security Updates

```bash
# 1. Update K8s secret (stronger JWT)
kubectl apply -f k8s/secret.yaml

# 2. Rebuild API image (non-root + security middleware)
docker build -t cloud-native-api:v1 ./backend
kind load docker-image cloud-native-api:v1 --name cloud-native

# 3. Apply hardened deployments
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/worker.yaml
kubectl apply -f k8s/networkpolicy.yaml

# 4. Rollout
kubectl rollout restart deployment/cloud-native-api -n cloud-native
kubectl rollout status deployment/cloud-native-api -n cloud-native
```

---

## Verify Security Features

```bash
# Security headers
curl -I http://localhost:8000/health
# Expect: X-Content-Type-Options: nosniff, X-Frame-Options: DENY

# Rate limiting (after many requests you may get HTTP 429)
# curl http://localhost:8000/

# JWT: app refuses to start if JWT_SECRET_KEY is weak/missing
```

Docker Compose path (update `.env` from `.env.example` first):

```bash
docker compose build api
docker compose up api
curl -I http://localhost:8000/health
```

---

## Secrets Management Rules

| Do ✅ | Don't ❌ |
|-------|---------|
| Keep secrets in `.env` (gitignored) or `k8s/secret.yaml` | Commit real AWS keys or JWT secrets |
| Use Terraform LocalStack `test`/`test` only locally | Reuse production credentials in this repo |
| Rotate JWT secret when moving to Phase 10 | Put secrets in ConfigMaps or Docker images |

---

## Phase 9 — Completed

---

# Phase 10 — Production AWS

**Goal:** Learn how the **same infrastructure** would be defined for real AWS — **as code only**.

> ## DO NOT CREATE REAL AWS RESOURCES FROM THIS REPO
>
> - We write Terraform so you understand production structure.
> - We do **NOT** run `terraform apply` against a real AWS account.
> - `confirm_real_aws` is hard-blocked at `false` — apply will fail on purpose.
> - Keep using **LocalStack** (`infrastructure/terraform/`) for anything that actually runs.

## Roadmap Progress

| # | Topic | Status |
|---|-------|--------|
| 1 | Separate prod Terraform project | ✅ |
| 2 | Apply disabled (code-only safety) | ✅ |
| 3 | S3 (encrypted, private) | ✅ code |
| 4 | DynamoDB (on-demand) | ✅ code |
| 5 | SQS | ✅ code |
| 6 | IAM least-privilege role | ✅ code |
| 7 | CloudWatch Logs | ✅ code |
| 8 | Optional EC2 demo (off) | ✅ code |
| 9 | ALB / ACM / Route53 | 📄 documented only |
| 10 | ECS | 📄 optional later |

---

## LocalStack vs Real AWS (code)

| Folder | Target | What we do |
|--------|--------|------------|
| `infrastructure/terraform/` | **LocalStack** | `plan` / `apply` OK (free local) |
| `infrastructure/terraform-aws-prod/` | **Real AWS shape** | **Read the code only** — never apply here |

---

## What the code DEFINES (not created)

These `.tf` files show what you *would* create on AWS someday — they are **not** applied in this project:

- S3 bucket (private + encryption)
- DynamoDB tables `files` + `users` (PAY_PER_REQUEST)
- SQS queue
- IAM role + instance profile (least privilege)
- CloudWatch log group
- AWS Budget + SNS email alert template
- Optional EC2 / ALB — left off / documented

---

## Allowed learning commands (this folder)

```bash
cd infrastructure/terraform-aws-prod

# Optional: install providers only (no AWS API creates)
terraform init

# Reading the files is enough for Phase 10.
# Do NOT run: terraform apply
# Do NOT set confirm_real_aws=true (blocked anyway)
```

---

## Cost Safety Checklist

1. Never use root AWS credentials with this folder
2. Never run `terraform apply` from `terraform-aws-prod/`
3. Keep LocalStack for all hands-on demos
4. Treat these files as a **portfolio / learning reference**

---

## Project Structure

```text
infrastructure/terraform-aws-prod/
├── versions.tf
├── provider.tf              # Real AWS provider shape (not applied)
├── variables.tf             # apply hard-blocked
├── locals.tf
├── s3.tf
├── dynamodb.tf
├── sqs.tf
├── iam.tf
├── cloudwatch.tf
├── budget.tf
├── ec2_optional.tf          # OFF
├── alb_placeholder.tf       # docs only
├── outputs.tf
└── terraform.tfvars.example
```

---

## ALB / ACM / HTTPS / Route53 / ECS

Documented only — not enabled. They cost money even with little traffic.

---

## Phase 10 — Completed (code-only)

---

# Phase 11 — Scaling & Cloud Architecture

**Goal:** Understand production architecture patterns — **concepts only, no AWS spend, no `terraform apply`.**

Full write-up: [`docs/architecture.md`](docs/architecture.md)

## Roadmap Progress

| # | Topic | Status |
|---|-------|--------|
| 1 | High availability | ✅ |
| 2 | Auto scaling | ✅ |
| 3 | Multi-AZ | ✅ |
| 4 | Caching | ✅ |
| 5 | CDN | ✅ |
| 6 | Disaster recovery | ✅ |
| 7 | Cost optimization | ✅ |
| 8 | Event-driven architecture | ✅ |

**Phase 11 — Completed**

---

## How Our Project Maps to Production

| Concept | What we already have | Production upgrade |
|---------|----------------------|--------------------|
| HA | 2 API replicas + health probes | Multi-AZ + load balancer |
| Auto scaling | Kubernetes HPA | HPA + node/ECS autoscaling |
| Multi-AZ | Simulated locally | Real AZs in AWS region |
| Caching | Not added (keep simple) | ElastiCache/Redis later |
| CDN | Not added | CloudFront → S3 |
| DR | LocalStack volume / TF recreate | Backups, PITR, multi-region plan |
| Cost control | LocalStack + apply-blocked prod TF | Budgets, right-sizing |
| Events | API → SQS → Worker | Same + DLQ / EventBridge |

---

## Mental Model

```text
LOCAL (what we run)              PRODUCTION (what we study)
─────────────────────            ──────────────────────────
kind / Docker Compose     ≈      EKS / ECS / EC2+ASG
LocalStack                ≈      S3 + DynamoDB + SQS
HPA                       ≈      Auto Scaling
Prometheus/Grafana/Loki   ≈      CloudWatch + managed observability
terraform/ (LocalStack)   ≈      terraform-aws-prod/ (reference only)
```

---

## Event-Driven Flow (you already built this)

```text
Client → API → S3 (file) + DynamoDB (metadata)
              → SQS message
                    → Worker → update status in DynamoDB
```

That is the core of scalable cloud backends: **fast API + async work**.

---

## What We Intentionally Did NOT Deploy

- Real multi-region failover
- ElastiCache / CloudFront
- Always-on ALB

Those cost money. We document them in `docs/architecture.md` instead.

---

## Phase 11 — Completed

---

# Phase 12 — Final Polish

**Goal:** Package the project as portfolio-ready documentation.

## Roadmap Progress

| # | Topic | Status |
|---|-------|--------|
| 1 | Architecture diagram | ✅ `docs/architecture-diagram.md` |
| 2 | README polish | ✅ portfolio one-liner + doc links |
| 3 | Screenshots | ✅ (Phases 0–8 images, Prometheus `image-44.png`) |
| 4 | API documentation | ✅ `docs/api.md` + Swagger |
| 5 | Terraform documentation | ✅ Phases 7 & 10 in README |
| 6 | CI/CD documentation | ✅ `docs/ci-cd.md` + `.github/workflows/ci.yml` |
| 7 | Kubernetes documentation | ✅ Phase 6 in README + `k8s/` |
| 8 | Demo checklist | ✅ `docs/demo.md` |
| 9 | Portfolio integration | ✅ top-of-README + docs index |

**Phase 12 — Completed**

---

## Portfolio Summary

This repository demonstrates an end-to-end DevOps / cloud-native learning path:

1. **App** — FastAPI auth, uploads, async worker  
2. **Cloud services (local)** — S3, DynamoDB, SQS via LocalStack  
3. **Containers** — Docker Compose  
4. **Orchestration** — Kubernetes (Deployments, Services, Ingress, HPA, PVs)  
5. **IaC** — Terraform for LocalStack; real-AWS TF kept as **read-only reference**  
6. **Observability** — Prometheus, Grafana, Loki, Promtail  
7. **Security** — CORS, headers, rate limits, JWT hardening, non-root containers  
8. **Architecture** — HA, scaling, event-driven design documented  

**Explicit non-goal:** creating billable resources on real AWS from this repo.

---

## Demo in 5 commands

```bash
docker compose up -d localstack
cd infrastructure/terraform && terraform apply && cd ../..
docker compose up api worker
curl http://localhost:8000/health
# Open http://localhost:8000/docs
```

Full walkthrough: [docs/demo.md](docs/demo.md)

---

## All Phases Complete

```text
Phase 0–12  ✅
```

Keep building skills on LocalStack + kind. Use `docs/` when presenting this project.

---

## Git — What to Commit

| Commit ✅ | Ignore ❌ |
|-----------|-----------|
| `docs/` | `**/*.tfstate*` |
| `infrastructure/terraform-aws-prod/` | `**/terraform.tfvars` |
| `.github/workflows/ci.yml` | `.env`, `localstack-data/` |
| `README.md` | |

```bash
git add README.md docs/ infrastructure/terraform-aws-prod/ .github/
git status
git commit -m "feat: complete Phases 10–12 (AWS TF reference, architecture, portfolio polish)"
git push
```
