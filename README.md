# Cloud Native Platform

- Start the Docker in local
- Run this command in bash : alias awslocal='aws --profile cloud-native --endpoint-url=http://localhost:4566'

## Goal

Build a production-style cloud-native application using AWS services locally with LocalStack.

The objective is to learn:

- AWS Core Services
- Infrastructure as Code
- Docker
- CI/CD
- Kubernetes
- Monitoring & Logging
- Cloud Architecture
- DevOps Practices

without incurring AWS costs.

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

# Phase 6

Dockerize everything 

![alt text](image-31.png)


![alt text](image-32.png)

![alt text](image-33.png)


Kuberenetes 

![alt text](image-36.png)

![alt text](image-37.png)

![alt text](image-38.png)


Process to Create Kind Cluster 

![alt text](image-39.png)

Application of Deployment and Service 

![alt text](image-40.png)
