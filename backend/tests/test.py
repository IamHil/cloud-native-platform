import boto3
from app.core.config import settings

print("Bucket:", settings.S3_BUCKET)
print("Endpoint:", settings.AWS_ENDPOINT_URL)

client = boto3.client(
    "s3",
    endpoint_url=settings.AWS_ENDPOINT_URL,
    region_name=settings.AWS_REGION,
    aws_access_key_id=settings.AWS_ACCESS_KEY_ID,
    aws_secret_access_key=settings.AWS_SECRET_ACCESS_KEY,
)

print(client.list_buckets())