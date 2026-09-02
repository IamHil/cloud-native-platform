# Cloud Native Platform

Build a production-style cloud-native application using AWS services locally with **LocalStack** — no real AWS costs.

Repository: [github.com/IamHil/cloud-native-platform](https://github.com/IamHil/cloud-native-platform) (branch: `main`)

---

## Learning Goals

- AWS Core Services (S3, DynamoDB, SQS)
- Docker & Docker Compose
- Kubernetes
- Infrastructure as Code (Terraform)
- Monitoring & Logging *(Phase 8)*
- Security & Production AWS *(Phases 9–10)*

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
| 8 | Monitoring & Logging | ⏳ |
| 9 | Security | ⏳ |
| 10 | Production AWS | ⏳ |
| 11 | Scaling & Cloud Architecture | ⏳ |
| 12 | Final Polish | ⏳ |

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
│   │   ├── api/                # Routes (auth, files, health)
│   │   ├── services/           # S3, DynamoDB, SQS clients
│   │   └── worker/             # SQS message processor
│   └── Dockerfile
├── infrastructure/
│   └── terraform/              # IaC — LocalStack only (Phase 7)
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

Next up: **Phase 8 — Monitoring & Logging (Prometheus, Grafana, Loki)**

---

## Git — What to Commit

| Commit ✅ | Ignore ❌ |
|-----------|-----------|
| `infrastructure/terraform/*.tf` | `infrastructure/terraform/.terraform/` |
| `infrastructure/terraform/.terraform.lock.hcl` | `infrastructure/terraform/*.tfstate*` |
| `infrastructure/terraform/localstack.auto.tfvars` | `infrastructure/terraform/terraform.tfvars` |
| `k8s/` manifests | `.env` files |
| `backend/` source code | `localstack-data/` |
| `README.md`, `docker-compose.yml` | `__pycache__/`, `*.pyc` |

```bash
git add README.md infrastructure/terraform/ k8s/ backend/app/services/ docker-compose.yml
git status
git commit -m "Complete Phase 6 (Kubernetes) and Phase 7 (Terraform LocalStack IaC)"
git push
```
